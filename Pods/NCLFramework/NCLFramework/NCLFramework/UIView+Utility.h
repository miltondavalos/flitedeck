//
//  UIView+Utility.h
//  NCLFramework
//
//  Created by Chad Long on 11/14/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

- (void)offsetViewHorizontally:(CGFloat)xOffset;
- (void)offsetViewVertically:(CGFloat)yOffset;
- (void)offsetViewByAmount:(CGPoint)offsetSize;
- (void)moveViewOriginXTo:(CGFloat)newX;
- (void)moveViewOriginYTo:(CGFloat)newY;
- (void)moveViewOriginToPoint:(CGPoint)newOrigin;
- (void)resizeViewWidthByAmount:(CGFloat)widthDelta;
- (void)resizeViewHeightByAmount:(CGFloat)heightDelta;
- (void)resizeViewByAmount:(CGSize)sizeDelta;
- (void)resizeViewHeightToAmount:(CGFloat)height;
- (void)resizeViewWidthToAmount:(CGFloat)width;
- (void)resizeViewWidthSymmetricallyToAmount:(CGFloat)width;
- (void)resizeViewToSize:(CGSize)newSize;
- (void)changeViewFrameWithOffset:(CGRect)offsetRect;

- (void)setShadowColor:(CGColorRef)shadowColor opacity:(float)opacity offset:(CGSize)offset radius:(CGFloat)radius;
- (CGSize)sizeThatFitsSubviews;

- (BOOL)findAndResignFirstResponder;

@end
