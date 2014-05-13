//
//  NFDCalenderMonthHeaderCell.h
//  TimesSquareTestApp
//
//  Created by Jeff Bailey on 10/15/13.
//
//

#import <TimesSquare/TimesSquare.h>


@interface NFDCalenderMonthHeaderCell : TSQCalendarMonthHeaderCell

- (id)initWithCalendar:(NSCalendar *)calendar reuseIdentifier:(NSString *)reuseIdentifier;

- (void)createHeaderLabels;

@end
