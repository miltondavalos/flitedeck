//
//  NCLMessage.h
//  NCLFramework
//
//  Created by Chad Long on 9/12/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NCLMessage : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic) BOOL playSound;

+ (NCLMessage*)messageWithText:(NSString*)messageText;

@end
