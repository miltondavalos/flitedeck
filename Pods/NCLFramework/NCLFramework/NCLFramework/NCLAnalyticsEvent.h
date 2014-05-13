//
//  NCLAnalyticsEvent.h
//  NCLFramework
//
//  Created by Chad Long on 9/16/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCLAnalyticsEvent : NSObject

@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSDate *createdTS;
@property (nonatomic, strong) NSString *component;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSNumber *elapsedTime;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong) NSMutableDictionary *eventInfo;

+ (NCLAnalyticsEvent*)eventForComponent:(NSString*)component action:(NSString*)action value:(NSString*)value;
+ (NCLAnalyticsEvent*)eventForComponent:(NSString*)component action:(NSString*)action value:(NSString*)value error:(NSError*)error;

- (void)updateElapsedTime;
- (void)generateTransactionID;

@end