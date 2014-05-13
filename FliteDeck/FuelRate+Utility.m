//
//  FuelRate+Utility.m
//  FliteDeck
//
//  Created by Chad Long on 4/19/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "FuelRate+Utility.h"

@implementation NFDFuelRate (Utility)

- (int)qualifiedDefaultRate
{
    int rate = [self.qualified12MonthRate intValue];

    if (rate <= 0)
    {
        rate = [self.qualified6MonthRate intValue];
    }
    
    if (rate <= 0)
    {
        rate = [self.qualified3MonthRate intValue];
    }

    if (rate <= 0)
    {
        rate = [self.qualified1MonthRate intValue];
    }
    
    return rate;
}

- (int)nonQualifiedDefaultRate
{
    int rate = [self.nonQualified12MonthRate intValue];
    
    if (rate <= 0)
    {
        rate = [self.nonQualified6MonthRate intValue];
    }
    
    if (rate <= 0)
    {
        rate = [self.nonQualified3MonthRate intValue];
    }
    
    if (rate <= 0)
    {
        rate = [self.nonQualified1MonthRate intValue];
    }
    
    return rate;    
}

@end
