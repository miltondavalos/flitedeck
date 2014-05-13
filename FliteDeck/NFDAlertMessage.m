//
//  NFDAlertMessage.m
//  FliteDeck
//
//  Created by Chad Predovich on 2/21/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDAlertMessage.h"

@implementation NFDAlertMessage

#pragma mark - Main method for showing the alert

+ (void)showAlertWithMessage:(NSString *)message title:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [alert show];
}


#pragma mark - Methods for different types of alerts

+ (void)showReachabilityAlertWithMessage:(NSString *)message title:(NSString *)title {
    if (title == nil) title = @"No Connectivity";
    if (message == nil) message = @"Sorry, there is no network connectivity available.";
    
    [self showAlertWithMessage:message title:title];
}

@end