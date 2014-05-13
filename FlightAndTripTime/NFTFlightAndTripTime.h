//
//  NFTFlightAndTripTime.h
//  FlightAndTripTime
//
//  Created by Chad Long on 2/8/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFTAlgorithms.h"
#import "NFTEnduranceEntry.h"
#import "NFTLatLong.h"
#import "NFTTripInfo.h"
#import "NFTEllipsoidalDistanceAndCourseInfo.h"

@interface NFTFlightAndTripTime : NSObject

+ (NFTTripInfo*)tripInfoForAircraftType:(NSString*)aircraftType
          latitudeAndLongitudeForOrigin:(NFTLatLong*)originLatLong
     latitudeAndLongitudeForDestination:(NFTLatLong*)destLatLong
                                 season:(NFTSeason)season
                     numberOfPassengers:(int)numberOfPax
                        highSpeedCruise:(int)highSpeedCruise
                        maxRangeInHours:(NSDecimalNumber*)maxRange
                                  error:(NSError**)error;

+ (NFTTripInfo*)tripInfoForAircraftType:(NSString*)aircraftType
          latitudeAndLongitudeForOrigin:(NFTLatLong*)originLatLong
     latitudeAndLongitudeForDestination:(NFTLatLong*)destLatLong
                                 season:(NFTSeason)season
                     numberOfPassengers:(int)numberOfPax
                                  error:(NSError**)error;

+ (NSDecimalNumber*)flightTimeForAircraftType:(NSString*)aircraftType
                latitudeAndLongitudeForOrigin:(NFTLatLong*)originLatLong
           latitudeAndLongitudeForDestination:(NFTLatLong*)destLatLong
                                       season:(NFTSeason)season
                              highSpeedCruise:(int)highSpeedCruise
                                        error:(NSError**)error;

@end
