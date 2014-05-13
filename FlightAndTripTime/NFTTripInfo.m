//
//  NFTTripInfo.m
//  FlightAndTripTime
//
//  Created by Chad Long on 2/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFTTripInfo.h"

@implementation NFTTripInfo

@synthesize distanceInNauticalMiles = _distanceInNauticalMiles,
            aircraftEndurance = _aircraftEndurance,
            tripTime = _tripTime,
            flightTime = _flightTime,
            aircraftRange = _aircraftRange,
            fuelStops = _fuelStops;

+ (NFTTripInfo*)tripInfoWithDistance:(NSDecimalNumber*)distance
                   aircraftEndurance:(NSDecimalNumber*)endurance
                       aircraftRange:(int)range
                            tripTime:(NSDecimalNumber*)tripTime
                          flightTime:(NSDecimalNumber*)flightTime
                           fuelStops:(int)fuelStops
{
    NFTTripInfo *tripInfo = [[NFTTripInfo alloc] init];
    
    tripInfo.distanceInNauticalMiles = distance;
    tripInfo.aircraftEndurance = endurance;
    tripInfo.aircraftRange = range;
    tripInfo.tripTime = tripTime;
    tripInfo.flightTime = flightTime;
    tripInfo.fuelStops = fuelStops;
    
    return tripInfo;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"distance=%@; endurance=%@; range=%i; tripTime=%@; flightTime=%@; fuelStops=%i",
            _distanceInNauticalMiles, _aircraftEndurance, _aircraftRange, _tripTime, _flightTime, _fuelStops];
}

@end
