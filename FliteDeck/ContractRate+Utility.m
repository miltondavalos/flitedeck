//
//  ContractRate+Utility.m
//  FliteDeck
//
//  Created by Chad Long on 3/21/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "ContractRate+Utility.h"

@implementation NFDContractRate (Utility)

- (int)californiaFeesForDeparture:(NFDAirport*)departure arrival:(NFDAirport*)arrival
{
    static NSString *california = @"CA";
    int feeTotal = 0;
    
    feeTotal += [[departure state_cd] isEqualToString:california] ? [self.californiaFee intValue] : 0;
    feeTotal += [[arrival state_cd] isEqualToString:california] ? [self.californiaFee intValue] : 0;
    
    return feeTotal;
}

- (BOOL)isTaxable:(NSString*)product
{
    product = [product uppercaseString];
    
    if ([product isEqualToString:@"CARD"])
    {
        return true;
    }
    else if ([product isEqualToString:@"DEMO"])
    {
        return true;
    }
    
    return false;
}

- (NSNumber*)estimatedHourlyFeeForProduct:(NSString*)product
{
    product = [product uppercaseString];
    
    float hourlyFee = 0.0f;

    // get the occupied hourly fee for the given product
    if ([product isEqualToString:@"SHARE"])
    {
        if ([[NSDecimalNumber notANumber] isEqualToNumber:self.shareOccupiedHourlyFee])
            return [NSDecimalNumber notANumber];
        
        hourlyFee = [self.shareOccupiedHourlyFee floatValue];
    }
    else if ([product isEqualToString:@"LEASE"])
    {
        if ([[NSDecimalNumber notANumber] isEqualToNumber:self.leaseOccupiedHourlyFee] ||
            [self.leaseOccupiedHourlyFee floatValue] == 0.0f)
        {
            return [NSDecimalNumber notANumber];
        }
        
        hourlyFee = [self.leaseOccupiedHourlyFee floatValue];
    }
    else if ([product isEqualToString:@"CARD"])
    {
        if (![self.typeGroupName isEqualToString:@"Citation V Ultra"])
        {
            if ([[NSDecimalNumber notANumber] isEqualToNumber:self.cardPurchase25Hour] ||
                [self.cardPurchase25Hour floatValue] == 0.0f)
            {
                return [NSDecimalNumber notANumber];
            }
        }

        hourlyFee = roundf([self.cardPurchase25Hour floatValue] / 25);
    }
    else if ([product isEqualToString:@"DEMO"])
    {
        hourlyFee = [self.demoOccupiedHourlyFee floatValue];
    }
    
    return [NSNumber numberWithFloat:hourlyFee];
}

@end
