//
//  NFDFlightProposalCardProductView.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/14/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightProposalDetailViewController.h"
#import "NFDFlightProposalManager.h"
#import "NFDProposal.h"

@interface NFDFlightProposalCardProductView : UIView <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NFDProposalParameterUpdater, NFDProposalResultUpdater, NFDFlightProposalDetailViewControllerOrientationDelegate>{

    UIPopoverController *popover;
    NSArray *cardHoursArray;
    NSArray *numberOfCardsArray;
    
    NSArray *fuelMonthRates;
    NSArray *fuelMonthRatesDisplayNames;

    BOOL isCrossCountryEnabled;
    NSNumber *crossCountryPurchasePrice;
    
    BOOL isPercentageIncreaseEnabled;
    NSNumber *nextYearPercentage;
    
    NSMutableArray *incentivesArray;
}

@property (strong, nonatomic) NFDFlightProposalDetailViewController *detailViewController;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) NSMutableArray *cardHoursArray;
@property (strong, nonatomic) NSArray *numberOfCardsArray;
@property (strong, nonatomic) NSArray *aircraftArray;
@property (strong, nonatomic) NSArray *fuelPeriodsArray;

@property (strong, nonatomic) IBOutlet UILabel *proposalParametersAnnualCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalParametersAverageHourlyCost;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostRateFuelVariableLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostAnnualFuelVariableLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostRateFuelFETLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostAnnualFuelFETLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalCardPurchasePurchasePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalCardPurchaseFETLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalCardTermLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalCardTermValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalAircraftGroupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *incentivesLabel;

@property (strong, nonatomic) IBOutlet UIView *cardResultsView;

@property (strong, nonatomic) IBOutlet UIButton *aircraftButton;
@property (strong, nonatomic) IBOutlet UIButton *cardTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *numberOfCardsButton;
@property (strong, nonatomic) IBOutlet UIButton *fuelMonthsButton;
@property (strong, nonatomic) IBOutlet UIImageView *cardTypeButtonChevron;
@property (weak, nonatomic) IBOutlet UIButton *incentivesButton;
@property (weak, nonatomic) IBOutlet UIImageView *incentivesDropDownArrow;
@property (weak, nonatomic) IBOutlet UIView *buttonsBackgroundView;

@property (strong, nonatomic) UIView *popoverOriginator;

@property (weak, nonatomic) IBOutlet UILabel *nextYearPercentageIncreaseStaticLabel;
@property (weak, nonatomic) IBOutlet UISwitch *nextYearSwitch;
@property (weak, nonatomic) IBOutlet UILabel *nextYearPercentageLabel;

- (void)interfaceDidChangeOrientation;

- (IBAction)displayInventoryModalView:(id)sender;
- (IBAction)nextYearSwitchChanged:(id)sender;

- (void)configureView;
- (void)configureParameterControls;
- (BOOL)isCrossCountryCardSelected;
- (void)updateProposalParameterData;
- (void)updateProposalResultData;
- (NFDProposal *)retrieveProposalForThisView;
- (void)dismissPopover;

@end
