//
//  NFDFlightProposalAggregator.h
//  FliteDeck
//
//  Created by Ryan Smith on 4/20/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFDFlightProposalAggregator : NSObject

+ (NFDFlightProposalAggregator *)sharedInstance;

+ (NSNumber *)aggregatedValueFor:(NSString *)item;

+ (NSNumber *)aggregatedTotalFor:(NSString *)item;
+ (NSNumber *)aggregatedHourlyRateFor:(NSString *)item;

@end
