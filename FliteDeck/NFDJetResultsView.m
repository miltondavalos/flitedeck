//
//  NFDJetResultsView.m
//  FliteDeck
//
//  Created by Mohit Jain on 3/1/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDJetResultsView.h"
#import "Leg.h"

@implementation NFDJetResultsView

@synthesize labelAircraftName;
@synthesize labelBlockTimeOut;
@synthesize labelBlockTimeReturn;
@synthesize labelBlockTimeTotal;
@synthesize labelHourlyHeader;
@synthesize labelHourlyOut;
@synthesize labelHourlyReturn;
@synthesize labelHourlyTotal;
@synthesize labelFuelHeader;
@synthesize labelFuelOut;
@synthesize labelFuelReturn;
@synthesize labelFuelTotal;
@synthesize labelTotalOut;
@synthesize labelTotalReturn;
@synthesize labelTotalTotal;
@synthesize fuelStopMessage;
@synthesize labelBlockHeader;
@synthesize aircraftImage;
@synthesize returnHeader;
@synthesize californiaOutFee;
@synthesize californiaReturnFee;
@synthesize californiaTotalFee;
@synthesize container;
@synthesize californiaFeeHeader;
@synthesize labelTotalHeader;
@synthesize showMoney =_showMoney;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *topLevelObjs = nil;
        topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NFDJetResultsView" owner:self options:nil];
        [self addSubview: [topLevelObjs objectAtIndex:0]];
    }
    return self;
}

//- (void)viewDidLoad
//{
//    //[super viewDidLoad];
//    
//    NSArray *topLevelObjs = nil;
//    topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NJetResultsView" owner:self options:nil];
//    [self addSubview: [topLevelObjs objectAtIndex:0]];
//}

- (void)setShowMoney:(BOOL)showMoney 
{
    _showMoney = showMoney;

    [labelHourlyHeader setHidden:!_showMoney];
    [labelHourlyOut setHidden:!_showMoney];
    [labelHourlyReturn setHidden:!_showMoney];
    [labelHourlyTotal setHidden:!_showMoney];

    [labelFuelHeader setHidden:!_showMoney];
    [labelFuelOut setHidden:!_showMoney];
    [labelFuelReturn setHidden:!_showMoney];
    [labelFuelTotal setHidden:!_showMoney];

    if (![californiaFeeHeader isHidden] &&
        !_showMoney)
    {
        [californiaFeeHeader setHidden:!_showMoney];
        [californiaOutFee setHidden:!_showMoney];
        [californiaReturnFee setHidden:!_showMoney];
        [californiaTotalFee setHidden:!_showMoney];
    }

    [labelTotalHeader setHidden:!_showMoney];
    [labelTotalOut setHidden:!_showMoney];
    [labelTotalReturn setHidden:!_showMoney];
    [labelTotalTotal setHidden:!_showMoney];
    
    CGRect blockHeaderFrame = labelBlockHeader.frame;
    CGRect blockOutFrame = labelBlockTimeOut.frame;
    CGRect blockReturnFrame = labelBlockTimeReturn.frame;
    CGRect blockTotalFrame = labelBlockTimeTotal.frame;
    
    if (_showMoney)
    {
        [labelBlockHeader setFrame:CGRectMake(80, blockHeaderFrame.origin.y, blockHeaderFrame.size.width, blockHeaderFrame.size.height)];
        [labelBlockTimeOut setFrame:CGRectMake(80, blockOutFrame.origin.y, blockOutFrame.size.width, blockOutFrame.size.height)];
        [labelBlockTimeReturn setFrame:CGRectMake(80, blockReturnFrame.origin.y, blockReturnFrame.size.width, blockReturnFrame.size.height)];
        [labelBlockTimeTotal setFrame:CGRectMake(80, blockTotalFrame.origin.y, blockTotalFrame.size.width, blockTotalFrame.size.height)];
        
        [fuelStopMessage setTextAlignment:NSTextAlignmentLeft];
    }
    else
    {
        [labelBlockHeader setFrame:CGRectMake(190, blockHeaderFrame.origin.y, blockHeaderFrame.size.width, blockHeaderFrame.size.height)];
        [labelBlockTimeOut setFrame:CGRectMake(190, blockOutFrame.origin.y, blockOutFrame.size.width, blockOutFrame.size.height)];
        [labelBlockTimeReturn setFrame:CGRectMake(190, blockReturnFrame.origin.y, blockReturnFrame.size.width, blockReturnFrame.size.height)];
        [labelBlockTimeTotal setFrame:CGRectMake(190, blockTotalFrame.origin.y, blockTotalFrame.size.width, blockTotalFrame.size.height)];
        
        [fuelStopMessage setTextAlignment:NSTextAlignmentCenter];
    }
}

- (void)setData : (AircraftTypeResults*) results {
    
    aircraftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_default.png",results.aircraft.typeName]];
    
    [aircraftImage setAlpha:1.0];
    
    labelAircraftName.text = results.name;

    float blockTimeOut = 0.0;
    float hourlyCostOut = 0.0;
    float fuelCostOut = 0.0;
    float californiaFeesOut = 0.0;
    float totalCostOut = 0.0;
    bool requiresFuelStop = NO;
    
    for (Leg *leg in results.outLegs) {
        blockTimeOut = blockTimeOut + leg.blockTime;
        hourlyCostOut = hourlyCostOut + leg.hourlyCost;
        fuelCostOut = fuelCostOut + leg.fuelCost;
        californiaFeesOut = californiaFeesOut + leg.californiaFee;
        totalCostOut = totalCostOut + leg.totalCost;
        
        if (leg.fuelStops > 0) {
            requiresFuelStop = YES;
        }
    }
    
    NSString *blockTimeFormat = @"%.1f";
    NSString *moneyFormat = @"$%.0f";
    
    labelBlockTimeOut.text = [NSString stringWithFormat:blockTimeFormat, blockTimeOut];
    labelHourlyOut.text = [NSString stringWithFormat:moneyFormat, hourlyCostOut];
    labelFuelOut.text = [NSString stringWithFormat:moneyFormat, fuelCostOut];
    californiaOutFee.text = [NSString stringWithFormat:moneyFormat, californiaFeesOut];
    labelTotalOut.text = [NSString stringWithFormat:moneyFormat, totalCostOut];
    
    float blockTimeRet = 0.0;
    float hourlyCostRet = 0.0;
    float fuelCostRet = 0.0;
    float californiaFeesRet = 0.0;
    float totalCostRet = 0.0;
    
    for (Leg *leg in results.retLegs)
    {
        blockTimeRet = blockTimeRet + leg.blockTime;
        hourlyCostRet = hourlyCostRet + leg.hourlyCost;
        fuelCostRet = fuelCostRet + leg.fuelCost;
        californiaFeesRet = californiaFeesRet + leg.californiaFee;
        totalCostRet = totalCostRet + leg.totalCost;
        
        if (leg.fuelStops > 0) {
            requiresFuelStop = YES;
        }
    }
    
    CGRect position = container.frame;
    int yPosition = 0;
    
    if (requiresFuelStop == NO)
    {
        yPosition = 17;
        
    }
    
    position.origin.y = yPosition;
    self.container.frame = position;
    
    // Checking if trip is Roundtrip
    if (results.retLegs.count > 0)
    {
        labelBlockTimeReturn.text = [NSString stringWithFormat:blockTimeFormat, blockTimeRet];
        labelHourlyReturn.text = [NSString stringWithFormat:moneyFormat, hourlyCostRet];
        labelFuelReturn.text = [NSString stringWithFormat:moneyFormat, fuelCostRet];
        californiaReturnFee.text = [NSString stringWithFormat:moneyFormat, californiaFeesRet];
        labelTotalReturn.text = [NSString stringWithFormat:moneyFormat, totalCostRet];
        returnHeader.text = @"Return";
    }
    else
    {
        labelBlockTimeReturn.text = @"";
        labelHourlyReturn.text = @"";
        labelFuelReturn.text = @"";
        californiaReturnFee.text = @"";
        labelTotalReturn.text = @"";
        returnHeader.text = @"";
    }

    float totalBlockTime, totalHourly = 0.0f, totalFuel = 0.0f, totalCaliforniaFee = 0.0f, totalTotal = 0.0f;
    totalBlockTime = blockTimeOut + blockTimeRet;
    
    if (totalBlockTime > 0.0f)
    {
        totalHourly = hourlyCostOut + hourlyCostRet;
        totalFuel = fuelCostOut + fuelCostRet;
        totalCaliforniaFee = californiaFeesOut + californiaFeesRet;
        totalTotal = totalCostOut + totalCostRet;
    }
    
    labelBlockTimeTotal.text = [NSString stringWithFormat:blockTimeFormat, totalBlockTime];
    labelHourlyTotal.text = [NSString stringWithFormat:moneyFormat, totalHourly];
    labelFuelTotal.text = [NSString stringWithFormat:moneyFormat, totalFuel];
    californiaTotalFee.text = [NSString stringWithFormat:moneyFormat, totalCaliforniaFee];
    labelTotalTotal.text = [NSString stringWithFormat:moneyFormat, totalTotal];
    
    if (requiresFuelStop)
    {
        fuelStopMessage.hidden = NO;
    }
    else {
        fuelStopMessage.hidden = YES;
    }

    // hide the california fees column if not applicable
    int xPositionForTotalsColumn = 380;
    BOOL hidden = NO;
    
    if (californiaFeesOut + californiaFeesRet <= 0.0f)
    {
        hidden = YES;
        xPositionForTotalsColumn = 380-75;
    }
    
    [labelTotalHeader setFrame:CGRectMake(xPositionForTotalsColumn, labelTotalHeader.frame.origin.y, 70, 20)];
    [labelTotalOut setFrame:CGRectMake(xPositionForTotalsColumn, labelTotalOut.frame.origin.y, 70, 20)];
    [labelTotalReturn setFrame:CGRectMake(xPositionForTotalsColumn, labelTotalReturn.frame.origin.y, 70, 20)];
    [labelTotalTotal setFrame:CGRectMake(xPositionForTotalsColumn, labelTotalTotal.frame.origin.y, 70, 20)];
    [californiaFeeHeader setHidden:hidden];
    [californiaOutFee setHidden:hidden];
    [californiaReturnFee setHidden:hidden];
    [californiaTotalFee setHidden:hidden];
}

-(void) clear {
    [aircraftImage setAlpha:0.0];
    //TODO: NEED TO SET THE IMAGE VALUE;
}

@end
