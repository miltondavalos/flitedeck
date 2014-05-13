//
//  UIColor+FliteDeckColors.h
//  FliteDeck
//
//  Created by Chad Predovich on 10/11/13.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (FliteDeckColors)

+ (UIColor *)tintColorDefault;
+ (UIColor *)tintColorForLightBackground;
+ (UIColor *)barTintColorDefault;

+ (UIColor *)flightPathColor;
+ (UIColor *)flightNotDepartedColor;
+ (UIColor *)flightInAirColor;
+ (UIColor *)flightLandedColor;

+ (UIColor *)mainBackgroundColor;
+ (UIColor *)contentBackgroundColor;
+ (UIColor *)modalBackgroundColor;
+ (UIColor *)modalNavigationBarTintColor;

+ (UIColor *)errorBackgroundColor;

+ (UIColor *)tableViewBackgroundColor;
+ (UIColor *)tableViewCellDefaultBackgroundColor;
+ (UIColor *)tableViewCellSelectedBackgroundColor;
+ (UIColor *)tableViewCellDefaultSecondaryTextColor;
+ (UIColor *)tableViewCellSelectedSecondaryTextColor;
+ (UIColor *)dividerLineColor;

+ (UIColor *)fliteDeckYellowColor;
+ (UIColor *)fliteDeckGreenColor;

+ (UIColor *)buttonBackgroundColorDisabled;
+ (UIColor *)buttonBackgroundColorEnabled;
+ (UIColor *)buttonTitleColorDisabled;
+ (UIColor *)buttonTitleColorEnabled;

+ (UIColor *)descriptorLabelTextColor;
+ (UIColor *)valueLabelTextColor;
+ (UIColor *)flightDetailsBorderColor;
+ (UIColor *)caseSectionHeadingBackgroundColor;
+ (UIColor *)caseSectionHeadingTextColor;
+ (UIColor *)caseBorderSelectedColor;

@end
