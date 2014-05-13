//
//  UIView+FrameUtilities.h
//  FliteDeck
//
//  Created by Ryan Smith on 6/22/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameUtilities)

- (void)offsetViewHorizontally:(CGFloat)xOffset;
- (void)offsetViewVertically:(CGFloat)yOffset;
- (void)offsetViewByAmount:(CGPoint)offsetSize;
- (void)moveViewOriginXTo:(CGFloat)newX;
- (void)moveViewOriginYTo:(CGFloat)newY;
- (void)moveViewOriginToPoint:(CGPoint)newOrigin;
- (void)resizeViewWidthByAmount:(CGFloat)widthDelta;
- (void)resizeViewHeightByAmount:(CGFloat)heightDelta;
- (void)resizeViewByAmount:(CGSize)sizeDelta;
- (void)resizeViewToSize:(CGSize)newSize;
- (void)changeViewFrameWithOffset:(CGRect)offsetRect;

- (BOOL)findAndResignFirstResponder;

@end
