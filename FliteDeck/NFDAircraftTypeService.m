//
//  NFDAircraftTypeService.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDAircraftTypeService.h"
#import "NSString+FliteDeck.h"

@implementation NFDAircraftTypeService


- (NSArray *) getAllAircraft  {
    
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"AircraftTypeGroup" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
        //NSSortDescriptor *sortByCabinSize = [[NSSortDescriptor alloc] initWithKey:@"cabin_size_cd" ascending:NO];
        
        NSSortDescriptor *sortByRanking = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
        
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortByRanking,nil]];
        
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
    return nil;
}

- (NSArray*) queryAircraftTypes : (NSString *) criteria {  
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AircraftTypeGroup" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(typeGroupName CONTAINS[cd] %@)", criteria];
        [fetchRequest setPredicate:predicate];
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"typeGroupName" ascending:YES];
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


- (NFDAircraftType *) queryAircraftTypesByTypeName : (NSString *) criteria {  
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AircraftType" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(typeName = %@)", criteria];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *recordsFound = [context executeFetchRequest:fetchRequest error:&error];
        if([recordsFound count] > 0){
            return [recordsFound objectAtIndex:0];
        }
        DLog(@"%@",[error description]);
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
}

- (NFDMasterAircraftType*)queryMasterAircraftTypesByTypeName:(NSString*)typeName
{
    NSError *error = nil;
    NFDMasterAircraftType *acType = nil;
    
    NSArray *aircraftTypeData = [NCLPersistenceUtil executeFetchRequestForEntityName:[NFDMasterAircraftType entityName]
                                                                        predicateKey:@"typeName"
                                                                      predicateValue:typeName
                                                                             sortKey:nil
                                                                  includeSubEntities: NO
                                                                             context:[[NFDPersistenceService sharedInstance] context]
                                                                               error:&error];
    
    if (!error &&
        aircraftTypeData.count > 0)
    {
        acType = [aircraftTypeData objectAtIndex:0];
    }
    
    return acType;
}



- (NSArray *) queryAircraftTypesByTypeGroupName : (NSString *) criteria {  
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AircraftType" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(typeGroupName = %@)", criteria];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *recordsFound = [context executeFetchRequest:fetchRequest error:&error];
        return recordsFound;
        DLog(@"%@",[error description]);
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
}

- (NSString *)displayNameForTypeName:(NSString *)typeName moc:(NSManagedObjectContext *)moc
{
    NSString *displayName = typeName; // Default to the type name
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AircraftType" inManagedObjectContext:moc];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(typeName = %@)", typeName];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *recordsFound = [context executeFetchRequest:fetchRequest error:&error];
        
        if ([recordsFound count] > 0) {
            NFDAircraftType *aircraftType = [recordsFound objectAtIndex:0];
            displayName = aircraftType.displayName;
        }
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    
    return displayName;
}

- (NSNumber *) maximumNumberOfPassengersInFleet {
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.includesSubentities=NO;

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AircraftType" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numberOfPax" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        
        NSError *error;
        NSArray *recordsFound = [context executeFetchRequest:fetchRequest error:&error];
        DLog(@"%@",[error description]);
        
        NFDAircraftType *aircraftType = [recordsFound objectAtIndex:0];
        return aircraftType.numberOfPax;
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
}

- (NFDAircraftTypeComparisionResult) compareAircraftTypes: (NSString *) requestedAircraftTypeText actualType: (NSString *) actualAircraftTypeText
{
    NFDAircraftTypeComparisionResult result = NFDAircraftTypeUnknown;

    if (requestedAircraftTypeText || actualAircraftTypeText ||
        ![requestedAircraftTypeText isEmptyOrWhitespace] || ![actualAircraftTypeText isEmptyOrWhitespace]) {

        BOOL differentAircraft = ![requestedAircraftTypeText isEqualToString:actualAircraftTypeText];
        if (differentAircraft) {
            NFDAircraftType *requestedType = [self queryAircraftTypesByTypeName: requestedAircraftTypeText];
            NFDAircraftType *actualType = [self queryAircraftTypesByTypeName: actualAircraftTypeText];
            if (requestedType && actualType) {
                if ([requestedType.typeGroupName isEqualToString:actualType.typeGroupName]) {
                    result = NFDAircraftTypeSame;
                } else {
                    if ([requestedType.displayOrder compare:actualType.displayOrder] == NSOrderedAscending) {
                        result = NFDAircraftTypeUpgrade;
                    } else {
                        result = NFDAircraftTypeDowngrade;
                    }
                }
            }
        }
    }

    return result;
}

- (BOOL) isContractExpiringOrExpired: (NSDate *) contractEndDate {
    
    if (contractEndDate == nil) return NO;
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:now toDate:contractEndDate options:0];
    return ([dateComponents day] <= 90 && [now compare:contractEndDate] == NSOrderedAscending) || [contractEndDate compare:now] == NSOrderedAscending;
}


@end
