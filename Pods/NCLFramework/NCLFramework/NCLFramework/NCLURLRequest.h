//
//  NCLURLRequest.h
//  NCLFramework
//
//  Created by Chad Long on 7/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GET_METHOD @"GET"
#define POST_METHOD @"POST"
#define PUT_METHOD @"PUT"
#define DELETE_METHOD @"DELETE"

typedef enum
{
    ContentTypeAny = 0,
    ContentTypeJSON,
    ContentTypeXML,
    ContentTypeImage,
} ContentType;

typedef enum
{
    ThreadPriorityBackground = 0,
    ThreadPriorityDefault
} ThreadPriority;

@interface NCLURLRequest : NSMutableURLRequest

@property (nonatomic, strong) NSDictionary *queryParams;
@property (nonatomic, strong) NSString *user;
@property (nonatomic) ThreadPriority threadPriority;
@property BOOL shouldUseSerialDispatchQueue;
@property BOOL shouldPresentAlertOnError;
@property BOOL shouldSuppressAnalytics;
@property BOOL shouldDisplayActivityIndicator;
@property (nonatomic, strong) NSObject *param;
@property (nonatomic, strong) NSString *notificationName;
@property (nonatomic, strong) NSObject *notificationID;
@property (nonatomic) ContentType expectedResponseType;

- (id)initWithScheme:(NSString*)scheme host:(NSString*)host port:(NSInteger)port path:(NSString*)urlPath queryParams:(NSDictionary*)queryParams;
- (BOOL)setJSONHeadersAndBodyWithData:(id)data httpMethod:(NSString*)method;
- (id)mutableCopy;
- (NSString*)host;
- (NSInteger)port;


@end