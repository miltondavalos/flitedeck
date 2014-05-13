//
//  NCLErrorPresenter.m
//  NCLFramework
//
//  Created by Chad Long on 3/14/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLErrorPresenter.h"
#import "NCLFramework.h"
#import "UIApplication+Utility.h"
#import "NCLMessageView.h"
#import "NSError+Utility.h"
#import "NCLAppOverlayWindow.h"

@implementation NCLErrorPresenter

+ (NCLErrorPresenter*)sharedInstance
{
	static dispatch_once_t pred;
	static NCLErrorPresenter *sharedInstance = nil;
    
	dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];

        sharedInstance.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.55 alpha:1];
    });
	
    return sharedInstance;
}

+ (void)presentError:(NSError*)error
{
    [self presentText:error.description];
}

+ (void)presentError:(NSError*)error parentView:(UIView*)parentView
{
    [self presentText:error.description parentView:parentView];
}

+ (void)presentText:(NSString*)text
{
    [NCLErrorPresenter presentText:text parentView:nil];
}

+ (void)presentText:(NSString*)text parentView:(UIView*)parentView
{
    NCLMessage *message = [[NCLMessage alloc] init];
    message.text = text;
    message.parentView = parentView;
    
    [NCLErrorPresenter presentMessage:message];
}

+ (void)presentMessage:(NCLMessage*)message
{
    [[self sharedInstance] pushViewWithMessage:message];
}

@end