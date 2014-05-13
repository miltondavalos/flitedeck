//
//  NCLErrorPresenter.h
//  NCLFramework
//
//  Created by Chad Long on 3/14/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NCLInfoPresenter.h"

@interface NCLErrorPresenter : NCLInfoPresenter

+ (NCLErrorPresenter*)sharedInstance;

+ (void)presentError:(NSError*)error;
+ (void)presentError:(NSError*)error parentView:(UIView*)parentView;

@end
