//
//  NFDFlightTrackingDetailMapAnnotation.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/7/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "NFDFlight.h"
#import "NFDAirport.h"

#define ARRIVAL_ANNOTIAION @"ARRIVAL_ANNOTIAION"
#define DEPARTURE_ANNOTIAION @"DEPARTURE_ANNOTIAION"
#define AIRCRAFT_ANNOTIAION @"AIRCRAFT_ANNOTIAION"
#define WESTBOUND_FLIGHT @"WESTBOUND_FLIGHT"
#define EASTBOUND_FLIGHT @"EASTBOUND_FLIGHT"

@interface NFDFlightTrackingDetailMapAnnotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D _coordinate;
    NSString *typeOfAnnotation;
    NFDFlight *flight;
    NFDAirport * airport;
    CLLocationDirection direction;
    
}

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) NSString *typeOfAnnotation;
@property(nonatomic, strong) NFDFlight *flight;
@property(nonatomic, strong) NFDAirport *airport;
@property CLLocationDirection direction;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (NSString*) title;
- (NSString*) subtitle;

@end
