//
//  FlightEstimatorParameters.m
//  FlightProfile
//
//  Created by Evol Johnson on 1/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "FlightEstimatorData.h"

@implementation FlightEstimatorData
@synthesize aircrafts, airports, totalDistance,season,product,passengers,results,roundTrip,prospect,userInfo,airportIds;

-(id) init {
    self = [super init];
    if(self){
        prospect = [[Prospect alloc] init];
        airports = [[NSMutableArray alloc] init];
        airportIds = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addAirport: (NFDAirport *) airport{
    if(airport.airportid == nil){
        DLog(@"Corrupted airport object");
    }
    [self.airports addObject:airport];
}

-(void) retrieveAirportsFromIds {
    NFDAirportService *service = [[NFDAirportService alloc] init];
    [self.airports removeAllObjects];
    for(NSString *a in airportIds){
        [self.airports addObject:[service findAirportWithCode:a]];
    }
}

-(void) resetInformation {
    self.product = nil;
    self.season = nil;
    [self.aircrafts removeAllObjects];
    [self.airports removeAllObjects];
    [self.airportIds removeAllObjects];
    self.passengers = 1;
    self.roundTrip = YES;
}

-(void) dealloc {
    self.product = nil;
    self.season = nil;
    [self.aircrafts removeAllObjects];
    self.aircrafts = nil;
    [self.airports removeAllObjects];
    self.airports = nil;
    [self.airportIds removeAllObjects];
    self.airportIds = nil;
    [self.results removeAllObjects];
    self.results = nil;
    //prospect = nil;
    //userInfo = nil;
}
                          
@end
