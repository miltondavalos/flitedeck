//
//  NCLFramework.h
//  NCLFramework
//
//  Created by Chad Long on 7/10/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLErrorPresenter.h"
#import "NCLInfoPresenter.h"
#import "NCLMessage.h"
#import "NCLHTTPClient.h"
#import "NCLURLRequest.h"
#import "Reachability.h"
#import "NCLNetworking.h"
#import "NCLPersistenceManager.h"
#import "NCLPersistenceUtil.h"
#import "NCLUserPassword.h"
#import "NCLClientCertificate.h"
#import "NCLKeychainStorage.h"
#import "NSObject+Utility.h"
#import "NSDate+Utility.h"
#import "NSDateFormatter+Utility.h"
#import "NSData+Utility.h"
#import "NSError+Utility.h"
#import "NSNumber+Utility.h"
#import "NSString+Utility.h"
#import "UIDevice+Utility.h"
#import "UIView+Utility.h"
#import "UIApplication+Utility.h"
#import "UIImage+Utility.h"
#import "NSManagedObjectContext+Utility.h"
#import "NCLAnalytics.h"
#import "NCLAnalyticsEvent.h"
#import "NCLAnalyticsTableViewController.h"

extern NSString * const NCLDateFormatShouldUseTwoDigitDateComponentsKey;
extern NSString * const NCLDateFormatShouldUseMilitaryTimeKey;
extern NSString * const NCLDateFormatShouldStripCommasKey;
extern NSString * const NCLDateFormatShouldStripColonsKey;

typedef enum
{
    LogLevelNONE = 1,
    LogLevelINFO,
    LogLevelDEBUG,
    LogLevelTRACE,
} LogLevel;

@interface NCLFramework : NSObject

@property (nonatomic) LogLevel logLevel;

+ (void)setLogLevel:(LogLevel)logLevel;
+ (LogLevel)logLevel;

+ (void)setAppPreference:(NSString*)key value:(NSObject*)value;
+ (NSObject*)appPreferenceForKey:(NSString*)key;

@end