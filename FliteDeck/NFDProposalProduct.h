//
//  NFDProposalProduct.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDAircraftInventory.h"

@interface NFDProposalProduct : NSObject
@property BOOL ShowOperationalHours;
@property (nonatomic,weak) NSString *SelectedAircraft;
@property (nonatomic,weak) NSNumber *MonthsFuel;
@property BOOL Qualified;
@property (nonatomic,weak) NSString *AnnualHours;
@property (nonatomic,weak) NFDAircraftInventory *AircraftInventory;
@property BOOL ACPreowned;
@property (nonatomic,weak) NSString *FuelPeriod;
@property (nonatomic,weak) NSString *PrepayEstimate;
-(void) setData: (NSDictionary*) dictionary;
@end
