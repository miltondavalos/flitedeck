
//
//  UIView+AddLine.m
//  FliteDeck
//
//  Created by Mohit Jain on 2/25/12.
//  Copyright (c) 2012 Compuware. All rights reserved.
//


#import "UIView+AddLine.h"


@implementation UIView(AddLine)

- (void)addBottomLineWithWidth:(CGFloat)width color:(UIColor *)color
{
    CGRect f = self.frame;
    f.size.height += width;
    self.frame = f;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - width,                                                                    self.frame.size.width, width)];
    bottomLine.backgroundColor = color;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:bottomLine];
}

- (UIView *)addVerticalLineWithWidth:(CGFloat)width color:(UIColor *)color atX:(CGFloat)x
{
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(x, 0.0f, width, self.frame.size.height)];
    vLine.backgroundColor = color;
    vLine.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    
    [self addSubview:vLine];
    
    return vLine;
}

- (UIView *)addHorizontalLineWithWidth:(CGFloat)width color:(UIColor *)color atY:(CGFloat)y
{
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width ,width)];
    vLine.backgroundColor = color;
    //vLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    [self addSubview:vLine];
    
    return vLine;
}

@end
