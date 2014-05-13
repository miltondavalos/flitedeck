//
//  NFDFlightProfileManager.m
//  FliteDeck
//
//  Created by Chad Predovich on 2/22/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProfileManager.h"

@implementation NFDFlightProfileManager

@synthesize originAirport;
@synthesize leg1Airport;
@synthesize leg2Airport;
@synthesize leg3Airport;
@synthesize destinationAirport;

@synthesize originString;
@synthesize leg1String;
@synthesize leg2String;
@synthesize leg3String;
@synthesize destinationString;

@synthesize season;
@synthesize type;
@synthesize passengers;
@synthesize roundTrip;

@synthesize estimatorData;
@synthesize estimator;

//Implementation of Singleton pattern using GCD that is ARC safe
+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject setEstimatorData:[[FlightEstimatorData alloc] init]];
        [_sharedObject setEstimator:[[NFDFlightProfileEstimator alloc] init]];
        [[_sharedObject estimatorData] setRoundTrip:YES];
    });
    return _sharedObject;
}

+(void) resetInformation {
    [NFDFlightProfileManager.sharedInstance setOriginAirport:nil];
    [NFDFlightProfileManager.sharedInstance setLeg1Airport:nil];
    [NFDFlightProfileManager.sharedInstance setLeg2Airport:nil];
    [NFDFlightProfileManager.sharedInstance setLeg3Airport:nil];
    [NFDFlightProfileManager.sharedInstance setDestinationAirport:nil];
    [[NFDFlightProfileManager.sharedInstance  estimatorData ] resetInformation];
    
}


@end
