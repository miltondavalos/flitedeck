//
//  NFDFlightProposalShareProductView.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/12/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "NFDFlightProposalShareProductView.h"
#import "PopoverTableViewController.h"
#import "NFDAircraftInventory.h"
#import "NFDShareFractionator.h"
#import "NFDFlightProposalCalculatorService.h"
#import "UIView+FrameUtilities.h"
#import "NFDUserManager.h"
#import "NFDFeaturesService.h"
#import "NSDate+CommonUtilities.h"

#define PREPAY_ESTIMATE_TABLE_VIEW 2
#define FUEL_PERIOD_TABLE_VIEW 3
#define LEASE_TERMS_TABLE_VIEW 4

#define AIRCRAFT_PICKER_VIEW 1
#define HOURS_PICKER_VIEW 2

#define AIRCRAFT_BUTTON 1
#define HOURS_BUTTON 2
#define FUEL_PERIOD_BUTTON 3
#define PREPAY_BUTTON 4
#define LEASE_TERM_BUTTON 5

#define PICKER_HEIGHT 216
#define PICKER_WIDTH 280
#define PICKER_X_OFFSET -12
#define PICKER_Y_OFFSET -12

#define POPOVER_TABLE_HEIGHT_1_ROW 44

@implementation NFDFlightProposalShareProductView

@synthesize detailViewController = _detailViewController;
@synthesize popover;
@synthesize aircraftArray = _aircraftArray;
@synthesize annualHoursArray = _annualHoursArray;
@synthesize prepayEstimateArray = _prepayEstimateArray;
@synthesize leaseTermsArray = _leaseTermsArray;
@synthesize fuelPeriodsArray = _fuelPeriodsArray;

@synthesize proposalAircraftDetailsView = _proposalAircraftDetailsView;
@synthesize proposalAircraftDetailsTailNumber = _proposalAircraftDetailsTailNumber;
@synthesize proposalAircraftDetailsLegalName = _proposalAircraftDetailsLegalName;
@synthesize proposalAircraftDetailsYear = _proposalAircraftDetailsYear;
@synthesize proposalAircraftDetailsAvailable = _proposalAircraftDetailsAvailable;
@synthesize proposalAircraftDetailsContractsUntilDate = _proposalAircraftDetailsContractsUntilDate;
@synthesize proposalAircraftDetailsSalesValue = _proposalAircraftDetailsSalesValue;

@synthesize proposalOperatingCostView = _proposalOperatingCostView;
@synthesize proposalOperatingCostRateMMFLabel = _proposalOperatingCostRateMMFLabel;
@synthesize proposalOperatingCostAnnualMMFLabel = _proposalOperatingCostAnnualMMFLabel;
@synthesize proposalOperatingCostRateOHFLabel = _proposalOperatingCostRateOHFLabel;
@synthesize proposalOperatingCostAnnualOHFLabel = _proposalOperatingCostAnnualOHFLabel;
@synthesize proposalOperatingCostRateFuelVariableLabel = _proposalOperatingCostRateFuelVariableLabel;
@synthesize proposalOperatingCostAnnualFuelVariableLabel = _proposalOperatingCostAnnualFuelVariableLabel;
@synthesize proposalOperatingCostFETLabel = _proposalOperatingCostFETLabel;
@synthesize proposalOperatingCostRateFETLabel = _proposalOperatingCostRateFETLabel;
@synthesize proposalOperatingCostAnnualFETLabel = _proposalOperatingCostAnnualFETLabel;

@synthesize proposalOperatingCostPrepaymentTypeLabel = _proposalOperatingCostPrepaymentTypeLabel;
@synthesize proposalOperatingCostPrepaymentSavings = _proposalOperatingCostPrepaymentSavings;

@synthesize proposalFinanceFiguresView = _proposalFinanceFiguresView;
@synthesize proposalFinanceFiguresDownPaymentLabel = _proposalFinanceFiguresDownPaymentLabel;
@synthesize proposalFinanceFiguresFinancedAmountLabel = _proposalFinanceFiguresFinancedAmountLabel;
@synthesize proposalFinanceFiguresMonthlyPILabel = _proposalFinanceFiguresMonthlyPILabel;
@synthesize proposalFinanceFiguresBalloonPaymentLabel = _proposalFinanceFiguresBalloonPaymentLabel;

@synthesize proposalLeaseFiguresView = _proposalLeaseFiguresView;
@synthesize proposalLeaseFiguresMonthlyFeeLabel = _proposalLeaseFiguresMonthlyFeeLabel;
@synthesize proposalLeaseFiguresMonthlyFeeFETLabel = _proposalLeaseFiguresMonthlyFeeFETLabel;
@synthesize proposalLeaseFiguresMonthlyFeeFETRateLabel = _proposalLeaseFiguresMonthlyFeeFETRateLabel;
@synthesize proposalLeaseFiguresAnnualLeaseFeeLabel = _proposalLeaseFiguresAnnualLeaseFeeLabel;
@synthesize proposalLeaseFiguresAnnualLeaseFETLabel = _proposalLeaseFiguresAnnualLeaseFETLabel;

@synthesize proposalPurchaseFiguresView = _proposalPurchaseFiguresView;
@synthesize proposalPurchaseFiguresAcquisitionLabel = _proposalPurchaseFiguresAcquisitionLabel;
@synthesize proposalPurchaseFiguresAcquisitionFETLabel = _proposalPurchaseFiguresAcquisitionFETLabel;
@synthesize proposalPurchaseFiguresAcquisitionFETRateLabel = _proposalPurchaseFiguresAcquisitionFETRateLabel;

@synthesize proposalPrepaymentEstimateView = _proposalPrepaymentEstimateView;
@synthesize proposalOperatingCostAnnualCostLabel = _proposalOperatingCostAnnualCostLabel;
@synthesize proposalOperatingCostAverageHourlyCostLabel = _proposalOperatingCostAverageHourlyCostLabel;
@synthesize purchaseLabelsView = _purchaseLabelsView;
@synthesize leaseLabelsView = _leaseLabelsView;
@synthesize financeLabelsView = _financeLabelsView;
@synthesize resultsView = _resultsView;
@synthesize aircraftButton = _aircraftButton;
@synthesize hoursButton = _hoursButton;
@synthesize fuelMonthsButton = _fuelMonthsButton;
@synthesize prepayButton = _prepayButton;
@synthesize leaseTermButton = _leaseTermButton;
@synthesize leaseTermLabel = _leaseTermLabel;
@synthesize qualifiedFETSwitch = _qualifiedFETSwitch;
@synthesize qualifiedFETLabel = _qualifiedFETLabel;
@synthesize buttonBackingView = _buttonBackingView;
@synthesize leaseTermButtonChevronImageView = _leaseTermButtonChevronImageView;
@synthesize prepayEstimateLabel = _prepayEstimateLabel;
@synthesize prepayEstimateChevronImageView = _prepayEstimateChevronImageView;
@synthesize prepayResultsLabel = _prepayResultsLabel;
@synthesize popoverOriginator = _popoverOriginator;

@synthesize fuelRates = _fuelRates;
@synthesize fuelRateNames = _fuelRateNames;

@synthesize nextYearSwitch = _nextYearSwitch;
@synthesize nextYearLabel = _nextYearLabel;
@synthesize nextYearOHFPercentageLabel = _nextYearOHFPercentageLabel;
@synthesize nextYearMMFPercentageLabel = _nextYearMMFPercentageLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureView
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NFDFeatures *features = [NFDFeaturesService currentFeatures];
    
    isPercentageIncreaseEnabled = features.shouldUseNextYearPercentage;
    if (isPercentageIncreaseEnabled) {
        [[proposal productParameters] setObject:features.nextYearPercentageOHF forKey:@"NextYearPercentageForOHF"];
        [[proposal productParameters] setObject:features.nextYearPercentageMMF forKey:@"NextYearPercentageForMMF"];
        
        NSString *nextYearString = [NSDate nextYearString];
        
        self.nextYearLabel.text = [NSString stringWithFormat:@"%@ Estimated %% increase", nextYearString];
        self.nextYearOHFPercentageLabel.text = [NSString stringWithFormat:@"OHF - %@%%", features.nextYearPercentageOHF.stringValue];
        self.nextYearMMFPercentageLabel.text = [NSString stringWithFormat:@"MMF - %@%%", features.nextYearPercentageMMF.stringValue];
        
        self.nextYearLabel.hidden = NO;
        self.nextYearSwitch.hidden = NO;
        self.nextYearOHFPercentageLabel.hidden = NO;
        self.nextYearMMFPercentageLabel.hidden = NO;
    }
    
    [[self.resultsView layer] setCornerRadius:12];
    
    [[self.resultsView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.resultsView layer] setShadowOffset:CGSizeMake(0, 1)];
    [[self.resultsView layer] setShadowOpacity:0.2];
    [[self.resultsView layer] setShadowRadius:2];
    
    [self.aircraftButton addTarget:self action:@selector(aircraftButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.hoursButton addTarget:self action:@selector(openPickerPopover:) forControlEvents:UIControlEventTouchUpInside];
    [self.fuelMonthsButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    [self.prepayButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    [self.leaseTermButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.aircraftButton setTag:AIRCRAFT_BUTTON];
    [self.hoursButton setTag:HOURS_BUTTON];
    [self.fuelMonthsButton setTag:FUEL_PERIOD_BUTTON];
    [self.leaseTermButton setTag:LEASE_TERM_BUTTON];
    [self.prepayButton setTag:PREPAY_BUTTON];
    
    [self.qualifiedFETSwitch addTarget:self action:@selector(switchFET:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextYearSwitch addTarget:self action:@selector(nextYearSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [self configureParameterControls];
}

- (void)configureParameterControls
{
    DLog(@"configureParameterControls");
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NFDAircraftInventory *aircraftInventory = [[proposal productParameters] objectForKey:@"AircraftInventory"];
    int available = ([[aircraftInventory share_immediately_available] floatValue] * 800);
    
    NSString *aircraftType;
    if ( [proposal.productCode intValue] == SHARE_LEASE_PRODUCT )
    {
        aircraftType = [[proposal productParameters] objectForKey:@"AircraftChoice"];
    } 
    else 
    {
        aircraftType = [aircraftInventory type];
    }
    
    NSArray *fuelPeriodChoicesArrayForQualified = [NFDFlightProposalCalculatorService fuelPeriodChoicesForAircraftType:aircraftType isQualified:YES];
    NSArray *fuelPeriodChoicesArrayForNonQualified = [NFDFlightProposalCalculatorService fuelPeriodChoicesForAircraftType:aircraftType isQualified:NO];
    fuelMonthRatesForQualifiedDisplayNames = [fuelPeriodChoicesArrayForQualified objectAtIndex:0];
    fuelMonthRatesForNonQualifiedDisplayNames = [fuelPeriodChoicesArrayForNonQualified objectAtIndex:0];
    fuelMonthRatesForQualified = [fuelPeriodChoicesArrayForQualified objectAtIndex:1];
    fuelMonthRatesForNonQualified = [fuelPeriodChoicesArrayForNonQualified objectAtIndex:1];
    
    self.aircraftArray = [NFDFlightProposalCalculatorService aircraftChoicesForLease];
    
    self.annualHoursArray = [NSMutableArray arrayWithArray:[NFDFlightProposalCalculatorService annualHourAllotmentChoicesForGeneralProductType:kGeneralProductTypeShare maxHoursAvailable:[NSNumber numberWithInt:available]]];
    
    if (proposal.productCode.intValue == SHARE_LEASE_PRODUCT)
    {
        [self.annualHoursArray removeObjectAtIndex:0];
        [self.annualHoursArray removeObjectAtIndex:0];
    }
    
    self.prepayEstimateArray = [NFDFlightProposalCalculatorService prepayEstimateChoicesForProductCode:proposal.productCode.intValue];
    self.leaseTermsArray = [NFDFlightProposalCalculatorService leaseTermChoicesForAircraftType:aircraftType];
    
    //Display Optional Product Views
    [self.proposalPurchaseFiguresView setHidden:YES];
    [self.proposalFinanceFiguresView setHidden:YES];
    [self.proposalLeaseFiguresView setHidden:YES];
    
    [self.purchaseLabelsView setHidden:YES];
    [self.leaseLabelsView setHidden:YES];
    [self.financeLabelsView setHidden:YES];
    
    [self.leaseTermButton setHidden:YES];
    [self.leaseTermLabel setHidden:YES];
    [self.leaseTermButtonChevronImageView setHidden:YES];
    
    self.nextYearSwitch.on = [[[proposal productParameters] objectForKey:@"ShouldApplyNextYearPercentageIncrease"] boolValue];
    
    switch ([proposal.productCode intValue]) {
        case SHARE_FINANCE_PRODUCT:{
            [self.proposalFinanceFiguresView setHidden:NO];
            [self.financeLabelsView setHidden:NO];
            [self.prepayButton setHidden:YES];
            [self.prepayEstimateLabel setHidden:YES];
            [self.prepayEstimateChevronImageView setHidden:YES];
            [self.buttonBackingView resizeViewHeightByAmount:-84];
            [self.qualifiedFETLabel offsetViewVertically:-84];
            [self.qualifiedFETSwitch offsetViewVertically:-84];
            [self.prepayResultsLabel setHidden:YES];
            [self.proposalOperatingCostPrepaymentSavings setHidden:YES];
            [self.proposalOperatingCostPrepaymentTypeLabel setHidden:YES];
            break;
        }                    
        case SHARE_PURCHASE_PRODUCT:{
            [self.proposalPurchaseFiguresView setHidden:NO];
            [self.purchaseLabelsView setHidden:NO];
            [self.buttonBackingView resizeViewHeightByAmount:-42];
            [self.qualifiedFETLabel offsetViewVertically:-42];
            [self.qualifiedFETSwitch offsetViewVertically:-42];
            break;
        }                    
        case SHARE_LEASE_PRODUCT:{
            DLog(@"Lease product");
            [self.proposalLeaseFiguresView setHidden:NO];
            [self.leaseLabelsView setHidden:NO];
            [self.leaseTermButton setHidden:NO];
            [self.leaseTermLabel setHidden:NO];
            [self.leaseTermButtonChevronImageView setHidden:NO];
            break;
        }                    
        default:
            break;
    }
}

#pragma mark - Manager, Proposal, Results Methods

- (NFDProposal *)retrieveProposalForThisView
{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    return [manager retrieveProposalAtIndex:self.tag];
}

- (void)updateSubtitleOfMasterView
{
    NFDProposal *proposal = [self retrieveProposalForThisView];

    //Calculate the Hours and Selected Aircraft Type
    NSString *aircraftChoice;
    if ( [proposal.productCode intValue] == SHARE_LEASE_PRODUCT )
    {
        aircraftChoice = [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[[proposal productParameters] objectForKey:@"AircraftChoice"]];
    }
    else
    {
        NFDAircraftInventory *aircraft = ([[proposal productParameters] objectForKey:@"AircraftInventory"]);
        aircraftChoice = [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[aircraft type]];
    }
    if (!aircraftChoice)
    {
        aircraftChoice = @"Aircraft";
    }
    NSString *annualHours = [[proposal productParameters] objectForKey:@"AnnualHours"];
    [proposal setSubTitle:[NSString stringWithFormat:@"%@ %@",[NFDShareFractionator fractionStringForShareHours:[annualHours intValue]],aircraftChoice]];

    //Update the Detail View's Title on the Navigation Bar
    [self.detailViewController setTitle:[NSString stringWithFormat:@"%@ %@",[NFDShareFractionator fractionStringForShareHours:[annualHours intValue]], [proposal title]]];

    //Notify Master Table Cell of the Update
    [[NSNotificationCenter defaultCenter] postNotificationName:PROPOSAL_SUBTITLE_UPDATED object:self];
}

/*

 QUALIFIED FET CONTROL LOGIC
 ===========================
 
 Federal Excise Taxes are applied only when the SVP has indicarted that the 
 proposal if doe a non-Qualified proposal.  The control to allow the SVP to
 make this decision is only displayed when one of the two following conditions
 have been met:
    
    1. The Aicraft has less than two (2) years of service remaining (contracts_until)
    2. The Annual Hours seelcted is for a 1/32nd Share (25 Hours)
 
 NOTE:  For Share Lease, since no actual aircraft is selected, only the
        second rule applies.
 
 */

- (BOOL)shouldDisplayQualifiedControls{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    if (( [proposal.productCode intValue] == SHARE_PURCHASE_PRODUCT ) || ( [proposal.productCode intValue] == SHARE_FINANCE_PRODUCT ))
    {
        
        //Determine years of service remaining...
        NFDAircraftInventory *aircraftInventory = [[proposal productParameters] objectForKey:@"AircraftInventory"];
        
        //Only evaluate if there is actually an aircraft selected
        if (aircraftInventory)
        {

            NSDate *contractUntil = [aircraftInventory contracts_until_date];
            NSTimeInterval secondsBetween = [contractUntil timeIntervalSinceDate:[NSDate date]];
            int numberOfYears = ( ( secondsBetween / 86400 ) / 365 );
            
            //Evaluate Annual Hours Selected...
            NSString *annualHoursSelcted = [[proposal productParameters] objectForKey:@"AnnualHours"];
            
            if ( [annualHoursSelcted isEqualToString:@"25"] || ([aircraftInventory contracts_until_date] && (numberOfYears < 2)) ) 
            {
                //NOTE: DO NOT set the Qualified parameter here, the SVP will decide
                return YES;
            }
            else
            {
                //Since the control will not display, set the Qualified parameter to YES
                [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];

                return NO;
            }
        }
        else
        {
            //Since the control will not display, set the Qualified parameter to YES
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
            return NO;
        }
        
    }
    else if ( [proposal.productCode intValue] == SHARE_LEASE_PRODUCT ) 
    {
        
        //See if an Aircraft selection ahs been made...
        NSString *aircraftChoice = [[proposal productParameters] objectForKey:@"AircraftChoice"];

        //Evaluate Annual Hours Selected...
        NSString *annualHoursSelcted = [[proposal productParameters] objectForKey:@"AnnualHours"];
        
        //Only evaluate if there is actually an aircraft selected
        if (aircraftChoice)
        {
            
            if ( [annualHoursSelcted isEqualToString:@"25"] ) 
            {
                //NOTE: DO NOT set the Qualified parameter here, the SVP will decide
                return YES;
            }
            else
            {
                //Since the control will not display, set the Qualified parameter to YES
                [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
                return NO;
            }
        }else
        {
            //Since the control will not display, set the Qualified parameter to YES
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
            return NO;
        }
    }else
    {
        //Since the control will not display, set the Qualified parameter to YES
        [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
        return NO;
    }
}

/*
 
 QUALIFIED FET CALCULATED FIELDS
 ===============================
 
 When the SVP does decide that the proposal is non-Qualified, the calculated
 fields associated with the application of FET are displayed.
 
 */

- (BOOL)shouldDisplayaFETCalculations
{
    NFDProposal *proposal = [self retrieveProposalForThisView];    
    if ([self shouldDisplayQualifiedControls])
    {
        NSNumber *isSelectedNumber = [[proposal productParameters] objectForKey:@"Qualified"];
        BOOL isQualified = [isSelectedNumber boolValue];
        
        //The SVP set the proposal as Qualified
        if (isQualified)
        {
            return NO;
            
        //The SVP set the proposal as non-Qualified
        }
        else
        {
            return YES;
        }
    
    //The Qualified control is not displayed
    }
    else 
    {
        return NO;
    }

}

- (BOOL)shouldDisplayPrepaymentSavingsEstimate
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    return ![[[proposal productParameters] objectForKey:@"PrepayEstimate"] isEqual:@"None"];
}

- (void)updateProposalParameterData
{
    DLog(@"update");
    //Retrieve Proposal Data
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NFDAircraftInventory *aircraftInventory = [[proposal productParameters] objectForKey:@"AircraftInventory"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];

    //Update Subtitle of Master Cell and View Title 
    [self updateSubtitleOfMasterView];
    
    int available = ([[aircraftInventory share_immediately_available] floatValue] * 800);
	
	self.annualHoursArray = [NSMutableArray arrayWithArray:[NFDFlightProposalCalculatorService annualHourAllotmentChoicesForGeneralProductType:kGeneralProductTypeShare maxHoursAvailable:[NSNumber numberWithInt:available]]];
    
    
    if ([self shouldDisplayQualifiedControls])
    {
        [self.qualifiedFETLabel setHidden:NO];
        [self.qualifiedFETSwitch setHidden:NO];
        [self.qualifiedFETSwitch setOn:[[[proposal productParameters] objectForKey:@"Qualified"] boolValue]];
    }
    else 
    {
        [self.qualifiedFETLabel setHidden:YES];
        [self.qualifiedFETSwitch setOn:NO];
        [self.qualifiedFETSwitch setHidden:YES];        
        [self.qualifiedFETSwitch setOn:[[[proposal productParameters] objectForKey:@"Qualified"] boolValue]];
    }
    
    
    BOOL isQualified = [[[proposal productParameters] objectForKey:@"Qualified"] boolValue];
    
    if (isQualified)
    {
        self.fuelRates = [NSArray arrayWithArray:fuelMonthRatesForQualified];
        self.fuelRateNames = [NSArray arrayWithArray:fuelMonthRatesForQualifiedDisplayNames];
    }
    else 
    {
        self.fuelRates = [NSArray arrayWithArray:fuelMonthRatesForNonQualified];
        self.fuelRateNames = [NSArray arrayWithArray:fuelMonthRatesForNonQualifiedDisplayNames];
    }
    
    if ( [proposal.productCode intValue] == SHARE_LEASE_PRODUCT )
    {
        //Display the Type of the Aircraft (same as "Legal Name" a.k.a. "TypeGroup")
//        NSString *aircraftChoice = [[proposal productParameters] objectForKey:@"AircraftChoice"];
        NSString *aircraftChoice = [[proposal productParameters] objectForKey:@"AircraftChoice"];
        [self.aircraftButton setTitle:[NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:aircraftChoice] forState:UIControlStateNormal];

        //Share Lease aircrafts are available "Immediately"
        [self.proposalAircraftDetailsAvailable setText:@"Immediately"];

        //Contracts Until is based off of the User Selected Lease Terms
        NSString *leaseTerms = [[proposal productParameters] objectForKey:@"LeaseTerm"];
        
        [self.leaseTermButton setTitle:leaseTerms forState:UIControlStateNormal];
        
        //Share Lease does not select a specific Aircraft from the inventory of available aircraft...
        [self.proposalAircraftDetailsTailNumber setText:@"N/A"];
        [self.proposalAircraftDetailsYear setText:@"N/A"];
        [self.proposalAircraftDetailsSalesValue setText:@"N/A"];
        
        [self.annualHoursArray removeObjectAtIndex:0];
        [self.annualHoursArray removeObjectAtIndex:0];
    }
    else
    {
        //Display Selected Aircraft Details
        if (aircraftInventory)
        {
            //Display the Legal Name of the Aircraft (same as "Type" a.k.a. "TypeGroup")
            //[self.proposalAircraftDetailsLegalName setText:[aircraftInventory legal_name]];
            [self.proposalAircraftDetailsLegalName setText:[NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[aircraftInventory type]]];
            
            //Tail Number of Aircraft
            [self.proposalAircraftDetailsTailNumber setText:[aircraftInventory tail]];
            
            //Vintage (Year) of Aircraft
            [self.proposalAircraftDetailsYear setText:[aircraftInventory year]];
            
            NSString *fullAircraftDescription;
            
            if ([[NFDUserManager sharedManager] proposalShowTailNumber])
            {
                fullAircraftDescription = [NSString stringWithFormat:@"%@ %@ [%@]",[aircraftInventory year], [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[aircraftInventory type]], [aircraftInventory tail]];
            }
            else 
            {
                fullAircraftDescription = [NSString stringWithFormat:@"%@ %@",[aircraftInventory year], [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[aircraftInventory type]]];
            }
            [self.aircraftButton setTitle:fullAircraftDescription forState:UIControlStateNormal];
            
            NSDate *availDate = [aircraftInventory anticipated_delivery_date];

            if ([[NSDate date] timeIntervalSinceDate:availDate] < 0)
            {
                [self.proposalAircraftDetailsAvailable setText:[dateFormat stringFromDate:availDate]];
            }
            else 
            {
                [self.proposalAircraftDetailsAvailable setText:@"Immediately"];
            }
       
//            [self.proposalAircraftDetailsContractsUntilDate setText:[[proposal productParameters] objectForKey:@"ContractsUntil"]];
        }
    }
    
    [self.proposalAircraftDetailsContractsUntilDate setText:[[proposal productParameters] objectForKey:@"ContractsUntil"]];
    
    [self.hoursButton setTitle:[[proposal productParameters] objectForKey:@"AnnualHoursChoice"] forState:UIControlStateNormal];
    [self.fuelMonthsButton setTitle:[[proposal productParameters] objectForKey:@"FuelPeriod"] forState:UIControlStateNormal];

    //Prepayment Label based off of selected Prepayment Savings
    NSString *prepayEstimate = [[proposal productParameters] objectForKey:@"PrepayEstimate"];
    [self.proposalOperatingCostPrepaymentTypeLabel setText:[NSString stringWithFormat:@"Prepay %@",prepayEstimate]];
    [self.prepayButton setTitle:prepayEstimate forState:UIControlStateNormal];



    
}

- (void)updateProposalResultData
{
    //Retrieve Proposal Data
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NSDictionary *result = [proposal calculatedResults];

    if (result){

        //Create Number Formatter for Currency
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [numberFormatter setMaximumFractionDigits:0];

        //Display Calculated Monthly Management Fee
        [self.proposalOperatingCostRateMMFLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"MonthlyManagementFeeRate"]]];
        [self.proposalOperatingCostAnnualMMFLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"MonthlyManagementFeeAnnual"]]];

        //Display Calculated Occupied Hourly Fee
        [self.proposalOperatingCostRateOHFLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"OccupiedHourlyFeeRate"]]];
        [self.proposalOperatingCostAnnualOHFLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"OccupiedHourlyFeeAnnual"]]];

        //Display Calculated Fuel Variable
        [self.proposalOperatingCostRateFuelVariableLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FuelVariableRate"]]];
        [self.proposalOperatingCostAnnualFuelVariableLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FuelVariableAnnual"]]];
        DLog(@"results");
        //Display Calculated Federal Excise Tax
        if ([self shouldDisplayaFETCalculations]){
            
            //FET for Operational Fees
            [self.proposalOperatingCostFETLabel setHidden:NO];
            [self.proposalOperatingCostRateFETLabel setHidden:NO];
            [self.proposalOperatingCostRateFETLabel setText:@"7.5%"];
            [self.proposalOperatingCostAnnualFETLabel setHidden:NO];
            [self.proposalOperatingCostAnnualFETLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FederalExciseTaxAnnual"]]];

            //FET for Share Purchase
            [self.proposalPurchaseFiguresAcquisitionFETLabel setHidden:NO];
            [self.proposalPurchaseFiguresAcquisitionFETRateLabel setHidden:NO];
            [self.proposalPurchaseFiguresAcquisitionFETRateLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FederalExciseTaxPurchase"]]];
            
            //FET for Share Lease
            [self.proposalLeaseFiguresMonthlyFeeFETLabel setHidden:NO];
            [self.proposalLeaseFiguresMonthlyFeeFETRateLabel setHidden:NO];
            [self.proposalLeaseFiguresMonthlyFeeFETRateLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"MonthlyLeaseFeeFETRate"]]];
            [self.proposalLeaseFiguresAnnualLeaseFETLabel setHidden:NO];
            [self.proposalLeaseFiguresAnnualLeaseFETLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"MonthlyLeaseFeeFETAnnual"]]];
            
        //DO NOT display Calculated Federal Excise Tax
        }else{

            //FET for Operational Fees
            [self.proposalOperatingCostFETLabel setHidden:YES];
            [self.proposalOperatingCostRateFETLabel setHidden:YES];
            [self.proposalOperatingCostRateFETLabel setText:@"NA"];
            [self.proposalOperatingCostAnnualFETLabel setHidden:YES];
            [self.proposalOperatingCostAnnualFETLabel setText:@"NA"];
            
            //FET for Share Purchase
            [self.proposalPurchaseFiguresAcquisitionFETLabel setHidden:YES];
            [self.proposalPurchaseFiguresAcquisitionFETRateLabel setHidden:YES];
            [self.proposalPurchaseFiguresAcquisitionFETRateLabel setText:@"NA"];

            //FET for Share Lease
            [self.proposalLeaseFiguresMonthlyFeeFETLabel setHidden:YES];
            [self.proposalLeaseFiguresMonthlyFeeFETRateLabel setHidden:YES];
            [self.proposalLeaseFiguresMonthlyFeeFETRateLabel setText:@"NA"];
            [self.proposalLeaseFiguresAnnualLeaseFETLabel setHidden:YES];
            [self.proposalLeaseFiguresAnnualLeaseFETLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"AnnualLeaseFeeFET"]]];
        }

        [self.proposalOperatingCostAnnualCostLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"AnnualCost"]]];
        [self.proposalOperatingCostAverageHourlyCostLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"AverageHourlyCost"]]];
        
        //Display Prepayment Savings
        [self.proposalPrepaymentEstimateView setHidden:![self shouldDisplayPrepaymentSavingsEstimate]];
        [self.proposalOperatingCostPrepaymentTypeLabel setText:[[proposal productParameters] objectForKey:@"PrepayEstimate"]];
        [self.proposalOperatingCostPrepaymentSavings setText:[numberFormatter stringFromNumber:[result objectForKey:@"PrepaymentSavings"]]];

        // --- OPTIONAL FIELDS --- //
        
        //Display Calculated Purchase Values
        [self.proposalPurchaseFiguresAcquisitionLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"PurchasePrice"]]];
        
        //Display Calculated Finance Values
        [self.proposalFinanceFiguresDownPaymentLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"DownPayment"]]];
        [self.proposalFinanceFiguresFinancedAmountLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FinancedAmount"]]];
        [self.proposalFinanceFiguresMonthlyPILabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"MonthlyPayment"]]];
        [self.proposalFinanceFiguresBalloonPaymentLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"BalloonPayment"]]];
        
        //Display Calculated Lease Values
        [self.proposalLeaseFiguresMonthlyFeeLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"MonthlyLeaseFeeRate"]]];
        [self.proposalLeaseFiguresAnnualLeaseFeeLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"MonthlyLeaseFeeAnnual"]]];
        
    }
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (tableView.tag) 
    {
        case PREPAY_ESTIMATE_TABLE_VIEW:
        case FUEL_PERIOD_TABLE_VIEW:
        case LEASE_TERMS_TABLE_VIEW:
        {
            return 1;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    switch (tableView.tag)
    {      
        case PREPAY_ESTIMATE_TABLE_VIEW:
        {
            return self.prepayEstimateArray.count;
            break;
        }
        case FUEL_PERIOD_TABLE_VIEW:
        {
            return self.fuelRates.count;
            break;
        }
        case LEASE_TERMS_TABLE_VIEW:
        {
            return self.leaseTermsArray.count;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:0.0]];
    [[cell detailTextLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:0.0]];
    
    switch (tableView.tag) 
    {
        case PREPAY_ESTIMATE_TABLE_VIEW:
        {
            [cell.textLabel setText:[self.prepayEstimateArray objectAtIndex:indexPath.row]];
            break;
        }
        case FUEL_PERIOD_TABLE_VIEW:
        {
            NFDProposal *proposal = [self retrieveProposalForThisView];
            cell.textLabel.text = [self.fuelRateNames objectAtIndex:indexPath.row];
            if ([cell.textLabel.text isEqualToString:[[proposal productParameters] objectForKey:@"FuelPeriod"]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        case LEASE_TERMS_TABLE_VIEW:
        {
            NFDProposal *proposal = [self retrieveProposalForThisView];
            [cell.textLabel setText:[self.leaseTermsArray objectAtIndex:indexPath.row]];
            if ([cell.textLabel.text isEqualToString:[[proposal productParameters] objectForKey:@"LeaseTerm"]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        default:
        {
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    [self resetButtonHighlight];
    
    switch (tableView.tag) 
    {            
        case PREPAY_ESTIMATE_TABLE_VIEW:
        {
            NSString *prepayEstimate = [self.prepayEstimateArray objectAtIndex:indexPath.row];
            [[proposal productParameters] setObject:prepayEstimate forKey:@"PrepayEstimate"];
            if (indexPath.row > 0)
            {
                [[proposal productParameters] setObject:@"3 Month" forKey:@"FuelPeriod"];
            }
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            [self.popover dismissPopoverAnimated:YES];
            break;
        }
        case FUEL_PERIOD_TABLE_VIEW:
        {
            NSString *fuelPeriod = [self.fuelRateNames objectAtIndex:indexPath.row];
            
            if ([[proposal productParameters] objectForKey:@"AircraftChoice"] != nil) {
                [[proposal productParameters] setObject:fuelPeriod forKey:@"FuelPeriod"];
            }
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            [self.popover dismissPopoverAnimated:YES];
            break;
        }
        case LEASE_TERMS_TABLE_VIEW:
        {
            NSString *leaseTerms = [self.leaseTermsArray objectAtIndex:indexPath.row];
            [[proposal productParameters] setObject:leaseTerms forKey:@"LeaseTerm"];
            [[proposal productParameters] setObject:leaseTerms forKey:@"ContractsUntil"];
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            [self.popover dismissPopoverAnimated:YES];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == HOURS_PICKER_VIEW)
    {
        return self.annualHoursArray.count;
    } 
    else if (pickerView.tag == AIRCRAFT_PICKER_VIEW)
    {
        return self.aircraftArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pickerTitle = @"";
    
    if (pickerView.tag == HOURS_PICKER_VIEW)
    {
        pickerTitle = [self.annualHoursArray objectAtIndex:row];
    } 
    else if (pickerView.tag == AIRCRAFT_PICKER_VIEW)
    {
        pickerTitle = [self.aircraftArray objectAtIndex:row];
    }
    return pickerTitle;
} 

#pragma mark - UIPickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    if (pickerView.tag == HOURS_PICKER_VIEW)
    {
        NSString *annualHoursChoice = [self.annualHoursArray objectAtIndex:row];
        NSString *annualHours;
        if ([annualHoursChoice isEqualToString:@"25 Multi"])
        {
            annualHours = @"25";
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"MultiShare"];
        }
        else if ([annualHoursChoice isEqualToString:@"50 Multi"])
        {
            annualHours = @"50";
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"MultiShare"];
        }
        else 
        {
            annualHours = annualHoursChoice;
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
        }
        [[proposal productParameters] setObject:annualHours forKey:@"AnnualHours"];
        [[proposal productParameters] setObject:annualHoursChoice forKey:@"AnnualHoursChoice"];
    } 
    else if (pickerView.tag == AIRCRAFT_PICKER_VIEW)
    {
        NSString *aircraftChoice = [NFDFlightProposalCalculatorService aircraftTypeNameFromDisplayName:[self.aircraftArray objectAtIndex:row]];
        
        [[proposal productParameters] setObject:aircraftChoice forKey:@"AircraftChoice"];
        [[proposal productParameters] setObject:@"50" forKey:@"AnnualHours"];
        [[proposal productParameters] setObject:@"50" forKey:@"AnnualHoursChoice"];
        [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
        [[proposal productParameters] setObject:@"N/A" forKey:@"Tail"];
    }
    [self shouldDisplayQualifiedControls];
    [self updateSubtitleOfMasterView];
    [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
}

#pragma mark - Button Action Methods

 - (void)aircraftButtonWasTapped:(id)sender
 {
     NFDProposal *proposal = [self retrieveProposalForThisView];
     if (proposal.productCode.intValue == SHARE_LEASE_PRODUCT)
     {
         [self openPickerPopover:sender];
     }
     else 
     {
         [self displayInventoryModalView];
     }
 }
     
- (void)displayInventoryModalView 
{
    if (self.detailViewController)
    {
        [self.detailViewController displayInventoryModalView];
    }
}

- (void)openTablePopover:(id)sender
{
    UITableViewController *popoverContent = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [popoverContent.tableView setScrollEnabled:NO];
    [popoverContent.tableView setDataSource:self];
    [popoverContent.tableView setDelegate:self];
    [popoverContent.tableView reloadData];
    float contentHeight = 0.0; 
    
    NFDProposal *proposal = [self retrieveProposalForThisView];
       
    switch ([(UIButton *)sender tag])
    {
        case FUEL_PERIOD_BUTTON:
        {
            BOOL hasPrepaySelected = ![[[proposal productParameters] objectForKey:@"PrepayEstimate"] isEqualToString:@"None"];
            if (hasPrepaySelected)
            {
                popoverContent = nil;
                return;
            }
            contentHeight = self.fuelRateNames.count * 44;
            [popoverContent.tableView setTag:FUEL_PERIOD_TABLE_VIEW];            
            break;
        }     
        case PREPAY_BUTTON:
        {
            contentHeight = self.prepayEstimateArray.count * 44;
            [popoverContent.tableView setTag:PREPAY_ESTIMATE_TABLE_VIEW];
            break;
        }
        case LEASE_TERM_BUTTON:
        {
            contentHeight = self.leaseTermsArray.count * 44;
            [popoverContent.tableView setTag:LEASE_TERMS_TABLE_VIEW];
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
    
    switch ([(UIButton *)sender tag]) {
        case AIRCRAFT_BUTTON:
        {            
            [pickerView setTag:AIRCRAFT_PICKER_VIEW];
            
            NSString *aircraftChoice = [[proposal productParameters] objectForKey:@"AircraftChoice"];
            if (!aircraftChoice) {
                aircraftChoice = [NFDFlightProposalCalculatorService aircraftTypeNameFromDisplayName:[self.aircraftArray objectAtIndex:0]];
                [[proposal productParameters] setObject:aircraftChoice forKey:@"AircraftChoice"];
                [self updateSubtitleOfMasterView];
                [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            }                   
            
            //Getting display name of aircraft to scroll and set in picker view 
            NSString *ac = [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:aircraftChoice] ;                       
            [pickerView selectRow:[self.aircraftArray indexOfObject:ac] inComponent:0 animated:YES];
            
            break;
        }
        case HOURS_BUTTON:
        {
            [pickerView setTag:HOURS_PICKER_VIEW];
            NSString *annualHoursChoice = [[proposal productParameters] objectForKey:@"AnnualHoursChoice"];
            if (!annualHoursChoice)
            {
                DLog(@"no hours");
            }
            [pickerView selectRow:[self.annualHoursArray indexOfObject:annualHoursChoice] inComponent:0 animated:NO];
            break;
        }            
        default:
            break;
    }
    
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
    [self.aircraftButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.hoursButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.leaseTermButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.fuelMonthsButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.prepayButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
}

- (void)switchFET:(id)sender
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    [[proposal productParameters] setObject:[NSNumber numberWithBool:self.qualifiedFETSwitch.on] forKey:@"Qualified"];
    [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
}

- (IBAction)nextYearSwitchChanged:(id)sender
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    [[proposal productParameters] setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"ShouldApplyNextYearPercentageIncrease"];
    [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
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
