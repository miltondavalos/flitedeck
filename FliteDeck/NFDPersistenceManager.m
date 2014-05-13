//
//  NFDPersistenceManager.m
//  FliteDeck
//
//  Created by Chad Long on 3/12/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFDPersistenceManager.h"
#import "NFDImportService.h"

@implementation NFDPersistenceManager

+ (NFDPersistenceManager*)sharedInstance
{
	static dispatch_once_t pred;
	static NFDPersistenceManager *sharedInstance = nil;
    
	dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
	
    return sharedInstance;
}

- (NSString*)modelName
{
    return @"FliteDeck";
}

- (BOOL)shouldAlwaysInstallResourcedDatabase
{
    return YES;
}

- (void)updateDataForNewBundleVersion:(NSManagedObjectContext*)context
{
    // import static data from resourced files
    // this is called for the first run of each new bundle version
    // used for simple recurring data updates without wiping any user updates to non-static tables in the database
    NFDImportService *importService = [[NFDImportService alloc] init];

    importService.context = [[NFDPersistenceManager sharedInstance] mainMOC];
    
    // aircraft type group load
    NSString *pathForAircraftTypeGroup = [[NSBundle mainBundle] pathForResource:@"AircraftTypeGroup" ofType:@"csv"];
    
    if (pathForAircraftTypeGroup)
        [importService importAircraftTypeGroup:pathForAircraftTypeGroup];
    
    // aircraft type load
    NSString *pathForAircraftType = [[NSBundle mainBundle] pathForResource:@"AircraftType" ofType:@"csv"];
    
    if (pathForAircraftType)
        [importService importAircraftTypes:pathForAircraftType];
    
    // events load
    NSString *pathForEvents = [[NSBundle mainBundle] pathForResource:@"Events" ofType:@"csv"];
    
    if (pathForEvents)
        [importService importEvent:pathForEvents];
    
    NSError *error = nil;
    [[importService context] save:&error];
    
    importService.context = [[NFDPersistenceManager sharedInstance] mainMOC];
}

@end
