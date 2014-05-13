//
//  NCLAnalyticsEvent.m
//  NCLFramework
//
//  Created by Chad Long on 9/16/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLAnalyticsEvent.h"
#import "NCLAnalytics.h"

@implementation NCLAnalyticsEvent

+ (NCLAnalyticsEvent*)eventForComponent:(NSString*)component action:(NSString*)action value:(NSString*)value
{
    return [NCLAnalyticsEvent eventForComponent:component action:action value:value error:nil];
}

+ (NCLAnalyticsEvent*)eventForComponent:(NSString*)component action:(NSString*)action value:(NSString*)value error:(NSError*)error
{
    // if not active, don't create useless objects
    if ([NCLAnalytics sharedInstance].active == NO)
    {
        return nil;
    }

    NCLAnalyticsEvent *event = [[NCLAnalyticsEvent alloc] init];
    event.createdTS = [NSDate new];
    event.component = component;
    event.action = action;
    event.value = value;
    event.error = error;
    
    return event;
}

- (void)generateTransactionID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    
    self.transactionID = (__bridge NSString*)uuidStringRef;
}

- (void)updateElapsedTime
{
    self.elapsedTime = [NSNumber numberWithLong:([self.createdTS timeIntervalSinceNow] * -1000.0)];
}

@end
