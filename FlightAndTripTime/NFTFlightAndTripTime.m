//
//  NFTFlightAndTripTime.m
//  FlightAndTripTime
//
//  Created by Chad Long on 2/8/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <math.h>

#import "NFTFlightAndTripTime.h"
#import "NFTFlightCalculator.h"
#import "NFTPersistenceManager.h"
#import "NFTTripInfo.h"

@implementation NFTFlightAndTripTime

+ (NFTTripInfo*)tripInfoForAircraftType:(NSString*)aircraftType
          latitudeAndLongitudeForOrigin:(NFTLatLong*)originLatLong
     latitudeAndLongitudeForDestination:(NFTLatLong*)destLatLong
                                 season:(NFTSeason)season
                     numberOfPassengers:(int)numberOfPax
                        highSpeedCruise:(int)highSpeedCruise
                        maxRangeInHours:(NSDecimalNumber*)maxRange
                                  error:(NSError**)error
{
    // distance, course and winds
    NFTEllipsoidalDistanceAndCourseInfo *distAndCourse = [NFTFlightCalculator ellipsoidalDistanceAndCourse:originLatLong withDestination:destLatLong];

    int windCorrection = [NFTFlightCalculator getWindCorrection:originLatLong
                                                         season:season
                                                     trueCourse:distAndCourse.frontCourse];

    // flight time
    NSError *flightTimeError = nil;
    NSDecimalNumber *flightTime = [NFTFlightCalculator flightTimeForAircraftType:aircraftType
                                                         distanceInNauticalMiles:distAndCourse.distanceNM
                                                                  windCorrection:windCorrection
                                                                           error:&flightTimeError];
    
    if (flightTimeError)
    {
        if (error != 0)
            *error = flightTimeError;
        
        return nil;
    }

    // endurance
    NFTEnduranceEntry *endurance = [NFTFlightCalculator enduranceForAircraftType:aircraftType
                                                                     numberOfPax:numberOfPax
                                                                  windCorrection:windCorrection];

    if (!endurance &&
       (maxRange == nil || [maxRange floatValue] <= 0))
    {
        if (error != 0)
        {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"Unable to obtain aircraft endurance information." forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"FlightAndTripTime" code:102 userInfo:details];
        }
        
        return nil;
    }

    // fuel stops and trip time
    int fuelStops = [NFTFlightCalculator fuelStopsWithEndurance:(endurance == nil ? maxRange : endurance.endurance) flightTime:flightTime];
    NSDecimalNumber* tripTime = [NFTFlightCalculator tripTimeForAircraftType:aircraftType flightTime:flightTime techStops:fuelStops];

    return [NFTTripInfo tripInfoWithDistance:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.1f", distAndCourse.distanceNM]]
                           aircraftEndurance:endurance.endurance
                               aircraftRange:[endurance.range intValue]
                                    tripTime:tripTime
                                  flightTime:flightTime
                                   fuelStops:fuelStops];
}

+ (NFTTripInfo*)tripInfoForAircraftType:(NSString*)aircraftType
          latitudeAndLongitudeForOrigin:(NFTLatLong*)originLatLong
     latitudeAndLongitudeForDestination:(NFTLatLong*)destLatLong
                                 season:(NFTSeason)season
                     numberOfPassengers:(int)numberOfPax
                                  error:(NSError**)error
{
    return [NFTFlightAndTripTime tripInfoForAircraftType:aircraftType
                           latitudeAndLongitudeForOrigin:originLatLong
                      latitudeAndLongitudeForDestination:destLatLong
                                                  season:season
                                      numberOfPassengers:numberOfPax
                                         highSpeedCruise:0
                                         maxRangeInHours:[NSDecimalNumber zero]
                                                   error:&*error];
}

+ (NSDecimalNumber*)flightTimeForAircraftType:(NSString*)aircraftType
                latitudeAndLongitudeForOrigin:(NFTLatLong*)originLatLong
           latitudeAndLongitudeForDestination:(NFTLatLong*)destLatLong
                                       season:(NFTSeason)season
                              highSpeedCruise:(int)highSpeedCruise
                                        error:(NSError**)error
{
    NFTEllipsoidalDistanceAndCourseInfo *distAndCourse = [NFTFlightCalculator ellipsoidalDistanceAndCourse:originLatLong withDestination:destLatLong];
    
    int windCorrection = [NFTFlightCalculator getWindCorrection:originLatLong
                                                         season:season
                                                     trueCourse:distAndCourse.frontCourse];
    
    NSDecimalNumber *flightTime = [NFTFlightCalculator flightTimeForAircraftType:aircraftType
                                                         distanceInNauticalMiles:distAndCourse.distanceNM
                                                                  windCorrection:windCorrection
                                                                           error:&*error];
    
    return flightTime;
}

@end
