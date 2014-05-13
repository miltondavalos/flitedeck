//
//  NCLInfoPresenter.m
//  NCLFramework
//
//  Created by Chad Long on 8/29/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLInfoPresenter.h"
#import "NCLMessage.h"

@implementation NCLInfoPresenter

+ (NCLInfoPresenter*)sharedInstance
{
	static dispatch_once_t pred;
	static NCLInfoPresenter *sharedInstance = nil;
    
	dispatch_once
    (&pred, ^
     {
         sharedInstance = [[self alloc] init];
     });
	
    return sharedInstance;
}

+ (void)presentText:(NSString*)text
{
    [NCLInfoPresenter presentText:text parentView:nil];
}

+ (void)presentText:(NSString*)text parentView:(UIView*)parentView
{
    NCLMessage *message = [[NCLMessage alloc] init];
    message.text = text;
    message.parentView = parentView;
    
    [NCLInfoPresenter presentMessage:message];
}

+ (void)presentMessage:(NCLMessage*)message
{
    [[self sharedInstance] pushViewWithMessage:message];
}

@end
