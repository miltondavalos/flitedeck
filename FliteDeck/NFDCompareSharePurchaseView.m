//
//  NFDCompareSharePurchaseView.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDCompareSharePurchaseView.h"
#import "AircraftInventory.h"

@implementation NFDCompareSharePurchaseView
@synthesize title;
@synthesize subtitle;
@synthesize type;
@synthesize delivery;
@synthesize tailNumber;
@synthesize year;
@synthesize serial;
@synthesize available;
@synthesize value;
@synthesize contracts;
@synthesize mmfRate;
@synthesize mmfAnnual;
@synthesize ohfRate;
@synthesize ohfAnnual;
@synthesize fetRate;
@synthesize fetAnnual;
@synthesize fuelRate;
@synthesize fuelAnnual;
@synthesize prepaySavings;
@synthesize acquisitionCost;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadNib:@"NFDCompareSharePurchaseView"];
        [self addVerticalLineWithWidth:1 color:[UIColor whiteColor]  atX:0];
        [self addVerticalLineWithWidth:1 color:[UIColor whiteColor]  atX:frame.size.width];
    }
    return self;
}

-(void) setData : (NFDProposal*) proposal{
    
    NFDProposalDictionaryAdapter *adapter = [[NFDProposalDictionaryAdapter alloc] init];
    [adapter setData:proposal];
    
    /*NSMutableDictionary *product = [proposal productParameters];
    NSMutableDictionary *results = [proposal calculatedResults];
    AircraftInventory *aircraft = [product objectForKey:@"AircraftInventory"];
    
    title.text = proposal.title;
    subtitle.text = proposal.subTitle;
    type.text = [NSString stringWithFormat:@"%@",aircraft.legal_name];
    delivery.text = [NSString stringWithFormat:@"%@",aircraft.anticipated_delivery_date];
    tailNumber.text = [NSString stringWithFormat:@"%@",aircraft.tail];
    year.text = [NSString stringWithFormat:@"%d",aircraft.year];
    serial.text = [NSString stringWithFormat:@"%d",aircraft.serial];
    float availablePercent = [aircraft.share_immediately_available floatValue] * 100;
    available.text = [NSString stringWithFormat:@"%d%", (int) availablePercent];
    NSNumber *valueN = [NSNumber numberWithInt:[aircraft.sales_value intValue]];
    value.text =  [NSString stringWithFormat:@"$%@",[valueN numberWithCommas:0]];
    contracts.text = [NSString stringWithFormat:@"%@",aircraft.contracts_until_date];
    mmfRate.text = [NSString stringWithFormat:@"%@",[(NSNumber*)[results objectForKey:@"MonthlyManagementFeeRate"] numberWithCommas:0]];
    mmfAnnual.text = [NSString stringWithFormat:@"%@",[(NSNumber*)[results objectForKey:@"MonthlyManagementFeeAnnual"] numberWithCommas:0]];
    
    ohfRate.text = [NSString stringWithFormat:@"%@",[(NSNumber*)[results objectForKey:@"OccupiedHourlyFeeRate"] numberWithCommas:0]];
    ohfAnnual.text = [NSString stringWithFormat:@"%@",[(NSNumber*)[results objectForKey:@"OccupiedHourlyFeeAnnual"] numberWithCommas:0]];*/
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    
    
    title.text = adapter.title;
    subtitle.text = adapter.subTitle;
    AircraftInventory *aircraft = adapter.product.AircraftInventory;
    NFDProposalResults *results = adapter.results;
    NFDProposalProduct *product = adapter.product;
    
    type.text = [NSString stringWithFormat:@"%@",adapter.product.AircraftInventory.legal_name];
    delivery.text = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:aircraft.anticipated_delivery_date]];
    tailNumber.text = [NSString stringWithFormat:@"%@",aircraft.tail];
    year.text = [NSString stringWithFormat:@"%@",aircraft.year];
    serial.text = [NSString stringWithFormat:@"%@",aircraft.serial];
    
    float availablePercent = [aircraft.share_immediately_available floatValue] * 100;
    available.text = [NSString stringWithFormat:@"%.0f%%", availablePercent];
    
    NSNumber *valueN = [NSNumber numberWithInt:[aircraft.sales_value intValue]];
    value.text =  [NSString stringWithFormat:@"$%@",[valueN numberWithCommas:0]];
    contracts.text = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:aircraft.contracts_until_date]];
    mmfRate.text = [NSString stringWithFormat:@"%@",[results.MonthlyManagementFeeRate numberWithCommas:0]];
    mmfAnnual.text = [NSString stringWithFormat:@"%@",[results.MonthlyManagementFeeAnnual numberWithCommas:0]];
    
    ohfRate.text = [NSString stringWithFormat:@"%@",[results.OccupiedHourlyFeeRate numberWithCommas:0]];
    ohfAnnual.text = [NSString stringWithFormat:@"%@",[results.OccupiedHourlyFeeAnnual numberWithCommas:0]];
    
    fetRate.text = [NSString stringWithFormat:@"%@",[results.FederalExciseTaxRate numberWithCommas:0]];
    fetAnnual.text = [NSString stringWithFormat:@"%@",[results.FederalExciseTaxAnnual numberWithCommas:0]];
    
    fuelRate.text = [NSString stringWithFormat:@"%@",[results.FuelVariableRate numberWithCommas:0]];
    fuelAnnual.text = [NSString stringWithFormat:@"%@",[results.FuelVariableAnnual numberWithCommas:0]];
    
    NSNumber *prepayN = [NSNumber numberWithInt:[product.PrepayEstimate intValue]];
    prepaySavings.text = [NSString stringWithFormat:@"%@",[prepayN numberWithCommas:0]];
    
    //acquisitionCost.text= [NSString stringWithFormat:@"%@",[product.a numberWithCommas:0]]; 
}

@end
