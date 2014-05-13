//
//  NFDCalenderMonthHeaderCell.m
//  TimesSquareTestApp
//
//  Created by Jeff Bailey on 10/15/13.
//
//

#import "NFDCalenderMonthHeaderCell.h"

@implementation NFDCalenderMonthHeaderCell


- (id)initWithCalendar:(NSCalendar *)calendar reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithCalendar:calendar reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)createHeaderLabels;
{
    self.textColor = [UIColor blackColor];

    NSDate *referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSDateComponents *offset = [NSDateComponents new];
    offset.day = 1;
    NSMutableArray *headerLabels = [NSMutableArray arrayWithCapacity:self.daysInWeek];
    
    NSDateFormatter *dayFormatter = [NSDateFormatter new];
    dayFormatter.calendar = self.calendar;
    dayFormatter.dateFormat = @"ccc"; // Three letter day format
    
    
    for (NSUInteger index = 0; index < self.daysInWeek; index++) {
        [headerLabels addObject:@""];
    }
    
    for (NSUInteger index = 0; index < self.daysInWeek; index++) {
        NSInteger ordinality = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:referenceDate];
        UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [dayFormatter stringFromDate:referenceDate];
        label.font = [UIFont boldSystemFontOfSize:12.f];
        label.backgroundColor = self.backgroundColor;
        label.textColor = self.textColor;
        [label sizeToFit];
        headerLabels[ordinality - 1] = label;
        [self.contentView addSubview:label];
        
        referenceDate = [self.calendar dateByAddingComponents:offset toDate:referenceDate options:0];
    }
    
    self.headerLabels = headerLabels;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = self.textColor;
}

@end
