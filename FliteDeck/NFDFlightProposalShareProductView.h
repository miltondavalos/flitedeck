//
//  NFDFlightProposalShareProductView.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/12/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightProposalDetailViewController.h"
#import "NFDFlightProposalManager.h"
#import "NFDProposal.h"

@interface NFDFlightProposalShareProductView : UIView <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NFDProposalParameterUpdater, NFDProposalResultUpdater, NFDFlightProposalDetailViewControllerOrientationDelegate>{
    
    UIPopoverController *popover;
    NSArray *aircraftArray;
    NSArray *annualHoursArray;
    NSArray *prepayEstimateArray;
    NSArray *leaseTermsArray;
    
    NSArray *fuelMonthRatesForQualified;
    NSArray *fuelMonthRatesForNonQualified;
    NSArray *fuelMonthRatesForQualifiedDisplayNames;
    NSArray *fuelMonthRatesForNonQualifiedDisplayNames;
    
    BOOL isPercentageIncreaseEnabled;
}

@property (strong, nonatomic) NFDFlightProposalDetailViewController *detailViewController;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) NSArray *aircraftArray;
@property (strong, nonatomic) NSMutableArray *annualHoursArray;
@property (strong, nonatomic) NSArray *prepayEstimateArray;
@property (strong, nonatomic) NSArray *leaseTermsArray;
@property (strong, nonatomic) NSArray *fuelPeriodsArray;

@property (strong, nonatomic) NSArray *fuelRates;
@property (strong, nonatomic) NSArray *fuelRateNames;

@property (strong, nonatomic) IBOutlet UIView *proposalAircraftDetailsView;
@property (strong, nonatomic) IBOutlet UILabel *proposalAircraftDetailsTailNumber;
@property (strong, nonatomic) IBOutlet UILabel *proposalAircraftDetailsLegalName;
@property (strong, nonatomic) IBOutlet UILabel *proposalAircraftDetailsYear;
@property (strong, nonatomic) IBOutlet UILabel *proposalAircraftDetailsAvailable;
@property (strong, nonatomic) IBOutlet UILabel *proposalAircraftDetailsContractsUntilDate;
@property (strong, nonatomic) IBOutlet UILabel *proposalAircraftDetailsSalesValue;

@property (strong, nonatomic) IBOutlet UIView  *proposalOperatingCostView;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostRateMMFLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostAnnualMMFLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostRateOHFLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostAnnualOHFLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostAnnualFETLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostRateFuelVariableLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostAnnualFuelVariableLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostFETLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostRateFETLabel;

@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostPrepaymentTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostPrepaymentSavings;

@property (strong, nonatomic) IBOutlet UIView *proposalFinanceFiguresView;
@property (strong, nonatomic) IBOutlet UILabel *proposalFinanceFiguresDownPaymentLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalFinanceFiguresFinancedAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalFinanceFiguresMonthlyPILabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalFinanceFiguresBalloonPaymentLabel;

@property (strong, nonatomic) IBOutlet UIView *proposalLeaseFiguresView;
@property (strong, nonatomic) IBOutlet UILabel *proposalLeaseFiguresMonthlyFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalLeaseFiguresMonthlyFeeFETLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalLeaseFiguresMonthlyFeeFETRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalLeaseFiguresAnnualLeaseFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalLeaseFiguresAnnualLeaseFETLabel;

@property (strong, nonatomic) IBOutlet UIView *proposalPurchaseFiguresView;
@property (strong, nonatomic) IBOutlet UILabel *proposalPurchaseFiguresAcquisitionLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalPurchaseFiguresAcquisitionFETLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalPurchaseFiguresAcquisitionFETRateLabel;

@property (strong, nonatomic) IBOutlet UIView *proposalPrepaymentEstimateView;

@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostAnnualCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *proposalOperatingCostAverageHourlyCostLabel;
@property (strong, nonatomic) IBOutlet UIView *purchaseLabelsView;
@property (strong, nonatomic) IBOutlet UIView *leaseLabelsView;
@property (strong, nonatomic) IBOutlet UIView *financeLabelsView;
@property (strong, nonatomic) IBOutlet UIView *resultsView;
@property (strong, nonatomic) IBOutlet UIButton *aircraftButton;
@property (strong, nonatomic) IBOutlet UIButton *hoursButton;
@property (strong, nonatomic) IBOutlet UIButton *fuelMonthsButton;
@property (strong, nonatomic) IBOutlet UIButton *prepayButton;
@property (strong, nonatomic) IBOutlet UIButton *leaseTermButton;
@property (strong, nonatomic) IBOutlet UILabel *leaseTermLabel;
@property (strong, nonatomic) IBOutlet UISwitch *qualifiedFETSwitch;
@property (strong, nonatomic) IBOutlet UILabel *qualifiedFETLabel;
@property (strong, nonatomic) IBOutlet UISwitch *nextYearSwitch;
@property (strong, nonatomic) IBOutlet UILabel *nextYearLabel;
@property (strong, nonatomic) IBOutlet UILabel *nextYearOHFPercentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *nextYearMMFPercentageLabel;
@property (strong, nonatomic) IBOutlet UIView *buttonBackingView;
@property (strong, nonatomic) IBOutlet UIImageView *leaseTermButtonChevronImageView;
@property (strong, nonatomic) IBOutlet UILabel *prepayEstimateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *prepayEstimateChevronImageView;
@property (strong, nonatomic) IBOutlet UILabel *prepayResultsLabel;

@property (strong, nonatomic) UIView *popoverOriginator;

- (void)displayInventoryModalView;
- (void)configureView;
- (void)configureParameterControls;
- (void)updateProposalParameterData;
- (void)updateProposalResultData;

- (void)interfaceDidChangeOrientation;
- (void)dismissPopover;

@end
