//
//  NFTAlgorithms.h
//
//  Ported from IJet2 and more specifically the Java code under FlightServices.R1, 
//  com.netjets.common.aviation.Algorithms.java
//
//  Created by Ron McCamish on 2/6/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RADIANS_PER_NAUTICAL_MILE = ((180.0d * 60.0d) / Math.PI)

#define NAUTICAL_MILES_PER_STATUTE_MILE 0.86897624f
#define STATUTE_MILES_PER_NAUTICAL_MILE 1.15077945f
#define KILOMETERS_PER_STATUTE_MILE     1.609347f

#define a_WGS84  6378137.0
#define f_WGS84  (1.0 / 298.25722210088)

typedef enum {SPRING, SUMMER, FALL, WINTER, ANNUAL} NFTSeason;

@interface NFTAlgorithms : NSObject

+ (float)interp_1d:(float)lowCrs 
            lowVal:(float)lowVal 
           highCrs:(float)highCrs 
           highVal:(float)highVal 
        trueCourse:(float)trueCourse;


+ (int)convertLatBandByDirection:(int)latBand
                          latDir:(char)latDir;

+ (NSString *)getSeasonByCode:(NFTSeason)season;

+ (int)annualWindCorrection:(int)winter 
                     spring:(int)spring
                     summer:(int)summer
                       fall:(int)fall;

@end

