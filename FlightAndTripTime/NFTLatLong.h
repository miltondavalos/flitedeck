//
//  NFTLatLong.h
//  FlightAndTripTime
//
//  Created by Ken Gregory on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFTLatitude.h"
#import "NFTLongitude.h"

@interface NFTLatLong : NSObject

@property (strong, nonatomic) NFTLatitude *latitude;
@property (strong, nonatomic) NFTLongitude *longitude;

- (id) initWithLatitude:(NFTLatitude *)lat 
              longitude:(NFTLongitude *)lng;

- (id) initWithSecondsLatitude:(double)secondsLatitude 
              secondsLongitude:(double)secondsLongitude;

- (double) latitudeInDegrees;
- (double) latitudeInMinutes;
- (double) latitudeInSeconds;

- (double) longitudeInDegrees;
- (double) longitudeInMinutes;
- (double) longitudeInSeconds;

@end
