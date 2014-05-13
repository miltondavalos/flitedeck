//
//  GeoHelper.h
//  FlightProfile
//
//  Created by Evol Johnson on 1/11/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDAirport.h"

@interface GeoHelper : NSObject
+ (float)distanceBetweenLat1:(float)lat1 Long1:(float)lon1 Lat2:(float)lat2 Long2:(float)lon2;

+ (float)distanceBetweenAirports: (NFDAirport*) origin destination: (NFDAirport*) destination;
@end
