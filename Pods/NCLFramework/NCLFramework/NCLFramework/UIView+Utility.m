//
//  UIView+Utility.m
//  NCLFramework
//
//  Created by Chad Long on 11/14/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

- (void)offsetViewHorizontally:(CGFloat)xOffset
{
    CGRect frame = self.frame;
    frame.origin.x += xOffset;
    self.frame = frame;
}
- (void)offsetViewVertically:(CGFloat)yOffset
{
    CGRect frame = self.frame;
    frame.origin.y += yOffset;
    self.frame = frame;
}
- (void)offsetViewByAmount:(CGPoint)offsetPoint
{
    CGRect frame = self.frame;
    frame.origin.x += offsetPoint.x;
    frame.origin.y += offsetPoint.y;
    self.frame = frame;
}
- (void)moveViewOriginXTo:(CGFloat)newX
{
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}
- (void)moveViewOriginYTo:(CGFloat)newY
{
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}
- (void)moveViewOriginToPoint:(CGPoint)newOrigin
{
    CGRect frame = self.frame;
    frame.origin = newOrigin;
    self.frame = frame;
}
- (void)resizeViewWidthByAmount:(CGFloat)widthDelta
{
    CGRect frame = self.frame;
    frame.size.width += widthDelta;
    self.frame = frame;
}
- (void)resizeViewHeightByAmount:(CGFloat)heightDelta
{
    CGRect frame = self.frame;
    frame.size.height += heightDelta;
    self.frame = frame;
}
- (void)resizeViewByAmount:(CGSize)sizeDelta
{
    CGRect frame = self.frame;
    frame.size.width += sizeDelta.width;
    frame.size.height += sizeDelta.height;
    self.frame = frame;
}
- (void)resizeViewHeightToAmount:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)resizeViewWidthToAmount:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)resizeViewToSize:(CGSize)newSize
{
    CGRect frame = self.frame;
    frame.size = newSize;
    self.frame = frame;
}
- (void)resizeViewWidthSymmetricallyToAmount:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.origin.x = self.frame.origin.x - 0.5 * (width - self.frame.size.width);
    frame.size.width = width;
    self.frame = frame;
}
- (void)changeViewFrameWithOffset:(CGRect)offsetRect
{
    [self offsetViewByAmount:offsetRect.origin];
    [self resizeViewByAmount:offsetRect.size];
}



- (void)setShadowColor:(CGColorRef)shadowColor opacity:(float)opacity offset:(CGSize)offset radius:(CGFloat)radius
{
    [self.layer setShadowColor:shadowColor];
    [self.layer setShadowOpacity:opacity];
    [self.layer setShadowOffset:offset];
    [self.layer setShadowRadius:radius];
}

- (CGSize)sizeThatFitsSubviews
{
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    for (UIView *view in [self subviews])
    {
        CGFloat fw = 0.0;
        CGFloat fh = 0.0;
        if ([view isKindOfClass:[UILabel class]])
        {
            CGSize size = [(UILabel *)view sizeThatFits:CGSizeZero];
            fw = size.width;
            fh = size.height;
        }
        else
        {
            fw = view.frame.origin.x + view.frame.size.width;
            fh = view.frame.origin.y + view.frame.size.height;
        }
        width = MAX(fw, width);
        height = MAX(fh, height);
    }
    
    return CGSizeMake(width, height);
}

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder)
    {
        [self resignFirstResponder];

        return YES;
    }
    
    for (UIView *subView in self.subviews)
    {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    
    return NO;
}

@end