//
//  NCLAppOverlayView.m
//  NCLFramework
//
//  Created by Chad Long on 8/29/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLAppOverlayWindow.h"
#import "NCLMessageView.h"

@implementation NCLAppOverlayWindow

+ (NCLAppOverlayWindow*)sharedInstance
{
	static dispatch_once_t pred;
	static NCLAppOverlayWindow *sharedInstance = nil;
    
	dispatch_once(&pred, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
	
    return sharedInstance;
}

+ (UIView*)view
{
    return [self sharedInstance].rootViewController.view;
}

- (instancetype)init
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        self.windowLevel = UIWindowLevelStatusBar;
        self.backgroundColor = [UIColor clearColor];
 
        // setup a root view controller so we get rotation logic
        UIViewController *rootController = [[UIViewController alloc] init];
        rootController.view.backgroundColor = [UIColor clearColor];
        [self setRootViewController:rootController];
        
        self.hidden = NO;
    }
    
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    // see if the hit is anywhere in our view hierarchy
    UIView *hitTestResult = [super hitTest:point withEvent:event];

    if (!hitTestResult ||
        ![hitTestResult isKindOfClass:[NCLMessageView class]])
    {
        // pass through all touches that are not for the touch sensitive info view
        return nil;
    }
    
    return hitTestResult;
}

@end