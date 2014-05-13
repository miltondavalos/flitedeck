//
//  NFDPersistenceService.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/10/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDPersistenceService.h"
#import "NFDPersistenceManager.h"

@implementation NFDPersistenceService
@synthesize pm,context;

-(id) init {
    self = [super init];
    if(self){
        //TODO: Migrate code away from Delegate.
//        NFDAppDelegate *delegate = (NFDAppDelegate *) [[UIApplication sharedApplication] delegate];
        pm = [NFDPersistenceManager sharedInstance];
        context = [pm mainMOC];
    }
    return self;
}

+ (id) sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (NSArray *) getAll : (NSString *) entityName sortedBy: (NSString*) fieldName {
    
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:entityName inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        if (fieldName) {
            NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:YES];
            
            [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortBy,nil]];
        }
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
        if([objects count] > 0){
            return objects;
        }
         DLog(@"%@",[error description]);
        return nil;
       
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
}

- (NSArray*) queryEntity : (NSString *) criteria  entityName:(NSString *) entityName fieldName :(NSString *) fieldName {  
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSString *query = [NSString stringWithFormat:@"(%@ CONTAINS[cd] %%@)",fieldName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: query,criteria];
        [fetchRequest setPredicate:predicate];
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSError *error;
        NSArray *records = [context executeFetchRequest:fetchRequest error:&error];
        return records;
        DLog(@"%@",[error description]);
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
    
}

- (NSArray*) queryEntityForUniqueValues : (NSString *) criteria  entityName:(NSString *) entityName fieldName :(NSString *) fieldName {  
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSString *query = [NSString stringWithFormat:@"(%@ = %%@)",fieldName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: query,criteria];
        [fetchRequest setPredicate:predicate];
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSError *error;
        NSArray *records = [context executeFetchRequest:fetchRequest error:&error];
        return records;
        DLog(@"%@",[error description]);
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
    
}

- (NSUInteger) getEntityCount: (NSString *) entityName {
    @try{
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
        NSError *error;
        NSArray *recordsFound = [context executeFetchRequest:fetchRequest error:&error];
        return [recordsFound count];
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return -1;
}

+ (void) copyManagedObjectAttributesFrom: (NSManagedObject *) source cloned:(NSManagedObject *)cloned entityName:(NSString *) entityName
{
    
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:source.managedObjectContext] attributesByName];
    
    for (NSString *attr in attributes) {
        [cloned setValue:[source valueForKey:attr] forKey:attr];
    }
}


@end
