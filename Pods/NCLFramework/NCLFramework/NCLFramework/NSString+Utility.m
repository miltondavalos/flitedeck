//
//  NSString+Utility.m
//  FliteDeck
//
//  Created by Chad Long on 5/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NSString+Utility.h"
#import "NSDate+Utility.h"

@implementation NSString (Utility)

+ (NSString*)stringFromDate:(NSDate*)date formatType:(NCLDateFormat)format
{
    return [NSString stringFromDate:date formatType:format timezone:[NSTimeZone defaultTimeZone]];
}

// using the device culture settings, formats a date to {date, time, or date & time} for the specified timezone
// an empty string is returned for null values
+ (NSString*)stringFromDate:(NSDate*)date formatType:(NCLDateFormat)format timezone:(NSTimeZone*)timezone
{
    if (date == nil ||
        [date isEqual:[NSNull null]] ||
        timezone == nil ||
        format > 3 || format < 1)
    {
        return @"";
    }
    
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterFromFormatType:format timezone:timezone];
    
    // return the formatted date string
    return [formatter stringFromDate:date];
}

+ (NSString*)stringFromObject:(id)object
{
    if (object == nil ||
        [object isEqual:[NSNull null]])
    {
        return @"";
    }
    
    if ([object isKindOfClass:[NSString class]])
        return (NSString*)object;
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber*)object stringValue];

    return [object description];
}


// trims leading and trailing spaces from this string 
- (NSString*)stringByTrimmingWhiteSpaceAndNewLines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// transforms all instances of adjacent whitespace into a single space
- (NSString*)stringByRemovingExtraWhiteSpace
{
    NSString *cleanedString = self;
    
    while ([cleanedString rangeOfString:@"  "].location != NSNotFound)
    {
        cleanedString = [cleanedString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }

    return cleanedString;
}

// removes all characters from a string that are part of the specified character set
- (NSString*)stringByRemovingCharactersInCharacterSet:(NSCharacterSet*)characterSet
{
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
}

-(NSString *) trimmed {
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    NSString *cleansed = [filteredArray componentsJoinedByString:@" "];
    return  cleansed;
}

// replaces all the specified substrings with the specified font
- (NSMutableAttributedString*)attributedStringWithFont:(UIFont*)font substrings:(NSArray*)substrings
{
    NSMutableArray *characterArray = [NSMutableArray new];
    NSMutableArray *wordArray = [NSMutableArray new];
    
    for (NSString *textToAttribute in substrings)
    {
        if (textToAttribute.length == 1)
        {
            [characterArray addObject:textToAttribute];
        }
        else if (textToAttribute.length > 1)
        {
            [wordArray addObject:textToAttribute];
        }
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         if ([characterArray containsObject:substring])
         {
             [attrString setAttributes:attributes range:substringRange];
         }
     }];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         if ([wordArray containsObject:substring])
         {
             [attrString setAttributes:attributes range:substringRange];
         }
     }];
    
    return attrString;
}

// case insensitive search for a string within another string
- (BOOL)contains:(NSString*)what
{
    NSRange range = [self rangeOfString:what options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound)
        return YES;
    
    return NO;
}

// Validation for Email:
- (BOOL)isValidEmail
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([self isEqualToString:@""])
    {
        return TRUE;
    }
    else
    {
        return [emailTest evaluateWithObject:self];
    }
}

- (NSString*)createNetJetsEmail
{
    NSString *string = [self stringByTrimmingWhiteSpaceAndNewLines];
    NSString *netjetsEmail = @"@netjets.com";
    
    if ([string contains:netjetsEmail]) {
        return string;
    }
    
    NSRange range = [string rangeOfString:@"@"];
    NSString *username;
    
    if (range.location == NSNotFound) {
        username = string;
    } else {
        username = [string substringToIndex:range.location];
    }
    
    return [NSString stringWithFormat:@"%@%@", username, netjetsEmail];
}

- (BOOL)isEmptyOrWhitespace {
    return !self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

@end
