//
//  NFTLatLong.m
//  FlightAndTripTime
//
//  ported from com.netjets.common.latlong.LatLong.java found in Netjets-Common
//
//  Created by Ken Gregory on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFTLatLong.h"

@implementation NFTLatLong

@synthesize latitude=_latitude;
@synthesize longitude=_longitude;

#pragma mark initialization

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (id) initWithLatitude:(NFTLatitude *)lat 
           longitude:(NFTLongitude *)lng
{
    self=[super init];
    if(self){
        self.latitude=lat;
        self.longitude=lng;
    }
    return self;
}

- (id) initWithSecondsLatitude:(double)secondsLatitude 
           secondsLongitude:(double)secondsLongitude
{
    self=[super init];
    if(self){

        self.latitude=[[NFTLatitude alloc] initWithSeconds:secondsLatitude];
        self.longitude=[[NFTLongitude alloc] initWithSeconds:secondsLongitude];
    }
    return self;
}

/**
 * @return The latitude converted to degrees.
 */
- (double) latitudeInDegrees
{
    return [self.latitude toDegrees];
}

- (double) latitudeInMinutes
{
    return [self.latitude toMinutes];
}
- (double) latitudeInSeconds
{
    return [self.latitude toSeconds];
}


- (double) longitudeInDegrees
{
    return [self.longitude toDegrees];
}
- (double) longitudeInMinutes
{
    return [self.longitude toMinutes];
}
- (double) longitudeInSeconds
{
    return [self.longitude toSeconds];
}

- (NSString *) description
{
    return [[NSString alloc] initWithFormat:@"Latitude: %@\nLongitude: %@",self.latitude,self.longitude];
}

@end
