//
//  NFTDataImportManager.m
//  FlightAndTripTime
//
//  Created by Long Chad on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFTDataImportManager.h"
#import "NFTCSVParser.h"
#import "NFTPersistenceManager.h"
#import "NFTEntryReceiver.h"
#import <CoreData/CoreData.h>

@interface NFTDataImportManager ()

+ (BOOL)importCSVWithResource:(NSString*)resource entityName:(NSString*)entityName fields:(NSArray*)fields;

@end


@implementation NFTDataImportManager

+ (BOOL)importCSVWithResource:(NSString*)resource entityName:(NSString*)entityName fields:(NSArray*)fields
{
    NSDate *startDate = [NSDate date];
    
    // load the csv file
    NSError *error = nil;
    NSManagedObjectContext *ctx = [[NFTPersistenceManager sharedInstance] mainMOC];
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"csv"];
    NSString *csvString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

    if (error)
    {
        DLog(@"error loading CSV file: %@", [error debugDescription]);
        return NO;
    }
    
    // clear, parse, and import data into core data
    if (![NFTDataImportManager deleteAllObjects:entityName inManagedObjectContext:ctx])
    {
        return NO;
    }
    
    NFTCSVParser *parser = [[NFTCSVParser alloc] initWithString:csvString
                                                      separator:@","
                                                      hasHeader:NO
                                                     fieldNames:fields];
    
    [parser parseRowsForReceiver:[[NFTEntryReceiver alloc] initWithContext:ctx entityName:entityName] selector:@selector(receiveRecord:)];
    [[NFTPersistenceManager sharedInstance] save];

    NSLog(@"data import from resource %@.csv to entity %@ completed in %f seconds", resource, entityName, [[NSDate date] timeIntervalSinceDate:startDate]);

    // log the resulting total record count
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.includesSubentities=NO;

    NSUInteger recordCount = [ctx countForFetchRequest:request error:&error];

    NSLog(@"entity %@ contains %i records", entityName, recordCount);
    
    return YES;
}

+ (BOOL)deleteAllObjects:(NSString*)entityDescription inManagedObjectContext:(NSManagedObjectContext*)context
{
    // fetch all records
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityDescription];
    fetchRequest.includesSubentities=NO;

    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        DLog(@"error fetching all objects for deletion: %@", [error debugDescription]);
        return NO;
    }
    
    // delete records one-by-one
    for (NSManagedObject *managedObject in items)
    {
        [context deleteObject:managedObject];
    }
    
    // commit changes
    [context save:&error];
    
    if (error)
    {
        DLog(@"error deleting all objects: %@", [error debugDescription]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)importAll
{
    BOOL success = YES;
    
    success = [NFTDataImportManager importEnduranceEntry];
    success = success && [NFTDataImportManager importStageDistAndSpeedData];
    success = success && [NFTDataImportManager importAircraftTypeByProgram];
    success = success && [NFTDataImportManager importWindCorrections];
    
    return success;
}

+ (BOOL)importEnduranceEntry
{
    return [self importCSVWithResource:@"EnduranceEntryData"
                            entityName:@"NFTEnduranceEntry"
                                fields:[NSArray arrayWithObjects:
                                        @"enduranceEntryId",
                                        @"aircraftType",
                                        @"numberOfPax",
                                        @"headwind",
                                        @"endurance",
                                        @"range",
                                        @"lastChanged",
                                        nil]];    
}

+ (BOOL)importStageDistAndSpeedData
{
    return [self importCSVWithResource:@"StageDistSpeedData"
                     entityName:@"NFTStageDistAndSpeed"
                         fields:[NSArray arrayWithObjects:
                                 @"stageDistAndSpeedId",
                                 @"aircraftType",
                                 @"distance",
                                 @"averageSpeed",
                                 @"lastChanged",
                                 nil]];
}

+ (BOOL)importAircraftTypeByProgram
{
    return [self importCSVWithResource:@"TurnTimeData"
                            entityName:@"NFTAircraftTypeByProgram"
                                fields:[NSArray arrayWithObjects:
                                        @"aircraftTypeByProgramId",
                                        @"programId",
                                        @"aircraftType",
                                        @"minNonRevenueTurnTime",
                                        @"minRevenueTurnTime",
                                        @"asapTurnTime",
                                        @"techTurnTime",
                                        @"internationalTurnTime",
                                        @"lastChanged",
                                        nil]];    
}

+ (BOOL)importWindCorrections
{
    return [self importCSVWithResource:@"WindCorrectionsData"
                            entityName:@"NFTWindCorrections"
                                fields:[NSArray arrayWithObjects:
                                        @"windCorrectionId",
                                        @"springFallCorrection",
                                        @"winterCorrection",
                                        @"trueCourse",
                                        @"latitude",
                                        @"summerCorrection",
                                        @"lastChanged",
                                        nil]];    
}

@end