//
//  NSDate+Utility.h
//  FliteDeck
//
//  Created by Chad Long on 5/15/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

+ (NSDate*)dateFromISOString:(NSString*)dateString;
+ (NSDate*)dateFromString:(NSString*)dateString format:(NSString*)format;
+ (NSString*)iso8601DateTimeFormatString;
+ (NSDate *)dateForMediumFormatString:(NSString *)mediumDateText;

+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;

- (NSDate*)dateByAddingComponent:(NSInteger)component amount:(NSInteger)amount;
- (NSInteger)dateComponent:(NSInteger)component;
- (NSInteger)dateComponent:(NSInteger)component timezone:(NSTimeZone*)timezone;

- (BOOL)isBefore:(NSDate*)date;
- (BOOL)isBeforeOrEqualTo:(NSDate*)date;
- (BOOL)isAfter:(NSDate*)date;
- (BOOL)isAfterOrEqualTo:(NSDate*)date;

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;

- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;

@end
