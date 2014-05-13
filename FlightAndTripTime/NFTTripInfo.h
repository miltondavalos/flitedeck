//
//  NFTTripInfo.h
//  FlightAndTripTime
//
//  Created by Chad Long on 2/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NFTEnduranceEntry;

@interface NFTTripInfo : NSObject

@property (nonatomic, strong) NSDecimalNumber *distanceInNauticalMiles;
@property (nonatomic, strong) NSDecimalNumber *aircraftEndurance;
@property (nonatomic, strong) NSDecimalNumber *tripTime;
@property (nonatomic, strong) NSDecimalNumber *flightTime;
@property (nonatomic) int aircraftRange;
@property (nonatomic) int fuelStops;

+ (id)tripInfoWithDistance:(NSDecimalNumber*)distance
         aircraftEndurance:(NSDecimalNumber*)endurance
             aircraftRange:(int)range
                  tripTime:(NSDecimalNumber*)tripTime
                flightTime:(NSDecimalNumber*)flightTime
                 fuelStops:(int)fuelStops;

@end
