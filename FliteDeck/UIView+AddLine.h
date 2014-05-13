//
//  UIView+AddLine.h
//  FliteDeck
//
//  Created by Mohit Jain on 2/25/12.
//  Copyright (c) 2012 Compuware. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface UIView(AddLine)

- (void)addBottomLineWithWidth:(CGFloat)width color:(UIColor *)color;

- (UIView *)addVerticalLineWithWidth:(CGFloat)width color:(UIColor *)color atX:(CGFloat)x;
- (UIView *)addHorizontalLineWithWidth:(CGFloat)width color:(UIColor *)color atY:(CGFloat)y;
@end
