//
//  NCLRemoteDataService.h
//  FliteDeck
//
//  Created by Chad Long on 5/21/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCLURLRequest;

#define HTTP_REQUEST_DID_COMPLETE_NOTIFICATION @"HTTPRequestDidCompleteNotification"

#define HTTP_REQUEST_ID_NOTIFICATION_KEY @"HTTPRequestIDNotificationKey"
#define HTTP_REQUEST_ERROR_NOTIFICATION_KEY @"HTTPRequestErrorNotificationKey"

@interface NCLHTTPClient : NSObject

+ (NSError*)translateError:(NSInteger)errorCode;
+ (NSError*)translateError:(NSError*)error response:(NSHTTPURLResponse*)httpResponse data:(NSData*)data;

- (BOOL)requiresAuthentication;
- (NSString*)user;
- (NSString*)host;
- (NSInteger)port;
- (BOOL)isSecure;

- (NCLURLRequest*)urlRequestWithPath:(NSString*)urlPath;
- (NCLURLRequest*)urlRequestWithPath:(NSString*)urlPath queryParams:(NSDictionary*)queryParams;

- (NSData*)sendSynchronousHttpRequest:(NCLURLRequest*)httpRequest returningResponse:(NSHTTPURLResponse**)response error:(NSError**)error;
- (void)sendHttpRequest:(NCLURLRequest*)httpRequest withBackgroundProcessingBlock:(void(^)(NSData*, NSError*))processingBlock;

// GET
- (void)sendHttpRequestWithPath:(NSString*)urlPath
                    queryParams:(NSDictionary*)queryParams
                   notification:(NSString*)notificationName
                 notificationID:(NSObject*)notificationID
  withBackgroundProcessingBlock:(void(^)(NSData*, NSError*))processingBlock;

// POST/PUT
- (void)sendHttpRequestWithPath:(NSString*)urlPath
                     httpMethod:(NSString*)httpMethod
                       httpBody:(id)data
                   notification:(NSString*)notificationName
                 notificationID:(NSObject*)notificationID
  withBackgroundProcessingBlock:(void(^)(NSData*, NSError*))processingBlock;

- (void)postNotificationForRequest:(NCLURLRequest *)httpRequest error:(NSError *)error;

@end
