//
//  NFDCase.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/13/13.
//
//

#import "NFDCase.h"
#import "UIColor+FliteDeckColors.h"
#import "NSMutableAttributedString+FliteDeck.h"

@implementation NFDCase

- (NSMutableAttributedString *)caseTitleDisplayText
{
    NSString *separator = @"→";
    
    NSString *title;
    
    if (self.type && ![self.type isEmptyOrWhitespace]) {
        title = self.type;
        
        if (self.category && ![self.category isEmptyOrWhitespace]) {
            title = [NSString stringWithFormat:@"%@ %@ %@", title, separator, self.category];
        }
        
        if (self.details && ![self.details isEmptyOrWhitespace]) {
            title = [NSString stringWithFormat:@"%@ %@ %@", title, separator, self.details];
        }
    } else {
        return nil;
    }
    
    NSMutableAttributedString *mutableAttributedString = [NSMutableAttributedString applyTextColor:[UIColor tintColorDefault] toAllInstancesOfSubstring:separator inText:title];
    
    return mutableAttributedString;
}

- (NSString *)minutesDelayedDisplayText
{
    if (self.minutesDelayed && ![self.minutesDelayed isEmptyOrWhitespace]) {
        return [NSString stringWithFormat:@"%@ minutes delayed", self.minutesDelayed];
    } else {
        return @"Not delayed";
    }
    
    return nil;
}

- (BOOL)isOpen
{
    return [self.status boolValue];
}

@end
