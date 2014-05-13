//
//  NCLAnalytics.h
//  NCLFramework
//
//  Created by Chad Long on 9/16/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCLAnalyticsEvent.h"
#import "NCLHTTPClient.h"

@interface NCLAnalytics : NCLHTTPClient

@property (atomic, readonly) BOOL active;

@property (nonatomic) BOOL requiresAuthentication;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *basePath;
@property (nonatomic) NSInteger port;
@property (nonatomic) BOOL isSecure;

@property (atomic) NSInteger retentionDays;
@property (atomic) NSInteger syncThreshold;
@property (atomic) NSInteger httpPostThrottle;
@property (atomic) BOOL autoSync;

+ (NCLAnalytics*)sharedInstance;

+ (void)start;
+ (void)stop;

+ (void)sendUsage;
+ (void)sendUsage:(BOOL)silentMode;

+ (void)sendDiagnostics:(NSDictionary*)additionalDiagnostics;
+ (void)sendDiagnostics:(NSDictionary*)additionalDiagnostics silentMode:(BOOL)silentMode;

+ (void)addTimedEvent:(NCLAnalyticsEvent*)event;
+ (void)addEvent:(NCLAnalyticsEvent*)event;

@end
