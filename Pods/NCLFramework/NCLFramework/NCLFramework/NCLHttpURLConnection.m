//
//  NCLURLConnection.m
//  NCLFramework
//
//  Created by Chad Long on 10/26/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLHttpURLConnection.h"
#import "NCLFramework.h"
#import "NCLURLRequest.h"
#import "NCLClientCertificate.h"
#import "NCLKeychainStorage.h"
#import "NCLHTTPProtocol.h"
#import "NCLNetworking_Private.h"

@implementation NCLHttpURLConnection
{
    NSURLConnection *_connection;
    NSMutableData *_data;
    NSHTTPURLResponse *_response;
    NSError *_error;
    NSCondition *_certLock;
    NSMutableURLRequest *_urlRequest;
    NSString *_user;
}

- (void)dealloc
{
    TRACELog(@"deallocating NCLHttpURLConnection: %@", _urlRequest.description);
}

+ (NSData*)sendSynchronousRequest:(NSURLRequest*)request user:(NSString*)user returningResponse:(NSHTTPURLResponse**)response error:(NSError**)error
{
    NCLHttpURLConnection *connection = [[NCLHttpURLConnection alloc] init];
    
    return [connection sendSynchronousRequest:request user:user returningResponse:&*response error:&*error];
}

- (NSData*)sendSynchronousRequest:(NSURLRequest*)request user:(NSString*)user returningResponse:(NSHTTPURLResponse**)response error:(NSError**)error
{
    INFOLog(@"sending http %@ request to: %@",  request.HTTPMethod,  [request description]);

    _certLock = [[NSCondition alloc] init];
    _user = user;
    _data = [[NSMutableData alloc] init];
    
    _urlRequest = [request mutableCopy];
    [[NCLNetworking sharedInstance] injectStandardHeadersForRequest:_urlRequest];
    DEBUGLog(@"headers: %@", [_urlRequest allHTTPHeaderFields]);
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if (![request isMemberOfClass:[NCLURLRequest class]] ||
            ((NCLURLRequest*)request).shouldDisplayActivityIndicator == YES)
        {
            [[NCLNetworking sharedInstance] incrementActivityCount];
        }
        
        _connection = [[NSURLConnection alloc] initWithRequest:_urlRequest delegate:self startImmediately:NO];
        [_connection start];
    });
    
    [_certLock lock];
    [_certLock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:_urlRequest.timeoutInterval + 2]];
    [_certLock unlock];

    if (_response &&
        response != 0)
    {
        *response = _response;

        INFOLog(@"http response code = %d", _response.statusCode);
        DEBUGLog(@"http response MIME type = %@", _response.MIMEType);
        DEBUGLog(@"http response headers: %@", _response.allHeaderFields);
    }

    if (_error)
    {
        INFOLog(@"ERROR occurred for http request: %@; error:%@", [request description], [_error localizedDescription]);
        
        if (error != 0)
            *error = _error;
    }
    else if ([NCLFramework logLevel] > 1)
    {
        if (_response &&
            [_response.MIMEType contains:@"image"])
        {
            INFOLog(@"http image response: < %d K >", (_data.length / 1024));
        }
        else
        {
            NSInteger maxDisplayBytes = ([NCLFramework logLevel] > 3) ? 1024*1000 : 1024;
            NSError *parseError = nil;
            id jsonData = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments error:&parseError];
            
            if (parseError ||
                !jsonData)
            {
                NSString *printableData = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
                NSString *moreBytes = printableData.length > maxDisplayBytes ? [NSString stringWithFormat:@"... < %i MORE BYTES >", printableData.length - maxDisplayBytes] : @"";
                printableData = printableData.length > maxDisplayBytes ? [printableData substringToIndex:maxDisplayBytes] : printableData;
                
                INFOLog(@"http response data:\n%@%@", printableData, moreBytes);
            }
            else
            {
                NSString *prettyPrintJSON = [jsonData description];
                NSString *moreBytes = prettyPrintJSON.length > maxDisplayBytes ? [NSString stringWithFormat:@"... < %i MORE BYTES >", prettyPrintJSON.length - maxDisplayBytes] : @"";
                prettyPrintJSON = prettyPrintJSON.length > maxDisplayBytes ? [prettyPrintJSON substringToIndex:maxDisplayBytes] : prettyPrintJSON;
                
                INFOLog(@"http JSON response:\n%@%@", prettyPrintJSON, moreBytes);
            }
        }
    }
    
    if (![request isMemberOfClass:[NCLURLRequest class]] ||
        ((NCLURLRequest*)request).shouldDisplayActivityIndicator == YES)
    {
        [[NCLNetworking sharedInstance] decrementActivityCount];
    }

    return _data;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = (NSHTTPURLResponse*)response;
    [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

# pragma mark - finished or canceled loading

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    DEBUGLog(@"connectionDidFinishLoading...");
    
    [_certLock lock];
    [_certLock broadcast];
    [_certLock unlock];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DEBUGLog(@"connectionDidFailWithError...");
    
    _error = error;
    
    [_certLock lock];
    [_certLock broadcast];
    [_certLock unlock];
}

- (void)cancel
{
    dispatch_async
    (
     dispatch_get_main_queue(), ^
     {
         [_connection cancel];
         
         INFOLog(@"connection canceled...");
     });
    
    [_certLock lock];
    [_certLock broadcast];
    [_certLock unlock];
}

# pragma mark - authentication

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] > 1)
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        
        return;
    }
    
    // trust all hosts
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        TRACELog(@"didReceiveServerTrustChallenge: protectionSpace {%@}", challenge.protectionSpace.serverTrust);
        
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    
    // use basic auth
    else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
    {
        DEBUGLog(@"didReceiveHTTPBasicChallenge: protectionSpace {%@:%@:%i:%@}",
             challenge.protectionSpace.protocol, challenge.protectionSpace.host, challenge.protectionSpace.port, challenge.protectionSpace.realm);
        
        NCLUserPassword *userPass = nil;
        
        if (_user)
        {
            userPass = [NCLKeychainStorage userPasswordForUser:_user host:challenge.protectionSpace.host];
            
            if (userPass)
            {
                NSURLCredential *cred = [[NSURLCredential alloc] initWithUser:userPass.username
                                                                     password:userPass.password
                                                                  persistence:NSURLCredentialPersistenceNone];
                
                [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
                
                INFOLog(@"using user/password credentials for session: %@", userPass.username);
            }
        }
        
        if (userPass == nil)
        {
            INFOLog(@"no user/password credentials for user/host %@/%@", _user, challenge.protectionSpace.host);
            
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
    
    // use a client cert
    else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate])
    {
        DEBUGLog(@"didReceiveClientCertificateChallenge: protectionSpace {%@:%@:%i:%@}",
             challenge.protectionSpace.protocol, challenge.protectionSpace.host, challenge.protectionSpace.port, challenge.protectionSpace.realm);
        
        NCLClientCertificate *certificate = [[NCLKeychainStorage sharedInstance] certificateForHost:challenge.protectionSpace.host];

        if (certificate)
        {
            NSURLCredential *credential = [certificate credential];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            
            INFOLog(@"using client certificate for session: %@", [certificate subjectSummary]);
        }
        else
        {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            
            INFOLog(@"no client certificate for host %@... continuing without client certificate authentication", challenge.protectionSpace.host);
        }
    }
}

@end
