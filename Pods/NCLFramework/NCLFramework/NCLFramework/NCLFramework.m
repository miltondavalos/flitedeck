//
//  NCLFramework.m
//  NCLFramework
//
//  Created by Chad Long on 10/18/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLFramework.h"

NSString * const NCLDateFormatShouldUseTwoDigitDateComponentsKey = @"DateFormatShouldUseTwoDigitDateComponentsKey";
NSString * const NCLDateFormatShouldUseMilitaryTimeKey = @"DateFormatShouldUseMilitaryTimeKey";
NSString * const NCLDateFormatShouldStripCommasKey = @"DateFormatShouldStripCommasKey";
NSString * const NCLDateFormatShouldStripColonsKey = @"DateFormatShouldStripColonsKey";

@interface NCLFramework()

@property (nonatomic, strong) NSMutableDictionary *appPrefs;

@end

@implementation NCLFramework

+ (NCLFramework*)sharedInstance
{
	static dispatch_once_t pred;
	static NCLFramework *sharedInstance = nil;
    
	dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
        [sharedInstance setLogLevel:LogLevelNONE];
        sharedInstance.appPrefs = [NSMutableDictionary new];
    });
	
    return sharedInstance;
}

+ (void)setAppPreference:(NSString*)key value:(NSObject*)value
{
    BOOL shouldSetPref = YES;
    
    if (([key isEqualToString:NCLDateFormatShouldUseTwoDigitDateComponentsKey] ||
         [key isEqualToString:NCLDateFormatShouldUseMilitaryTimeKey] ||
         [key isEqualToString:NCLDateFormatShouldStripCommasKey] ||
         [key isEqualToString:NCLDateFormatShouldStripColonsKey])
            &&
        ![value respondsToSelector:@selector(isEqualToNumber:)])
    {
        shouldSetPref = NO;
    }
    
    if (shouldSetPref)
        [[NCLFramework sharedInstance].appPrefs setObject:value forKey:key];
    else
        INFOLog(@"app preference for %@ is illegal: class is %@", key, NSStringFromClass([value class]));
}

+ (NSObject*)appPreferenceForKey:(NSString*)key
{
    return [[NCLFramework sharedInstance].appPrefs objectForKey:key];
}

+ (void)setLogLevel:(LogLevel)logLevel
{
    [NCLFramework sharedInstance].logLevel = logLevel;
}

+ (LogLevel)logLevel
{
    return [NCLFramework sharedInstance].logLevel;
}
     
@end
