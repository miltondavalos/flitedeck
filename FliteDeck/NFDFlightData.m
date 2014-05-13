//
//  NFDFlightData.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightData.h"

@implementation NFDFlightData

@synthesize Response;
@synthesize Status;
@synthesize Origin;
@synthesize Destination;
@synthesize Speed;
@synthesize Altitude;
@synthesize AircraftType;
@synthesize Lat;
@synthesize Lon;
@synthesize Distance;
@synthesize Bearing;
@synthesize EDT;
@synthesize ETA;
@synthesize PDT;
@synthesize PTA;
@synthesize AircraftName;
@synthesize AirlineName;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"WARNING: NFDFlightData attempting to set undefined key: %@ for value: %@", key, value);
}

@end
