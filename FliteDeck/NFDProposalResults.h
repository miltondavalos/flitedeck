//
//  NFDProposalResults.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFDProposalResults : NSObject
@property(nonatomic,weak) NSDate *result;
@property(nonatomic,weak) NSNumber *FederalExciseTaxAnnual;
@property(nonatomic,weak) NSNumber *OccupiedHourlyFeeAnnual;
@property(nonatomic,weak) NSNumber *FuelVariableRate;
@property(nonatomic,weak) NSNumber *FuelVariableFederalExciseTaxRate;
@property(nonatomic,weak) NSNumber *FuelVariableAnnual;
@property(nonatomic,weak) NSNumber *MonthlyManagementFeeAnnual;
@property(nonatomic,weak) NSNumber *OccupiedHourlyFeeRate;
@property(nonatomic,weak) NSNumber *FuelVariableFederalExciseTaxAnnual;
@property(nonatomic,weak) NSNumber *MonthlyManagementFeeRate;
@property(nonatomic,weak) NSString *PLACEHOLDER;
@property(nonatomic,weak) NSNumber *FederalExciseTaxRate;

-(void) setData : (NSDictionary*) dictionary;

@end
