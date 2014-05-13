//
//  NSDateFormatter+Utility.m
//  NCLFramework
//
//  Created by Chad Long on 9/9/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NSDateFormatter+Utility.h"
#import "NCLFramework.h"

@implementation NSDateFormatter (Utility)

+ (NSDateFormatter*)dateFormatterFromFormatType:(NCLDateFormat)format
{
    return [self dateFormatterFromFormatType:format timezone:[NSTimeZone defaultTimeZone]];
}

+ (NSDateFormatter*)dateFormatterFromFormatType:(NCLDateFormat)format timezone:(NSTimeZone*)timezone
{
    // get the standard format for the culture set on the device
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timezone];
    
    if (format != NCLDateFormatTimeOnly)
        [formatter setDateStyle:NSDateFormatterShortStyle];
    else
        [formatter setDateStyle:NSDateFormatterNoStyle];
    
    if (format != NCLDateFormatDateOnly)
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    else
        [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    // enforce two-digit month and day if preferred
    if (format != NCLDateFormatTimeOnly)
    {
        NSObject *shouldUseTwoDigitDateComponents = [NCLFramework appPreferenceForKey:NCLDateFormatShouldUseTwoDigitDateComponentsKey];
        
        if (shouldUseTwoDigitDateComponents &&
            [(NSNumber*)shouldUseTwoDigitDateComponents isEqualToNumber:@YES])
        {
            if ([formatter.dateFormat rangeOfString:@"M" options:0].location != NSNotFound &&
                [formatter.dateFormat rangeOfString:@"MM" options:0].location == NSNotFound)
            {
                formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:@"M" withString:@"MM"];
            }
            
            if ([formatter.dateFormat rangeOfString:@"d" options:0].location != NSNotFound &&
                [formatter.dateFormat rangeOfString:@"dd" options:0].location == NSNotFound)
            {
                formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:@"d" withString:@"dd"];
            }
            
            if ([formatter.dateFormat rangeOfString:@"yyyy" options:0].location != NSNotFound)
            {
                formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
            }
        }
    }
    
    // enforce military time if preferred
    if (format != NCLDateFormatDateOnly)
    {
        NSObject *shouldUseMilitaryTime = [NCLFramework appPreferenceForKey:NCLDateFormatShouldUseMilitaryTimeKey];
        
        if (shouldUseMilitaryTime &&
            [(NSNumber*)shouldUseMilitaryTime isEqualToNumber:@YES])
        {
            if ([formatter.dateFormat rangeOfString:@"h" options:0].location != NSNotFound &&
                [formatter.dateFormat rangeOfString:@"hh" options:0].location == NSNotFound)
            {
                formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:@"h" withString:@"HH"];
            }
            
            else if ([formatter.dateFormat rangeOfString:@"hh" options:0].location != NSNotFound)
            {
                formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:@"hh" withString:@"HH"];
            }
            
            else if ([formatter.dateFormat rangeOfString:@"H" options:0].location != NSNotFound &&
                     [formatter.dateFormat rangeOfString:@"HH" options:0].location == NSNotFound)
            {
                formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:@"H" withString:@"HH"];
            }
            
            if ([formatter.dateFormat rangeOfString:@"a" options:0].location != NSNotFound)
            {
                formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:@"a" withString:@""];
                formatter.dateFormat = [formatter.dateFormat stringByTrimmingWhiteSpaceAndNewLines];
            }
        }
    }
    
    // strip colons if preferred
    static NSString *colon = @":";
    NSObject *shouldStripColons = [NCLFramework appPreferenceForKey:NCLDateFormatShouldStripColonsKey];
    
    if (shouldStripColons &&
        [(NSNumber*)shouldStripColons isEqualToNumber:@YES] &&
        [formatter.dateFormat rangeOfString:colon options:0].location != NSNotFound)
    {
        formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:colon withString:@""];
    }
    
    // strip commas if preferred
    static NSString *comma = @",";
    NSObject *shouldStripCommas = [NCLFramework appPreferenceForKey:NCLDateFormatShouldStripCommasKey];
    
    if (shouldStripCommas &&
        [(NSNumber*)shouldStripCommas isEqualToNumber:@YES] &&
        [formatter.dateFormat rangeOfString:comma options:0].location != NSNotFound)
    {
        formatter.dateFormat = [formatter.dateFormat stringByReplacingOccurrencesOfString:comma withString:@""];
    }
    
    return formatter;
}

@end
