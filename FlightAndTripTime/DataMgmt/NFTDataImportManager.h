//
//  NFTDataImportManager.h
//  FlightAndTripTime
//
//  Created by Long Chad on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFTDataImportManager : NSObject

+ (BOOL)deleteAllObjects:(NSString*)entityDescription inManagedObjectContext:(NSManagedObjectContext*)context;
+ (BOOL)importAll;
+ (BOOL)importEnduranceEntry;
+ (BOOL)importStageDistAndSpeedData;
+ (BOOL)importAircraftTypeByProgram;
+ (BOOL)importWindCorrections;

@end
