//
//  NFDFlightProposalPhenonTransitionProductView.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/14/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightProposalDetailViewController.h"
#import "NFDFlightProposalManager.h"
#import "NFDProposal.h"

@interface NFDFlightProposalPhenomTransitionProductView : UIView <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NFDProposalParameterUpdater, NFDProposalResultUpdater, NFDFlightProposalDetailViewControllerOrientationDelegate>

@property (strong, nonatomic) NFDFlightProposalDetailViewController *detailViewController;
@property (strong, nonatomic) UIPopoverController *popover;

@property (strong, nonatomic) NSArray *annualHoursArray;
@property (strong, nonatomic) NSArray *fuelChoicesArray;

@property (nonatomic, strong) NSArray *leasePrepayOptions;
@property (nonatomic, strong) NSArray *purchasePrepayOptions;

@property (weak, nonatomic) IBOutlet UITableView *annualHoursTableView;
@property (weak, nonatomic) IBOutlet UITableView *fuelMonthsTableView;
@property (weak, nonatomic) IBOutlet UITableView *fetQualifiedTableView;

@property (weak, nonatomic) IBOutlet UIView *proposalResultsView;
@property (weak, nonatomic) IBOutlet UIView *proposalResultsLeaseSideView;
@property (weak, nonatomic) IBOutlet UIView *proposalResultsPurchaseSideView;

@property (strong, nonatomic) IBOutlet UIButton *leaseHoursButton;
@property (strong, nonatomic) IBOutlet UIButton *purchaseHoursButton;
@property (strong, nonatomic) IBOutlet UIButton *leaseFuelMonthsButton;
@property (strong, nonatomic) IBOutlet UIButton *purchaseFuelMonthsButton;
@property (strong, nonatomic) IBOutlet UIButton *leasePrepayButton;
@property (strong, nonatomic) IBOutlet UIButton *purchasePrepayButton;

@property (strong, nonatomic) IBOutlet UIImageView *fuelLock;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseTailNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseAvailabilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseTermLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseMonthlyLeaseFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseMonthlyLeaseFeeAnnualLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseFETRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseFETAnnualLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyLeaseFETStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *recurringFETStaticLabel;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseTailNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseAvailabilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseTermLabel;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsAcquisitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsDepositLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsProgressPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsCashClosingLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsFETLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalPurchaseFETStaticLabel;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseRateMMFLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseRateOHFLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseRateFuelVariableLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseRateFETLabel;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseAnnualMMFLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseAnnualOHFLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseAnnualFuelVariableLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseAnnualFETLabel;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseAnnualOpCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsLeaseHourlyOpCostLabel;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseRateMMFLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseRateOHFLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseRateFuelVariableLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseRateFETLabel;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseAnnualMMFLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseAnnualOHFLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseAnnualFuelVariableLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseAnnualFETLabel;

@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseAnnualOpCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalResultsPurchaseHourlyOpCostLabel;

@property (strong, nonatomic) IBOutlet UILabel *prepayEstimateLabel;
@property (strong, nonatomic) IBOutlet UILabel *leasePrepayEstimateTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *leasePrepayEstimateValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *purhcasePrepayEstimateTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *purchasePrepayEstimateValueLabel;


@property (strong, nonatomic) UIView *popoverOriginator;

- (void)interfaceDidChangeOrientation;

- (void)configureView;
- (void)updateProposalParameterData;
- (void)updateProposalResultData;
- (void)dismissPopover;

@end
