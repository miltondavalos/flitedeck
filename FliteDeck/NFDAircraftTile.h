//
//  NFDAircraftTile.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDAircraftSelector.h"
#import "AircraftTypeGroup+Custom.h"
#import "NFDAircraftType.h"
#import "NFDAircraftWarningMessageViewController.h"

#define AIRCRAFT_IMAGE_HEIGHT 175
#define AIRCRAFT_IMAGE_WIDTH 215

@class NFDAircraftSelector;

@interface NFDAircraftTile : UIView {
    UIButton *warningsButton;
}

@property (nonatomic,strong)  NFDAircraftTypeGroup *aircraft;
@property (nonatomic,strong)  NFDAircraftType *aircraftType;
@property (nonatomic,strong)  NSNumber *position;
@property (nonatomic,strong)  UIImageView *checked;

@property (nonatomic,strong)  UIButton *runwayWarningButton;
@property (nonatomic,strong)  UIButton *paxWarningButton;
@property (nonatomic,strong)  UIButton *fuelStopButton;
@property (nonatomic,strong)  UIButton *acNotAvailableButton;
@property (nonatomic,strong)  NSString *runwayWarning;
@property (nonatomic,strong)  NSString *paxWarning;
@property (nonatomic,strong)  NSString *fuelStopWarning;
@property (nonatomic,strong)  NSString *acNotAvailableWarning;
@property (nonatomic,strong)  NSArray *warningsArray;

@property (nonatomic,strong) NFDAircraftWarningMessageViewController *warningsContent;
@property (nonatomic,strong) UIPopoverController *popover;

@property (nonatomic,strong)  UIImageView *hilite;
@property (nonatomic,strong)  UIImageView *background;
@property (nonatomic,strong)  UILabel *label;

@property (nonatomic,strong)  NFDAircraftSelector *belongs;
@property BOOL selected;

//-(void) setUpGestures: (NSNotification*) notification;
-(void)setData:(NFDAircraftTypeGroup *)ac;
-(void)setup;
-(void)toggleCheck: (BOOL) canSelectMore;
-(void)toggleWarnings;
-(void)toggle:(NSNotification *)notification;
-(void)enableWarningButtons;
-(void)disableWarningButtons;
-(void)hideWarningButtons;
-(void)showWarnings:(id)sender;
-(void)showWarningsForOrientationChange;
-(void)showCheckmark;

@end

