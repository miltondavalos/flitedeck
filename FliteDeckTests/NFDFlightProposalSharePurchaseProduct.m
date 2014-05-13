//
//  NFDFlightProposalSharePurchaseProduct.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 4/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalSharePurchaseProduct.h"
#import "NFDFlightProposalCalculatorService.h"
//#import "NFDProposalCalculatorService.h"
#import "NFDFlightProposalManager.h"
#import "NFDAircraftInventory.h"

//Expected Default Values for Share Purchase Product
#define MONTHS_FUEL_DEFAULT 0
#define ANNUAL_HOURS_DEFAULT @"25"

//Expected Default Values for Share Purchase Product
#define SELECTED_AIRCRAFT_TYPE @"CE-560EP"
#define AIRCRAFT_TAIL @"N827QS"

@implementation NFDFlightProposalSharePurchaseProduct

- (void)setUp
{
    [super setUp];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testSharePurchaseDefaultValues
{
    NFDProposal *proposal = [NFDFlightProposalManager createNewProposalForProduct:SHARE_PURCHASE_PRODUCT];
    NSNumber *selectedSegment = [[proposal productParameters] objectForKey:@"MonthsFuel"];
    NSNumber *expectedNumberValue = [NSNumber numberWithInt:MONTHS_FUEL_DEFAULT];
    if( selectedSegment != expectedNumberValue ){
        STFail(@"DEFAULT VALUE NOT SET CORRECTLY %d != %d",selectedSegment, expectedNumberValue);
    }
    NSString *annualHours = [[proposal productParameters] objectForKey:@"AnnualHours"];
    NSString *expectedStringValue = ANNUAL_HOURS_DEFAULT;
    if( ![annualHours isEqualToString:expectedStringValue] ){
        STFail(@"DEFAULT VALUE NOT SET CORRECTLY %@ != %@",annualHours, expectedStringValue);
    }
}

- (void)testAircraftLookup
{
    //TODO: Change implementation of getAircraftInventory lookup...
//    NSArray *aircrafts = [NFDFlightProposalCalculatorService inventoryForAicraftType:SELECTED_AIRCRAFT_TYPE];
//    if ([aircrafts count] < 1){
//        STFail(@"AIRCRAFT LOOKUP NOT RETURNING EXPECTED RESULTS");
//    }
//    AircraftInventory *aircraftInventory = [aircrafts objectAtIndex:0];
//    NSString *tail = [aircraftInventory tail];
//    NSString *expectedTailValue = AIRCRAFT_TAIL;
//    if (![tail isEqualToString:expectedTailValue]){
//        STFail(@"AIRCRAFT INVENTORY LOOKUP TAIL NOT MATCHING EXPECTED VALUE %@ != %@",tail,expectedTailValue);
//    }
    
}

- (void)testCalculationOfMonthlyManagementFee
{
    NSNumber *monthlyManagementFeeRate = [NSNumber numberWithInt:0];
    NSNumber *monthlyManagementFeeAnnual = [NSNumber numberWithInt:0];
    NSNumber *expectedRateResult = [NSNumber numberWithInt:0];
    NSNumber *expectedAnnualResult = [NSNumber numberWithInt:0];
    NSString *aircraftType = @"";
    NSString *numberOfAnnualHours = @"";
    NSString *aircraftVintage = @"";

    //TEST ONE
    aircraftType = @"CE-560E";
    numberOfAnnualHours = @"300";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:47592];
    expectedAnnualResult = [NSNumber numberWithInt:571104];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST ONE - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST ONE - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }

    //TEST TWO
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"25";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:9203];
    expectedAnnualResult = [NSNumber numberWithInt:110436];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST TWO - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST TWO - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }

    //TEST THREE
    aircraftType = @"GV";
    numberOfAnnualHours = @"50";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:24478];
    expectedAnnualResult = [NSNumber numberWithInt:293736];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST THREE - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST THREE - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }

    //TEST FOUR
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"800";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:249264];
    expectedAnnualResult = [NSNumber numberWithInt:2991168];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST FOUR - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST FOUR - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }

    //TEST FIVE
    aircraftType = @"CE-750";
    numberOfAnnualHours = @"400";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:105640];
    expectedAnnualResult = [NSNumber numberWithInt:1267680];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST FIVE - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST FIVE - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }

    //TEST SIX
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"200";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:62316];
    expectedAnnualResult = [NSNumber numberWithInt:747792];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST SIX - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST SIX - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST SEVEN
    aircraftType = @"HS-125-800XPC";
    numberOfAnnualHours = @"75";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:15863];
    expectedAnnualResult = [NSNumber numberWithInt:190356];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST SEVEN - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST SEVEN - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST EIGHT
    aircraftType = @"G-200";
    numberOfAnnualHours = @"100";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:28840];
    expectedAnnualResult = [NSNumber numberWithInt:346080];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST EIGHT - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST EIGHT - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST NINE
    aircraftType = @"CE-750";
    numberOfAnnualHours = @"500";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:132050];
    expectedAnnualResult = [NSNumber numberWithInt:1584600];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST NINE - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST NINE - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST TEN
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"600";
    aircraftVintage = @"2010";
    expectedRateResult = [NSNumber numberWithInt:186948];
    expectedAnnualResult = [NSNumber numberWithInt:2243376];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST TEN - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST TEN - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }

    //TEST ELEVEN
    aircraftType = @"GIV-SP";
    numberOfAnnualHours = @"375";
    aircraftVintage = @"2000";
    expectedRateResult = [NSNumber numberWithInt:132578];
    expectedAnnualResult = [NSNumber numberWithInt:1590936];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST ELEVEN - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST ELEVEN - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }

    //TEST TWELVE
    aircraftType = @"CE-750";
    numberOfAnnualHours = @"400";
    aircraftVintage = @"2000";
    expectedRateResult = [NSNumber numberWithInt:110440];
    expectedAnnualResult = [NSNumber numberWithInt:1325280];
    monthlyManagementFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST TWELVE - MONTHLY MANAGEMENT FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeRate intValue], [expectedRateResult intValue]);
    }
    monthlyManagementFeeAnnual = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:aircraftVintage andShareSize:numberOfAnnualHours isMultiShare:NO];
    if( [monthlyManagementFeeAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST TWELVE - MONTHLY MANAGEMENT FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyManagementFeeAnnual intValue], [expectedAnnualResult intValue]);
    }

}

- (void)testCalculationOfOccupiedHourlyFee
{
    NSNumber *occupiedHourlyFeeRate = [NSNumber numberWithInt:0];
    NSNumber *occupiedHourlyFeeAnnual = [NSNumber numberWithInt:0];
    
    NSNumber *expectedRateResult = [NSNumber numberWithInt:0];
    NSNumber *expectedAnnualResult = [NSNumber numberWithInt:0];
    NSString *aircraftType = @"";
    NSString *numberOfAnnualHours = @"";
    NSString *vintage = @"";
    NSString *proposalYear = @"";
    
    //TEST ONE
    aircraftType = @"CE-560E";
    numberOfAnnualHours = @"300";
    vintage = @"2002";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:2444];
    expectedAnnualResult = [NSNumber numberWithInt:733200];
    
    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST ONE - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST ONE - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST TWO
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"25";
    vintage = @"1999";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:4225];
    expectedAnnualResult = [NSNumber numberWithInt:105625];

    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST TWO - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST TWO - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    
    
    //TEST THREE
    aircraftType = @"GV";
    numberOfAnnualHours = @"50";
    vintage = @"2000";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:5312];
    expectedAnnualResult = [NSNumber numberWithInt:265600];
    
    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST THREE - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST THREE - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    
    //TEST FOUR
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"800";
    vintage = @"1999";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:4225];
    expectedAnnualResult = [NSNumber numberWithInt:3380000];
    
    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST FOUR - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST FOUR - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST FIVE
    aircraftType = @"CE-750";
    numberOfAnnualHours = @"400";
    vintage = @"2000";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:3509];
    expectedAnnualResult = [NSNumber numberWithInt:1403600];

    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST FIVE - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST FIVE - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST SIX
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"200";
    vintage = @"2001";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:4225];
    expectedAnnualResult = [NSNumber numberWithInt:845000];
    
    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST SIX - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST SIX - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    
    //TEST SEVEN
    aircraftType = @"HS-125-800XPC";
    numberOfAnnualHours = @"75";
    vintage = @"2002";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:3091];
    expectedAnnualResult = [NSNumber numberWithInt:231825];
    
    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST SEVEN - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST SEVEN - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    
    //TEST EIGHT
    aircraftType = @"G-200";
    numberOfAnnualHours = @"100";
    vintage = @"2002";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:3798];
    expectedAnnualResult = [NSNumber numberWithInt:379800];
    
    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST EIGHT - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST EIGHT - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    

    //TEST NINE
    aircraftType = @"CE-750";
    numberOfAnnualHours = @"500";
    vintage = @"2000";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:3509];
    expectedAnnualResult = [NSNumber numberWithInt:1754500];

    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST NINE - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST NINE - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST TEN
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"600";
    vintage = @"2000";
    proposalYear = @"2012";
    expectedRateResult = [NSNumber numberWithInt:4225];
    expectedAnnualResult = [NSNumber numberWithInt:2535000];
    
    occupiedHourlyFeeRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeRate intValue] != [expectedRateResult intValue])
    {
        STFail(@"TEST TEN - OCCUPIED HOURLY FEE RATE DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeRate intValue], [expectedRateResult intValue]);
    }
    
    occupiedHourlyFeeAnnual = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:numberOfAnnualHours usingProposalYear:proposalYear];
    
    if ([occupiedHourlyFeeAnnual intValue] != [expectedAnnualResult intValue])
    {
        STFail(@"TEST TEN - OCCUPIED HOURLY FEE ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i", [occupiedHourlyFeeAnnual intValue], [expectedAnnualResult intValue]);
    }
}

- (void)testCalculationOfFederalExciseTax
{
    NSNumber *federalExciseTaxRate = [NSNumber numberWithInt:0];
    NSNumber *federalExciseTaxAnnual = [NSNumber numberWithInt:0];
    NSNumber *expectedRateResult = [NSNumber numberWithInt:0];
    NSNumber *expectedAnnualResult = [NSNumber numberWithInt:0];
    NSNumber *occupiedHourlyFeeRate = [NSNumber numberWithInt:0];
    NSNumber *occupiedHourlyFeeAnnual = [NSNumber numberWithInt:0];
    NSString *aircraftType = @"";
    NSString *numberOfAnnualHours = @"";
    
    //    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    //TEST ONE
    aircraftType = @"CE-560E";
    numberOfAnnualHours = @"300";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:2444];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:733200];
    expectedRateResult = [NSNumber numberWithInt:183];
    expectedAnnualResult = [NSNumber numberWithInt:54990];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST ONE - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST ONE - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST TWO
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"25";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:4225];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:105625];
    expectedRateResult = [NSNumber numberWithInt:316];
    expectedAnnualResult = [NSNumber numberWithInt:7921];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST TWO - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST TWO - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST THREE
    aircraftType = @"GV";
    numberOfAnnualHours = @"50";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:5312];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:265600];
    expectedRateResult = [NSNumber numberWithInt:398];
    expectedAnnualResult = [NSNumber numberWithInt:19920];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST THREE - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST THREE - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST FOUR
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"800";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:4225];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:3379800];
    expectedRateResult = [NSNumber numberWithInt:316];
    expectedAnnualResult = [NSNumber numberWithInt:253485];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST FOUR - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST FOUR - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST FIVE
    aircraftType = @"CE-750";
    numberOfAnnualHours = @"400";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:3509];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:1403600];
    expectedRateResult = [NSNumber numberWithInt:263];
    expectedAnnualResult = [NSNumber numberWithInt:105270];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST FIVE - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST FIVE - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST SIX
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"200";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:4225];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:845000];
    expectedRateResult = [NSNumber numberWithInt:316];
    expectedAnnualResult = [NSNumber numberWithInt:63375];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST SIX - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST SIX - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST SEVEN
    aircraftType = @"HS-125-800XPC";
    numberOfAnnualHours = @"75";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:3091];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:231825];
    expectedRateResult = [NSNumber numberWithInt:231];
    expectedAnnualResult = [NSNumber numberWithInt:17386];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST SEVEN - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST SEVEN - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST EIGHT
    aircraftType = @"G-200";
    numberOfAnnualHours = @"100";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:3798];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:379800];
    expectedRateResult = [NSNumber numberWithInt:284];
    expectedAnnualResult = [NSNumber numberWithInt:28485];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST EIGHT - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST EIGHT - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST NINE
    aircraftType = @"CE-750";
    numberOfAnnualHours = @"500";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:3509];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:1754500];
    expectedRateResult = [NSNumber numberWithInt:263];
    expectedAnnualResult = [NSNumber numberWithInt:131587];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST NINE - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST NINE - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
    //TEST TEN
    aircraftType = @"DA-2000";
    numberOfAnnualHours = @"600";
    occupiedHourlyFeeRate = [NSNumber numberWithInt:4225];
    occupiedHourlyFeeAnnual = [NSNumber numberWithInt:2535000];
    expectedRateResult = [NSNumber numberWithInt:316];
    expectedAnnualResult = [NSNumber numberWithInt:190125];
    federalExciseTaxRate = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeRate];
    if( [federalExciseTaxRate intValue] != [expectedRateResult intValue] ){
        STFail(@"TEST TEN - FEDERAL EXCISE TAX RATE DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxRate intValue], [expectedRateResult intValue]);
    }
    federalExciseTaxAnnual = [NFDFlightProposalCalculatorService calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:occupiedHourlyFeeAnnual];
    if( [federalExciseTaxAnnual intValue] != [expectedAnnualResult intValue] ){
        STFail(@"TEST TEN - FEDERAL EXCISE TAX ANNUAL DOES NOT MATCH EXPECTED RESULT %i != %i",[federalExciseTaxAnnual intValue], [expectedAnnualResult intValue]);
    }
    
}

@end
