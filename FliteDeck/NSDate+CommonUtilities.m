//
//  NSDate+CommonUtilities.m
//  FliteDeck
//
//  Created by Chad Predovich on 3/7/13.
//
//

#import "NSDate+CommonUtilities.h"

@implementation NSDate (CommonUtilities)

+ (NSString *)nextYearString
{
    NSDate *now = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:+1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:now options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:newDate];
}

- (NSInteger)numberOfDaysUntil:(NSDate *)aDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:aDate options:0];
    
    return [components day];
}

@end
