//
//  NSDate+CommonUtilities.h
//  FliteDeck
//
//  Created by Chad Predovich on 3/7/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (CommonUtilities)

+ (NSString *)nextYearString;

- (NSInteger)numberOfDaysUntil:(NSDate *)aDate;

@end
