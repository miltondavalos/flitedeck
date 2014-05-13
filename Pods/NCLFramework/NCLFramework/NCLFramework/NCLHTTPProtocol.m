//
//  NCLURLProtocol.m
//  WebViewTest
//
//  Created by Chad Long on 7/18/13.
//  Copyright (c) 2013 NetJets. All rights reserved.
//

#import "NCLHTTPProtocol.h"
#import "NCLFramework.h"
#import "NCLNetworking.h"
#import "NCLHttpURLConnection.h"
#import "NCLURLRequest.h"
#import "NSString+Utility.h"
#import "NCLHTTPClient.h"
#import "NCLNetworking_Private.h"

@implementation NCLHTTPProtocol
{
    NSMutableURLRequest *_request;
    NCLHttpURLConnection *_connection;
}

+ (BOOL)canInitWithRequest:(NSURLRequest*)request
{
    static NSString *httpScheme = @"http";
    static NSString *webKitKey = @"User-Agent";
    static NSString *webKitValue = @"AppleWebKit";
    
    NSString *scheme = [[[request URL] scheme] lowercaseString];

    // use this protocol only for instances of UIWebView
    if ([scheme contains:httpScheme] &&
        [[request allHTTPHeaderFields] objectForKey:webKitKey] &&
        [[[request allHTTPHeaderFields] objectForKey:webKitKey] contains:webKitValue] &&
        [[request allHTTPHeaderFields] objectForKey:httpProtocolKey] == nil)
    {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)protocolClient
{
    _request = [request mutableCopy];
    [_request setValue:NSStringFromClass([self class]) forHTTPHeaderField:httpProtocolKey];
    
	return [super initWithRequest:_request cachedResponse:cachedResponse client:protocolClient];
}

- (void)startLoading
{
    NSHTTPURLResponse *httpResponse = nil;
    NSError *httpError = nil;
    NSString *user = [[[NCLNetworking sharedInstance] userForHost:_request.URL.host] mutableCopy];
    
    DEBUGLog(@"protocol startLoading w/ registered user %@ for host %@", user, _request.URL.host);

    _connection = [[NCLHttpURLConnection alloc] init];
    NSData *data = [_connection sendSynchronousRequest:_request user:user returningResponse:&httpResponse error:&httpError];
    
    if (httpError)
    {
        DEBUGLog(@"protocol executing client callback w/ error");
        
        [[self client] URLProtocol:self didFailWithError:[NCLHTTPClient translateError:httpError response:nil data:nil]];
    }
    else
    {
        DEBUGLog(@"protocol executing client callback w/ data");

        // build the response
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:_request.URL
                                                                  statusCode:httpResponse ? httpResponse.statusCode : 200
                                                                 HTTPVersion:@"1.1"
                                                                headerFields:httpResponse ? [httpResponse allHeaderFields] : [NSDictionary new]];
        
        // execute client callbacks
        [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[self client] URLProtocol:self didLoadData:data];
        [[self client] URLProtocolDidFinishLoading:self];
    }
    
    _connection = nil;
}

-(void)stopLoading
{
    [_connection cancel];
}

@end
