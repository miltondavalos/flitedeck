//
//  NFTEnduranceEntry.h
//  FlightAndTripTime
//
//  Created by Long Chad on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NFTEnduranceEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * enduranceEntryId;
@property (nonatomic, retain) NSString * aircraftType;
@property (nonatomic, retain) NSNumber * numberOfPax;
@property (nonatomic, retain) NSNumber * headwind;
@property (nonatomic, retain) NSDecimalNumber * endurance;
@property (nonatomic, retain) NSNumber * range;
@property (nonatomic, retain) NSDate * lastChanged;

@end
