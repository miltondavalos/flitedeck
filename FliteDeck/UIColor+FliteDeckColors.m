//
//  UIColor+FliteDeckColors.m
//  FliteDeck
//
//  Created by Chad Predovich on 10/11/13.
//
//

#import "UIColor+FliteDeckColors.h"

@implementation UIColor (FliteDeckColors)

+ (UIColor *)tintColorDefault
{
    return [UIColor colorWithRed:0.503 green:0.732 blue:0.859 alpha:1.000];
}

+ (UIColor *)tintColorForLightBackground
{
    return [UIColor colorWithRed:0.239 green:0.344 blue:0.525 alpha:1.000];
}

+ (UIColor *)barTintColorDefault
{
    return [UIColor colorWithWhite:0.198 alpha:1.000];
}

+ (UIColor *)flightPathColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)flightNotDepartedColor
{
//    return [UIColor colorWithRed:1.0 green:0.51 blue:0.53 alpha:1.000];  Salmon
    return [UIColor whiteColor];
}

+ (UIColor *)flightInAirColor
{
    // Dark green
    return [UIColor colorWithRed:0 green:.51 blue:.15 alpha:1.000];
}

+ (UIColor *)flightLandedColor
{
    // Light green
    return [UIColor fliteDeckGreenColor];
}

+ (UIColor *)mainBackgroundColor
{
    return [UIColor colorWithWhite:0.11 alpha:1.0];
}

+ (UIColor *)contentBackgroundColor
{
    return [UIColor colorWithWhite:0.17 alpha:1.0];
}

+ (UIColor *)modalBackgroundColor
{
    return [UIColor colorWithWhite:0.200 alpha:1.000];
}

+ (UIColor *)modalNavigationBarTintColor
{
    return [UIColor colorWithWhite:0.198 alpha:1.000];
}

+ (UIColor *)errorBackgroundColor
{
    return [UIColor colorWithRed:0.566 green:0.164 blue:0.144 alpha:1.000];
}

+ (UIColor *)tableViewBackgroundColor
{
    return [UIColor colorWithWhite:0.137 alpha:1.000];
}

+ (UIColor *)tableViewCellDefaultBackgroundColor
{
    return [UIColor colorWithRed:0.137 green:0.133 blue:0.137 alpha:1.000];
}

+ (UIColor *)tableViewCellSelectedBackgroundColor
{
    return [UIColor colorWithRed:0.135 green:0.189 blue:0.254 alpha:1.000];
}

+ (UIColor *)tableViewCellDefaultSecondaryTextColor
{
    return [UIColor colorWithRed:0.819 green:0.815 blue:0.822 alpha:1.000];
}

+ (UIColor *)tableViewCellSelectedSecondaryTextColor
{
    return [UIColor colorWithRed:0.741 green:0.830 blue:0.953 alpha:1.000];
}

+ (UIColor *)dividerLineColor
{
    return [UIColor colorWithRed:0.216 green:0.215 blue:0.217 alpha:1.000];
}

+ (UIColor *)fliteDeckYellowColor
{
    return [UIColor colorWithRed:0.996 green:0.980 blue:0.318 alpha:1.000];
}

+ (UIColor *)fliteDeckGreenColor
{
    return [UIColor colorWithRed:0.024 green:0.655 blue:0.329 alpha:1.000];
}

+ (UIColor *)buttonBackgroundColorDisabled
{
    return [UIColor colorWithRed:0.208 green:0.207 blue:0.209 alpha:1.000];
}

+ (UIColor *)buttonBackgroundColorEnabled
{
    return [UIColor colorWithRed:0.239 green:0.344 blue:0.525 alpha:1.000];
}

+ (UIColor *)buttonTitleColorDisabled
{
    return [UIColor colorWithWhite:0.774 alpha:1.000];
}

+ (UIColor *)buttonTitleColorEnabled
{
    return [UIColor colorWithRed:0.822 green:0.902 blue:0.979 alpha:1.000];
}

+ (UIColor *)descriptorLabelTextColor
{
    return [UIColor colorWithWhite:0.635 alpha:1.000];
}

+ (UIColor *)valueLabelTextColor
{
    return [UIColor colorWithWhite:0.937 alpha:1.000];
}

+ (UIColor *)flightDetailsBorderColor
{
    return [UIColor colorWithRed:0.255 green:0.251 blue:0.274 alpha:1.000];
}

+ (UIColor *)caseSectionHeadingBackgroundColor
{
    return [UIColor colorWithRed:0.135 green:0.189 blue:0.254 alpha:1.000];
}

+ (UIColor *)caseSectionHeadingTextColor
{
    return [UIColor colorWithRed:0.741 green:0.831 blue:0.953 alpha:1.000];
}

+ (UIColor *)caseBorderSelectedColor
{
    return [UIColor colorWithRed:0.432 green:0.456 blue:0.507 alpha:1.000];
}

@end
