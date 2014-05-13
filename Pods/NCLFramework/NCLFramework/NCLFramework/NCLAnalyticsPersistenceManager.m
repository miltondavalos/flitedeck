//
//  NCLAnalyticsPersistenceManager.m
//  NCLFramework
//
//  Created by Chad Long on 9/17/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLAnalyticsPersistenceManager.h"

@implementation NCLAnalyticsPersistenceManager

+ (NCLAnalyticsPersistenceManager*)sharedInstance
{
	static dispatch_once_t pred;
	static NCLAnalyticsPersistenceManager *sharedInstance = nil;
    
	dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
	
    return sharedInstance;
}

- (NSString*)modelName
{
    return @"NCLAnalytics";
}

@end
