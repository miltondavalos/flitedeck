//
//  NFDFlightProposalManager.m
//  ProposalCalculatorPrototype
//
//  Created by Geoffrey Goetz on 3/7/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalManager.h"
#import "NFDFlightProposalCalculatorService.h"
#import "NFDAircraftInventory.h"
#import "NFDAircraftType.h"
#import "NCLFramework.h"
#import "NFDPersistenceManager.h"

#define calculate_queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define results_queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define other_queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation NFDFlightProposalManager

@synthesize proposals;
@synthesize selectedProposals;
@synthesize aggregated = _aggregated;

//Implementation of Singleton pattern using GCD that is ARC safe
+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject setProposals:[NSMutableArray array]];
        [_sharedObject setSelectedProposals:[NSMutableDictionary dictionary]];
        [_sharedObject setAggregated:NO];
    });
    return _sharedObject;
}

#pragma mark - Proposal/Product Creation

+ (NFDProposal*)createNewProposalForProduct:(int)productCode{

    NFDProposal *proposal = [[NFDProposal alloc] init];
    [proposal setCalculated:NO];
    
    switch (productCode) {
        case SHARE_FINANCE_PRODUCT:{
            [proposal setProductCode:[NSNumber numberWithInt:SHARE_FINANCE_PRODUCT]];
            [proposal setProductType:[NSNumber numberWithInt:SHARE_PRODUCT_TYPE]];
            [proposal setTitle:@"Finance"];
            [proposal setSubTitle:@"Finance"];
            [proposal setTopLabel:@"F"];
            [proposal setBottomLabel:@"Finance"];
            
            //Set Default Parameters
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"MonthsFuel"];
            [[proposal productParameters] setObject:@"25" forKey:@"AnnualHours"];
            [[proposal productParameters] setObject:@"25" forKey:@"AnnualHoursChoice"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ACPreowned"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ShowOperationalHours"];
            [[proposal productParameters] setObject:@"None" forKey:@"PrepayEstimate"];
            [[proposal productParameters] setObject:@"1" forKey:@"SelectedAircraft"];
            [[proposal productParameters] setObject:@"Last" forKey:@"FuelPeriod"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ShouldApplyNextYearPercentageIncrease"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"NextYearPercentageForOHF"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"NextYearPercentageForMMF"];
            
            break;
        }
        case SHARE_PURCHASE_PRODUCT:{
            [proposal setProductCode:[NSNumber numberWithInt:SHARE_PURCHASE_PRODUCT]];
            [proposal setProductType:[NSNumber numberWithInt:SHARE_PRODUCT_TYPE]];
            [proposal setTitle:@"Purchase"];
            [proposal setSubTitle:@"Purchase"];
            [proposal setTopLabel:@"P"];
            [proposal setBottomLabel:@"Purchase"];
            
            //Set Default Parameters
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"MonthsFuel"];
            [[proposal productParameters] setObject:@"25" forKey:@"AnnualHours"];
            [[proposal productParameters] setObject:@"25" forKey:@"AnnualHoursChoice"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ACPreowned"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ShowOperationalHours"];
            [[proposal productParameters] setObject:@"None" forKey:@"PrepayEstimate"];
            [[proposal productParameters] setObject:@"1" forKey:@"SelectedAircraft"];
            [[proposal productParameters] setObject:@"Last" forKey:@"FuelPeriod"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ShouldApplyNextYearPercentageIncrease"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"NextYearPercentageForOHF"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"NextYearPercentageForMMF"];
            
            break;
        }
        case SHARE_LEASE_PRODUCT:{
            [proposal setProductCode:[NSNumber numberWithInt:SHARE_LEASE_PRODUCT]];
            [proposal setProductType:[NSNumber numberWithInt:SHARE_PRODUCT_TYPE]];
            [proposal setTitle:@"Lease"];
            [proposal setSubTitle:@"Lease"];
            [proposal setTopLabel:@"L"];
            [proposal setBottomLabel:@"Lease"];
            
            //Set Default Parameters
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"MonthsFuel"];
            [[proposal productParameters] setObject:@"50" forKey:@"AnnualHours"];
            [[proposal productParameters] setObject:@"50" forKey:@"AnnualHoursChoice"];
            [[proposal productParameters] setObject:@"24 Month" forKey:@"LeaseTerm"];
            [[proposal productParameters] setObject:@"24 Month" forKey:@"ContractsUntil"]; // for compare view 
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ShowOperationalHours"];
            [[proposal productParameters] setObject:@"None" forKey:@"PrepayEstimate"];
            [[proposal productParameters] setObject:@"1" forKey:@"SelectedAircraft"];
            [[proposal productParameters] setObject:@"Last" forKey:@"FuelPeriod"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
            [[proposal productParameters] setObject:@"N/A" forKey:@"Tail"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ShouldApplyNextYearPercentageIncrease"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"NextYearPercentageForOHF"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"NextYearPercentageForMMF"];
            
            break;
        }
        case CARD_PRODUCT:{
            [proposal setProductCode:[NSNumber numberWithInt:CARD_PRODUCT]];
            [proposal setProductType:[NSNumber numberWithInt:CARD_PRODUCT_TYPE]];
            [proposal setTitle:@"Card"];
            [proposal setSubTitle:@"Card"];
            [proposal setTopLabel:@"C"];
            [proposal setBottomLabel:@"Card"];
            
            //Set Default Parameters
            [[proposal productParameters] setObject:@"25 Hour Card" forKey:@"CardHours"];
            [[proposal productParameters] setObject:@"1" forKey:@"NumberOfCards"];
            [[proposal productParameters] setObject:@"Last" forKey:@"FuelPeriod"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"Qualified"];
            [[proposal productParameters] setObject:@"N/A" forKey:@"Tail"];
            [[proposal productParameters] setObject:@"12 Months" forKey:@"ContractsUntil"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"IsCrossCountrySelected"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"CrossCountryPurchasePrice"];
            [[proposal productParameters] setObject:@"None" forKey:@"Incentive"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"ShouldApplyNextYearPercentageIncrease"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"NextYearPercentageForPurchasePrice"];
            
            break;
        }
        case COMBO_CARD_PRODUCT:{
            [proposal setProductCode:[NSNumber numberWithInt:COMBO_CARD_PRODUCT]];
            [proposal setProductType:[NSNumber numberWithInt:CARD_PRODUCT_TYPE]];
            [proposal setTitle:@"Combo Card"];
            [proposal setSubTitle:@"Combo Card"];
            [proposal setTopLabel:@"CC"];
            [proposal setBottomLabel:@"Combo Card"];
            
            //Set Default Parameters
            [[proposal productParameters] setObject:@"25 Hour Combo Card" forKey:@"CardHours"];
            [[proposal productParameters] setObject:@"1" forKey:@"NumberOfCards"];
            [[proposal productParameters] setObject:@"Last" forKey:@"FuelPeriod"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"Qualified"];
            [[proposal productParameters] setObject:@"N/A" forKey:@"Tail"];
            [[proposal productParameters] setObject:@"12 Months" forKey:@"ContractsUntil"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
            
            break;
        }
        case PHENOM_TRANSITION_LEASE_PRODUCT:{
            [proposal setProductCode:[NSNumber numberWithInt:PHENOM_TRANSITION_LEASE_PRODUCT]];
            [proposal setProductType:[NSNumber numberWithInt:PHENOM_TRANSITION_PRODUCT_TYPE]];
            [proposal setTitle:@"Phenom Transition"];
            [proposal setSubTitle:@"Excel Lease > Phenom Purchase"];
            [proposal setTopLabel:@"PT"];
            [proposal setBottomLabel:@"Phenom Transition"];
            
            //Set Default Parameters
            [[proposal productParameters] setObject:@"Phenom" forKey:@"AircraftChoice"];
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"MonthsFuel"];
            [[proposal productParameters] setObject:@"50" forKey:@"AnnualHours"];
            [[proposal productParameters] setObject:@"50" forKey:@"AnnualHoursChoice"];
            [[proposal productParameters] setObject:@"Last" forKey:@"FuelPeriod"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
            [[proposal productParameters] setObject:@"None" forKey:@"PrepayEstimate"];
            [[proposal productParameters] setObject:@"N/A" forKey:@"Tail"];
            [[proposal productParameters] setObject:@"TBD" forKey:@"ContractsUntil"];
            
            break;
        }
        case PHENOM_TRANSITION_PURCHASE_PRODUCT:{
            [proposal setProductCode:[NSNumber numberWithInt:PHENOM_TRANSITION_PURCHASE_PRODUCT]];
            [proposal setProductType:[NSNumber numberWithInt:PHENOM_TRANSITION_PRODUCT_TYPE]];
            [proposal setTitle:@"Phenom Transition"];
            [proposal setSubTitle:@""];
            [proposal setTopLabel:@"PT"];
            [proposal setBottomLabel:@"Phenom Transition"];
            
            //Set Default Parameters
            [[proposal productParameters] setObject:[NSNumber numberWithInt:0] forKey:@"MonthsFuel"];
            [[proposal productParameters] setObject:@"50" forKey:@"AnnualHours"];
            [[proposal productParameters] setObject:@"50" forKey:@"AnnualHoursChoice"];
            [[proposal productParameters] setObject:@"Last" forKey:@"FuelPeriod"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"Qualified"];
            [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
            [[proposal productParameters] setObject:@"None" forKey:@"PrepayEstimate"];
            [[proposal productParameters] setObject:@"TBD" forKey:@"Tail"];
            [[proposal productParameters] setObject:@"5 Years" forKey:@"ContractsUntil"];
            
            break;
        }
        default:{
            break;
        }
    }
    
    return proposal;
}

#pragma mark - Manage Proposals

- (BOOL)hasProposals{

    if ([self.proposals count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (int)totalCountOfProposals{

    if (self.proposals == nil) {
        return 0;
    } else {
        return [self.proposals count];
    }
}

- (BOOL)includesPhenom
{
    if (self.proposals.count > 1)
    {
        for (NFDProposal *proposal in self.proposals)
        {
            if (proposal.productType.intValue == PHENOM_TRANSITION_PRODUCT_TYPE)
            {
                return YES;
            }
        }
    }
    return NO;
}

- (NFDProposal*)retrieveProposalAtIndex:(int)index{

    NFDProposal *retrievedProposal;
    if (self.hasProposals){
        retrievedProposal = [self.proposals objectAtIndex:index];
    }
    if (retrievedProposal) {
        return retrievedProposal;
    } else {
        return nil;
    }
}

- (NFDProposal *)retrieveProposalWithId:(NSString *)identifier
{
    for (NFDProposal *proposal in self.proposals)
    {
        if ([[proposal uniqueIdentifier] isEqualToString:identifier])
        {
            return proposal;
        }
    }
    return nil;
}

- (BOOL)hasSelectedProposals{

    if ([self.selectedProposals count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (int)totalCountOfSelectedProposals{    
    if (self.selectedProposals == nil) {
        return 0;
    } else {
        return [self.selectedProposals count];
    }
}

- (NFDProposal*)retrieveSelectedProposalForKey:(int)key{

    NFDProposal *retrievedProposal;
    if (self.hasSelectedProposals){
        retrievedProposal = [self.selectedProposals objectForKey:[NSNumber numberWithInt:key]];
    }
    if (retrievedProposal) {
        return retrievedProposal;
    } else {
        return nil;
    }
}

- (NSArray*)retrieveAllSelectedProposals
{
    return [[[self selectedProposals] allValues] sortedArrayUsingComparator:^NSComparisonResult(NFDProposal *obj1, NFDProposal *obj2) {
        if (obj1.productCode.intValue > obj2.productCode.intValue) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.productCode.intValue < obj2.productCode.intValue) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;       
    }];
}


- (void)clearAllProposals{

    [self.proposals removeAllObjects];
    [self.selectedProposals removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:PROPOSAL_LIST_UPDATED object:nil];
}

#pragma mark - Calculate Results

- (BOOL)canDispalyCompareView{

    if ([self hasSelectedProposals]){
        NSEnumerator *e = [[self selectedProposals] objectEnumerator];
        NFDProposal *selectedProposal;
        while (selectedProposal = [e nextObject]) {
            if (![selectedProposal hasBeenCalculated]){
                return NO;
            }
        }
        return YES;
    }else{
        return NO;
    }
}

-(void)calculateShareResultForProposal:(NFDProposal*)proposal{
    //Determine the correct AircraftTypeName to be used in Calculations
    NFDAircraftInventory *aircraftInventory = [[proposal productParameters] objectForKey:@"AircraftInventory"];
    NSString *aircraftTypeName = @"";
    NSNumber *acquisitionCost = [NSNumber numberWithInt:0];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSNumber *vintage = [NSNumber numberWithInteger:[components year]];
    if ([proposal.productCode intValue] == SHARE_LEASE_PRODUCT)
    {
        aircraftTypeName = [[proposal productParameters] objectForKey:@"AircraftChoice"];
    }
    else
    {
        if (aircraftInventory)
        {
            aircraftTypeName = [aircraftInventory type];
            // set "AircraftChoice" in dictionary for later use.
            [[proposal productParameters] setObject:[aircraftInventory legal_name] forKey:@"AircraftChoice"];
            //Calculate Acquisiiton Cost
            NSString *hoursString = [[proposal productParameters] objectForKey:@"AnnualHours"];
            NSNumber *aircraftValue = [NSNumber numberWithFloat:[[aircraftInventory sales_value] floatValue]];
            NSNumber *annualHours = [NSNumber numberWithFloat:[hoursString floatValue]];
            acquisitionCost = [NFDFlightProposalCalculatorService calculateAcquisitionCostFromAircraftValue:aircraftValue andAnnualHours:annualHours];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            vintage = [formatter numberFromString:[aircraftInventory year]];
        }
    }
    [proposal.calculatedResults setObject:acquisitionCost forKey:@"PurchasePrice"];
    
    //Retrieve the Share Size from Product Parameters
    NSString *shareSize = [[proposal productParameters] objectForKey:@"AnnualHours"];
    BOOL isMultiShare = [[[proposal productParameters] objectForKey:@"MultiShare"] boolValue];
    //Retrieve the Fuel Period Choice from Product Parameters
    NSString *fuelPeriodChoice = [[proposal productParameters] objectForKey:@"FuelPeriod"];

    BOOL isQualified = [[[proposal productParameters] objectForKey:@"Qualified"] boolValue];
    
    NSNumber *mgtFeeRate = [NSNumber numberWithInt:0];
    NSNumber *mgtFeeAnnual = [NSNumber numberWithInt:0];
    NSNumber *ohfRate = [NSNumber numberWithInt:0];
    NSNumber *ohfAnnual = [NSNumber numberWithInt:0];
    NSNumber *fuelVariableRate = [NSNumber numberWithInt:0];
    NSNumber *fuelVariableTotal = [NSNumber numberWithInt:0];
    NSString *leaseTerms = @"";
    NSNumber *monthlyLeaseFee = [NSNumber numberWithInt:0];
    NSNumber *annualLeaseFee = [NSNumber numberWithInt:0];
    NSNumber *monthlyLeaseFeeFET = [NSNumber numberWithInt:0];
    NSNumber *annualLeaseFeeFET = [NSNumber numberWithInt:0];
    NSNumber *operationalAnnualCost = [NSNumber numberWithInt:0];
    NSNumber *operationalAverageHourlyCost = [NSNumber numberWithInt:0];
    NSNumber *fetAnnual = [NSNumber numberWithInt:0];
    NSNumber *deposit = [NSNumber numberWithInt:0];
    
    NSNumber *nextYearPercentageForOHF = nil;
    NSNumber *nextYearPercentageForMMF = nil;
    BOOL shouldApplyNextYearPercentageIncrease = [[[proposal productParameters] objectForKey:@"ShouldApplyNextYearPercentageIncrease"] boolValue];
    
    if (shouldApplyNextYearPercentageIncrease) {
        nextYearPercentageForOHF = [[proposal productParameters] objectForKey:@"NextYearPercentageForOHF"];
        nextYearPercentageForMMF = [[proposal productParameters] objectForKey:@"NextYearPercentageForMMF"];
    }
    
    switch ([proposal.productCode intValue]) 
    {
        case SHARE_PURCHASE_PRODUCT:
            //Calculate Monthly Management Fee: Rate and Annual Values for Purchase and Finance
            mgtFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftTypeName andAircraftVintage:[aircraftInventory year] andShareSize:shareSize isMultiShare:isMultiShare];
            mgtFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftTypeName andAircraftVintage:[aircraftInventory year] andShareSize:shareSize isMultiShare:isMultiShare];
            
            //Calculate Occupied Hourly Fee: Rate and Annual Values for Purchase and Finance
            ohfRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftTypeName andVintage:[aircraftInventory year]];
            ohfAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftTypeName vintage:[aircraftInventory year] andShareSize:shareSize];
            
            //Calculate Fuel Variable: Rate and Annual Values for Purchase and Finance 
            fuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:aircraftTypeName andFuelPeriod:fuelPeriodChoice isQualified:isQualified];
            fuelVariableTotal = [NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:aircraftTypeName andFuelPeriod:fuelPeriodChoice forNumberOfHours:shareSize isQualified:isQualified];   
            
            fetAnnual = [NFDFlightProposalCalculatorService calculateShareOperationalFederalExciseTaxForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize andFuelPeriod:fuelPeriodChoice isQualified:isQualified isMultiShare:isMultiShare];
            
            operationalAnnualCost = [NFDFlightProposalCalculatorService calculateShareOperationalAnnualCostForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize andFuelPeriod:fuelPeriodChoice nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:isQualified isMultiShare:isMultiShare];
            
            operationalAverageHourlyCost = [NFDFlightProposalCalculatorService calculateShareOperationalAverageHourlyCostForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize andFuelPeriod:fuelPeriodChoice nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:isQualified isMultiShare:isMultiShare];
            
            deposit = [NFDFlightProposalCalculatorService calculateDepositFromAcquisitionCost:acquisitionCost qualified:isQualified];
            
            break;
        case SHARE_FINANCE_PRODUCT:
            //Calculate Monthly Management Fee: Rate and Annual Values for Purchase and Finance
            mgtFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftTypeName andAircraftVintage:[aircraftInventory year] andShareSize:shareSize isMultiShare:isMultiShare];
            mgtFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftTypeName andAircraftVintage:[aircraftInventory year] andShareSize:shareSize isMultiShare:isMultiShare];

            //Calculate Occupied Hourly Fee: Rate and Annual Values for Purchase and Finance
            ohfRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftTypeName andVintage:[aircraftInventory year]];
            ohfAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftTypeName vintage:[aircraftInventory year] andShareSize:shareSize];            

            //Calculate Fuel Variable: Rate and Annual Values for Purchase and Finance 
            fuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:aircraftTypeName andFuelPeriod:fuelPeriodChoice isQualified:isQualified];
            fuelVariableTotal = [NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:aircraftTypeName andFuelPeriod:fuelPeriodChoice forNumberOfHours:shareSize isQualified:isQualified];   
            
            fetAnnual = [NFDFlightProposalCalculatorService calculateShareOperationalFederalExciseTaxForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize andFuelPeriod:fuelPeriodChoice isQualified:isQualified isMultiShare:isMultiShare];
            
            operationalAnnualCost = [NFDFlightProposalCalculatorService calculateFinanceOperationalAnnualCostForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize andFuelPeriod:fuelPeriodChoice nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:isQualified withAcquisitionCost:acquisitionCost isMultiShare:isMultiShare];
            
            operationalAverageHourlyCost = [NFDFlightProposalCalculatorService calculateFinanceOperationalAverageHourlyCostForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize andFuelPeriod:fuelPeriodChoice nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:isQualified withAcquisitionCost:acquisitionCost isMultiShare:isMultiShare];
            
            break;
        case SHARE_LEASE_PRODUCT:
            //Calculate Monthly Lease Fee
            leaseTerms = [[proposal productParameters] objectForKey:@"LeaseTerm"];
            monthlyLeaseFee = [NFDFlightProposalCalculatorService calculateMonthlyLeaseFeeForAircraftType:aircraftTypeName annualHours:shareSize leaseTerm:leaseTerms];
            annualLeaseFee = [NFDFlightProposalCalculatorService calculateAnnualLeaseFeeForAircraftType:aircraftTypeName annualHours:shareSize leaseTerm:leaseTerms];
            monthlyLeaseFeeFET = [NFDFlightProposalCalculatorService calculateMonthlyLeaseFeeFETForAircraftType:aircraftTypeName annualHours:shareSize leaseTerm:leaseTerms isQualified:isQualified];
            annualLeaseFeeFET = [NFDFlightProposalCalculatorService calculateAnnualLeaseFETForAircraftType:aircraftTypeName annualHours:shareSize leaseTerm:leaseTerms isQualified:isQualified];
            //Calculate Monthly Management Fee: Rate and Annual Values for Lease
            mgtFeeRate = [NFDFlightProposalCalculatorService calculateLeaseMonthlyManagementFeeRateForAircraftType:aircraftTypeName andShareSize:shareSize isMultiShare:isMultiShare];
            mgtFeeAnnual = [NFDFlightProposalCalculatorService calculateLeaseMonthlyManagementFeeAnnualForAircraftType:aircraftTypeName andShareSize:shareSize isMultiShare:isMultiShare];

            //Calculate Occupied Hourly Fee: Rate and Annual Values for Lease
            ohfRate = [NFDFlightProposalCalculatorService calculateLeaseOccupiedHourlyFeeRateForAircraftType:aircraftTypeName];
            ohfAnnual = [NFDFlightProposalCalculatorService calculateLeaseOccupiedHourlyFeeAnnualForAircraftType:aircraftTypeName andShareSize:shareSize];

            //Calculate Fuel Variable: Rate and Annual Values for Lease
            fuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:aircraftTypeName andFuelPeriod:fuelPeriodChoice isQualified:isQualified];
            
            fuelVariableTotal = [NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:aircraftTypeName andFuelPeriod:fuelPeriodChoice forNumberOfHours:shareSize isQualified:isQualified];
            
            fetAnnual = [NFDFlightProposalCalculatorService calculateLeaseOperationalFederalExciseTaxForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize andFuelPeriod:fuelPeriodChoice isQualified:isQualified isMultiShare:isMultiShare];
            
            operationalAnnualCost = [NFDFlightProposalCalculatorService calculateLeaseOperationalAnnualCostForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize leaseTerm:leaseTerms andFuelPeriod:fuelPeriodChoice nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:isQualified isMultiShare:isMultiShare];
            
            operationalAverageHourlyCost = [NFDFlightProposalCalculatorService calculateLeaseOperationalAverageHourlyCostForAircraftType:aircraftTypeName vintage:[aircraftInventory year] shareSize:shareSize leaseTerm:leaseTerms andFuelPeriod:fuelPeriodChoice nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:isQualified isMultiShare:isMultiShare];
            
            deposit = [NFDFlightProposalCalculatorService calculateMonthlyLeaseDepositForAircraftType:aircraftTypeName annualHours:shareSize leaseTerm:leaseTerms isQualified:isQualified];
            break;
        default:
            break;
    }
    
    if (shouldApplyNextYearPercentageIncrease) {
        ohfRate = [NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForOHF andInitialCost:ohfRate];
        ohfAnnual = [NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForOHF andInitialCost:ohfAnnual];
        
        mgtFeeRate = [NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForMMF andInitialCost:mgtFeeRate];
        mgtFeeAnnual = [NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForMMF andInitialCost:mgtFeeAnnual];
    }
    
    //Calculate Federal Excise Tax
    NSNumber *fetRate = [NSNumber numberWithInt:0];

    
    NSNumber *fetPurchase = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForAcquisitionCost:acquisitionCost];
    
    if (mgtFeeRate){
        [proposal.calculatedResults setObject:mgtFeeRate forKey:@"MonthlyManagementFeeRate"];
    }else{
        mgtFeeRate = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:mgtFeeRate forKey:@"MonthlyManagementFeeRate"];
    }
    if (mgtFeeAnnual){
        [proposal.calculatedResults setObject:mgtFeeAnnual forKey:@"MonthlyManagementFeeAnnual"];
    }else{
        mgtFeeAnnual = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:mgtFeeAnnual forKey:@"MonthlyManagementFeeAnnual"];
    }
    if (ohfRate){
        [proposal.calculatedResults setObject:ohfRate forKey:@"OccupiedHourlyFeeRate"];
    }else{
        ohfRate = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:ohfRate forKey:@"OccupiedHourlyFeeRate"];
    }
    if (ohfAnnual){
        [proposal.calculatedResults setObject:ohfAnnual forKey:@"OccupiedHourlyFeeAnnual"];
    }else{
        ohfAnnual = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:ohfAnnual forKey:@"OccupiedHourlyFeeAnnual"];
    }
    if (fuelVariableRate){
        [proposal.calculatedResults setObject:fuelVariableRate forKey:@"FuelVariableRate"];
    }else{
        fuelVariableRate = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:fuelVariableRate forKey:@"FuelVariableRate"];
    }
    
    if (monthlyLeaseFee)
    {
        [proposal.calculatedResults setObject:monthlyLeaseFee forKey:@"MonthlyLeaseFeeRate"];
    }
    
    if (annualLeaseFee)
    {
        [proposal.calculatedResults setObject:annualLeaseFee forKey:@"MonthlyLeaseFeeAnnual"];
    }
    
    if (annualLeaseFeeFET)
    {
        [proposal.calculatedResults setObject:annualLeaseFeeFET forKey:@"MonthlyLeaseFeeFETAnnual"];
    }
    
    if (fuelVariableTotal)
    {
        [proposal.calculatedResults setObject:fuelVariableTotal forKey:@"FuelVariableAnnual"];
    }
    else
    {
        fuelVariableTotal = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:fuelVariableTotal forKey:@"FuelVariableAnnual"];
    }
    

    if (fetRate && !isQualified)
    {
        [proposal.calculatedResults setObject:fetRate forKey:@"FederalExciseTaxRate"];
    }
    else
    {
        fetRate = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:fetRate forKey:@"FederalExciseTaxRate"];
    }
    
    if (fetAnnual && !isQualified)
    {
        [proposal.calculatedResults setObject:fetAnnual forKey:@"FederalExciseTaxAnnual"];
    }
    else
    {
        fetAnnual = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:fetAnnual forKey:@"FederalExciseTaxAnnual"];
    }
    
    if (monthlyLeaseFeeFET && !isQualified)
    {
        [proposal.calculatedResults setObject:monthlyLeaseFeeFET forKey:@"MonthlyLeaseFeeFETRate"];
    }
    else 
    {
        monthlyLeaseFeeFET = [NSNumber numberWithInt:0];
        [proposal.calculatedResults setObject:monthlyLeaseFeeFET forKey:@"MonthlyLeaseFeeFETRate"];
    }
    
    if (proposal.productCode.intValue == SHARE_PURCHASE_PRODUCT)
    {
        if (fetPurchase && !isQualified)
        {
            [proposal.calculatedResults setObject:fetPurchase forKey:@"FederalExciseTaxPurchase"];
        }
        else
        {
            fetPurchase = [NSNumber numberWithInt:0];
            [proposal.calculatedResults setObject:fetPurchase forKey:@"FederalExciseTaxPurchase"];
        } 
    }
    
    if (proposal.productCode.intValue == SHARE_FINANCE_PRODUCT)
    {
        NSNumber *calcCost = acquisitionCost;
        if (fetPurchase && !isQualified)
        {
            calcCost = [NSNumber numberWithDouble:(acquisitionCost.doubleValue + fetPurchase.doubleValue)];
        }
        
        //Calculate DownPayment
        NSNumber *downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:calcCost];
        [proposal.calculatedResults setObject:downPayment forKey:@"DownPayment"];

        //Calculate FinancedAmount
        NSNumber *financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:calcCost];
        [proposal.calculatedResults setObject:financedAmount forKey:@"FinancedAmount"];

        //Calculate MonthlyPayment
        NSNumber *monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:calcCost forVintage:vintage forDisplay:YES];
        [proposal.calculatedResults setObject:monthlyPayment forKey:@"MonthlyPayment"];

        //Calculate BalloonPayment
        NSNumber *balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:calcCost forVintage:vintage];
        [proposal.calculatedResults setObject:balloonPayment forKey:@"BalloonPayment"];
        
        [proposal.calculatedResults setObject:[NSNumber numberWithInt:0] forKey:@"PurchasePrice"];
    }
    
    NSNumber *fetForAnnualCost = [NSNumber numberWithInt:0];
    if (isQualified) {
        fetForAnnualCost = fetAnnual;
    }
    
    if (proposal.productCode.intValue == SHARE_LEASE_PRODUCT)
    {
        [proposal.calculatedResults setObject:deposit forKey:@"Deposit"];
    }
    
    if (proposal.productCode.intValue == SHARE_PURCHASE_PRODUCT)
    {
        [proposal.calculatedResults setObject:deposit forKey:@"Deposit"];
    }

    [proposal.calculatedResults setObject:operationalAnnualCost forKey:@"AnnualCost"];

    [proposal.calculatedResults setObject:operationalAverageHourlyCost forKey:@"AverageHourlyCost"];
    
    //****************************** THE LINE ******************************
    
    //Temporary Date Display (remove when all calculations are in place)
    NSDate *tempDate = [NSDate date];
    [proposal.calculatedResults setObject:tempDate forKey:@"result"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSSecondCalendarUnit fromDate:tempDate];
    NSString *tempString = [NSString stringWithFormat:@"%i", comps.second];
   
    [proposal.calculatedResults setObject:tempString forKey:@"PLACEHOLDER"];
    
    //Calculate Prepayment Savings
    NSNumber *prepaymentSavings = [NSNumber numberWithInt:0];
    NSString *prepayEstimate = [[proposal productParameters] objectForKey:@"PrepayEstimate"];
    
    
    //Issue:245 - Hard wire prepay fuel variable to 3 month value
    NSNumber *PrepayFuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:aircraftTypeName andFuelPeriod:MONTH_RATE_3_MONTHS isQualified:isQualified];
    
    NSString *hoursString = [[proposal productParameters] objectForKey:@"AnnualHours"];
    prepaymentSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:prepayEstimate usingMMF:mgtFeeRate andOHF:ohfRate andFuel:PrepayFuelVariableRate andLease:monthlyLeaseFee havingAnnualHoursOf:[NSNumber numberWithInt:[hoursString intValue]] isQualified:isQualified];
   
    [proposal.calculatedResults setObject:prepaymentSavings forKey:@"PrepaymentSavings"];
    
}

-(void)calculateCardResultForProposal:(NFDProposal*)proposal{
    
    //Temporary Date Display (remove when all calculations are in place)
    NSDate *tempDate = [NSDate date];
    [proposal.calculatedResults setObject:tempDate forKey:@"result"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSSecondCalendarUnit fromDate:tempDate];
    NSNumber *tempNumber = [NSNumber numberWithInteger:comps.second];

    
    NSString *aircraftGroupName = [[proposal productParameters] objectForKey:@"AircraftChoice"];
    NSString *cardType = [[proposal productParameters] objectForKey:@"CardHours"];
    

    int numberOfCards = [[[proposal productParameters] objectForKey:@"NumberOfCards"] intValue];
    
    // total hours for later use.
    float numberOfHours = [[NFDFlightProposalCalculatorService hoursForCardType:cardType] floatValue] * numberOfCards;
    [[proposal productParameters] setObject:[NSNumber numberWithFloat:numberOfHours] forKey:@"AnnualHours"];
    
    NSString *fuelPeriodChoice = [[proposal productParameters] objectForKey:@"FuelPeriod"];
    
    //Calculate Fuel Variable: Rate and Annual Values
    NSNumber *fuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriodChoice isQualified:NO];
    NSNumber *fuelVariableTotal = [NFDFlightProposalCalculatorService fuelVariableTotalForAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriodChoice forCardType:cardType andNumberOfCards:numberOfCards];
    
    [proposal.calculatedResults setObject:fuelVariableRate forKey:@"FuelVariableRate"];
    [proposal.calculatedResults setObject:fuelVariableTotal forKey:@"FuelVariableAnnual"];

//    NSNumber *fuelFETRate = [NFDFlightProposalCalculatorService calculateCardFuelFETRateforAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriodChoice];
    
    NSNumber *fuelFETAnnual = [NFDFlightProposalCalculatorService calculateCardFuelFETAnnualforAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards andFuelPeriod:fuelPeriodChoice];
    //Calculate Variable Federal Excise Tax: Rate and Annual Values
    [proposal.calculatedResults setObject:@"7.5%" forKey:@"FederalExciseTaxRate"];
    [proposal.calculatedResults setObject:fuelFETAnnual forKey:@"FederalExciseTaxAnnual"];

    [proposal.calculatedResults setObject:tempNumber forKey:@"PLACEHOLDER"];
    
    //Calculate Purchase Price Federal Excise Tax and Purchase Price
    if ([[[proposal productParameters] objectForKey:@"IsCrossCountrySelected"] boolValue]) {
        NSNumber *crossCountryPurchasePrice = [[proposal productParameters] objectForKey:@"CrossCountryPurchasePrice"];
        
        if ([[[proposal productParameters] objectForKey:@"ShouldApplyNextYearPercentageIncrease"] boolValue]) {
            NSNumber *nextYearPercentageForPurchasePrice = [[proposal productParameters] objectForKey:@"NextYearPercentageForPurchasePrice"];
            crossCountryPurchasePrice = [NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForPurchasePrice andInitialCost:crossCountryPurchasePrice];
        }
        
        [[proposal calculatedResults] setObject:crossCountryPurchasePrice forKey:@"PurchasePrice"];
        
        [proposal.calculatedResults setObject:[NFDFlightProposalCalculatorService calculateCardPurchaseFETForPurchasePrice:crossCountryPurchasePrice] forKey:@"FederalExciseTaxPurchase"];
        
        [[proposal calculatedResults] setObject:[NFDFlightProposalCalculatorService calculateCardTotalCostForAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards fuelPeriod:fuelPeriodChoice andPurchasePrice:crossCountryPurchasePrice] forKey:@"AnnualCost"];
        
        [[proposal calculatedResults] setObject:[NFDFlightProposalCalculatorService calculateCardAverageHourlyCostForAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards fuelPeriod:fuelPeriodChoice andPurchasePrice:crossCountryPurchasePrice] forKey:@"AverageHourlyCost"];
    } else {
        NSNumber *purchasePrice = [NFDFlightProposalCalculatorService calculateCardPurchasePriceForAircraftGroupName:aircraftGroupName cardType:cardType andNumberOfCards:numberOfCards];
        
        if ([[[proposal productParameters] objectForKey:@"ShouldApplyNextYearPercentageIncrease"] boolValue]) {
            NSNumber *nextYearPercentageForPurchasePrice = [[proposal productParameters] objectForKey:@"NextYearPercentageForPurchasePrice"];
            purchasePrice = [NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForPurchasePrice andInitialCost:purchasePrice];
            
            [proposal.calculatedResults setObject:[NFDFlightProposalCalculatorService calculateCardPurchaseFETForPurchasePrice:purchasePrice] forKey:@"FederalExciseTaxPurchase"];
            
            [[proposal calculatedResults] setObject:purchasePrice forKey:@"PurchasePrice"];
            
            [[proposal calculatedResults] setObject:[NFDFlightProposalCalculatorService calculateCardTotalCostForAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards fuelPeriod:fuelPeriodChoice andPurchasePrice:purchasePrice] forKey:@"AnnualCost"];
            
            [[proposal calculatedResults] setObject:[NFDFlightProposalCalculatorService calculateCardAverageHourlyCostForAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards fuelPeriod:fuelPeriodChoice andPurchasePrice:purchasePrice] forKey:@"AverageHourlyCost"];
        } else {
            [[proposal calculatedResults] setObject:purchasePrice forKey:@"PurchasePrice"];
            
            [proposal.calculatedResults setObject:[NFDFlightProposalCalculatorService calculateCardPurchaseFETForAircraftGroupName:aircraftGroupName cardType:cardType andNumberOfCards:numberOfCards] forKey:@"FederalExciseTaxPurchase"];
            
            [[proposal calculatedResults] setObject:[NFDFlightProposalCalculatorService calculateCardTotalCostForAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards andFuelPeriod:fuelPeriodChoice] forKey:@"AnnualCost"];
            
            [[proposal calculatedResults] setObject:[NFDFlightProposalCalculatorService calculateCardAverageHourlyCostForAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards andFuelPeriod:fuelPeriodChoice] forKey:@"AverageHourlyCost"];
        }
    }

}


-(void)calculateComboCardResultForProposal:(NFDProposal*)proposal{
    
    //Temporary Date Display (remove when all calculations are in place)
    NSDate *tempDate = [NSDate date];
    [proposal.calculatedResults setObject:tempDate forKey:@"result"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSSecondCalendarUnit fromDate:tempDate];
    NSNumber *tempNumber = [NSNumber numberWithInteger:comps.second];
    
    [proposal.calculatedResults setObject:tempNumber forKey:@"PLACEHOLDER"];
    
    NSArray *aircraftChoices = [[[proposal productParameters] objectForKey:@"AircraftChoice"] componentsSeparatedByString:@"\r"];
    //NSString *aircraftGroupName = [[proposal productParameters] objectForKey:@"AircraftChoice"];
    
    NSString *cardType = [[proposal productParameters] objectForKey:@"CardHours"]; // <- should always be 25
    
    
    int numberOfCards = [[[proposal productParameters] objectForKey:@"NumberOfCards"] intValue];
    
    // total hours for later use.
    float numberOfHours = [[NFDFlightProposalCalculatorService hoursForCardType:cardType] floatValue] * numberOfCards;
    [[proposal productParameters] setObject:[NSNumber numberWithFloat:numberOfHours] forKey:@"AnnualHours"];
    
    NSString *fuelPeriodChoice = [[proposal productParameters] objectForKey:@"FuelPeriod"];
    
    //Calculate Fuel Variable: Rate and Annual Values
    
    NSNumber *fuelVariableRate = [NFDFlightProposalCalculatorService comboCardFuelVariableRateForAircraftGroupNames:aircraftChoices andFuelPeriod:fuelPeriodChoice];
    NSNumber *fuelVariableTotal = [NFDFlightProposalCalculatorService comboCardFuelVariableTotalForAircraftGroupNames:aircraftChoices andFuelPeriod:fuelPeriodChoice andNumberOfCards:numberOfCards];
        
    [proposal.calculatedResults setObject:fuelVariableRate forKey:@"FuelVariableRate"];
    [proposal.calculatedResults setObject:fuelVariableTotal forKey:@"FuelVariableAnnual"];

    
//    NSNumber *fuelFETRate = [NFDFlightProposalCalculatorService comboCardFuelFETRateForAircraftGroupNames:aircraftChoices andFuelPeriod:fuelPeriodChoice];
    NSNumber *fuelFETTotal = [NFDFlightProposalCalculatorService comboCardFuelFETTotalForAircraftGroupNames:aircraftChoices andFuelPeriod:fuelPeriodChoice andNumberOfCards:numberOfCards];

    [proposal.calculatedResults setObject:@"7.5%" forKey:@"FederalExciseTaxRate"];
    [proposal.calculatedResults setObject:fuelFETTotal forKey:@"FederalExciseTaxAnnual"];
    
    //Calulate Purchase Price, FET, Annual and Average hourly cost
    
    NSNumber *purchasePrice = [NFDFlightProposalCalculatorService calculateComboCardPurchasePriceForAircraftGroupNames:aircraftChoices andNumberOfCards:numberOfCards];
    NSNumber *purchaseFET = 0;
    NSNumber *annualCost = 0;
    NSNumber *hourlyCost = 0;
    
    
    if ([[[proposal productParameters] objectForKey:@"ShouldApplyNextYearPercentageIncrease"] boolValue]) {
        NSNumber *nextYearPercentageForPurchasePrice = [[proposal productParameters] objectForKey:@"NextYearPercentageForPurchasePrice"];
        purchasePrice = [NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForPurchasePrice andInitialCost:purchasePrice];
        
        purchaseFET = [NFDFlightProposalCalculatorService calculateCardPurchaseFETForPurchasePrice:purchasePrice];
        
        annualCost = [NFDFlightProposalCalculatorService calculateComboCardTotalCostForAircraftGroupNames:aircraftChoices purchasePrice:purchasePrice purchaseFET:purchaseFET numberOfCards:numberOfCards andFuelPeriod:fuelPeriodChoice];
        hourlyCost = [NFDFlightProposalCalculatorService calculateComboCardAverageHourlyCostForTotalCost:annualCost andNumberOfCards:numberOfCards];
    } else {
        purchaseFET = [NFDFlightProposalCalculatorService calculateComboCardPurchaseFETForAircraftGroupNames:aircraftChoices andNumberOfCards:numberOfCards];
        
        annualCost = [NFDFlightProposalCalculatorService calculateComboCardTotalCostForAircraftGroupNames:aircraftChoices numberOfCards:numberOfCards andFuelPeriod:fuelPeriodChoice];
        hourlyCost = [NFDFlightProposalCalculatorService calculateComboCardAverageHourlyCostForAircraftGroupNames:aircraftChoices numberOfCards:numberOfCards andFuelPeriod:fuelPeriodChoice];
    }

    [proposal.calculatedResults setObject:purchasePrice forKey:@"PurchasePrice"];    
    [proposal.calculatedResults setObject:purchaseFET forKey:@"FederalExciseTaxPurchase"];
    [proposal.calculatedResults setObject:annualCost forKey:@"AnnualCost"];
    [proposal.calculatedResults setObject:hourlyCost forKey:@"AverageHourlyCost"];
    
}

-(void)calculatePhenomTransitionResultForProposal:(NFDProposal*)proposal{

    //Temporary Date Display (remove when all calculations are in place)
    NSDate *tempDate = [NSDate date];
    [proposal.calculatedResults setObject:tempDate forKey:@"result"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSSecondCalendarUnit fromDate:tempDate];
    NSNumber *tempNumber = [NSNumber numberWithInteger:comps.second];
    
    [proposal.calculatedResults setObject:tempNumber forKey:@"PLACEHOLDER"];
    NSString *phenomLeaseAircraftTypeName = @"CE-560XLS";
    NSString *phenomPurchaseAircraftTypeName = @"EMB-505S";
    
    NSString *leaseAnnualHours = [[proposal productParameters] objectForKey:@"AnnualHours"];
    NSString *purchaseAnnualHours = [[proposal.relatedProposal productParameters] objectForKey:@"AnnualHours"];
    BOOL leaseIsMultiShare = [[[proposal productParameters] objectForKey:@"MultiShare"] boolValue];
    BOOL purchaseIsMultiShare = [[[proposal.relatedProposal productParameters] objectForKey:@"MultiShare"] boolValue];
    NSString *fuelPeriodChoice = [[proposal productParameters] objectForKey:@"FuelPeriod"];
    
    NSString *leaseTerm = @"36 Month";
    
    BOOL isQualified = [[[proposal productParameters] objectForKey:@"Qualified"] boolValue];

    // monthly lease fee
    NSNumber *phenomLeaseMonthlyLeaseFee = [NFDFlightProposalCalculatorService calculateMonthlyLeaseFeeForAircraftType:phenomLeaseAircraftTypeName annualHours:leaseAnnualHours leaseTerm:leaseTerm];
    
    NSNumber *phenomLeaseAnnualLeaseFee = [NFDFlightProposalCalculatorService calculateAnnualLeaseFeeForAircraftType:phenomLeaseAircraftTypeName annualHours:leaseAnnualHours leaseTerm:leaseTerm];
    
    // lease FET
    NSNumber *phenomLeaseLeaseFETRate = [NFDFlightProposalCalculatorService calculateMonthlyLeaseFeeFETForAircraftType:phenomLeaseAircraftTypeName annualHours:leaseAnnualHours leaseTerm:leaseTerm isQualified:isQualified];
    
    NSNumber *phenomLeaseLeaseFETRateAnnual = [NFDFlightProposalCalculatorService calculateAnnualLeaseFETForAircraftType:phenomLeaseAircraftTypeName annualHours:leaseAnnualHours leaseTerm:leaseTerm isQualified:isQualified];
    
    // lease OHF - use Phenom OHF
    NSNumber *phenomLeaseOccupiedHourlyFee = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:phenomPurchaseAircraftTypeName andVintage:@"2013"];
    
    NSNumber *phenomLeaseOccupiedAnnualFee = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:phenomPurchaseAircraftTypeName vintage:@"2013" andShareSize:purchaseAnnualHours];

    // lease MMF - use Phenom MMF
    NSNumber *phenomLeaseMonthlyManagementFee = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:phenomPurchaseAircraftTypeName andAircraftVintage:@"2013" andShareSize:purchaseAnnualHours isMultiShare:leaseIsMultiShare];
    
    NSNumber *phenomLeaseMonthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:phenomPurchaseAircraftTypeName andAircraftVintage:@"2013" andShareSize:purchaseAnnualHours isMultiShare:leaseIsMultiShare];
    
    // fuel rate - use Excel/XLS fuel
    NSNumber *phenomLeaseFuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:phenomLeaseAircraftTypeName andFuelPeriod:fuelPeriodChoice isQualified:isQualified];
    
    NSNumber *phenomLeaseFuelVariableAnnual = [NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:phenomLeaseAircraftTypeName andFuelPeriod:fuelPeriodChoice forNumberOfHours:leaseAnnualHours isQualified:isQualified];
        
    NSNumber *phenomLeaseOperationalFETAnnual = [NFDFlightProposalCalculatorService calculateTotalFETForMonthlyManagementFee:phenomLeaseMonthlyManagementFeeAnnual occupiedHourlyFee:phenomLeaseOccupiedAnnualFee fuel:phenomLeaseFuelVariableAnnual isQualified:isQualified];
    
    // lease annual operational cost
    NSNumber *phenomLeaseAnnualOperationalCost = [NFDFlightProposalCalculatorService calculateAnnualOperationalCostForAnnualMonthlyManagementFee:phenomLeaseMonthlyManagementFeeAnnual annualOperationHourlyFee:phenomLeaseOccupiedAnnualFee annualFuel:phenomLeaseFuelVariableAnnual annualFET:phenomLeaseOperationalFETAnnual annualLeaseFee:phenomLeaseAnnualLeaseFee annualLeaseFET:phenomLeaseLeaseFETRateAnnual];
    
    // lease operation average hourly cost
    NSNumber *phenomLeaseOperationalHourlyCost = [NFDFlightProposalCalculatorService calculateAverageHourlyOperationalCostForAnnualMonthlyManagementFee:phenomLeaseMonthlyManagementFeeAnnual annualOperationHourlyFee:phenomLeaseOccupiedAnnualFee annualFuel:phenomLeaseFuelVariableAnnual annualFET:phenomLeaseOperationalFETAnnual annualLeaseFee:phenomLeaseAnnualLeaseFee annualLeaseFET:phenomLeaseLeaseFETRateAnnual andShareSize:leaseAnnualHours];
    
    NSNumber *phenomLeasePrepaymentSavings = [NSNumber numberWithInt:0];
    NSString *phenomLeasePrepayEstimate = [[proposal productParameters] objectForKey:@"PrepayEstimate"];    
    
    //Issue:245 - Hard wire prepay fuel variable to 3 month value
    NSNumber *phenomLeasePrepayFuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:phenomLeaseAircraftTypeName andFuelPeriod:MONTH_RATE_3_MONTHS isQualified:isQualified];
    
    phenomLeasePrepaymentSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:phenomLeasePrepayEstimate usingMMF:phenomLeaseMonthlyManagementFee andOHF:phenomLeaseOccupiedHourlyFee andFuel:phenomLeasePrepayFuelVariableRate andLease:phenomLeaseMonthlyLeaseFee havingAnnualHoursOf:[NSNumber numberWithInt:[leaseAnnualHours intValue]] isQualified:isQualified];
    
    [proposal.calculatedResults setObject:phenomLeasePrepaymentSavings forKey:@"PrepaymentSavings"];
    [proposal.calculatedResults setObject:phenomLeaseMonthlyLeaseFee forKey:@"MonthlyLeaseFeeRate"];
    [proposal.calculatedResults setObject:phenomLeaseAnnualLeaseFee forKey:@"MonthlyLeaseFeeAnnual"];
    [proposal.calculatedResults setObject:phenomLeaseOccupiedHourlyFee forKey:@"OccupiedHourlyFeeRate"];
    [proposal.calculatedResults setObject:phenomLeaseOccupiedAnnualFee forKey:@"OccupiedHourlyFeeAnnual"];
    [proposal.calculatedResults setObject:phenomLeaseLeaseFETRate forKey:@"MonthlyLeaseFeeFET"];
    [proposal.calculatedResults setObject:phenomLeaseLeaseFETRateAnnual forKey:@"AnnualLeaseFeeFET"];
    [proposal.calculatedResults setObject:phenomLeaseMonthlyManagementFee forKey:@"MonthlyManagementFeeRate"];
    [proposal.calculatedResults setObject:phenomLeaseMonthlyManagementFeeAnnual forKey:@"MonthlyManagementFeeAnnual"];
    [proposal.calculatedResults setObject:phenomLeaseFuelVariableRate forKey:@"FuelVariableRate"];
    [proposal.calculatedResults setObject:phenomLeaseFuelVariableAnnual forKey:@"FuelVariableAnnual"];
    [proposal.calculatedResults setObject:phenomLeaseOperationalFETAnnual forKey:@"FederalExciseTaxAnnual"];
    [proposal.calculatedResults setObject:phenomLeaseAnnualOperationalCost forKey:@"AnnualCost"];
    [proposal.calculatedResults setObject:phenomLeaseOperationalHourlyCost forKey:@"AverageHourlyCost"];
    
    
    NFDProposal *purchaseProposal = proposal.relatedProposal;

    // purchase price
    NSNumber *phenomTotalAcquisitionValue = [NSNumber numberWithDouble:8800000.0];// [NFDFlightProposalCalculatorService acquisitionCostForAircraftTypeGroup:phenomPurchaseAircraftTypeGroupName];
    
    NSNumber *phenomPurchaseAcquisitionCost = [NFDFlightProposalCalculatorService calculateAcquisitionCostFromAircraftValue:phenomTotalAcquisitionValue andAnnualHours:[NSNumber numberWithFloat:[purchaseAnnualHours floatValue]]];
    
    NSNumber *phenomPurchaseTermFET = [NFDFlightProposalCalculatorService calculateTermFETForAcquisitionCost:phenomPurchaseAcquisitionCost isQualified:isQualified];
    
    // deposit
    NSNumber *phenomPurchaseDeposit = [NFDFlightProposalCalculatorService calculateDepositForAnnualHours:purchaseAnnualHours];
    
    NSNumber *phenomPurchaseProgressPayment = [NFDFlightProposalCalculatorService calculateProgressPaymentForAcquisitionCost:phenomPurchaseAcquisitionCost];
    
    NSNumber *phenomPurchaseCashDue = [NFDFlightProposalCalculatorService calculateCashDueAtClosingForAcquisitionCost:phenomPurchaseAcquisitionCost fet:phenomPurchaseTermFET deposit:phenomPurchaseDeposit progressPayment:phenomPurchaseProgressPayment];
    
    // purchase OHF    
    NSNumber *phenomPurchaseOccupiedHourlyFee = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:phenomPurchaseAircraftTypeName andVintage:@"2013"];
    
    NSNumber *phenomPurchaseOccupiedAnnualFee = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:phenomPurchaseAircraftTypeName vintage:@"2013" andShareSize:purchaseAnnualHours];
    
    // purchase MMF
    NSNumber *phenomPurchaseMonthlyManagementFee = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:phenomPurchaseAircraftTypeName andAircraftVintage:@"2013" andShareSize:purchaseAnnualHours isMultiShare:purchaseIsMultiShare];
    
    NSNumber *phenomPurchaseMonthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:phenomPurchaseAircraftTypeName andAircraftVintage:@"2013" andShareSize:purchaseAnnualHours isMultiShare:purchaseIsMultiShare];
    
    // fuel rate
    NSNumber *phenomPurchaseFuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:phenomPurchaseAircraftTypeName andFuelPeriod:fuelPeriodChoice isQualified:isQualified];
    
    NSNumber *phenomPurchaseFuelVariableAnnual = [NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:phenomPurchaseAircraftTypeName andFuelPeriod:fuelPeriodChoice forNumberOfHours:purchaseAnnualHours isQualified:isQualified];
    
    // MMF FET
    
    NSNumber *phenomPurchaseRecurringFETAnnual = [NFDFlightProposalCalculatorService calculateTotalFETForMonthlyManagementFee:phenomPurchaseMonthlyManagementFeeAnnual occupiedHourlyFee:phenomPurchaseOccupiedAnnualFee fuel:phenomPurchaseFuelVariableAnnual isQualified:isQualified];
    
    // purchase annual operational cost
    NSNumber *phenomPurchaseAnnualOperationalCost = [NFDFlightProposalCalculatorService calculateAnnualOperationalCostForAnnualMonthlyManagementFee:phenomPurchaseMonthlyManagementFeeAnnual annualOperationHourlyFee:phenomPurchaseOccupiedAnnualFee annualFuel:phenomPurchaseFuelVariableAnnual annualFET:phenomPurchaseRecurringFETAnnual annualLeaseFee:[NSNumber numberWithInt:0] annualLeaseFET:[NSNumber numberWithInt:0]];
    
    // purchase operational average hourly cost
    NSNumber *phenomPurchaseOperationalHourlyCost = [NFDFlightProposalCalculatorService calculateAverageHourlyOperationalCostForAnnualMonthlyManagementFee:phenomPurchaseMonthlyManagementFeeAnnual annualOperationHourlyFee:phenomPurchaseOccupiedAnnualFee annualFuel:phenomPurchaseFuelVariableAnnual annualFET:phenomPurchaseRecurringFETAnnual annualLeaseFee:[NSNumber numberWithInt:0] annualLeaseFET:[NSNumber numberWithInt:0] andShareSize:purchaseAnnualHours];
    
    NSNumber *phenomPurchasePrepaymentSavings = [NSNumber numberWithInt:0];
    NSString *phenomPurchasePrepayEstimate = [[purchaseProposal productParameters] objectForKey:@"PrepayEstimate"];    
    
    //Issue:245 - Hard wire prepay fuel variable to 3 month value
    NSNumber *phenomPurchasePrepayFuelVariableRate = [NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:phenomPurchaseAircraftTypeName andFuelPeriod:MONTH_RATE_3_MONTHS isQualified:isQualified];
    
    phenomPurchasePrepaymentSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:phenomPurchasePrepayEstimate usingMMF:phenomPurchaseMonthlyManagementFee andOHF:phenomPurchaseOccupiedHourlyFee andFuel:phenomPurchasePrepayFuelVariableRate andLease:[NSNumber numberWithInt:0] havingAnnualHoursOf:[NSNumber numberWithInt:[purchaseAnnualHours intValue]] isQualified:isQualified];
    
    [purchaseProposal.calculatedResults setObject:phenomPurchasePrepaymentSavings forKey:@"PrepaymentSavings"];
    
    [purchaseProposal.calculatedResults setObject:phenomPurchaseAcquisitionCost forKey:@"PurchasePrice"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseTermFET forKey:@"FederalExciseTaxPurchase"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseDeposit forKey:@"Deposit"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseProgressPayment forKey:@"ProgressPayment"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseCashDue forKey:@"CashDue"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseOccupiedHourlyFee forKey:@"OccupiedHourlyFeeRate"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseOccupiedAnnualFee forKey:@"OccupiedHourlyFeeAnnual"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseMonthlyManagementFee forKey:@"MonthlyManagementFeeRate"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseMonthlyManagementFeeAnnual forKey:@"MonthlyManagementFeeAnnual"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseFuelVariableRate forKey:@"FuelVariableRate"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseFuelVariableAnnual forKey:@"FuelVariableAnnual"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseRecurringFETAnnual forKey:@"FederalExciseTaxAnnual"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseAnnualOperationalCost forKey:@"AnnualCost"];
    [purchaseProposal.calculatedResults setObject:phenomPurchaseOperationalHourlyCost forKey:@"AverageHourlyCost"];
    [purchaseProposal setCalculated:YES];
}

-(void)notifyResultsUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PROPOSAL_RESULTS_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PROPOSAL_PARAMETERS_UPDATED object:nil];
}

-(void)performCalculationsForProposal:(NFDProposal*)proposal
{
    if (([[proposal productParameters] objectForKey:@"AircraftChoice"] && ![[[proposal productParameters] objectForKey:@"AircraftChoice"] isEqualToString:@""])
        ||
        ([[proposal productParameters] objectForKey:@"AircraftInventory"]))
    {
//        dispatch_retain(results_queue);
        dispatch_sync(calculate_queue, ^{
            [proposal setCalculated:YES];
            switch ([[proposal productType] intValue]) {
                case SHARE_PRODUCT_TYPE:
                    [self calculateShareResultForProposal:proposal];
                    break;
                case CARD_PRODUCT_TYPE:
                    if (proposal.productCode.intValue == CARD_PRODUCT)
                    {
                        [self calculateCardResultForProposal:proposal];
                    }
                    else //combo card
                    {
                        [self calculateComboCardResultForProposal:proposal];
                    }
                    break;
                case PHENOM_TRANSITION_PRODUCT_TYPE:
                    [self calculatePhenomTransitionResultForProposal:proposal];
                    break;
                default:
                    break;
            }
            dispatch_sync(results_queue, ^{
                [self notifyResultsUpdated]; 
            });
//            dispatch_release(results_queue);
        });
    }
}

@end
