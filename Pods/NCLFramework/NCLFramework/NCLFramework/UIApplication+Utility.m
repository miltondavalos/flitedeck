//
//  UIApplication+Utility.m
//  NCLFramework
//
//  Created by Chad Long on 3/13/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "UIApplication+Utility.h"

@implementation UIApplication (Utility)

+ (CGFloat)currentWidth
{
    return [self currentSize].width;
}

+ (CGFloat)currentHeight
{
    return [self currentSize].height;
}

+ (CGSize)currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

+ (UIViewController*)rootViewController
{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

@end
