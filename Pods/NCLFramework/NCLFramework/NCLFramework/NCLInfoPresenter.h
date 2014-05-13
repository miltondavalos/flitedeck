//
//  NCLInfoPresenter.h
//  NCLFramework
//
//  Created by Chad Long on 8/29/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLMessagePresenter.h"

@interface NCLInfoPresenter : NCLMessagePresenter

+ (NCLInfoPresenter*)sharedInstance;

+ (void)presentText:(NSString*)text;
+ (void)presentText:(NSString*)text parentView:(UIView*)parentView;
+ (void)presentMessage:(NCLMessage*)message;

@end
