//
//  NSNumber+Utilities.m
//  FlightProfile
//
//  Created by Mohit Jain on 1/30/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NSNumber+Utilities.h"

@implementation NSNumber (Utilities) 

- (NSString*) numberWithCommas:(int)decimalValue
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:decimalValue];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:self];
    return formattedNumberString;
}

@end
