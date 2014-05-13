//
//  MathUtil.h
//  FlightAndTripTime
//
//  Created by Ken Gregory on 2/11/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NFTMathUtil : NSObject




/**
 * Constant to convert degrees to radians.
 *
 * Conversion from java approach came from here: 
 * http://iphonedevelopertips.com/objective-c/java-developers-guide-to-static-variables-in-objective-c.html
 */
+ (double) DEG_RAD;


/**
 * Constant to convert radians to degrees.
 */
+ (double) RAD_DEG;


/**
 * Calculate the sine of the parameter given in degrees.
 */
+ (double) sinDegrees:(double) degrees;

/**
 * Calculate the arc sine of the parameter given in degrees.
 */
+ (double) asinDegrees:(double) degrees;

/**
 * Calculate the cosine of the parameter given in degrees.
 */
+ (double) cosDegrees:(double) degrees;

/**
 * Calculate the arc cosine of the parameter given in degrees.
 */
+ (double) acosDegrees:(double) degrees;

/**
 * Calculate the tangent of the parameter given in degrees.
 */
+ (double) tanDegrees:(double) degrees;

/**
 * Calculate the arc tangent of the parameter given in degrees.
 */
+ (double) atanDegrees:(double) degrees;

/**
 * Round a double to the specified number of decimal places.
 * 
 * @param toBeRounded The double to be rounded.
 * @param fractionDigits The number of decimal places to round to.
 * @return The double rounded to the specified number of decimal places.
 */
+ (double) roundDouble:(double) toBeRounded withFractionalDigits:(int) fractionDigits;



@end
