//
//  NCLAnalytics.m
//  NCLFramework
//
//  Created by Chad Long on 9/16/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLAnalytics.h"
#import "NCLAnalyticsPersistenceManager.h"
#import "Event.h"
#import "EventDetail.h"
#import "NCLURLRequest.h"
#import "NSManagedObjectContext+Utility.h"
#import "NSDate+Utility.h"

@interface NCLAnalytics()

@property (strong, nonatomic) NSOperationQueue *serialOperationQueue;
@property (nonatomic, strong) NCLAnalyticsEvent *appWillResignActiveEvent;
@property (nonatomic) BOOL locked;

@end

@implementation NCLAnalytics

static NSString *installDateKey = @"installDate";

#pragma mark - lifecycle

+ (NCLAnalytics*)sharedInstance
{
	static dispatch_once_t pred;
	static NCLAnalytics *sharedInstance = nil;
    
	dispatch_once
    (&pred, ^
     {
         sharedInstance = [[self alloc] init];
         sharedInstance.active = NO;
         sharedInstance.requiresAuthentication = YES;
         sharedInstance.basePath = @"";
         sharedInstance.port = 0;
         sharedInstance.isSecure = YES;
         sharedInstance.retentionDays = 3;
         sharedInstance.syncThreshold = 100;
         sharedInstance.httpPostThrottle = 150;
         sharedInstance.autoSync = NO;
         
         if (![[NSUserDefaults standardUserDefaults] objectForKey:installDateKey])
         {
             [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:installDateKey];
         }
     });
	
    return sharedInstance;
}

+ (void)start
{
    if (![NCLAnalytics sharedInstance].active)
    {
        static dispatch_once_t pred;
        
        dispatch_once
        (&pred, ^
         {
             [[NCLAnalyticsPersistenceManager sharedInstance] mainMOC];
             
             [NCLAnalytics sharedInstance].serialOperationQueue = [[NSOperationQueue alloc] init];
             [NCLAnalytics sharedInstance].serialOperationQueue.maxConcurrentOperationCount = 1;
             [NCLAnalytics sharedInstance].serialOperationQueue.name = @"NCLAnalyticsSerialOperationQueue";
             
             [[NSNotificationCenter defaultCenter] addObserver:[NCLAnalytics sharedInstance] selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
             [[NSNotificationCenter defaultCenter] addObserver:[NCLAnalytics sharedInstance] selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
             
             DEBUGLog(@"NCL analytics is READY");
         });
        
        [NCLAnalytics sharedInstance].active = YES;
        
        INFOLog(@"NCL analytics started...");
    }
}

+ (void)stop
{
    if ([NCLAnalytics sharedInstance].active)
    {
        INFOLog(@"NCL analytics stopped");
        
        [NCLAnalytics sharedInstance].active = NO;
    }
}

- (void)setActive:(BOOL)active
{
    _active = active;
}

- (void)applicationDidBecomeActive
{
    // begin auditing how long app is active
    NCLAnalyticsEvent *activateEvent = [NCLAnalyticsEvent eventForComponent:@"app" action:@"applicationDidBecomeActive" value:nil];
    [self addEvent:activateEvent];
    
    self.appWillResignActiveEvent = [NCLAnalyticsEvent eventForComponent:@"app" action:@"applicationWillResignActive" value:nil];
    self.appWillResignActiveEvent.createdTS = activateEvent.createdTS;
    
    // record when app was installed
    NSDate *installDate = [[NSUserDefaults standardUserDefaults]objectForKey:installDateKey];
    
    if (!installDate)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSDate new].description forKey:installDateKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

    // perform delayed maintenance... allow other activation logic to have priority
    [self performSelector:@selector(performMaintenance) withObject:nil afterDelay:7.5];
}

- (void)applicationWillResignActive
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.appWillResignActiveEvent updateElapsedTime];
    [self.appWillResignActiveEvent setCreatedTS:[NSDate new]];
    [NCLAnalytics addEvent:self.appWillResignActiveEvent];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - routine maintenance

- (void)performMaintenance
{
    if ([NCLAnalytics sharedInstance].active == YES)
    {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSManagedObjectContext *moc = [[NCLAnalyticsPersistenceManager sharedInstance] privateMOCWithParent:nil];
            
            // keep the table clean... remove stale records
            NSDate *removalThreshold = [NSDate dateWithTimeIntervalSinceNow:self.retentionDays*60*60*24*(-1)];
            NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"createdTS < %@", removalThreshold];
            NSInteger records = [moc deleteAllObjectsForEntityName:@"Event" predicate:deletePredicate error:nil];
            
            NSError *error = nil;
            
            if (![moc save:&error])
            {
                INFOLog(@"error cleaning expired device usage: %@", error);
            }
            else
            {
                INFOLog(@"removed %d device usage records prior to %@", records, removalThreshold.description);
                
                // if in WiFi, send usage records
                if ([NCLAnalytics sharedInstance].active == YES &&
                    [NCLAnalytics sharedInstance].autoSync == YES &&
                    [NCLNetworking sharedInstance].networkStatus == ReachableViaWiFi &&
                    [moc countForFetchRequestForEntityName:@"Event" predicate:nil error:nil] > self.syncThreshold)
                {
                    [[NCLAnalytics sharedInstance] sendUsage:moc silentMode:YES];
                }
            }
        }];
        
        [operation setThreadPriority:0.4]; // priority LOW, but not so low as to prevent disk access
        
        [[NCLAnalytics sharedInstance].serialOperationQueue addOperation:operation];
    }
}

#pragma mark - device usage

+ (void)sendUsage
{
    [NCLAnalytics sendUsage:YES];
}

+ (void)sendUsage:(BOOL)silentMode
{
    NSManagedObjectContext *moc = [[NCLAnalyticsPersistenceManager sharedInstance] privateMOCWithParent:nil];
    [[NCLAnalytics sharedInstance] sendUsage:moc silentMode:silentMode];
}

- (void)sendUsage:(NSManagedObjectContext*)moc silentMode:(BOOL)silentMode
{
    if ([self tryLock])
    {
        // build the JSON to be posted to the server
        NSMutableArray *moSentList = [NSMutableArray new];
        NSMutableArray *eventInfo = [NSMutableArray new];
        NSArray *events = [moc executeFetchRequestForEntityName:@"Event" predicate:nil error:nil];
        
        if (events.count > 0)
        {
            NSInteger throttle = 1;
            
            for (Event *event in events)
            {
                NSMutableDictionary *eventDict = [NSMutableDictionary new];
                [eventDict setObject:event.createdTS.description forKey:@"createdTS"];
                [eventDict setObject:event.component forKey:@"component"];
                [eventDict setObject:event.action forKey:@"action"];
                
                if (event.elapsedTime)
                    [eventDict setObject:event.elapsedTime forKey:@"elapsedTime"];
                
                if (event.errorCode && [event.errorCode integerValue] != 0)
                    [eventDict setObject:event.errorCode forKey:@"errorCode"];
                
                if (event.transactionID)
                    [eventDict setObject:event.transactionID forKey:@"transactionID"];
                
                if (event.value)
                    [eventDict setObject:event.value forKey:@"value"];
                
                if (event.eventDetail &&
                    event.eventDetail.count > 0)
                {
                    NSMutableDictionary *eventDetailDict = [NSMutableDictionary new];
                    
                    for (EventDetail *eventDetail in event.eventDetail)
                    {
                        [eventDetailDict setObject:eventDetail.value forKey:eventDetail.key];
                    }
                    
                    [eventDict setObject:eventDetailDict forKey:@"eventDetail"];
                }
                
                [eventInfo addObject:eventDict];
                [moSentList addObject:[event.objectID copy]];
                
                // throttle the post into segments
                throttle++;
                
                if (self.httpPostThrottle > 0 &&
                    throttle > self.httpPostThrottle)
                {
                    break;
                }
            }
            
            // post the events to the server
            NCLURLRequest *request = [self urlRequestWithPath:[NSString stringWithFormat:@"%@/usage", self.basePath]];
            request.param = moSentList;
            request.shouldPresentAlertOnError = !silentMode;
            request.timeoutInterval = 60;
            request.shouldSuppressAnalytics = YES;
            request.shouldDisplayActivityIndicator = !silentMode;
            [request setJSONHeadersAndBodyWithData:eventInfo httpMethod:POST_METHOD];
            
            [self sendHttpRequest:request withBackgroundProcessingBlock:^(NSData *data, NSError *error)
             {
                 if (error)
                 {
                     [self unlock];

                     INFOLog(@"error sending device usage: %@", error.description);
                 }
                 else
                 {
                     INFOLog(@"device usage sent successfully");
                     
                     NSManagedObjectContext *moc2 = [[NCLAnalyticsPersistenceManager sharedInstance] privateMOCWithParent:nil];
                     
                     for (NSManagedObjectID *moID in (NSArray*)request.param)
                     {
                         NSManagedObject *mo = [moc2 existingObjectWithID:moID error:nil];
                         
                         if (mo)
                         {
                             [moc2 deleteObject:mo];
                         }
                     }
                     
                     if (![moc2 save:&error])
                     {
                         [self unlock];
                     
                         INFOLog(@"error cleaning sent device usage: %@", error);
                     }
                     else
                     {
                         [self unlock];
                         [NCLAnalytics sendUsage:silentMode];
                     }
                 }
             }];
        }
        else
        {
            [self unlock];
        }
    }
    else
    {
        INFOLog(@"already posting usage data... canceling duplicate request");
    }
}

#pragma mark - device diagnostics

+ (void)sendDiagnostics:(NSDictionary*)additionalDiagnostics
{
    [[NCLAnalytics sharedInstance] sendDiagnostics:additionalDiagnostics silentMode:YES];
}

+ (void)sendDiagnostics:(NSDictionary*)additionalDiagnostics silentMode:(BOOL)silentMode
{
    [[NCLAnalytics sharedInstance] sendDiagnostics:additionalDiagnostics silentMode:silentMode];
}

- (void)sendDiagnostics:(NSDictionary*)additionalDiagnostics silentMode:(BOOL)silentMode
{
    NSMutableDictionary *deviceInfo = [NSMutableDictionary new];
    [deviceInfo setObject:[NSString stringWithFormat:@"%d", [[UIApplication sharedApplication] enabledRemoteNotificationTypes]] forKey:@"enabledRemoteNotificationTypes"];
    [deviceInfo setObject:[NSDateFormatter dateFormatterFromFormatType:NCLDateFormatDateOnly].dateFormat forKey:@"dateFormat"];
    [deviceInfo setObject:[UIDevice modelName] forKey:@"modelName"];
    [deviceInfo setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    [deviceInfo setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osVersion"];
    [deviceInfo setObject:[[NSUserDefaults standardUserDefaults] objectForKey:installDateKey] forKey:installDateKey];
    [deviceInfo setObject:[UIDevice freeMemory] forKey:@"freeMemory"];
    [deviceInfo setObject:[UIDevice freeDiskspace] forKey:@"freeDisk"];
    [deviceInfo setObject:[NCLAnalyticsPersistenceManager sharedInstance].storeSize forKey:@"analyticsDBSize"];

    if (additionalDiagnostics)
    {
        [deviceInfo addEntriesFromDictionary:additionalDiagnostics];
    }

    NCLURLRequest *request = [self urlRequestWithPath:[NSString stringWithFormat:@"%@/diagnostics", self.basePath]];
    request.shouldPresentAlertOnError = !silentMode;
    request.shouldSuppressAnalytics = YES;
    request.shouldDisplayActivityIndicator = !silentMode;
    [request setJSONHeadersAndBodyWithData:deviceInfo httpMethod:POST_METHOD];
    
    [self sendHttpRequest:request withBackgroundProcessingBlock:^(NSData *data, NSError *error)
     {
         if (error)
         {
             INFOLog(@"error sending device diagnostics: %@", error.description);
         }
         else
         {
             INFOLog(@"device diagnostics sent successfully");
         }
     }];
}

#pragma mark - adding events

+ (void)addTimedEvent:(NCLAnalyticsEvent*)event
{
    if (event)
    {
        [event updateElapsedTime];
        [[NCLAnalytics sharedInstance] addEvent:event];
    }
}

+ (void)addEvent:(NCLAnalyticsEvent*)event
{
    if (event)
    {
        [[NCLAnalytics sharedInstance] addEvent:event];
    }
}

- (void)addEvent:(NCLAnalyticsEvent*)analyticsEvent
{
    if (analyticsEvent &&
        [NCLAnalytics sharedInstance].active == YES)
    {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            
            NSManagedObjectContext *moc = [[NCLAnalyticsPersistenceManager sharedInstance] privateMOCWithParent:nil];
            Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc];
            event.transactionID = analyticsEvent.transactionID;
            event.component = analyticsEvent.component;
            event.action = analyticsEvent.action;
            event.value = analyticsEvent.value;
            event.createdTS = analyticsEvent.createdTS;
            event.elapsedTime = analyticsEvent.elapsedTime;
            
            if (analyticsEvent.error)
            {
                event.errorCode = [NSNumber numberWithInteger:analyticsEvent.error.code];
                
                static NSString *errorDescriptionKey = @"errorDescription";
                EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:moc];
                eventDetail.key = errorDescriptionKey;
                eventDetail.value = analyticsEvent.error.description;
                [event addEventDetailObject:eventDetail];
            }
            
            if (analyticsEvent.eventInfo)
            {
                for (NSString *key in analyticsEvent.eventInfo)
                {
                    EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:moc];
                    eventDetail.key = key;
                    eventDetail.value = [[analyticsEvent.eventInfo objectForKey:key] description];
                    [event addEventDetailObject:eventDetail];
                }
            }
            
            NSError *error = nil;
            
            if (![moc save:&error])
            {
                INFOLog(@"error saving analytics: %@", error);
            }
        }];
        
        [operation setThreadPriority:0.4]; // priority LOW, but not so low as to prevent disk access
        
        [[NCLAnalytics sharedInstance].serialOperationQueue addOperation:operation];
    }
}

# pragma mark - locking

- (BOOL)tryLock
{
    // standard API locking doesn't handle cross threading
    @synchronized(self)
    {
        if (!self.locked)
        {
            self.locked = YES;
            
            return YES;
        }
        
        return NO;
    }
}

- (void)unlock
{
    @synchronized(self)
    {
        self.locked = NO;
    }
}

@end
