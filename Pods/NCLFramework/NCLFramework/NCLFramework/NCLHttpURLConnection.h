//
//  NCLURLConnection.h
//  NCLFramework
//
//  Created by Chad Long on 10/26/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCLURLRequest;

@interface NCLHttpURLConnection : NSObject <NSURLConnectionDelegate>

+ (NSData*)sendSynchronousRequest:(NSURLRequest*)request
                             user:(NSString*)user
                returningResponse:(NSHTTPURLResponse**)response
                            error:(NSError**)error;

- (NSData*)sendSynchronousRequest:(NSURLRequest*)request
                             user:(NSString*)user
                returningResponse:(NSHTTPURLResponse**)response
                            error:(NSError**)error;

- (void)cancel;

@end
