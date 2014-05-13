//
//  UIApplication+Utility.h
//  NCLFramework
//
//  Created by Chad Long on 3/13/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Utility)

+ (CGFloat)currentWidth;
+ (CGFloat)currentHeight;
+ (CGSize)currentSize;
+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;
+ (UIViewController*)rootViewController;

@end
