//
//  NCLMessage.m
//  NCLFramework
//
//  Created by Chad Long on 9/12/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLMessage.h"

@implementation NCLMessage

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.text = @"";
        self.parentView = nil;
        self.playSound = NO;
    }
    
    return self;
}

+ (NCLMessage*)messageWithText:(NSString*)messageText
{
    NCLMessage *message = [[NCLMessage alloc] init];
    message.text = messageText;
    
    return message;
}

@end
