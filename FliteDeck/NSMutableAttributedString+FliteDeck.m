//
//  NSMutableAttributedString+FliteDeck.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/16/13.
//
//

#import "NSMutableAttributedString+FliteDeck.h"

@implementation NSMutableAttributedString (FliteDeck)

+ (NSMutableAttributedString *)applyTextColor:(UIColor *)color toAllInstancesOfSubstring:(NSString *)substring inText:(NSString *)text
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSString *pattern = [NSString stringWithFormat:@"(%@)", substring];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:nil];
    
    NSRange range = NSMakeRange(0, text.length);
    
    [regex enumerateMatchesInString:text options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:subStringRange];
    }];
    
    return mutableAttributedString;
}

@end
