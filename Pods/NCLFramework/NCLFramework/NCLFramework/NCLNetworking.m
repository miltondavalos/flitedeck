//
//  NCLNetworking.m
//  NCLFramework
//
//  Created by Chad Long on 1/4/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLNetworking.h"
#import "NCLFramework.h"
#import "NCLHttpURLConnection.h"
#import "NSString+Utility.h"
#import "UIDevice+Utility.h"
#import "NCLHTTPProtocol.h"

#define NETWORKING_HEADER_DEVICE_ID @"Device-ID"
#define NETWORKING_HEADER_APP_VERSION @"App-Version"
#define NETWORKING_HEADER_OS_VERSION @"OS-Version"

@interface NCLNetworking()

@property (nonatomic) NSInteger activityCount;
@property (nonatomic, strong) NSTimer *activityIndicatorVisibilityTimer;
//@property (nonatomic, strong) dispatch_queue_t serialDispatchQueue;

@end

@implementation NCLNetworking
{
    NSMutableDictionary *_appHeaders;
    NSMutableDictionary *_standardHeaders;
    NSMutableDictionary *_authInfo;
    Reachability *_reachability;
}

@synthesize serialOperationQueue = _serialOperationQueue;
@synthesize concurrentOperationQueue = _concurrentOperationQueue;
//@synthesize serialDispatchQueue = _serialDispatchQueue;

+ (NCLNetworking*)sharedInstance
{
	static dispatch_once_t pred;
	static NCLNetworking *sharedInstance = nil;
    
	dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
        
        sharedInstance.activityCount = 0;
        [NSURLProtocol registerClass:[NCLHTTPProtocol class]];
        
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    });
	
    return sharedInstance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSString*)secondLevelDomainForHost:(NSString*)host
{
    // host is required for uniqueness
    if (host == nil ||
        host.length == 0)
    {
        NSException *exception = [NSException exceptionWithName:@"Exception"
                                                         reason:@"A host is required"
                                                       userInfo:nil];
        @throw exception;
    }
    
    // resolve to second level domain name to make this universal across environments
    host = [host lowercaseString];
    NSArray *domainComponents = [host componentsSeparatedByString: @"."];
    
    if (domainComponents.count > 1)
    {
        host = [NSString stringWithFormat:@"%@.%@", domainComponents[domainComponents.count-2], domainComponents[domainComponents.count-1]];
    }
    
    return host;
}

- (NSOperationQueue*)serialOperationQueue
{
    if (_serialOperationQueue == nil)
    {
        @synchronized(self)
        {
            if (_serialOperationQueue == nil)
            {
                _serialOperationQueue = [[NSOperationQueue alloc] init];
                _serialOperationQueue.maxConcurrentOperationCount = 1;
                _serialOperationQueue.name = @"NCLNetworkingSerialOperationQueue";
            }
            
        }
    }
    
    return _serialOperationQueue;
}

- (NSOperationQueue*)concurrentOperationQueue
{
    if (_concurrentOperationQueue == nil)
    {
        @synchronized(self)
        {
            if (_concurrentOperationQueue == nil)
            {
                _concurrentOperationQueue = [[NSOperationQueue alloc] init];
                _concurrentOperationQueue.maxConcurrentOperationCount = 3;
                _concurrentOperationQueue.name = @"NCLNetworkingConcurrentOperationQueue";
            }
            
        }
    }
    
    return _concurrentOperationQueue;
}

//- (dispatch_queue_t)serialDispatchQueue
//{
//    if (_serialDispatchQueue == nil)
//    {
//        @synchronized(self)
//        {
//            if (_serialDispatchQueue == nil)
//                _serialDispatchQueue = dispatch_queue_create([[NSString stringWithFormat:@"SerialDispatchQueue%@", NSStringFromClass([self class])] UTF8String], NULL);
//        }
//    }
//    
//    return _serialDispatchQueue;
//}

#pragma mark - maintain "reference count" for http activity

- (void)applicationWillResignActive
{
    DEBUGLog(@"resetting http request count to 0");
    
    @synchronized(self)
    {
        self.activityCount = 0;
    }
}

- (void)incrementActivityCount
{
    @synchronized(self)
    {
        self.activityCount = self.activityCount +=1;
    }
}

- (void)decrementActivityCount
{
    @synchronized(self)
    {
        self.activityCount = MAX(self.activityCount-1, 0);
    }
}

- (void)setActivityCount:(NSInteger)activityCount
{
    @synchronized(self)
    {
		_activityCount = activityCount;
	}
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateNetworkActivityIndicatorVisibilityDelayed];
    });
}

- (BOOL)shouldShowNetworkActivityIndicator
{
    return (self.activityCount > 0);
}

- (void)updateNetworkActivityIndicatorVisibility
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self shouldShowNetworkActivityIndicator]];
}

- (void)updateNetworkActivityIndicatorVisibilityDelayed
{
    static NSTimeInterval const NETWORK_ACTIVITY_INVISIBILITY_DELAY = 0.2;

    // Delay hiding of activity indicator for a short interval, to avoid flickering
    if (![self shouldShowNetworkActivityIndicator])
    {
        [self.activityIndicatorVisibilityTimer invalidate];
        self.activityIndicatorVisibilityTimer = [NSTimer timerWithTimeInterval:NETWORK_ACTIVITY_INVISIBILITY_DELAY
                                                                        target:self
                                                                      selector:@selector(updateNetworkActivityIndicatorVisibility)
                                                                      userInfo:nil
                                                                       repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:self.activityIndicatorVisibilityTimer forMode:NSRunLoopCommonModes];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(updateNetworkActivityIndicatorVisibility) withObject:nil waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

#pragma mark - user/host webview authentication

- (void)enableWebViewAuthenticationForUser:(NSString*)user host:(NSString*)host
{
    if (host != nil &&
        host.length > 0)
    {
        host = [NCLNetworking secondLevelDomainForHost:host];
        
        @synchronized(_authInfo)
        {
            if (_authInfo == nil)
                _authInfo = [[NSMutableDictionary alloc] init];
            
            if (user == nil)
            {
                INFOLog(@"disabling WebView authentication for host:%@", host);
                
                [_authInfo removeObjectForKey:host];
            }
            else
            {
                INFOLog(@"enabling WebView authentication for user:%@ host:%@", user, host);
                
                [_authInfo setObject:user forKey:host];
            }
        }
    }
}

- (NSString*)userForHost:(NSString*)host
{
    if (host)
    {
        host = [NCLNetworking secondLevelDomainForHost:host];
        
        @synchronized(_authInfo)
        {
            return [_authInfo objectForKey:host];
        }
    }
    else
        return nil;
}

#pragma mark - global http header injection

- (NSDictionary*)appHeaders;
{
    if (_appHeaders == nil)
    {
        @synchronized(_appHeaders)
        {
            if (_appHeaders == nil)
            {
                _appHeaders = [[NSMutableDictionary alloc] init];
                [_appHeaders setObject:[UIDevice identifier] forKey:NETWORKING_HEADER_DEVICE_ID];
                [_appHeaders setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:NETWORKING_HEADER_APP_VERSION];
                [_appHeaders setObject:[[UIDevice currentDevice] systemVersion] forKey:NETWORKING_HEADER_OS_VERSION];
            }
        }
    }
    
    return _appHeaders;
}

- (NSMutableDictionary*)standardHeadersForDomain:(NSString*)domain;
{
    return [_standardHeaders objectForKey:[NCLNetworking secondLevelDomainForHost:domain]];
}

// used to inject standard http headers for all outgoing http requests to hosts with the specified top-level domain
- (void)setStandardHeaders:(NSDictionary*)standardHeaders forDomain:(NSString*)domain
{
    if (domain != nil &&
        domain.length > 0)
    {
        domain = [NCLNetworking secondLevelDomainForHost:domain];
        
        @synchronized(_standardHeaders)
        {
            if (_standardHeaders == nil)
                _standardHeaders = [[NSMutableDictionary alloc] init];
            
            if (standardHeaders == nil)
                [_standardHeaders removeObjectForKey:domain];
            else
                [_standardHeaders setObject:standardHeaders forKey:domain];
        }
    }
}

- (void)injectStandardHeadersForRequest:(NSMutableURLRequest*)urlRequest
{
    @synchronized(_standardHeaders)
    {
        if (urlRequest &&
            _standardHeaders)
        {
            for (NSString *domain in _standardHeaders)
            {
                if ([urlRequest.URL.host contains:domain])
                {
                    NSDictionary *headerDict = [_standardHeaders objectForKey:domain];
                    
                    if (headerDict)
                    {
                        for (NSString *headerKey in headerDict)
                        {
                            NSString *value = [NSString stringFromObject:[headerDict objectForKey:headerKey]];
                            
                            if (value.length > 0)
                            {
                                [urlRequest addValue:[headerDict objectForKey:headerKey] forHTTPHeaderField:headerKey];
                            }
                        }
                    }
                    
                    break;
                }
            }
        }
    }
}

#pragma mark - network status

- (Reachability*)reachability
{
    if (_reachability == nil)
    {
        @synchronized(self)
        {
            if (_reachability == nil)
                _reachability = [Reachability reachabilityForInternetConnection];
        }
    }
    
    return _reachability;
}

- (NetworkStatus)networkStatus
{
    return [[self reachability] currentReachabilityStatus];
}

- (BOOL)hasInternetConnection
{
    return [[self reachability] currentReachabilityStatus] != NotReachable;
}

- (void)startNetworkStatusNotifier
{
    [[self reachability] startNotifier];
}

- (void)stopNetworkStatusNotifier
{
    [[self reachability] stopNotifier];
}

@end
