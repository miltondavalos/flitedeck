//
//  NFDFlightTrackingDetailMapAnnotation.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/7/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightTrackingDetailMapAnnotation.h"

@implementation NFDFlightTrackingDetailMapAnnotation

@synthesize coordinate = _coordinate;
@synthesize flight;
@synthesize airport;
@synthesize typeOfAnnotation;
@synthesize direction;

- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate{
    self = [super init];
    if (self != nil) {
        _coordinate = theCoordinate;
    }
    return self;
}

- (NSString*) title{
    NSString *returnTitle = @" ";
    if (flight){
        if ([typeOfAnnotation isEqualToString:ARRIVAL_ANNOTIAION]) {
            returnTitle = [NSString stringWithFormat:@"Arrival: %@", [flight arrivalICAO]];
        } else if ([typeOfAnnotation isEqualToString:DEPARTURE_ANNOTIAION]) {
            returnTitle = [NSString stringWithFormat:@"Departure: %@", [flight departureICAO]];
        } else if ([typeOfAnnotation isEqualToString:AIRCRAFT_ANNOTIAION]) {
            returnTitle = [NSString stringWithFormat:@"Aircraft: %@", [flight aircraftTypeActual]];
        }
    }
    return returnTitle;
}

- (NSString*) subtitle{
    NSString *returnSubTitle = nil;
    if (flight){
        if ([typeOfAnnotation isEqualToString:ARRIVAL_ANNOTIAION]) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *timeStamp = [[NSString alloc] init];
            
            if ([flight arrivalTimeActual] != nil) {
                timeStamp = [dateFormatter stringFromDate:[flight arrivalTimeActual]];
                returnSubTitle = [NSString stringWithFormat:@"Actual:  %@", timeStamp];
            } else if ([flight arrivalTimeEstimated] != nil) {
                timeStamp = [dateFormatter stringFromDate:[flight arrivalTimeEstimated]];
                returnSubTitle = [NSString stringWithFormat:@"Estimated:  %@", timeStamp];
            }
            
        } else if ([typeOfAnnotation isEqualToString:DEPARTURE_ANNOTIAION]) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *timeStamp = [[NSString alloc] init];
            
            if ([flight departureTimeActual] != nil) {
                timeStamp = [dateFormatter stringFromDate:[flight departureTimeActual]];
                returnSubTitle = [NSString stringWithFormat:@"Actual:  %@", timeStamp];
            } else if ([flight departureTimeEstimated] != nil) {
                timeStamp = [dateFormatter stringFromDate:[flight departureTimeEstimated]];
                returnSubTitle = [NSString stringWithFormat:@"Estimated:  %@", timeStamp];
            }       
          
        } else if ([typeOfAnnotation isEqualToString:AIRCRAFT_ANNOTIAION]) {
            returnSubTitle = [NSString stringWithFormat:@"Status: %@", [flight flightStatus]];
        }
    }
    
    return returnSubTitle;
}

@end
