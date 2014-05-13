//
//  NFDFlightProposalPhenonTransitionProductView.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/14/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalPhenomTransitionProductView.h"
#import "NFDFlightProposalCalculatorService.h"
#import <QuartzCore/QuartzCore.h>

#define ANNUAL_HOURS_SELECTOR_TABLE_VIEW 1
#define FUEL_MONTHS_SELECTOR_TABLE_VIEW 2
#define FET_QUALIFIED_SELECTOR_TABLE_VIEW 3
#define FUEL_MONTHS_OPTIONS_TABLE_VIEW 4

#define PICKER_HEIGHT 216
#define PICKER_WIDTH 220
#define PICKER_X_OFFSET -12
#define PICKER_Y_OFFSET -12

#define LEASE_HOURS_BUTTON 11
#define PURCHASE_HOURS_BUTTON 12

#define LEASE_FUEL_BUTTON 21
#define PURCHASE_FUEL_BUTTON 22

#define LEASE_PREPAY_BUTTON 31
#define PURCHASE_PREPAY_BUTTON 32

#define LEASE_HOURS_PICKER_VIEW 11
#define PURCHASE_HOURS_PICKER_VIEW 12

#define LEASE_FUEL_TABLE_VIEW 21
#define PURCHASE_FUEL_TABLE_VIEW 22

#define LEASE_PREPAY_TABLE_VIEW 31
#define PURCHASE_PREPAY_TABLE_VIEW 32

@implementation NFDFlightProposalPhenomTransitionProductView

@synthesize detailViewController = _detailViewController;
@synthesize popover = _popover;

@synthesize annualHoursArray = _annualHoursArray;
@synthesize fuelChoicesArray = _fuelChoicesArray;
@synthesize leasePrepayOptions = _leasePrepayOptions;
@synthesize purchasePrepayOptions = _purchasePrepayOptions;

@synthesize annualHoursTableView = _annualHoursTableView;
@synthesize fuelMonthsTableView = _fuelMonthsTableView;
@synthesize fetQualifiedTableView = _fetQualifiedTableView;
@synthesize proposalResultsView = _proposalResultsView;
@synthesize proposalResultsLeaseSideView = _proposalResultsLeaseSideView;
@synthesize proposalResultsPurchaseSideView = _proposalResultsPurchaseSideView;

@synthesize leaseHoursButton = _proposalResultsLeaseHourAllotmentButton;
@synthesize purchaseHoursButton = _proposalResultsPurchaseHourAllotmentButton;
@synthesize leaseFuelMonthsButton = _leaseFuelMonthsButton;
@synthesize purchaseFuelMonthsButton = _purchaseFuelMonthsButton;
@synthesize leasePrepayButton = _leasePrepayButton;
@synthesize purchasePrepayButton = _purchasePrepayButton;

@synthesize fuelLock = _fuelLock;

@synthesize proposalResultsLeaseTailNumberLabel = _proposalResultsLeaseTailNumberLabel;
@synthesize proposalResultsLeaseAvailabilityLabel = _proposalResultsLeaseAvailabilityLabel;
@synthesize proposalResultsLeaseTermLabel = _proposalResultsLeaseTermLabel;
@synthesize proposalResultsLeaseMonthlyLeaseFeeLabel = _proposalResultsLeaseMonthlyLeaseFeeLabel;
@synthesize proposalResultsLeaseMonthlyLeaseFeeAnnualLabel = _proposalResultsLeaseMonthlyLeaseFeeAnnualLabel;
@synthesize proposalResultsLeaseFETRateLabel = _proposalResultsLeaseFETRateLabel;
@synthesize proposalResultsLeaseFETAnnualLabel = _proposalResultsLeaseFETAnnualLabel;
@synthesize monthlyLeaseFETStaticLabel = _monthlyLeaseFETStaticLabel;
@synthesize recurringFETStaticLabel = _recurringFETStaticLabel;
@synthesize proposalResultsPurchaseTailNumberLabel = _proposalResultsPurchaseTailNumberLabel;
@synthesize proposalResultsPurchaseAvailabilityLabel = _proposalResultsPurchaseAvailabilityLabel;
@synthesize proposalResultsPurchaseTermLabel = _proposalResultsPurchaseTermLabel;
@synthesize proposalResultsAcquisitionLabel = _proposalResultsAcquisitionLabel;
@synthesize proposalResultsDepositLabel = _proposalResultsDepositLabel;
@synthesize proposalResultsProgressPaymentLabel = _proposalResultsProgressPaymentLabel;
@synthesize proposalResultsCashClosingLabel = _proposalResultsCashClosingLabel;
@synthesize proposalResultsFETLabel = _proposalResultsFETLabel;
@synthesize proposalPurchaseFETStaticLabel = _proposalPurchaseFETLabel;
@synthesize proposalResultsLeaseRateMMFLabel = _proposalResultsLeaseRateMMFLabel;
@synthesize proposalResultsLeaseRateOHFLabel = _proposalResultsLeaseRateOHFLabel;
@synthesize proposalResultsLeaseRateFuelVariableLabel = _proposalResultsLeaseRateFuelVariableLabel;
@synthesize proposalResultsLeaseRateFETLabel = _proposalResultsLeaseRateFETLabel;
@synthesize proposalResultsLeaseAnnualMMFLabel = _proposalResultsLeaseAnnualMMFLabel;
@synthesize proposalResultsLeaseAnnualOHFLabel = _proposalResultsLeaseAnnualOHFLabel;
@synthesize proposalResultsLeaseAnnualFuelVariableLabel = _proposalResultsLeaseAnnualFuelVariableLabel;
@synthesize proposalResultsLeaseAnnualFETLabel = _proposalResultsLeaseAnnualFETLabel;
@synthesize proposalResultsLeaseAnnualOpCostLabel = _proposalResultsLeaseAnnualOpCostLabel;
@synthesize proposalResultsLeaseHourlyOpCostLabel = _proposalResultsLeaseHourlyOpCostLabel;
@synthesize proposalResultsPurchaseRateMMFLabel = _proposalResultsPurchaseRateMMFLabel;
@synthesize proposalResultsPurchaseRateOHFLabel = _proposalResultsPurchaseRateOHFLabel;
@synthesize proposalResultsPurchaseRateFuelVariableLabel = _proposalResultsPurchaseRateFuelVariableLabel;
@synthesize proposalResultsPurchaseRateFETLabel = _proposalResultsPurchaseRateFETLabel;
@synthesize proposalResultsPurchaseAnnualMMFLabel = _proposalResultsPurchaseAnnualMMFLabel;
@synthesize proposalResultsPurchaseAnnualOHFLabel = _proposalResultsPurchaseAnnualOHFLabel;
@synthesize proposalResultsPurchaseAnnualFuelVariableLabel = _proposalResultsPurchaseAnnualFuelVariableLabel;
@synthesize proposalResultsPurchaseAnnualFETLabel = _proposalResultsPurchaseAnnualFETLabel;
@synthesize proposalResultsPurchaseAnnualOpCostLabel = _proposalResultsPurchaseAnnualOpCostLabel;
@synthesize proposalResultsPurchaseHourlyOpCostLabel = _proposalResultsPurchaseHourlyOpCostLabel;
@synthesize prepayEstimateLabel = _prepayEstimateLabel;
@synthesize leasePrepayEstimateTypeLabel = _leasePrepayEstimateTypeLabel;
@synthesize leasePrepayEstimateValueLabel = _leasePrepayEstimateValueLabel;
@synthesize purhcasePrepayEstimateTypeLabel = _purhcasePrepayEstimateTypeLabel;
@synthesize purchasePrepayEstimateValueLabel = _purchasePrepayEstimateValueLabel;

@synthesize popoverOriginator = _popoverOriginator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)configureView
{
    [[self.proposalResultsLeaseSideView layer] setCornerRadius:12];
    [[self.proposalResultsPurchaseSideView layer] setCornerRadius:12];
    
    [[self.proposalResultsLeaseSideView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.proposalResultsLeaseSideView layer] setShadowOffset:CGSizeMake(0, 1)];
    [[self.proposalResultsLeaseSideView layer] setShadowOpacity:0.2];
    [[self.proposalResultsLeaseSideView layer] setShadowRadius:2];
 
    [[self.proposalResultsPurchaseSideView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.proposalResultsPurchaseSideView layer] setShadowOffset:CGSizeMake(0, 1)];
    [[self.proposalResultsPurchaseSideView layer] setShadowOpacity:0.2];
    [[self.proposalResultsPurchaseSideView layer] setShadowRadius:2];
    
    NFDProposal *proposal = [self retrieveProposalForThisView];
    
    NSNumber *qualified = [[proposal productParameters] objectForKey:@"Qualified"];

    self.annualHoursArray = [NFDFlightProposalCalculatorService annualHourAllotmentChoicesForGeneralProductType:kGeneralProductTypePhenomTransistion maxHoursAvailable:nil];
    
    [self.leaseHoursButton addTarget:self action:@selector(openPickerPopover:) forControlEvents:UIControlEventTouchUpInside];
    [self.purchaseHoursButton addTarget:self action:@selector(openPickerPopover:) forControlEvents:UIControlEventTouchUpInside];

    [self.leaseHoursButton setTag:LEASE_HOURS_BUTTON];
    [self.purchaseHoursButton setTag:PURCHASE_HOURS_BUTTON];
    
    self.fuelChoicesArray = [[NFDFlightProposalCalculatorService fuelPeriodChoicesForAircraftType:@"EMB-505S" isQualified:qualified] objectAtIndex:0];
    
    [self.leaseFuelMonthsButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    [self.purchaseFuelMonthsButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.leaseFuelMonthsButton setTag:LEASE_FUEL_BUTTON];
    [self.purchaseFuelMonthsButton setTag:PURCHASE_FUEL_BUTTON];
    
    self.leasePrepayOptions = [NFDFlightProposalCalculatorService prepayEstimateChoicesForProductCode:SHARE_LEASE_PRODUCT];
    self.purchasePrepayOptions = [NFDFlightProposalCalculatorService prepayEstimateChoicesForProductCode:SHARE_PURCHASE_PRODUCT];

    [self.leasePrepayButton setTag:LEASE_PREPAY_BUTTON];
    [self.purchasePrepayButton setTag:PURCHASE_PREPAY_BUTTON];
    
    [self.leasePrepayButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    [self.purchasePrepayButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    
    [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
}

#pragma mark - Manager, Proposal, Results Methods

- (NFDProposal *)retrieveProposalForThisView
{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    return [manager retrieveProposalAtIndex:self.tag];
}

- (void)updateProposalParameterData
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NFDProposal *purchaseProposal = proposal.relatedProposal;
    
    // currently, keep hours and fuel period synced for both parts of Phenom Trans
    NSString *annualHours = [[proposal productParameters] objectForKey:@"AnnualHoursChoice"];
    [[purchaseProposal productParameters] setObject:annualHours forKey:@"AnnualHoursChoice"];

    [self.leaseHoursButton setTitle:annualHours forState:UIControlStateNormal];
    [self.purchaseHoursButton setTitle:annualHours forState:UIControlStateNormal];
    
    NSString *fuelPeriod = [[proposal productParameters] objectForKey:@"FuelPeriod"];
    [[purchaseProposal productParameters] setObject:fuelPeriod forKey:@"FuelPeriod"];
    
    [self.leaseFuelMonthsButton setTitle:fuelPeriod forState:UIControlStateNormal];
    [self.purchaseFuelMonthsButton setTitle:fuelPeriod forState:UIControlStateNormal];
    
    NSString *leasePrepayEstimate = [[proposal productParameters] objectForKey:@"PrepayEstimate"];
    NSString *purchasePrepayEstimate = [[purchaseProposal productParameters] objectForKey:@"PrepayEstimate"];
    
    [self.leasePrepayEstimateTypeLabel setText:leasePrepayEstimate];
    [self.purhcasePrepayEstimateTypeLabel setText:purchasePrepayEstimate];
    
    [self.leasePrepayButton setTitle:leasePrepayEstimate forState:UIControlStateNormal];
    [self.purchasePrepayButton setTitle:purchasePrepayEstimate forState:UIControlStateNormal];
    
    if ([annualHours floatValue] > 25)
    {
        [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
        [self.fetQualifiedTableView setHidden:YES];
    }
    else 
    {
        [self.fetQualifiedTableView setHidden:NO];
    }
    
    NSNumber *qualified = [[proposal productParameters] objectForKey:@"Qualified"];
    [[purchaseProposal productParameters] setObject:qualified forKey:@"Qualified"];
    
    BOOL hasPrepaySelected = (![[[proposal productParameters] objectForKey:@"PrepayEstimate"] isEqualToString:@"None"]) || (![[[proposal.relatedProposal productParameters] objectForKey:@"PrepayEstimate"] isEqualToString:@"None"]);
    
    if (hasPrepaySelected)
    {
        [self.fuelLock setHidden:NO];
        [self.leasePrepayEstimateTypeLabel setHidden:NO];
        [self.leasePrepayEstimateValueLabel setHidden:NO];
        [self.purhcasePrepayEstimateTypeLabel setHidden:NO];
        [self.purchasePrepayEstimateValueLabel setHidden:NO];
        [self.prepayEstimateLabel setHidden:NO];
    }
    else 
    {
        [self.fuelLock setHidden:YES];
        [self.leasePrepayEstimateTypeLabel setHidden:YES];
        [self.leasePrepayEstimateValueLabel setHidden:YES];
        [self.purhcasePrepayEstimateTypeLabel setHidden:YES];
        [self.purchasePrepayEstimateValueLabel setHidden:YES];
        [self.prepayEstimateLabel setHidden:YES];
    }
}

- (void)updateProposalResultData
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NFDProposal *purchaseProposal = proposal.relatedProposal;
    NSDictionary *result = [proposal calculatedResults];
    
    if (result){
        
        //Create Number Formatter for Currency
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [numberFormatter setMaximumFractionDigits:0];
        
        NSNumber *phenomLeaseMonthlyLeaseFee = [proposal.calculatedResults objectForKey:@"MonthlyLeaseFeeRate"];
        NSNumber *phenomLeaseAnnualLeaseFee = [proposal.calculatedResults objectForKey:@"MonthlyLeaseFeeAnnual"];
        NSNumber *phenomLeaseOccupiedHourlyFee = [proposal.calculatedResults objectForKey:@"OccupiedHourlyFeeRate"];
        NSNumber *phenomLeaseOccupiedAnnualFee = [proposal.calculatedResults objectForKey:@"OccupiedHourlyFeeAnnual"];
        NSNumber *phenomLeaseMonthlyManagementFee = [proposal.calculatedResults objectForKey:@"MonthlyManagementFeeRate"];
        NSNumber *phenomLeaseMonthlyManagementFeeAnnual = [proposal.calculatedResults objectForKey:@"MonthlyManagementFeeAnnual"];
        NSNumber *phenomLeaseFuelVariableRate = [proposal.calculatedResults objectForKey:@"FuelVariableRate"];
        NSNumber *phenomLeaseFuelVariableAnnual = [proposal.calculatedResults objectForKey:@"FuelVariableAnnual"];
        NSNumber *phenomLeaseAnnualOperationalCost = [proposal.calculatedResults objectForKey:@"AnnualCost"];
        NSNumber *phenomLeaseOperationalHourlyCost = [proposal.calculatedResults objectForKey:@"AverageHourlyCost"];
        NSNumber *phenomLeasePrepaySavings = [proposal.calculatedResults objectForKey:@"PrepaymentSavings"];
        
        NSString *phenomLeaseMonthlyLeaseFeeString = [numberFormatter stringFromNumber:phenomLeaseMonthlyLeaseFee];
        NSString *phenomLeaseAnnualLeaseFeeString = [numberFormatter stringFromNumber:phenomLeaseAnnualLeaseFee];
        NSString *phenomLeaseOccupiedHourlyFeeString = [numberFormatter stringFromNumber:phenomLeaseOccupiedHourlyFee];
        NSString *phenomLeaseOccupiedAnnualFeeString = [numberFormatter stringFromNumber:phenomLeaseOccupiedAnnualFee];
        NSString *phenomLeaseMonthlyManagementFeeString = [numberFormatter stringFromNumber:phenomLeaseMonthlyManagementFee];
        NSString *phenomLeaseMonthlyManagementFeeAnnualString = [numberFormatter stringFromNumber:phenomLeaseMonthlyManagementFeeAnnual];
        NSString *phenomLeaseFuelVariableRateString = [numberFormatter stringFromNumber:phenomLeaseFuelVariableRate];
        NSString *phenomLeaseFuelVariableAnnualString = [numberFormatter stringFromNumber:phenomLeaseFuelVariableAnnual];
        NSString *phenomLeaseAnnualOperationalCostString = [numberFormatter stringFromNumber:phenomLeaseAnnualOperationalCost];
        NSString *phenomLeaseOperationalHourlyCostString = [numberFormatter stringFromNumber:phenomLeaseOperationalHourlyCost];
        NSString *phenomLeasePrepaySavingsString = [numberFormatter stringFromNumber:phenomLeasePrepaySavings];

        [self.proposalResultsLeaseAvailabilityLabel setText:@"Immediate"];
        [self.proposalResultsLeaseMonthlyLeaseFeeLabel setText:phenomLeaseMonthlyLeaseFeeString];
        [self.proposalResultsLeaseMonthlyLeaseFeeAnnualLabel setText:phenomLeaseAnnualLeaseFeeString];
        [self.proposalResultsLeaseRateMMFLabel setText:phenomLeaseMonthlyManagementFeeString];
        [self.proposalResultsLeaseRateOHFLabel setText:phenomLeaseOccupiedHourlyFeeString];
        [self.proposalResultsLeaseRateFuelVariableLabel setText:phenomLeaseFuelVariableRateString];
        [self.proposalResultsLeaseAnnualFuelVariableLabel setText:phenomLeaseFuelVariableAnnualString];
        [self.proposalResultsLeaseAnnualMMFLabel setText:phenomLeaseMonthlyManagementFeeAnnualString];
        [self.proposalResultsLeaseAnnualOHFLabel setText:phenomLeaseOccupiedAnnualFeeString];
        [self.proposalResultsLeaseAnnualOpCostLabel setText:phenomLeaseAnnualOperationalCostString];
        [self.proposalResultsLeaseHourlyOpCostLabel setText:phenomLeaseOperationalHourlyCostString];
        [self.leasePrepayEstimateValueLabel setText:phenomLeasePrepaySavingsString];
        
        NSNumber *phenomPurchaseAcquisitionCost = [purchaseProposal.calculatedResults objectForKey:@"PurchasePrice"];
        NSNumber *phenomPurchaseDeposit = [purchaseProposal.calculatedResults objectForKey:@"Deposit"];
        NSNumber *phenomPurchaseProgressPayment = [purchaseProposal.calculatedResults objectForKey:@"ProgressPayment"];
        NSNumber *phenomPurchaseCashDue = [purchaseProposal.calculatedResults objectForKey:@"CashDue"];
        NSNumber *phenomPurchaseOccupiedHourlyFee = [purchaseProposal.calculatedResults objectForKey:@"OccupiedHourlyFeeRate"];
        NSNumber *phenomPurchaseOccupiedAnnualFee = [purchaseProposal.calculatedResults objectForKey:@"OccupiedHourlyFeeAnnual"];
        NSNumber *phenomPurchaseMonthlyManagementFee = [purchaseProposal.calculatedResults objectForKey:@"MonthlyManagementFeeRate"];
        NSNumber *phenomPurchaseMonthlyManagementFeeAnnual = [purchaseProposal.calculatedResults objectForKey:@"MonthlyManagementFeeAnnual"];
        NSNumber *phenomPurchaseFuelVariableRate = [purchaseProposal.calculatedResults objectForKey:@"FuelVariableRate"];
        NSNumber *phenomPurchaseFuelVariableAnnual = [purchaseProposal.calculatedResults objectForKey:@"FuelVariableAnnual"];
        NSNumber *phenomPurchaseAnnualOperationalCost = [purchaseProposal.calculatedResults objectForKey:@"AnnualCost"];
        NSNumber *phenomPurchaseOperationalHourlyCost = [purchaseProposal.calculatedResults objectForKey:@"AverageHourlyCost"];
        NSNumber *phenomPurchasePrepaySavings = [purchaseProposal.calculatedResults objectForKey:@"PrepaymentSavings"];
        
        NSString *phenomPurhaseAcquisitionCostString = [numberFormatter stringFromNumber:phenomPurchaseAcquisitionCost];
        NSString *phenomPurchaseDepositString = [numberFormatter stringFromNumber:phenomPurchaseDeposit];
        NSString *phenomPurchaseProgressPaymentString = [numberFormatter stringFromNumber:phenomPurchaseProgressPayment];
        NSString *phenomPurchaseCashDueString = [numberFormatter stringFromNumber:phenomPurchaseCashDue];
        NSString *phenomPurchaseOccupiedHourlyFeeString = [numberFormatter stringFromNumber:phenomPurchaseOccupiedHourlyFee];
        NSString *phenomPurchaseOccupiedAnnualFeeString = [numberFormatter stringFromNumber:phenomPurchaseOccupiedAnnualFee];
        NSString *phenomPurchaseMonthlyManagementFeeString = [numberFormatter stringFromNumber:phenomPurchaseMonthlyManagementFee];
        NSString *phenomPurchaseMonthlyManagementFeeAnnualString = [numberFormatter stringFromNumber:phenomPurchaseMonthlyManagementFeeAnnual];
        NSString *phenomPurchaseFuelVariableRateString = [numberFormatter stringFromNumber:phenomPurchaseFuelVariableRate];
        NSString *phenomPurchaseFuelVariableAnnualString = [numberFormatter stringFromNumber:phenomPurchaseFuelVariableAnnual];
        NSString *phenomPurchaseAnnualOperationalCostString = [numberFormatter stringFromNumber:phenomPurchaseAnnualOperationalCost];
        NSString *phenomPurchaseOperationalHourlyCostString = [numberFormatter stringFromNumber:phenomPurchaseOperationalHourlyCost];
        NSString *phenomPurchasePrepaySavingsString = [numberFormatter stringFromNumber:phenomPurchasePrepaySavings];
        
        [self.proposalResultsPurchaseAvailabilityLabel setText:@"2013"];
        [self.proposalResultsAcquisitionLabel setText:phenomPurhaseAcquisitionCostString];
        [self.proposalResultsDepositLabel setText:phenomPurchaseDepositString];
        [self.proposalResultsProgressPaymentLabel setText:phenomPurchaseProgressPaymentString];
        [self.proposalResultsCashClosingLabel setText:phenomPurchaseCashDueString];
        [self.proposalResultsPurchaseRateMMFLabel setText:phenomPurchaseMonthlyManagementFeeString];
        [self.proposalResultsPurchaseRateOHFLabel setText:phenomPurchaseOccupiedHourlyFeeString];
        [self.proposalResultsPurchaseRateFuelVariableLabel setText:phenomPurchaseFuelVariableRateString];
        [self.proposalResultsPurchaseAnnualMMFLabel setText:phenomPurchaseMonthlyManagementFeeAnnualString];
        [self.proposalResultsPurchaseAnnualOHFLabel setText:phenomPurchaseOccupiedAnnualFeeString];
        [self.proposalResultsPurchaseAnnualFuelVariableLabel setText:phenomPurchaseFuelVariableAnnualString];
        [self.proposalResultsPurchaseAnnualOpCostLabel setText:phenomPurchaseAnnualOperationalCostString];
        [self.proposalResultsPurchaseHourlyOpCostLabel setText:phenomPurchaseOperationalHourlyCostString];
        [self.purchasePrepayEstimateValueLabel setText:phenomPurchasePrepaySavingsString];
        
        // Only display FET calculations if the (FET) Qualified button is unchecked
        NSNumber *isSelectedNumber = [[proposal productParameters] objectForKey:@"Qualified"];
        BOOL isChecked = [isSelectedNumber boolValue];
        if (isChecked){
            [self.monthlyLeaseFETStaticLabel setHidden:YES];
            [self.recurringFETStaticLabel setHidden:YES];
            [self.proposalResultsLeaseFETRateLabel setHidden:YES];
            [self.proposalResultsLeaseFETAnnualLabel setHidden:YES];
            [self.proposalResultsLeaseRateFETLabel setHidden:YES];
            [self.proposalResultsLeaseAnnualFETLabel setHidden:YES];
            
            [self.proposalPurchaseFETStaticLabel setHidden:YES];
            [self.proposalResultsFETLabel setHidden:YES];
            [self.proposalResultsPurchaseRateFETLabel setHidden:YES];
            [self.proposalResultsPurchaseAnnualFETLabel setHidden:YES];
        } else {
            // Lease FET Calculations
            NSNumber *phenomLeaseLeaseFETRate = [proposal.calculatedResults objectForKey:@"MonthlyLeaseFeeFET"];
            NSNumber *phenomLeaseLeaseFETRateAnnual = [proposal.calculatedResults objectForKey:@"AnnualLeaseFeeFET"];
            //NSNumber *phenomLeaseRecurringFET = [proposal.calculatedResults objectForKey:@"PhenomLease-RecurringFET"];
            NSNumber *phenomLeaseRecurringFETAnnual = [proposal.calculatedResults objectForKey:@"FederalExciseTaxAnnual"];
            NSString *phenomLeaseLeaseFETRateString = [numberFormatter stringFromNumber:phenomLeaseLeaseFETRate];
            NSString *phenomLeaseLeaseFETRateAnnualString = [numberFormatter stringFromNumber:phenomLeaseLeaseFETRateAnnual];
            //NSString *phenomLeaseRecurringFETString = [numberFormatter stringFromNumber:phenomLeaseRecurringFET];
            NSString *phenomLeaseRecurringFETAnnualString = [numberFormatter stringFromNumber:phenomLeaseRecurringFETAnnual];
            [self.proposalResultsLeaseFETRateLabel setText:phenomLeaseLeaseFETRateString];
            [self.proposalResultsLeaseFETAnnualLabel setText:phenomLeaseLeaseFETRateAnnualString];
            //[self.proposalResultsLeaseRateFETLabel setText:phenomLeaseRecurringFETString];
            [self.proposalResultsLeaseAnnualFETLabel setText:phenomLeaseRecurringFETAnnualString];
            
            // Purchase FET Calculations
            NSNumber *phenomPurchaseTermFET = [purchaseProposal.calculatedResults objectForKey:@"FederalExciseTaxPurchase"];
            //NSNumber *phenomPurchaseRecurringFET = [proposal.calculatedResults objectForKey:@"PhenomPurchase-RecurringFET"];
            NSNumber *phenomPurchaseRecurringFETAnnual = [purchaseProposal.calculatedResults objectForKey:@"FederalExciseTaxAnnual"];
            NSString *phenomPurchaseTermFETString = [numberFormatter stringFromNumber:phenomPurchaseTermFET];
            //NSString *phenomPurchaseRecurringFETString = [numberFormatter stringFromNumber:phenomPurchaseRecurringFET];
            NSString *phenomPurchaseRecurringFETAnnualString = [numberFormatter stringFromNumber:phenomPurchaseRecurringFETAnnual];
            [self.proposalResultsFETLabel setText:phenomPurchaseTermFETString];
            //[self.proposalResultsPurchaseRateFETLabel setText:phenomPurchaseRecurringFETString];
            [self.proposalResultsPurchaseAnnualFETLabel setText:phenomPurchaseRecurringFETAnnualString];
            
            [self.monthlyLeaseFETStaticLabel setHidden:NO];
            [self.recurringFETStaticLabel setHidden:NO];
            [self.proposalPurchaseFETStaticLabel setHidden:NO];
            [self.proposalResultsLeaseFETRateLabel setHidden:NO];
            [self.proposalResultsLeaseFETAnnualLabel setHidden:NO];
            [self.proposalResultsLeaseRateFETLabel setHidden:NO];
            [self.proposalResultsLeaseAnnualFETLabel setHidden:NO];
            
            [self.proposalResultsFETLabel setHidden:NO];
            [self.proposalResultsPurchaseRateFETLabel setHidden:NO];
            [self.proposalResultsPurchaseAnnualFETLabel setHidden:NO];
        }
    }
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case LEASE_FUEL_TABLE_VIEW:
        case PURCHASE_FUEL_TABLE_VIEW:
        {
            return [self.fuelChoicesArray count];
            break;
        }
        case LEASE_PREPAY_TABLE_VIEW:
        {
            return [self.leasePrepayOptions count];
            break;
        }
        case PURCHASE_PREPAY_TABLE_VIEW:
        {
            return [self.purchasePrepayOptions count];
            break;
        }
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    NFDProposal *proposal = [self retrieveProposalForThisView];
    switch (tableView.tag) 
    {
        case LEASE_FUEL_TABLE_VIEW:
        case PURCHASE_FUEL_TABLE_VIEW:
        {
            NSString *selectedFuelPeriod = [[proposal productParameters] objectForKey:@"FuelPeriod"];
            NSString *fuelPeriod = [self.fuelChoicesArray objectAtIndex:indexPath.row];
            if ([fuelPeriod isEqualToString:selectedFuelPeriod]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = [self.fuelChoicesArray objectAtIndex:indexPath.row];
            break;
        }
        case LEASE_PREPAY_TABLE_VIEW:
        {            
            NSString *selectedEstimate = [[proposal productParameters] objectForKey:@"PrepayEstimate"];
            NSString *prepayEstimate = [self.leasePrepayOptions objectAtIndex:indexPath.row];
            if ([prepayEstimate isEqualToString:selectedEstimate]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = [self.leasePrepayOptions objectAtIndex:indexPath.row];
            break;
        }
        case PURCHASE_PREPAY_TABLE_VIEW:
        {   
            NSString *selectedEstimate = [[proposal.relatedProposal productParameters] objectForKey:@"PrepayEstimate"];
            NSString *prepayEstimate = [self.purchasePrepayOptions objectAtIndex:indexPath.row];
            if ([prepayEstimate isEqualToString:selectedEstimate]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = [self.purchasePrepayOptions objectAtIndex:indexPath.row];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NFDProposal *proposal = [self retrieveProposalForThisView];
    
    switch (tableView.tag)
    {
        case LEASE_FUEL_TABLE_VIEW:
        case PURCHASE_FUEL_TABLE_VIEW:
        {
            NSString *fuelChoice = [self.fuelChoicesArray objectAtIndex:indexPath.row];
            [[proposal productParameters] setObject:fuelChoice forKey:@"FuelPeriod"];
            [[proposal.relatedProposal productParameters] setObject:fuelChoice forKey:@"FuelPeriod"];
            break;
        }
        case LEASE_PREPAY_TABLE_VIEW:
        {
            NSString *prepayEstimate = [self.leasePrepayOptions objectAtIndex:indexPath.row];
            [[proposal productParameters] setObject:prepayEstimate forKey:@"PrepayEstimate"];
            if (indexPath.row > 0)
            {
                [[proposal productParameters] setObject:@"3 Month" forKey:@"FuelPeriod"];
                [[proposal.relatedProposal productParameters] setObject:@"3 Month" forKey:@"FuelPeriod"];
            }
            break;
        }
        case PURCHASE_PREPAY_TABLE_VIEW:
        {
            NSString *prepayEstimate = [self.purchasePrepayOptions objectAtIndex:indexPath.row];
            [[proposal.relatedProposal productParameters] setObject:prepayEstimate forKey:@"PrepayEstimate"];
            if (indexPath.row > 0)
            {
                [[proposal productParameters] setObject:@"3 Month" forKey:@"FuelPeriod"];
                [[proposal.relatedProposal productParameters] setObject:@"3 Month" forKey:@"FuelPeriod"];
            }
            break;
        }
        default:{
            break;
        }
    }
    [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
    [self updateProposalResultData];
    [self.popover dismissPopoverAnimated:YES];
    [self popoverControllerDidDismissPopover:self.popover];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case LEASE_HOURS_PICKER_VIEW:
        case PURCHASE_HOURS_PICKER_VIEW:
        {
            return [self.annualHoursArray count];
            break;
        }    
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case LEASE_HOURS_PICKER_VIEW:
        case PURCHASE_HOURS_PICKER_VIEW:
        {
            NSString *annualHours = [self.annualHoursArray objectAtIndex:row];
            return annualHours;
            break;
        }
        default:
            break;
    }
    return nil;
} 

#pragma mark - UIPickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NFDProposal *proposal = [self retrieveProposalForThisView];

    switch (pickerView.tag) {
        case LEASE_HOURS_PICKER_VIEW:
        case PURCHASE_HOURS_PICKER_VIEW:
        {
            NSString *annualHoursChoice = [self.annualHoursArray objectAtIndex:row];
            NSString *annualHours;
            if ([annualHoursChoice isEqualToString:@"25 Multi"])
            {
                annualHours = @"25";
                [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"MultiShare"];
                [[proposal.relatedProposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"MultiShare"];
            }
            else if ([annualHoursChoice isEqualToString:@"50 Multi"])
            {
                annualHours = @"50";
                [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"MultiShare"];
                [[proposal.relatedProposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"MultiShare"];
            }
            else 
            {
                annualHours = annualHoursChoice;
                [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
                [[proposal.relatedProposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
            }
            
            [[proposal productParameters] setObject:annualHoursChoice forKey:@"AnnualHoursChoice"];
            [[proposal productParameters] setObject:annualHours forKey:@"AnnualHours"];
            
            [[proposal.relatedProposal productParameters] setObject:annualHoursChoice forKey:@"AnnualHoursChoice"];            
            [[proposal.relatedProposal productParameters] setObject:annualHours forKey:@"AnnualHours"];
            
            if ([annualHours floatValue] > 25)
            {
                [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
                [[proposal.relatedProposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
            }
            
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal.relatedProposal];
            [self.annualHoursTableView reloadData]; 
            break;
        }   
        default:
            break;
    }
}

- (void)openTablePopover:(id)sender
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    
    UITableViewController *popoverContent = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [popoverContent.tableView setScrollEnabled:NO];
    [popoverContent.tableView setDataSource:self];
    [popoverContent.tableView setDelegate:self];
    [popoverContent.tableView reloadData];
    float contentHeight = 0.0;
    
    BOOL hasPrepaySelected = (![[[proposal productParameters] objectForKey:@"PrepayEstimate"] isEqualToString:@"None"]) || (![[[proposal.relatedProposal productParameters] objectForKey:@"PrepayEstimate"] isEqualToString:@"None"]);
    
    
    switch ([(UIButton *)sender tag]) {
        case LEASE_FUEL_BUTTON:
        {
            if (hasPrepaySelected)
            {
                return;
            }
            contentHeight = self.fuelChoicesArray.count * 44;
            [popoverContent.tableView setTag:LEASE_FUEL_TABLE_VIEW];            
            break;
        }   
        case PURCHASE_FUEL_BUTTON:
        {
            if (hasPrepaySelected)
            {
                return;
            }
            contentHeight = self.fuelChoicesArray.count * 44;
            [popoverContent.tableView setTag:PURCHASE_FUEL_TABLE_VIEW];
            break;
        }  
        case LEASE_PREPAY_BUTTON:
        {
            contentHeight = self.leasePrepayOptions.count * 44;
            [popoverContent.tableView setTag:LEASE_PREPAY_TABLE_VIEW];
            break;
        }  
        case PURCHASE_PREPAY_BUTTON:
        {
            contentHeight = self.purchasePrepayOptions.count * 44;
            [popoverContent.tableView setTag:PURCHASE_PREPAY_TABLE_VIEW];
            break;
        }  
        default:
            break;
    }
    
    [popoverContent setPreferredContentSize:CGSizeMake(220, contentHeight)];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [self.popover presentPopoverFromRect:CGRectMake(0, 0, [(UIButton *)sender frame].size.width, [(UIButton *)sender frame].size.height) inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [self.popover setDelegate:self];
    
    [self setPopoverOriginator:sender];
    [(UIButton *)sender setBackgroundColor:[UIColor colorWithWhite:0.12 alpha:1]];
}

- (void)openPickerPopover:(id)sender
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    UIViewController *popoverContent = [[UIViewController alloc] init];
    [popoverContent setPreferredContentSize:CGSizeMake(PICKER_WIDTH + 2*PICKER_X_OFFSET, PICKER_HEIGHT + 2*PICKER_Y_OFFSET)];
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.frame = CGRectMake(PICKER_X_OFFSET, PICKER_Y_OFFSET, PICKER_WIDTH, PICKER_HEIGHT);
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setShowsSelectionIndicator:YES];
    
    [(UIButton *)sender setBackgroundColor:[UIColor colorWithWhite:0.12 alpha:1]];
    int rowToSelect = 0;
    
    switch ([(UIButton *)sender tag]) {
        case LEASE_HOURS_BUTTON:
        {
            NSString *annualHoursChoice = [[proposal productParameters] objectForKey:@"AnnualHoursChoice"];
            rowToSelect = [self.annualHoursArray indexOfObject:annualHoursChoice];
            pickerView.tag = LEASE_HOURS_PICKER_VIEW;
            break;
        }   
        case PURCHASE_HOURS_BUTTON:
        {
            NSString *annualHoursChoice = [[proposal productParameters] objectForKey:@"AnnualHoursChoice"];
            rowToSelect = [self.annualHoursArray indexOfObject:annualHoursChoice];
            pickerView.tag = PURCHASE_HOURS_PICKER_VIEW;
            break;
        }            
        default:
            break;
    }
    
    [pickerView selectRow:rowToSelect inComponent:0 animated:NO];
    [[popoverContent view] addSubview:pickerView];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent]; 
    [self.popover presentPopoverFromRect:CGRectMake(0, 0, [(UIButton *)sender frame].size.width, [(UIButton *)sender frame].size.height) inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [self setPopoverOriginator:sender];
    [self.popover setDelegate:self];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self resetButtonHighlight];
    [self setPopoverOriginator:nil];
}


- (void)resetButtonHighlight
{
    [self.leaseHoursButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.purchaseHoursButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.leaseFuelMonthsButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.purchaseFuelMonthsButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.leasePrepayButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.purchasePrepayButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
}

- (void)interfaceDidChangeOrientation
{
    if ([self.popover isPopoverVisible] && self.popoverOriginator)
    {
        [self.popover dismissPopoverAnimated:NO];
        [self.popover presentPopoverFromRect:CGRectMake(0, 0, [self.popoverOriginator frame].size.width, [self.popoverOriginator frame].size.height) inView:self.popoverOriginator permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)dismissPopover
{
    if ([self.popover isPopoverVisible]) {
        [self.popover dismissPopoverAnimated:NO];
    }
}

@end
