//
//  NSString+Utility.h
//  FliteDeck
//
//  Created by Chad Long on 5/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSDateFormatter+Utility.h"

@interface NSString (Utility)

+ (NSString*)stringFromDate:(NSDate*)date formatType:(NCLDateFormat)format;
+ (NSString*)stringFromDate:(NSDate*)date formatType:(NCLDateFormat)format timezone:(NSTimeZone*)timezone;
+ (NSString*)stringFromObject:(id)object;

- (NSString*)stringByTrimmingWhiteSpaceAndNewLines;
- (NSString*)stringByRemovingExtraWhiteSpace;
- (NSString*)stringByRemovingCharactersInCharacterSet:(NSCharacterSet*)characterSet;

- (NSMutableAttributedString*)attributedStringWithFont:(UIFont*)font substrings:(NSArray*)substrings;

- (NSString *) trimmed;
- (BOOL)contains:(NSString*)what;
- (BOOL)isValidEmail;
- (NSString*)createNetJetsEmail;
- (BOOL)isEmptyOrWhitespace;

@end
