//
//  NFDProposalResults.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDProposalResults.h"

@implementation NFDProposalResults
@synthesize result;
@synthesize FederalExciseTaxAnnual;
@synthesize OccupiedHourlyFeeAnnual;
@synthesize FuelVariableRate;
@synthesize FuelVariableFederalExciseTaxRate;
@synthesize FuelVariableAnnual;
@synthesize MonthlyManagementFeeAnnual;
@synthesize OccupiedHourlyFeeRate;
@synthesize FuelVariableFederalExciseTaxAnnual;
@synthesize MonthlyManagementFeeRate;
@synthesize PLACEHOLDER;
@synthesize FederalExciseTaxRate;

-(void) setData : (NSDictionary*) dictionary {
    self.result = [dictionary objectForKey:@"result"];
    self.FederalExciseTaxAnnual = [dictionary objectForKey:@"FederalExciseTaxAnnual"];
    self.OccupiedHourlyFeeAnnual = [dictionary objectForKey:@"OccupiedHourlyFeeAnnual"];
    self.FuelVariableRate = [dictionary objectForKey:@"FuelVariableRate"];
    self.FuelVariableFederalExciseTaxRate = [dictionary objectForKey:@"FuelVariableFederalExciseTaxRate"];
    self.FuelVariableAnnual = [dictionary objectForKey:@"FuelVariableAnnual"];
    self.MonthlyManagementFeeAnnual = [dictionary objectForKey:@"MonthlyManagementFeeAnnual"];
    self.OccupiedHourlyFeeRate = [dictionary objectForKey:@"OccupiedHourlyFeeRate"];
    self.FuelVariableFederalExciseTaxAnnual = [dictionary objectForKey:@"FuelVariableFederalExciseTaxAnnual"];
    self.MonthlyManagementFeeRate = [dictionary objectForKey:@"MonthlyManagementFeeRate"];
    self.PLACEHOLDER = [dictionary objectForKey:@"PLACEHOLDER"];
    self.FederalExciseTaxRate = [dictionary objectForKey:@"FederalExciseTaxRate"];
}
@end
