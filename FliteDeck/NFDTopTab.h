//
//  NFDTopTab.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDAircraftSelector.h"

@interface NFDTopTab : UIView

@property (nonatomic,strong) IBOutlet UIButton *aircraftTypesButton;
@property (nonatomic,strong) IBOutlet UIButton *flightButton;
@property (nonatomic,strong) UIView *aircraftView;
@property (nonatomic,strong) UIView *flightView;
@property (nonatomic,strong) NFDAircraftSelector *aircraftSelector;
@property BOOL extended;

-(IBAction)clickedFlight:(id) sender ;
-(IBAction)clickedAircraft:(id) sender ;
-(void) setupGestures;
@end
