//
//  MathUtil.m
//  FlightAndTripTime
//
//  Created by Ken Gregory on 2/11/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFTMathUtil.h"
#import <math.h>

@implementation NFTMathUtil


#pragma mark initialization

- (id)init
{
    self = [super init];
    if (self) {
       
    }
    
    return self;
}

#pragma mark Class Methods

/**
 * Constant to convert degrees to radians.
 */
static double DEG_RAD = (M_PI / (double)180.0);
+ (double) DEG_RAD {return DEG_RAD;}


/**
 * Constant to convert radians to degrees.
 */
static  double RAD_DEG = ((double)180.0 / M_PI);
+ (double) RAD_DEG{return RAD_DEG;}


//
/**
 * Calculate the sine of the parameter given in degrees.
 */
+ (double) sinDegrees:(double) degrees
{
   
    return sin(degrees * DEG_RAD);
}


/**
 * Calculate the arc sine of the parameter given in degrees.
 */
+ (double) asinDegrees:(double) degrees
{
    return ((asin(degrees)) * RAD_DEG);
}


/**
 * Calculate the cosine of the parameter given in degrees.
 */
+ (double) cosDegrees:(double) degrees
{
    return (cos(degrees * DEG_RAD));
}


/**
 * Calculate the arc cosine of the parameter given in degrees.
 */
+ (double) acosDegrees:(double) degrees
{
    return ((acos(degrees)) * RAD_DEG);
}

/**
 * Calculate the tangent of the parameter given in degrees.
 */
+ (double) tanDegrees:(double) degrees
{
    return (tan(degrees * DEG_RAD));
}


/**
 * Calculate the arc tangent of the parameter given in degrees.
 */
+ (double) atanDegrees:(double) degrees
{
    return ((atan(degrees)) * RAD_DEG);
}


/**
 * Round a double to the specified number of decimal places.
 * 
 * @param toBeRounded The double to be rounded.
 * @param fractionDigits The number of decimal places to round to.
 * @return The double rounded to the specified number of decimal places.
 */
+ (double) roundDouble:(double) toBeRounded withFractionalDigits:(int) fractionDigits 
{ 
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init ]; 
    
    [format setMaximumFractionDigits:fractionDigits]; 
    
    NSString* tempDouble = [format stringFromNumber:[[NSNumber alloc] initWithDouble:toBeRounded]];
  
    return [[format numberFromString:tempDouble] doubleValue];
             
}



@end
