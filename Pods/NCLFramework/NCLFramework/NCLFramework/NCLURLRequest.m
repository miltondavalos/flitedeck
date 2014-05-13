//
//  NCLURLRequest.m
//  NCLFramework
//
//  Created by Chad Long on 7/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLFramework.h"
#import "NCLURLRequest.h"
#import "UIDevice+Utility.h"

@implementation NCLURLRequest

@synthesize queryParams = _queryParams;

#pragma mark - Initialization

+ (id)requestWithURL:(NSURL *)URL
{
    return [[NCLURLRequest alloc] initWithURL:URL];
}

- (id)initWithURL:(NSURL*)theURL
{
    return [self initWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0];
}

+ (id)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    return [[NCLURLRequest alloc] initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
}

- (id)initWithURL:(NSURL*)theURL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super initWithURL:theURL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    
    if (self)
    {
        self.shouldUseSerialDispatchQueue = NO;
        self.threadPriority = ThreadPriorityDefault;
        self.shouldPresentAlertOnError = NO;
        self.shouldSuppressAnalytics = NO;
        self.shouldDisplayActivityIndicator = YES;
        self.expectedResponseType = ContentTypeJSON;
        [self setHTTPShouldHandleCookies:NO];
        [self setHTTPMethod:GET_METHOD];
    }
    
    return self;
}

- (id)initWithScheme:(NSString*)scheme host:(NSString*)host port:(NSInteger)port path:(NSString*)urlPath queryParams:(NSDictionary*)queryParams
{
    self = [self init];
    
    if (self)
    {
        [self setURL:[self urlForScheme:scheme host:host port:port path:urlPath queryParams:queryParams]];
        [self setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
        [self setTimeoutInterval:30.0];
        _queryParams = queryParams;
        self.shouldUseSerialDispatchQueue = NO;
        self.threadPriority = ThreadPriorityDefault;
        self.shouldPresentAlertOnError = NO;
        self.shouldSuppressAnalytics = NO;
        self.shouldDisplayActivityIndicator = YES;
        self.expectedResponseType = ContentTypeJSON;
        [self setHTTPShouldHandleCookies:NO];
        [self setHTTPMethod:GET_METHOD];
    }

    return self;
}

#pragma mark - Convenience methods

- (NSURL*)urlForScheme:(NSString*)scheme host:(NSString*)host port:(NSInteger)port path:(NSString*)urlPath queryParams:(NSDictionary*)queryParams
{
    NSString *portString = (port != 0) ? [NSString stringWithFormat:@":%i", port] : @"";
    NSString *queryParamsString = [self stringForQueryParams:queryParams];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@%@%@", scheme, host, portString, urlPath, queryParamsString]];
}

- (void)setQueryParams:(NSDictionary*)queryParams
{
    NSURL *url = [self urlForScheme:self.URL.scheme host:self.host port:self.port path:self.URL.path queryParams:queryParams];
    [self setURL:url];
    
    _queryParams = queryParams;
}

- (BOOL)setJSONHeadersAndBodyWithData:(id)data httpMethod:(NSString*)method
{
    BOOL success = YES;
    
    if (data != nil)
    {
        [self setHTTPMethod:method];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        
        if (error)
        {
            success = NO;
            
            if ([NCLFramework logLevel] > 1)
            {
                NSString *printableData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                INFOLog(@"JSON serialization error: %@\n%@", [error localizedDescription], printableData);
            }
        }
        else
        {
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
            [self setHTTPBody:jsonData];
            
            if ([NCLFramework logLevel] > 1)
            {
                NSInteger maxDisplayBytes = ([NCLFramework logLevel] > 3) ? 1024*1000 : 1024;
                NSError *parseError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
                
                if (json)
                {
                    NSString *prettyPrintJSON = [json description];
                    NSString *moreBytes = prettyPrintJSON.length > maxDisplayBytes ? [NSString stringWithFormat:@"... < %i MORE BYTES >", prettyPrintJSON.length - maxDisplayBytes] : @"";
                    prettyPrintJSON = prettyPrintJSON.length > maxDisplayBytes ? [prettyPrintJSON substringToIndex:maxDisplayBytes] : prettyPrintJSON;
                    
                    INFOLog(@"JSON payload:\n%@%@", prettyPrintJSON, moreBytes);
                }
            }
        }
    }
    else
    {
        [self setHTTPMethod:GET_METHOD];
    }
    
    return success;
}

- (NSString*)host
{
    return self.URL.host;
}

- (NSInteger)port
{
    if (self.URL.port == nil)
        return 0;
    else
        return [self.URL.port integerValue];
}

#pragma mark - Description & copying

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@://%@%@%@%@",
            self.URL.scheme, self.host, self.port == 0 ? @"" : [NSString stringWithFormat:@":%i", self.port], self.URL.path, [self stringForQueryParams:self.queryParams]];
}

- (id)mutableCopy
{
    NCLURLRequest *urlRequest = [[NCLURLRequest alloc] initWithURL:self.URL cachePolicy:self.cachePolicy timeoutInterval:self.timeoutInterval];
    urlRequest.queryParams = self.queryParams;
    [urlRequest setAllHTTPHeaderFields:self.allHTTPHeaderFields];
    urlRequest.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies;
    urlRequest.HTTPMethod = self.HTTPMethod;
    urlRequest.HTTPBody = self.HTTPBody;
    
    urlRequest.param = self.param;
    urlRequest.user = self.user;
    urlRequest.shouldUseSerialDispatchQueue = self.shouldUseSerialDispatchQueue;
    urlRequest.shouldPresentAlertOnError = self.shouldPresentAlertOnError;
    urlRequest.shouldSuppressAnalytics = self.shouldSuppressAnalytics;
    urlRequest.shouldDisplayActivityIndicator = self.shouldDisplayActivityIndicator;
    urlRequest.notificationName = self.notificationName;
    urlRequest.notificationID = self.notificationID;
    urlRequest.expectedResponseType = self.expectedResponseType;
    urlRequest.threadPriority = self.threadPriority;
    
    return urlRequest;
}

#pragma mark - Query string encoding

- (NSString*)stringForQueryParams:(NSDictionary*)queryParams
{
    NSString *queryParamsString = @"";
    
    if (queryParams != nil &&
        queryParams.count > 0)
    {
        queryParamsString = [NSString stringWithFormat:@"?%@", [self stringWithURLEncodedComponentsForDictionary:queryParams]];
    }
    
    return queryParamsString;
}

- (NSString*)stringWithURLEncodedComponentsForDictionary:(NSDictionary*)dictionary
{
    NSMutableArray *arguments = [NSMutableArray array];
    
    for (NSString *key in dictionary)
    {
        NSObject *object = [dictionary objectForKey:key];
        
        // clean up strings with proper escaping
        if ([object isKindOfClass:[NSString class]])
        {
            [arguments addObject:[NSString stringWithFormat:@"%@=%@", key, [self stringByEscapingForURLQueryString:(NSString*)object]]];
        }
        
        // numbers
        if ([object isKindOfClass:[NSNumber class]])
        {
            [arguments addObject:[NSString stringWithFormat:@"%@=%@", key, [(NSNumber*)object stringValue]]];
        }
        
        // format dates/times in ISO 8601
        else if ([object isKindOfClass:[NSDate class]])
        {
            [arguments addObject:[NSString stringWithFormat:@"%@=%@", key, [(NSDate*)object description]]];
        }
    }
    
    return [arguments componentsJoinedByString:@"&"];
}

- (NSString*)stringByEscapingForURLQueryString:(NSString*)queryString
{
    NSString *result = queryString;
    
    CFStringRef originalAsCFString = (__bridge CFStringRef)queryString;
    CFStringRef leaveAlone = CFSTR(" ");
    CFStringRef toEscape = CFSTR("\n\r?[]()$,!'*;:@&=#%+/");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, originalAsCFString, leaveAlone, toEscape, kCFStringEncodingUTF8);
    
    if (escapedStr)
    {
        NSMutableString *mutable = [NSMutableString stringWithString:(__bridge NSString*)escapedStr];
        CFRelease(escapedStr);
        
        [mutable replaceOccurrencesOfString:@" " withString:@"+" options:0 range:NSMakeRange(0, [mutable length])];
        result = mutable;
    }
    
    return result;
}

@end
