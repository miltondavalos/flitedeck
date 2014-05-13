//
//  EllipsoidalDistanceAndCourseResult.m
//  FlightAndTripTime
//
//  Created by Ken Gregory on 2/13/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFTEllipsoidalDistanceAndCourseInfo.h"

@implementation NFTEllipsoidalDistanceAndCourseInfo

@synthesize distanceKM=_distanceKM;
@synthesize distanceNM=_distanceNM;
@synthesize distanceSM=_distanceSM;
@synthesize frontCourse=_frontCourse;


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


-(id) initWithDistanceKM:(double) distanceInKiloMeters distanceSM:(double) distanceInStatuteMiles distanceNM:(double) distanceInNauticalMiles frontCourse:(double) frontCourse
{
    self = [self init];
    if (self) {
        self.distanceKM=distanceInKiloMeters;
        self.distanceNM=distanceInNauticalMiles;
        self.distanceSM=distanceInStatuteMiles;
        self.frontCourse=frontCourse;
    }
    return self;    
    
}


-(NSString *)description
{
    return [[NSString alloc] initWithFormat:@"%g KM, %g NM, %g SM, %g Course",self.distanceKM,self.distanceNM,self.distanceSM,self.frontCourse];
}

@end
