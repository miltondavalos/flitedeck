//
//  NCOPersistenceManager.m
//  
//  Common persistence management
//
//  Created by Chad Long on 3/13/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLPersistenceManager.h"
#import <CoreData/CoreData.h>
#import "NCLFramework.h"
#import "NCLPrivateMOC.h"

@interface NCLPersistenceManager()

- (void)processRequiredUpdatesForStoreWithURL:(NSURL*)storeURL;
- (BOOL)isFirstRunForBundleVersion;
- (BOOL)isFirstRunForSQLiteDB:(NSURL*)resourcedStoreURL;
- (NSString*)sharedDocumentsPath;

@end

@implementation NCLPersistenceManager

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize mainMOC = _mainMOC;
@synthesize objectModel = _objectModel;

- (NSString*)modelName
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (BOOL)shouldAlwaysInstallResourcedDatabase
{
    return NO;
}

- (BOOL)supportsModelVersioning
{
    return NO;
}

- (void)updateDataForNewBundleVersion:(NSManagedObjectContext*)context
{
    // implementation provided by subclass if required
}

- (NSBundle*)mainBundle
{
    // may be overridden by test targets that contain their own sqlite DB (including the tests for this framework)
    return [NSBundle mainBundle];
}

- (BOOL)isFirstRunForBundleVersion
{
    NSString* lastBundleVersionKey = [NSString stringWithFormat:@"LastSQLiteBundleFor%@", [self modelName]];
    
    NSString *bundleVersion = [[self mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *installedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:lastBundleVersionKey];

    if (installedVersion == nil ||
        ![bundleVersion isEqualToString:installedVersion])
    {
        INFOLog(@"detected new bundle version for model %@... %@", [self modelName], bundleVersion);

        [[NSUserDefaults standardUserDefaults] setObject:bundleVersion forKey:lastBundleVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return YES;
    }

    return NO;
}

- (BOOL)isFirstRunForSQLiteDB:(NSURL*)resourcedStoreURL
{
    NSDate *sourcedFileDate = nil;
    NSDictionary *fileAttributes = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:resourcedStoreURL.path])
    {
        INFOLog(@"SQLite DB does not exist for model %@", self.modelName);
    }
    else
    {
        NSError *fileError = nil;
        fileAttributes = [fileManager attributesOfItemAtPath:resourcedStoreURL.path error:&fileError];
        
        if (fileError)
        {
            INFOLog(@"SQLite DB file access error: %@", [fileError localizedDescription]);
            @throw [NSException exceptionWithName:@"Database Access Error" reason:@"Error reading database version" userInfo:nil];
        }
        
        sourcedFileDate = [fileAttributes objectForKey:@"NSFileModificationDate"];
    }

    NSString* lastSQLiteDBKey = [NSString stringWithFormat:@"LastSQLiteDBFor%@", [self modelName]];
    NSDate *installedFileDate = [[NSUserDefaults standardUserDefaults] objectForKey:lastSQLiteDBKey];
    
    if (sourcedFileDate != nil &&
        ![sourcedFileDate isEqualToDate:installedFileDate])
    {
        INFOLog(@"detected new SQLite DB for model %@... %@ --> %@", self.modelName, sourcedFileDate, installedFileDate);
        
        [[NSUserDefaults standardUserDefaults] setObject:sourcedFileDate forKey:lastSQLiteDBKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        return YES;
    }
    
    return NO;
}

- (NSNumber*)storeSize
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbName = [[self modelName] stringByAppendingString:@".sqlite"];
	NSString *storePath = [[self sharedDocumentsPath] stringByAppendingPathComponent:dbName];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:storePath error:NULL];
    
    if (fileAttributes)
        return [NSNumber numberWithLongLong:[fileAttributes fileSize] / 1024.0]; // expressed in KB
    else
        return @0;
}

- (NSManagedObjectModel*)objectModel
{
	if (_objectModel)
		return _objectModel;
    
	NSBundle *bundle = [self mainBundle];
	NSString *modelPath = [bundle pathForResource:[self modelName] ofType:@"momd"];
    
    if (!modelPath)
    {
        modelPath = [bundle pathForResource:[NSString stringWithFormat:@"NCLFramework.framework/%@", [self modelName]] ofType:@"momd"];
        
        if (!modelPath)
        {
            INFOLog(@"missing resource for model: %@", [self modelName]);
            
            return nil;
        }
    }
    
	_objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    
	return _objectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
	if (_persistentStoreCoordinator)
		return _persistentStoreCoordinator;

    @synchronized(self)
    {
        if (_persistentStoreCoordinator)
            return _persistentStoreCoordinator;
        
        // get the path to the data store
        NSString *dbName = [[self modelName] stringByAppendingString:@".sqlite"];
        NSString *storePath = [[self sharedDocumentsPath] stringByAppendingPathComponent:dbName];
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        
        // instantiate the persistence store with a reference to the current model
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.objectModel];
        
        // conditionally use resourced data stores
        [self processRequiredUpdatesForStoreWithURL:storeURL];
        
        // setup the persistence store, performing lightweight migration if necessary
        NSError* error = nil;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                 @{@"journal_mode" : @"DELETE"}, NSSQLitePragmasOption,
                                 nil];

        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:options
                                                               error:&error])
        {
            INFOLog(@"Fatal error creating or migrating persistent store: %@", error);
            
            abort();
        }
        
        return _persistentStoreCoordinator;
    }
}

- (void)processRequiredUpdatesForStoreWithURL:(NSURL*)storeURL
{
    // get the metadata for the current store
    BOOL storeIsCompatible = NO;
    NSDictionary *storeMetadata = nil;
    
    if (storeURL)
    {
        NSError *storeMetadataError = nil;
        storeMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&storeMetadataError];
        storeIsCompatible = [[_persistentStoreCoordinator managedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:storeMetadata];
    }
    
    // get the metadata for the resourced store (if one exists)
    BOOL isFirstRunForDB = NO;
    BOOL resourcedStoreIsCompatible = NO;
    NSURL *resourcedStoreURL = [[self mainBundle] URLForResource:[self modelName] withExtension:@"sqlite"];
    
    if (resourcedStoreURL)
    {
        NSError *resourcedStoreMetadataError = nil;
        NSDictionary *resourcedStoreMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:resourcedStoreURL error:&resourcedStoreMetadataError];
        resourcedStoreIsCompatible = [[_persistentStoreCoordinator managedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:resourcedStoreMetadata];
        
        // determine if this is a new DB
        isFirstRunForDB = [self isFirstRunForSQLiteDB:resourcedStoreURL];
    }

    // remove the existing store when appropriate
    if (storeMetadata != nil)
    {
        // if the current store is not compatible with the current model and this instance of the PM does not support versioning, remove the current store
        if (![self supportsModelVersioning] &&
            !storeIsCompatible)
        {
            [self removeStoreAtURL:storeURL];
        }
        
        // if a compatible resourced store exists, and this instance of the PM is configured to always install "new" resourced stores, we need to first remove any existing stores
        else if (resourcedStoreIsCompatible &&
             [self shouldAlwaysInstallResourcedDatabase] &&
             isFirstRunForDB)
        {
            [self removeStoreAtURL:storeURL];
        }
    }

    // install the resourced store when appropriate
    if (resourcedStoreIsCompatible)
    {
        // if the resourced store is compatible with the current model & the current store doesn't exist, install the resourced store
        if (storeMetadata == nil)
        {
            [self installStoreAtURL:resourcedStoreURL toURL:storeURL];
        }
        
        // if a compatible resourced store exists, and this instance of the PM is configured to always install "new" resourced stores
        else if ([self shouldAlwaysInstallResourcedDatabase] &&
                 isFirstRunForDB)
        {
            [self installStoreAtURL:resourcedStoreURL toURL:storeURL];
        }
    }
}

- (void)removeStoreAtURL:(NSURL*)storeURL
{
    INFOLog(@"removing existing data store: %@", storeURL);
    
    NSError *fileError = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if (![fileManager removeItemAtURL:storeURL error:&fileError])
    {
        INFOLog(@"Fatal error removing existing data store: %@", fileError);
        [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"coreData" action:@"removeStoreAtURL" value:storeURL.description error:fileError]];
        
        abort();
    }
}

- (void)installStoreAtURL:(NSURL*)resourcedStoreURL toURL:(NSURL*)storeURL
{
    INFOLog(@"installing resourced sqlite file %@\nto %@...", resourcedStoreURL, storeURL);
    
    NSError *fileError = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if (![fileManager copyItemAtURL:resourcedStoreURL toURL:storeURL error:&fileError])
    {
        INFOLog(@"Fatal error copying new data store: %@", fileError);
        [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"coreData" action:@"installStoreAtURL" value:storeURL.description error:fileError]];
        
        abort();
    }
}

#pragma mark - Object contexts

- (NSManagedObjectContext*)mainMOC
{
	if (_mainMOC)
		return _mainMOC;
    
	// create the main context only on the main thread
	if (![NSThread isMainThread])
    {
		[self performSelectorOnMainThread:@selector(mainMOC)
                               withObject:nil
                            waitUntilDone:YES];
		return _mainMOC;
	}
    
    @synchronized(self)
    {
        if (_mainMOC)
            return _mainMOC;
        
        _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainMOC setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        
        // import static data if required
        if ([self isFirstRunForBundleVersion])
            [self updateDataForNewBundleVersion:_mainMOC];
    }
    
	return _mainMOC;
}

- (NSManagedObjectContext*)privateMOC
{
    if (![NSThread isMainThread])
    {
        return [self privateMOCWithParent:[self mainMOC]];
    }
    else
    {
        return [self mainMOC];
    }
}

- (NSManagedObjectContext*)privateMOCWithParent:(NSManagedObjectContext*)parentMOC
{
    NCLPrivateMOC *moc = [[NCLPrivateMOC alloc] initWithParentMOC:parentMOC];
    
    if (parentMOC == nil)
        [moc setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
	return moc;
}

#pragma mark - Save and merge

- (BOOL)save
{
	if (![self.mainMOC hasChanges])
		return YES;
    
    BOOL saveStatus = YES;
    NSError *error = nil;
    
    if (![self.mainMOC save:&error])
    {
        saveStatus = NO;
    }

    if (saveStatus == NO)
    {
        INFOLog(@"error saving to mainMOC: %@\n%@", [error localizedDescription], [error userInfo]);
        [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"coreData" action:@"save" value:NSStringFromClass([self class]) error:error]];
        
        [NCLErrorPresenter presentError:error];
    }
    else
    {
        INFOLog(@"save of mainMOC completed");
    }
    
	return saveStatus;
}

#pragma mark - DB location

- (NSString*)sharedDocumentsPath
{
	static NSString *SharedDocumentsPath = nil;
    
	if (SharedDocumentsPath)
		return SharedDocumentsPath;
    
	// compose a path to the <Library>/Database directory
	NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	SharedDocumentsPath = [libraryPath stringByAppendingPathComponent:@"Database"];
    
	// ensure the database directory exists
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	BOOL isDirectory;
    
	if (![fileManager fileExistsAtPath:SharedDocumentsPath isDirectory:&isDirectory] || !isDirectory)
    {
		NSError *error = nil;
		NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
		[fileManager createDirectoryAtPath:SharedDocumentsPath
               withIntermediateDirectories:YES
                                attributes:attr
                                     error:&error];
		if (error)
			INFOLog(@"Error creating directory path: %@", [error localizedDescription]);
	}
    
	return SharedDocumentsPath;
}

@end

