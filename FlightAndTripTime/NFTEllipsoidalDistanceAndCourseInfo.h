//
//  EllipsoidalDistanceAndCourseResult.h
//  FlightAndTripTime
//
//  Created by Ken Gregory on 2/13/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFTEllipsoidalDistanceAndCourseInfo : NSObject

@property (nonatomic) double distanceKM;
@property (nonatomic) double distanceSM;
@property (nonatomic) double distanceNM;
@property (nonatomic) double frontCourse;

-(id) initWithDistanceKM:(double) distanceInKilometers
              distanceSM:(double) distanceInStatuteMiles
              distanceNM:(double) distanceInNauticalMiles
             frontCourse:(double) frontCourse;

-(NSString *)description;

@end
