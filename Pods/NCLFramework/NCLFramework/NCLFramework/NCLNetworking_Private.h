//
//  NCLNetworking_NCLNetworking_Private_.h
//  NCLFramework
//
//  Created by Chad Long on 1/16/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <NCLFramework/NCLFramework.h>

@interface NCLNetworking ()

+ (NSString*)secondLevelDomainForHost:(NSString*)host;

- (void)injectStandardHeadersForRequest:(NSMutableURLRequest*)urlRequest;
- (NSString*)userForHost:(NSString*)host;
- (Reachability*)reachability;

- (void)incrementActivityCount;
- (void)decrementActivityCount;
- (void)updateNetworkActivityIndicatorVisibility;
- (void)updateNetworkActivityIndicatorVisibilityDelayed;

@end
