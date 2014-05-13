//
//  NFDFlightProposalAggregator.m
//  FliteDeck
//
//  Created by Ryan Smith on 4/20/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import "NFDFlightProposalAggregator.h"
#import "NFDProposal.h"
#import "NFDFlightProposalCalculatorService.h"
#import "NFDFlightProposalManager.h"

static NFDFlightProposalAggregator *sharedInstance;

@implementation NFDFlightProposalAggregator

+ (NSNumber *)aggregatedValueFor:(NSString *)item
{
    NSNumber *aggregatedValue = [NSNumber numberWithFloat:0];
    
    NSArray *hourlyRateItems = [NSArray arrayWithObjects:
                                @"OccupiedHourlyFeeRate",
                                @"FuelVariableRate",
                                @"AverageHourlyCost", nil];
    
    NSArray *ignoredItems = [NSArray arrayWithObjects:
                             @"Available",
                             @"Tail",
                             @"ContractsUntil", nil];
    
    if ([hourlyRateItems containsObject:item])
    {
        aggregatedValue = [NFDFlightProposalAggregator aggregatedHourlyRateFor:item];
    }
    else if (![ignoredItems containsObject:item])
    {
        aggregatedValue = [NFDFlightProposalAggregator aggregatedTotalFor:item];
    }
    else {
        aggregatedValue = nil;
    }
    
    return aggregatedValue;
}


+ (NSNumber *)aggregatedHourlyRateFor:(NSString *)item
{
    NSArray *proposals = [[NFDFlightProposalManager sharedInstance] retrieveAllSelectedProposals];
    NSMutableArray *rates = [[NSMutableArray alloc] init];
    NSMutableArray *hours = [[NSMutableArray alloc] init];
    double totalHours = 0;
    
    for (NFDProposal *proposal in proposals)
    {
        if (proposal.productCode.intValue != PHENOM_TRANSITION_LEASE_PRODUCT)
        {
            if ([[proposal unifiedDictionary] objectForKey:item])
            {
                [rates addObject:[[proposal unifiedDictionary] objectForKey:item]];
            }
            else 
            {
                [rates addObject:[NSNumber numberWithFloat:0]];
            }
            [hours addObject:[[proposal unifiedDictionary] objectForKey:@"AnnualHours"]];
            totalHours += [[[proposal unifiedDictionary] objectForKey:@"AnnualHours"] doubleValue];
        }
    }
    
    double rate = 0;
    
    for (int i=0; i<rates.count; i++)
    {
        rate += [[rates objectAtIndex:i] doubleValue] * ([[hours objectAtIndex:i] doubleValue] / totalHours);
    }
    return [NSNumber numberWithDouble:rate];
}

+ (NSNumber *)aggregatedTotalFor:(NSString *)item
{
    NSArray *proposals = [[NFDFlightProposalManager sharedInstance] retrieveAllSelectedProposals];
    double total = 0;
    
    for (NFDProposal *proposal in proposals)
    {
        if (proposal.productCode.intValue != PHENOM_TRANSITION_LEASE_PRODUCT)
        {
            if ([[proposal unifiedDictionary] objectForKey:item])
            {
                total += [[[proposal unifiedDictionary] objectForKey:item] doubleValue];
            }
        }
    }
    return [NSNumber numberWithDouble:total];
}





#pragma mark -
#pragma mark Singleton stuff

+ (NFDFlightProposalAggregator *)sharedInstance
{
	if (!sharedInstance)
	{
		sharedInstance = [[NFDFlightProposalAggregator alloc] init];
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
