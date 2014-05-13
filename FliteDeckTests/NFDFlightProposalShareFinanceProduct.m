//
//  NFDFlightProposalShareFinanceProduct.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 4/4/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalShareFinanceProduct.h"
#import "NFDFlightProposalCalculatorService.h"
#import "NFDFlightProposalManager.h"
#import "NFDAircraftInventory.h"

//Expected Default Values for Share Purchase Product
#define MONTHS_FUEL_DEFAULT 0
#define ANNUAL_HOURS_DEFAULT @"25"

@implementation NFDFlightProposalShareFinanceProduct

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

- (void)testShareFinanceDefaultValues
{
    NFDProposal *proposal = [NFDFlightProposalManager createNewProposalForProduct:SHARE_FINANCE_PRODUCT];
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

- (void)testCalculationOfDownPayment
{
    NSNumber *acquisitionCost = [NSNumber numberWithInt:0];
    NSNumber *expectedDownPayment = [NSNumber numberWithInt:0];
    NSNumber *downPayment = [NSNumber numberWithInt:0];

    //TEST ONE
    acquisitionCost = [NSNumber numberWithFloat:round(3115054.0f*300.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:233629.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST ONE - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }

    //TEST TWO
    acquisitionCost = [NSNumber numberWithFloat:round(20559240.0f*50.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:256991.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST TWO - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }

    //TEST THREE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*50.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:81250.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST THREE - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }
    
    //TEST FOUR
    acquisitionCost = [NSNumber numberWithFloat:round(9287098.0f*800.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:1857420.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST FOUR - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }
    
    //TEST FIVE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*400.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:650000.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST FIVE - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }
    
    //TEST SIX
    acquisitionCost = [NSNumber numberWithFloat:round(10148767.0f*200/800)];
    expectedDownPayment = [NSNumber numberWithFloat:507438.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST SIX - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }
    
    //TEST SEVEN
    acquisitionCost = [NSNumber numberWithFloat:round(4207205.0f*75.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:78885.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST SEVEN - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }
    
    //TEST EIGHT
    acquisitionCost = [NSNumber numberWithFloat:round(7707564.0f*100.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:192689.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST EIGHT - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }
    
    //TEST NINE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*500.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:812500.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST NINE - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }
    
    //TEST TEN
    acquisitionCost = [NSNumber numberWithFloat:round(9977761.0f*600.0f/800.0f)];
    expectedDownPayment = [NSNumber numberWithFloat:1496664.0f];
    downPayment = [NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost];
    if( [downPayment intValue] != [expectedDownPayment intValue] ){
        STFail(@"TEST TEN - DOWN PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[downPayment intValue], [expectedDownPayment intValue]);
    }
}

- (void)testCalculationOfFinancedAmmount
{
    NSNumber *acquisitionCost = [NSNumber numberWithInt:0];
    NSNumber *expectedFinancedAmmount = [NSNumber numberWithInt:0];
    NSNumber *financedAmount = [NSNumber numberWithInt:0];
    
    //TEST ONE
    acquisitionCost = [NSNumber numberWithFloat:round(3115054.0f*300.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:934516.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST ONE - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST TWO
    acquisitionCost = [NSNumber numberWithFloat:round(20559240.0f*50.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:1027962.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST TWO - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST THREE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*50.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:325000.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST THREE - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST FOUR
    acquisitionCost = [NSNumber numberWithFloat:round(9287098.0f*800.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:7429678.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST FOUR - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST FIVE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*400.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:2600000.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST FIVE - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST SIX
    acquisitionCost = [NSNumber numberWithFloat:round(10148767.0f*200.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:2029753.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST SIX - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST SEVEN
    acquisitionCost = [NSNumber numberWithFloat:round(4207205.0f*75.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:315540.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST SEVEN - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST EIGHT
    acquisitionCost = [NSNumber numberWithFloat:round(7707564.0f*100.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:770756.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST EIGHT - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST NINE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*500.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:3250000.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST NINE - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
    //TEST TEN
    acquisitionCost = [NSNumber numberWithFloat:round(9977761.0f*600.0f/800.0f)];
    expectedFinancedAmmount = [NSNumber numberWithFloat:5986657.0f];
    financedAmount = [NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost];
    if( [financedAmount intValue] != [expectedFinancedAmmount intValue] ){
        STFail(@"TEST TEN - FINANCED AMMOUNT DOES NOT MATCH EXPECTED RESULT %i != %i",[financedAmount intValue], [expectedFinancedAmmount intValue]);
    }
    
}

- (void)testCalculationOfMonthlyPayment
{
    NSNumber *acquisitionCost = [NSNumber numberWithInt:0];
    NSNumber *vintage = [NSNumber numberWithInt:0];
    NSNumber *expectedMonthlyPayment = [NSNumber numberWithInt:0];
    NSNumber *monthlyPayment = [NSNumber numberWithInt:0];
    
    //TEST ONE
    acquisitionCost = [NSNumber numberWithFloat:round(3115054.0f*300.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2002];
    expectedMonthlyPayment = [NSNumber numberWithFloat:10375.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST ONE - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST TWO
    acquisitionCost = [NSNumber numberWithFloat:round(20559240.0f*50.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedMonthlyPayment = [NSNumber numberWithFloat:13509.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST TWO - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST THREE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*50.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedMonthlyPayment = [NSNumber numberWithFloat:4271.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST THREE - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST FOUR
    acquisitionCost = [NSNumber numberWithFloat:round(9287098.0f*800.0f/800.0f)];
    vintage = [NSNumber numberWithInt:1999];
    expectedMonthlyPayment = [NSNumber numberWithFloat:108537.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST FOUR - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST FIVE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*400.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedMonthlyPayment = [NSNumber numberWithFloat:34168.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST FIVE - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST SIX
    acquisitionCost = [NSNumber numberWithFloat:round(10148767.0f*200/800)];
    vintage = [NSNumber numberWithInt:2001];
    expectedMonthlyPayment = [NSNumber numberWithFloat:24369.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST SIX - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST SEVEN
    acquisitionCost = [NSNumber numberWithFloat:round(4207205.0f*75.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2002];
    expectedMonthlyPayment = [NSNumber numberWithFloat:3503.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST SEVEN - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST EIGHT
    acquisitionCost = [NSNumber numberWithFloat:round(7707564.0f*100.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2002];
    expectedMonthlyPayment = [NSNumber numberWithFloat:8557.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST EIGHT - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST NINE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*500.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedMonthlyPayment = [NSNumber numberWithFloat:42710.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST NINE - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
    //TEST TEN
    acquisitionCost = [NSNumber numberWithFloat:round(9977761.0f*600.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedMonthlyPayment = [NSNumber numberWithFloat:78673.0f];
    monthlyPayment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [monthlyPayment intValue] != [expectedMonthlyPayment intValue] ){
        STFail(@"TEST TEN - MONTHLY PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[monthlyPayment intValue], [expectedMonthlyPayment intValue]);
    }
    
}

- (void)testCalculationOfBalloonPayment
{
    NSNumber *acquisitionCost = [NSNumber numberWithInt:0];
    NSNumber *vintage = [NSNumber numberWithInt:0];
    NSNumber *expectedBalloonPayment = [NSNumber numberWithInt:0];
    NSNumber *balloonPayment = [NSNumber numberWithInt:0];
    
    //TEST ONE
    acquisitionCost = [NSNumber numberWithFloat:round(3115054.0f*300.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2002];
    expectedBalloonPayment = [NSNumber numberWithInt:536655.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST ONE - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST TWO
    acquisitionCost = [NSNumber numberWithFloat:round(20559240.0f*50.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedBalloonPayment = [NSNumber numberWithInt:444051.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST TWO - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST THREE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*50.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedBalloonPayment = [NSNumber numberWithInt:140391.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST THREE - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST FOUR
    acquisitionCost = [NSNumber numberWithFloat:round(9287098.0f*800.0f/800.0f)];
    vintage = [NSNumber numberWithInt:1999];
    expectedBalloonPayment = [NSNumber numberWithInt:2448903.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST FOUR - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST FIVE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*400.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedBalloonPayment = [NSNumber numberWithInt:1123128.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST FIVE - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST SIX
    acquisitionCost = [NSNumber numberWithFloat:round(10148767.0f*200/800)];
    vintage = [NSNumber numberWithInt:2001];
    expectedBalloonPayment = [NSNumber numberWithInt:1037627.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST SIX - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST SEVEN
    acquisitionCost = [NSNumber numberWithFloat:round(4207205.0f*75.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2002];
    expectedBalloonPayment = [NSNumber numberWithInt:181202.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST SEVEN - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST EIGHT
    acquisitionCost = [NSNumber numberWithFloat:round(7707564.0f*100.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2002];
    expectedBalloonPayment = [NSNumber numberWithInt:442614.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST EIGHT - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST NINE
    acquisitionCost = [NSNumber numberWithFloat:round(6500000.0f*500.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedBalloonPayment = [NSNumber numberWithInt:1403910.0f];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST NINE - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
    //TEST TEN
    acquisitionCost = [NSNumber numberWithFloat:round(9977761.0f*600.0f/800.0f)];
    vintage = [NSNumber numberWithInt:2000];
    expectedBalloonPayment = [NSNumber numberWithInt:2586069.0];
    balloonPayment = [NFDFlightProposalCalculatorService calculateBalloonPaymentFromAcquisitionCost:acquisitionCost forVintage:vintage];
    if( [balloonPayment intValue] != [expectedBalloonPayment intValue] ){
        STFail(@"TEST TEN - BALLOON PAYMENT DOES NOT MATCH EXPECTED RESULT %i != %i",[balloonPayment intValue], [expectedBalloonPayment intValue]);
    }
    
}

@end
