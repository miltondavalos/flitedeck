//
//  NFTAlgorithms.m
//
//  Ported from IJet2 and more specifically the Java code under FlightServices.R1, 
//  com.netjets.common.aviation.Algorithms.java
//
//  Created by Ron McCamish on 2/6/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFTAlgorithms.h"

#include <math.h>

@implementation NFTAlgorithms


/**
 Linear interpolation value between low and high correction.
 */

+ (float)interp_1d:(float)lowCrs 
            lowVal:(float)lowVal 
           highCrs:(float)highCrs 
           highVal:(float)highVal 
        trueCourse:(float)trueCourse
{
    
    if (highCrs == lowCrs)
    {
        return highVal;
    }
        
    return (highVal - (((highCrs - trueCourse) * (highVal - lowVal)) / (highCrs - lowCrs)));
}


/**
 Convert latitude band based on the flight direction.
 */

+ (int)convertLatBandByDirection:(int)latBand
                          latDir:(char)latDir 
{
    if (latDir == 'S')
    {
        if (latBand > 0)
        {
            latBand = -1 * latBand;
        }
    }
    return latBand;
}

/**
 Return the season code based on selected season value
 */

+ (NSString *)getSeasonByCode:(NFTSeason)season
{
    NSString *stringForSeason;
    
    if (season == WINTER)
    {
        stringForSeason = @"winterCorrection";
        
    }
    else if (season == SPRING ||
             season == FALL)
    {
        stringForSeason = @"springFallCorrection";
        
    }
    else if (season == SUMMER)
    {
        stringForSeason = @"summerCorrection";
    
    }
    else
    {
        // Assume Annual if no match (or Annual is requested)
        stringForSeason = @"annualCorrection";
    }
    
    return stringForSeason;
}


/**
 For now, the assumption is that Annual wind correction is the average of the winter, spring, 
 summer and fall winds.
 */

+ (int)annualWindCorrection:(int)winter 
                         spring:(int)spring
                         summer:(int)summer
                           fall:(int)fall
{    
    return((winter + spring + summer + fall)/4);
}

@end
