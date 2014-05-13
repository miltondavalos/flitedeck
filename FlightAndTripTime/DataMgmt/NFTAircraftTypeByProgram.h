//
//  NFTAircraftTypeByProgram.h
//  FlightAndTripTime
//
//  Created by Chad Long on 2/15/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NFTAircraftTypeByProgram : NSManagedObject

@property (nonatomic, retain) NSNumber * aircraftTypeByProgramId;
@property (nonatomic, retain) NSNumber * programId;
@property (nonatomic, retain) NSString * aircraftType;
@property (nonatomic, retain) NSDecimalNumber * minNonRevenueTurnTime;
@property (nonatomic, retain) NSDecimalNumber * minRevenueTurnTime;
@property (nonatomic, retain) NSDecimalNumber * asapTurnTime;
@property (nonatomic, retain) NSDecimalNumber * techTurnTime;
@property (nonatomic, retain) NSDecimalNumber * internationalTurnTime;
@property (nonatomic, retain) NSDate * lastChanged;

@end
