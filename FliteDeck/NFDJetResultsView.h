//
//  NFDJetResultsView.h
//  FliteDeck
//
//  Created by Mohit Jain on 3/1/12.
//  Copyright (c) 2012 Compuware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AircraftTypeResults.h"

@interface NFDJetResultsView : UIView

//@property (weak, nonatomic) IBOutlet UIButton *aircraftInfoButton;
@property (weak, nonatomic) IBOutlet UIImageView *aircraftImage;

@property (weak, nonatomic) IBOutlet UILabel *labelAircraftName;
@property (weak, nonatomic) IBOutlet UILabel *returnHeader;
@property (weak, nonatomic) IBOutlet UILabel *fuelStopMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelBlockHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelBlockTimeOut;
@property (weak, nonatomic) IBOutlet UILabel *labelBlockTimeReturn;
@property (weak, nonatomic) IBOutlet UILabel *labelBlockTimeTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelHourlyHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelHourlyOut;
@property (weak, nonatomic) IBOutlet UILabel *labelHourlyReturn;
@property (weak, nonatomic) IBOutlet UILabel *labelHourlyTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelFuelHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelFuelOut;
@property (weak, nonatomic) IBOutlet UILabel *labelFuelReturn;
@property (weak, nonatomic) IBOutlet UILabel *labelFuelTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalOut;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalReturn;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalTotal;
@property (weak, nonatomic) IBOutlet UILabel *californiaFeeHeader;
@property (weak, nonatomic) IBOutlet UILabel *californiaOutFee;
@property (weak, nonatomic) IBOutlet UILabel *californiaReturnFee;
@property (weak, nonatomic) IBOutlet UILabel *californiaTotalFee;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic) BOOL showMoney;

-(void) setData : (AircraftTypeResults*) results;
-(void) clear;

@end
