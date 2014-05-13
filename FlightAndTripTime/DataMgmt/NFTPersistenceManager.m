//
//  PersistenceManager.m
//  FlightAndTripTime
//
//  Created by Long Chad on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFTPersistenceManager.h"

@implementation NFTPersistenceManager

+ (NFTPersistenceManager*)sharedInstance
{
	static dispatch_once_t pred;
	static NFTPersistenceManager *sharedInstance = nil;
    
	dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
	
    return sharedInstance;
}

- (NSString*)modelName
{
    return @"FlightAndTripTime";
}

- (BOOL)shouldAlwaysInstallResourcedDatabase
{
    return true;
}

@end
