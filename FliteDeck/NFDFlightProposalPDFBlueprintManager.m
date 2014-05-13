//
//  NFDFlightProposalPDFBlueprintManager.m
//  FliteDeck
//
//  Created by Ryan Smith on 5/3/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import "NFDFlightProposalPDFBlueprintManager.h"

static NFDFlightProposalPDFBlueprintManager *sharedInstance;

@implementation NFDFlightProposalPDFBlueprintManager

@synthesize blueprint = _blueprint;

#pragma mark -
#pragma mark Singleton stuff

- (id)init
{
    if ((self = [super init]))
    {
        self.blueprint = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (NFDFlightProposalPDFBlueprintManager *)sharedInstance
{
	if (!sharedInstance)
	{
		sharedInstance = [[NFDFlightProposalPDFBlueprintManager alloc] init];
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	if (!sharedInstance)
	{
		sharedInstance = [super allocWithZone:zone];
		return sharedInstance;
	}
	else 
	{
		return nil;
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

@end
