//
//  UIView+FrameUtilities.m
//  FliteDeck
//
//  Created by Ryan Smith on 6/22/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import "UIView+FrameUtilities.h"

@implementation UIView (FrameUtilities)

- (void)offsetViewHorizontally:(CGFloat)xOffset
{
    CGRect frame = self.frame;
    frame.origin.x += xOffset;
    self.frame = frame;
}
- (void)offsetViewVertically:(CGFloat)yOffset;
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
    [self resizeViewWidthByAmount:sizeDelta.width];
    [self resizeViewHeightByAmount:sizeDelta.height];
}
- (void)resizeViewToSize:(CGSize)newSize
{
    CGRect frame = self.frame;
    frame.size = newSize;
    self.frame = frame;
}
- (void)changeViewFrameWithOffset:(CGRect)offsetRect
{
    [self offsetViewByAmount:offsetRect.origin];
    [self resizeViewByAmount:offsetRect.size];
}

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}


@end
