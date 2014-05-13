//
//  NFDProposalProduct.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDProposalProduct.h"

@implementation NFDProposalProduct
@synthesize ShowOperationalHours;
@synthesize SelectedAircraft;
@synthesize MonthsFuel;
@synthesize Qualified;
@synthesize AnnualHours;
@synthesize AircraftInventory;
@synthesize ACPreowned;
@synthesize FuelPeriod;
@synthesize PrepayEstimate;

-(void) setData: (NSDictionary*) dictionary{
    self.ShowOperationalHours =  [dictionary objectForKey:@"ShowOperationalHours"];
    self.SelectedAircraft = [dictionary objectForKey:@"SelectedAircraft"];
    self.MonthsFuel = [dictionary objectForKey:@"MonthsFuel"];
    self.Qualified = [dictionary objectForKey:@"Qualified"];
    self.AnnualHours = [dictionary objectForKey:@"AnnualHours"];
    self.AircraftInventory = [dictionary objectForKey:@"AircraftInventory"];
    self.ACPreowned = [dictionary objectForKey:@"ACPreowned"];
    self.FuelPeriod = [dictionary objectForKey:@"FuelPeriod"];
    self.PrepayEstimate = [dictionary objectForKey:@"PrepayEstimate"];
}


@end
