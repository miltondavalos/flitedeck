//
//  NCLRemoteDataService.m
//  FliteDeck
//
//  Created by Chad Long on 5/21/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLFramework.h"
#import "NCLHTTPClient.h"
#import "NCLHttpURLConnection.h"
#import "NSString+Utility.h"
#import "NCLUserPassword.h"
#import "NCLClientCertificate.h"
#import "NCLKeychainStorage.h"
#import "Reachability.h"
#import "NCLURLRequest.h"
#import "NSDate+Utility.h"
#import "NSError+Utility.h"
#import "NSData+Utility.h"
#import "NCLNetworking_Private.h"
#import "NCLAnalytics.h"
#import "NCLAnalyticsEvent.h"

@implementation NCLHTTPClient

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    return self;
}

- (BOOL)requiresAuthentication
{
    return YES;
}

- (NSString*)user
{
    // may be overridden by subclasses to provide the user in a user/password authentication scheme
    return nil;
}

- (NSString*)host
{
    // must be overridden by subclasses to provide the hostname/ip addr for this remote service
    INFOLog(@"host not defined for class");
    
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

- (NSInteger)port
{
    // may be overridden by subclasses to provide the port for this remote service
    return 0;
}

- (BOOL)isSecure
{
    // may be overridden by subclasses to provide the protocol (http,https) for this remote service
    return YES;
}

#pragma mark - Get

- (void)sendHttpRequestWithPath:(NSString*)urlPath
                    queryParams:(NSDictionary*)queryParams
                   notification:(NSString*)notificationName
                 notificationID:(NSObject*)notificationID
  withBackgroundProcessingBlock:(void(^)(NSData*, NSError*))processingBlock
{
    NCLURLRequest *urlRequest = [self urlRequestWithPath:urlPath queryParams:queryParams];
    urlRequest.notificationName = notificationName;
    urlRequest.notificationID = notificationID;
    
    [self sendHttpRequest:urlRequest withBackgroundProcessingBlock:processingBlock];
}

#pragma mark - Post/Put

- (void)sendHttpRequestWithPath:(NSString*)urlPath
                     httpMethod:(NSString*)httpMethod
                       httpBody:(id)data
                   notification:(NSString*)notificationName
                 notificationID:(NSObject*)notificationID
  withBackgroundProcessingBlock:(void(^)(NSData*, NSError*))processingBlock
{
    NCLURLRequest *urlRequest = [self urlRequestWithPath:urlPath queryParams:nil];
    [urlRequest setJSONHeadersAndBodyWithData:data httpMethod:httpMethod];
    urlRequest.notificationName = notificationName;
    urlRequest.notificationID = notificationID;

    [self sendHttpRequest:urlRequest withBackgroundProcessingBlock:processingBlock];
}

#pragma mark - Base request

- (NCLURLRequest*)urlRequestWithPath:(NSString*)urlPath
{
    return [self urlRequestWithPath:urlPath queryParams:nil];
}

- (NCLURLRequest*)urlRequestWithPath:(NSString*)urlPath queryParams:(NSDictionary*)queryParams
{
    // get a baseline NCLURLRequest for this http service
    NSString *scheme = self.isSecure == YES ? @"https" : @"http";
    NCLURLRequest *urlRequest = [[NCLURLRequest alloc] initWithScheme:scheme host:self.host port:self.port path:urlPath queryParams:queryParams];

    urlRequest.queryParams = queryParams;
    urlRequest.user = self.user;
    
    return urlRequest;
}

- (NSData*)sendHttpRequest:(NCLURLRequest*)httpRequest returningResponse:(NSHTTPURLResponse**)response error:(NSError**)error withBackgroundProcessingBlock:(void(^)(NSData*, NSError*))processingBlock
{
    NSData *data = nil;
    NSHTTPURLResponse *httpResponse = nil;
    NSError *localError = nil;
    
    // validate that the host is reachable
    if ([NCLNetworking sharedInstance].networkStatus == NotReachable)
    {
        localError = [NCLHTTPClient translateError:NSURLErrorNotConnectedToInternet];
        
        if (processingBlock)
            processingBlock(nil, localError);
    }
    
    // if the service requires basic auth and a user is not specified/set, it is an error condition
    NCLUserPassword *userPass = nil;
    
    if (!localError &&
        self.requiresAuthentication == YES &&
        [[NCLKeychainStorage sharedInstance] certificateForHost:httpRequest.host] == nil)
    {
        if (httpRequest.user != nil)
            userPass = [NCLKeychainStorage userPasswordForUser:httpRequest.user host:httpRequest.host];
        
        if (userPass == nil ||
            userPass.username == nil ||
            userPass.username.length == 0 ||
            userPass.password == nil ||
            userPass.password.length == 0)
        {
            localError = [NSError errorWithDomain:NSURLErrorDomain
                                             code:kCFURLErrorUserAuthenticationRequired
                                      description:@"Credentials Not Provided"
                                    failureReason:@"We cannot authenticate your username or password."
                               recoverySuggestion:@"Provide a valid username and password."];
            
            if (processingBlock)
                processingBlock(nil, localError);
        }
    }
    
    if (!localError)
    {
        // build authorization header for basic authentication
        [self injectAuthorizationHeaderForRequest:httpRequest withCredentials:userPass];

        // execute the http request... include analytics?
        NCLAnalyticsEvent *networkEvent = nil;
        
        if (httpRequest.shouldSuppressAnalytics == NO)
        {
            networkEvent = [NCLAnalyticsEvent eventForComponent:@"network" action:[httpRequest.HTTPMethod lowercaseString] value:[httpRequest.URL.path lowercaseString]];
            [networkEvent generateTransactionID];
            [self injectAnalyticsHeadersForRequest:httpRequest transactionID:networkEvent.transactionID];
        }
        
        data = [NCLHttpURLConnection sendSynchronousRequest:httpRequest user:httpRequest.user returningResponse:&httpResponse error:&localError];
        
        if (networkEvent)
            [networkEvent updateElapsedTime];
        
        // validate any expected content types in the response
        if (!localError &&
            httpResponse &&
            httpResponse.statusCode != 204 &&
            httpRequest.expectedResponseType != ContentTypeAny)
        {
            NSString *contentType = httpResponse.MIMEType;
            
            if (contentType)
            {
                NSSet *allowableContentTypes = nil;
                
                if (httpRequest.expectedResponseType == ContentTypeJSON)
                {
                    allowableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
                }
                else if (httpRequest.expectedResponseType == ContentTypeXML)
                {
                    allowableContentTypes = [NSSet setWithObjects:@"application/xml", @"text/xml", nil];
                }
                else if (httpRequest.expectedResponseType == ContentTypeImage)
                {
                    allowableContentTypes = [NSSet setWithObjects:@"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];
                }
                
                if (allowableContentTypes &&
                    ![allowableContentTypes containsObject:contentType])
                {
                    INFOLog(@"response w/ content type '%@' NOT allowed!", contentType);
                    
                    localError = [NCLHTTPClient translateError:NSURLErrorCannotParseResponse];
                }
            }
        }
        
        // handle known/expected errors
        localError = [NCLHTTPClient translateError:localError response:httpResponse data:data];
        
        if (localError)
        {
            // clear the password on an unauthorized error (helps prevent account locks)
            if (localError.code == 401 &&
                httpRequest.user != nil &&
                userPass != nil)
            {
                [userPass setPassword:@""];
                [NCLKeychainStorage saveUserPassword:userPass error:nil];
            }
            
            if (processingBlock)
                processingBlock(nil, localError);
        }
        // 200 level http status = OK
        else if (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 204)
        {
            @try
            {
                if (processingBlock)
                    processingBlock(data, nil);
            }
            
            // handle unexpected errors such as parsing (this can leak memory with ARC, but is better than a crash)
            @catch (NSException *exception)
            {
                localError = [NSError errorWithDomain:NSURLErrorDomain code:1 description:[exception name] failureReason:[exception reason]];
                
                if (processingBlock)
                    processingBlock(nil, localError);
            }
        }
        // this is unexpected, and can be caused by unknown issues on the server
        else
        {
            localError = [NSError errorWithDomain:NSURLErrorDomain
                                             code:kCFURLErrorUnknown
                                      description:@"Unexpected Error"
                                    failureReason:[NSString stringWithFormat:@"An unexpected error (%d) has occurred.", httpResponse.statusCode]];
            
            if (processingBlock)
                processingBlock(nil, localError);
        }
        
        // save this event to the analytics data store
        if (networkEvent)
        {
            networkEvent.error = localError;
            [NCLAnalytics addEvent:networkEvent];
        }
    }
    
    if (response != 0 && httpResponse)
        *response = httpResponse;
    
    if (error != 0)
        *error = localError;
    
    // show errors & send notifications (as appropriate)
    [self performHttpPostProcessingForRequest:httpRequest error:localError];
    
    return data;
}

- (NSData*)sendSynchronousHttpRequest:(NCLURLRequest*)httpRequest returningResponse:(NSHTTPURLResponse**)response error:(NSError**)error
{
    return [self sendHttpRequest:httpRequest returningResponse:&*response error:&*error withBackgroundProcessingBlock:nil];
}

- (void)sendHttpRequest:(NCLURLRequest*)httpRequest withBackgroundProcessingBlock:(void(^)(NSData*, NSError*))processingBlock
{
    // create an operation to be executed in the background
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^
    {
        [self sendHttpRequest:httpRequest returningResponse:nil error:nil withBackgroundProcessingBlock:processingBlock];
    }];

    // determine if this operation should be processed serially or concurrently... place it on the appropriate queue
    NSOperationQueue *operationQueue = nil;
    
    if (httpRequest.shouldUseSerialDispatchQueue)
        operationQueue = [NCLNetworking sharedInstance].serialOperationQueue;
    else
        operationQueue = [NCLNetworking sharedInstance].concurrentOperationQueue;
    
    if (httpRequest.threadPriority != ThreadPriorityDefault)
        [operation setThreadPriority:0.0];
    
    [operationQueue addOperation:operation];
}

- (void)injectAuthorizationHeaderForRequest:(NCLURLRequest*)httpRequest withCredentials:(NCLUserPassword*)userPass
{
    // if basic auth should be used, get the credentials from the keychain
    if (self.requiresAuthentication == YES &&
        httpRequest.user != nil &&
        [[NCLKeychainStorage sharedInstance] certificateForHost:httpRequest.host] == nil)
    {
        if (userPass == nil)
            userPass = [NCLKeychainStorage userPasswordForUser:httpRequest.user host:httpRequest.host];
        
        // build authorization header for basic authentication
        if (userPass != nil)
        {
            NSString *authStr = [NSString stringWithFormat:@"%@:%@", userPass.username, userPass.password];
            NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
            NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData encodeBase64]];
            [httpRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
        }
    }
}

- (void)injectAnalyticsHeadersForRequest:(NCLURLRequest*)httpRequest transactionID:(NSString*)transactionID
{
    if ([NCLAnalytics sharedInstance].active == YES &&
        transactionID)
    {
        [httpRequest setValue:transactionID forHTTPHeaderField:@"Trans-ID"];
        [httpRequest setValue:[NSString stringWithFormat:@"%d", [NCLNetworking sharedInstance].networkStatus] forHTTPHeaderField:@"Network-Status"];
    }
}

- (void)injectAuthorizationHeaderForRequest:(NCLURLRequest*)httpRequest
{
    [self injectAuthorizationHeaderForRequest:httpRequest withCredentials:nil];
}

+ (NSError*)translateError:(NSInteger)errorCode
{
    return [NCLHTTPClient translateError:[NSError errorWithDomain:NSURLErrorDomain code:errorCode description:nil failureReason:nil] response:nil data:nil];
}

+ (NSError*)translateError:(NSError*)error response:(NSHTTPURLResponse*)httpResponse data:(NSData*)data
{
    NSError *errorTranslation = nil;
    
    // if we get a http 400+ response w/JSON, parse the response for error information
    if (httpResponse.statusCode >= 400)
    {
        NSError *jsonError = nil;
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (!jsonError &&
            [payload isKindOfClass:[NSDictionary class]] &&
            [payload objectForKey:@"code"])
        {
            errorTranslation = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:[[NSNumber numberFromObject:[payload objectForKey:@"code"] shouldUseZeroDefault:YES] integerValue]
                                            description:[NSString stringFromObject:[payload objectForKey:@"description"]]
                                          failureReason:nil];
        }
    }

    // if the payload didn't have a customized error, let's use a generic one
    if (!errorTranslation)
    {
        // http status of 401 = Unauthorized (basic auth or client cert authentication failure)
        if (httpResponse.statusCode == 401 ||
            (error && error.code == NSURLErrorUserCancelledAuthentication))
        {
            errorTranslation = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:401
                                            description:@"Unauthorized"
                                          failureReason:@"We cannot authenticate your username or password."
                                     recoverySuggestion:@"Ensure that your account is not locked and that you have provided a valid username and password."];
        }
        // http status of 403 = Forbidden
        else if (httpResponse.statusCode == 403)
        {
            errorTranslation = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:403
                                            description:@"Forbidden"
                                          failureReason:@"You are not authorized to use this service."];
        }
        // http status of 404 = Not found
        else if (httpResponse.statusCode == 404 ||
                 (error && error.code == NSURLErrorResourceUnavailable))
        {
            errorTranslation = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:404
                                            description:@"Resource Not Found"
                                          failureReason:@"This service is unavailable."];
        }
        // not connected
        else if (error && error.code == NSURLErrorNotConnectedToInternet)
        {
            errorTranslation = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:kCFURLErrorNotConnectedToInternet
                                            description:@"Not Connected"
                                          failureReason:@"A connection to the network could not be established."
                                     recoverySuggestion:@"Ensure that the device has a valid network connection."];
        }
        // unexpected response
        else if (error && error.code == NSURLErrorCannotParseResponse)
        {
            errorTranslation = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:NSURLErrorCannotParseResponse
                                            description:@"Unexpected Response"
                                          failureReason:@"An unexpected response was received from the network."
                                     recoverySuggestion:@"Ensure that the device has a valid network connection."];
        }
        // catch the rest of the iOS network errors (does not include some http errors)
        else if (error)
        {
            errorTranslation = [NSError errorWithDomain:NSURLErrorDomain code:error.code description:@"Connection Error" failureReason:error.localizedDescription];
        }
        // catch the rest of the http errors
        else if (httpResponse.statusCode >= 400)
        {
            errorTranslation = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:kCFURLErrorUnknown
                                            description:@"Server Error"
                                          failureReason:[NSString stringWithFormat:@"An unexpected error (%d) has occurred.", httpResponse.statusCode]];
        }
    }
    
    return errorTranslation == nil ? error : errorTranslation;
}

- (void)postNotificationForRequest:(NCLURLRequest *)httpRequest error:(NSError *)error
{
    // post notification that processing is complete... include a call identifier and any error data in the notification
    if (httpRequest.notificationName)
    {
        NSArray *keys = [NSArray arrayWithObjects:
                         HTTP_REQUEST_ID_NOTIFICATION_KEY,
                         HTTP_REQUEST_ERROR_NOTIFICATION_KEY, nil];
        NSArray *objects = [NSArray arrayWithObjects:
                            (httpRequest.notificationID == nil ? [NSNull null] : httpRequest.notificationID),
                            (error == nil ? [NSNull null] : error), nil];
        NSDictionary *notificationData = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        dispatch_async
        (dispatch_get_main_queue(), ^
         {
             INFOLog(@"sending %@ notification", httpRequest.notificationName);
             
             [[NSNotificationCenter defaultCenter] postNotificationName:httpRequest.notificationName object:self userInfo:notificationData];
         });
    }
}

- (void)performHttpPostProcessingForRequest:(NCLURLRequest*)httpRequest error:(NSError*)error
{
    // if requested, display an error alert when applicable
    if (httpRequest.shouldPresentAlertOnError &&
        error != nil)
    {
        NSString *title = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        NSString *message = [error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
        
        if (message == nil)
        {
            message = title;
            title = @"Error";
        }
       
        // display error view
        [NCLErrorPresenter presentError:error];
    }
    
    [self postNotificationForRequest:httpRequest error:error];
}

@end
