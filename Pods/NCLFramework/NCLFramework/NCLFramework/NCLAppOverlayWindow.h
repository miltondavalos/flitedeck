//
//  NCLAppOverlayView.h
//  NCLFramework
//
//  Created by Chad Long on 8/29/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCLAppOverlayWindow : UIWindow

+ (NCLAppOverlayWindow*)sharedInstance;
+ (UIView*)view;

@end
