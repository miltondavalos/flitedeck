//
//  NSDate+Utility.m
//  FliteDeck
//
//  Created by Chad Long on 5/15/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

// Some methods came from:
// Erica Sadun, http://ericasadun.com
// iPhone Developer's Cookbook 3.x and beyond
// BSD License, Use at your own risk

#import "NSDate+Utility.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@implementation NSDate (Utility)

// constructs a GMT date/time using the provided date string and an ISO 8601 format
+ (NSDate*)dateFromISOString:(NSString*)dateString
{
    return [NSDate dateFromString:dateString format:[NSDate iso8601DateTimeFormatString]];
}

// constructs a GMT date/time using the provided date string and format.
// The dateString must be specified in GMT format
+ (NSDate*)dateFromString:(NSString*)dateString format:(NSString*)format
{
    if (dateString == nil ||
        [dateString isEqual:[NSNull null]] ||
        dateString.length == 0 ||
        format == nil)
    {
        return nil;
    }
    
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:format];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    });
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString*)iso8601DateTimeFormatString
{
    static NSString *iso8601DateTimeFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    
    return iso8601DateTimeFormat;
}

+ (NSDate *)dateForMediumFormatString:(NSString *)mediumDateText
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterNoStyle];
    });
    
    return [formatter dateFromString:mediumDateText];
}

- (NSDate*)dateByAddingComponent:(NSInteger)component amount:(NSInteger)amount
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    if (component == NSYearCalendarUnit)
        [comps setYear:amount];
    else if (component == NSMonthCalendarUnit)
        [comps setMonth:amount];
    else if (component == NSDayCalendarUnit)
        [comps setDay:amount];
    else if (component == NSHourCalendarUnit)
        [comps setHour:amount];
    else if (component == NSMinuteCalendarUnit)
        [comps setMinute:amount];
    else if (component == NSSecondCalendarUnit)
        [comps setSecond:amount];
    
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}

// gets a specific date component from this date for a specific timezone
- (NSInteger)dateComponent:(NSInteger)component
{
    return [self dateComponent:component timezone:[NSTimeZone defaultTimeZone]];
}

- (NSInteger)dateComponent:(NSInteger)component timezone:(NSTimeZone*)timezone
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:timezone];
    
    NSDateComponents *dateComponents = [calendar components:component fromDate:self];
    
    if (component == NSYearCalendarUnit)
        return [dateComponents year];
    else if (component == NSMonthCalendarUnit)
        return [dateComponents month];
    else if (component == NSDayCalendarUnit)
        return [dateComponents day];
    else if (component == NSHourCalendarUnit)
        return [dateComponents hour];
    else if (component == NSMinuteCalendarUnit)
        return [dateComponents minute];
    else if (component == NSSecondCalendarUnit)
        return [dateComponents second];
    else if (component == NSWeekdayCalendarUnit)
        return [dateComponents weekday];

    return 0;
}

- (BOOL)isBeforeOrEqualTo:(NSDate*)date
{
    return ([self isBefore:date] || [self compare:date] == NSOrderedSame);
}

- (BOOL)isBefore:(NSDate*)date
{
    return ([self compare:date] == NSOrderedAscending);
}

- (BOOL)isAfterOrEqualTo:(NSDate*)date
{
    return ([self isAfter:date] || [self compare:date] == NSOrderedSame);
}

- (BOOL)isAfter:(NSDate*)date
{
    return ([self compare:date] == NSOrderedDescending);
}

- (BOOL)isEqualToDateIgnoringTime:(NSDate*)aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) &&
			(components1.day == components2.day));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
	return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
	return [[NSDate date] dateBySubtractingDays:days];
}

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

// gets a date/time string in an ISO 8601 format
- (NSString*)description
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDate iso8601DateTimeFormatString]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    return [dateFormatter stringFromDate:self];
}

@end
