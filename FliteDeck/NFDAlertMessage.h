//
//  NFDAlertMessage.h
//  FliteDeck
//
//  Created by Chad Predovich on 2/21/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFDAlertMessage : NSObject

+ (void)showAlertWithMessage:(NSString *)message title:(NSString *)title;
+ (void)showReachabilityAlertWithMessage:(NSString *)message title:(NSString *)title;

@end
