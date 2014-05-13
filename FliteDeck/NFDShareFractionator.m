//
//  NFDShareFractionator.m
//  FliteDeck
//
//  Created by Ryan Smith on 3/27/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import "NFDShareFractionator.h"

@implementation NFDShareFractionator

+ (NSString *)fractionStringForShareHours:(int)hours
{
    if (hours < 800.0)
    {
        if (hours == 0)
        {
            return @"0";
        }
        float percentageShare = hours/800.0;
        
        int denoms[6];
        denoms[0] = 32;
        denoms[1] = 16;
        denoms[2] = 8;
        denoms[3] = 4;
        denoms[4] = 2;
        denoms[5] = 1;
        
        NSArray *ordinals = [NSArray arrayWithObjects:@"nd", @"th", @"th", @"th", @"", @"st", nil]; 
        int nom = 0;
        int denom = 0;
        NSString *ordinal = @"";
        for (int i=0; i<sizeof(denoms); i++)
        {
            if ((percentageShare*denoms[i]-floorf(percentageShare*denoms[i])) > 0)
            {
                if (i > 0)
                {
                    denom = denoms[i-1];
                    nom = percentageShare*denom;
                    ordinal = [ordinals objectAtIndex:i-1];
                    break;
                }
            }
        }
        
        return [NSString stringWithFormat:@"%i/%i%@", nom, denom, ordinal];
    }
    else
    {
        return @"Whole";
    }
}

@end
