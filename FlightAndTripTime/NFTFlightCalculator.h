//
//  NFTFlightCalculator.h
//  FlightAndTripTime
//
//  Created by Chad Long on 2/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NFTAlgorithms.h"
#import "NFTEnduranceEntry.h"
#import "NFTLatLong.h"
#import "NFTEllipsoidalDistanceAndCourseInfo.h"

@interface NFTFlightCalculator : NSObject

+ (NSDecimalNumber*)tripTimeForAircraftType:(NSString*)aircraftType
                                 flightTime:(NSDecimalNumber*)flightTime
                                  techStops:(int)techStops;

+ (NSDecimalNumber*)flightTimeForAircraftType:(NSString*)aircraftType
                      distanceInNauticalMiles:(double)distance
                               windCorrection:(int)windCorrection
                                        error:(NSError**)error;

+ (NSDecimalNumber*)flightTimeForAircraftType:(NSString*)aircraftType
                      distanceInNauticalMiles:(double)distance
                               windCorrection:(int)windCorrection
                              highSpeedCruise:(int)highSpeedCruise
                                        error:(NSError**)error;

+ (NFTEnduranceEntry*)enduranceForAircraftType:(NSString*)aircraftType
                                   numberOfPax:(int)numberOfPax
                                windCorrection:(int)headWind;

+ (int)fuelStopsWithEndurance:(NSDecimalNumber*)endurance
                   flightTime:(NSDecimalNumber*)flightTime;

+ (NFTEllipsoidalDistanceAndCourseInfo*)ellipsoidalDistanceAndCourse:(NFTLatLong*)station1
                                                    withDestination:(NFTLatLong*)station2;

+ (int)getWindCorrection:(NFTLatLong *)airportLatLong 
                  season:(NFTSeason)seasonCode
              trueCourse:(int)trueCourse;

+ (int)findHighTrueCourse:(int)trueCourse 
                  latBand:(int)latBand 
                  context:(NSManagedObjectContext *)context;

+ (int)findLowTrueCourse:(int)trueCourse 
                  latBand:(int)latBand 
                  context:(NSManagedObjectContext *)context;

+ (int)findSeasonCorrection:(int)trueCourse 
                    latBand:(int)latBand
                     season:(NSString *)season
                    context:(NSManagedObjectContext *)context;

@end
