//
//  ContractRate+Utility.h
//  FliteDeck
//
//  Created by Chad Long on 3/21/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFDContractRate.h"
#import "NFDAirport.h"

@interface NFDContractRate (Utility)

- (int)californiaFeesForDeparture:(NFDAirport*)departure arrival:(NFDAirport*)arrival;
- (BOOL)isTaxable:(NSString*)product;
- (NSNumber*)estimatedHourlyFeeForProduct:(NSString*)product;

@end
