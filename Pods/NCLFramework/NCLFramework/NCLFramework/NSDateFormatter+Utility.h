//
//  NSDateFormatter+Utility.h
//  NCLFramework
//
//  Created by Chad Long on 9/9/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NCLDateFormatDateOnly = 1,
    NCLDateFormatTimeOnly,
    NCLDateFormatDateAndTime,
} NCLDateFormat;

@interface NSDateFormatter (Utility)

+ (NSDateFormatter*)dateFormatterFromFormatType:(NCLDateFormat)format;
+ (NSDateFormatter*)dateFormatterFromFormatType:(NCLDateFormat)format timezone:(NSTimeZone*)timezone;

@end
