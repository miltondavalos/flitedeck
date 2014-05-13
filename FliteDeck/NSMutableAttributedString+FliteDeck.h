//
//  NSMutableAttributedString+FliteDeck.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/16/13.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (FliteDeck)

+ (NSMutableAttributedString *)applyTextColor:(UIColor *)color toAllInstancesOfSubstring:(NSString *)substring inText:(NSString *)text;

@end
