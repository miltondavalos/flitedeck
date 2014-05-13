//
//  NFDFlightProposalPrePayCalculations.m
//  FliteDeck
//
//  Created by Evol Johnson on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDFlightProposalCalculatorService.h"
#import "NFDFlightProposalPrePayCalculations.h"
#import <math.h>


@implementation NFDFlightProposalPrePayCalculations

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

- (void)testMmfPrePayCalculations
{
    // Test Cast #
    NSNumber *testMmfRate = [NSNumber numberWithFloat:9863.0f];
    NSNumber *testOhf = [NSNumber numberWithFloat:0.0f];
    NSNumber *testFuel = [NSNumber numberWithFloat:0.0f];
    NSNumber *testLease = [NSNumber numberWithFloat:0.0f];
    NSNumber *testAnnualHours = [NSNumber numberWithFloat:50.0f];
    BOOL qualified = YES;
    
    NSNumber *prepaySavings = 
    [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:@"MMF" usingMMF:testMmfRate andOHF:testOhf andFuel:testFuel andLease:testLease havingAnnualHoursOf:testAnnualHours isQualified:qualified];
    
    NSNumber *expectedNumberValue = [NSNumber numberWithFloat:2117.79f];
                                     
    if( ![self doNumbersMatch:prepaySavings comparedTo:expectedNumberValue ] ){
        STFail(@"Pre-Payment Calculations not correct: Caclulated = %f Expected = %f",[prepaySavings floatValue], [expectedNumberValue floatValue]);
    }
}

- (void)testOhfAndFuelPrePayCalculations
{
    // Test Cast #
    NSNumber *testMmfRate = [NSNumber numberWithFloat:0.0f];
    NSNumber *testOhf = [NSNumber numberWithFloat:1986.0f];
    NSNumber *testFuel = [NSNumber numberWithFloat:1237.0f];
    NSNumber *testLease = [NSNumber numberWithFloat:0.0f];
    NSNumber *testAnnualHours = [NSNumber numberWithFloat:50.0f];
    BOOL qualified = YES;
    
    NSNumber *prepaySavings = 
    [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:@"OHF & Fuel" usingMMF:testMmfRate andOHF:testOhf andFuel:testFuel andLease:testLease havingAnnualHoursOf:testAnnualHours isQualified:qualified];
    
    NSNumber *expectedNumberValue = [NSNumber numberWithFloat:2883.53f];
    
    if( ![self doNumbersMatch:prepaySavings comparedTo:expectedNumberValue ] ){
        STFail(@"Pre-Payment Calculations not correct: Caclulated = %f Expected = %f",[prepaySavings floatValue], [expectedNumberValue floatValue]);
    }
}


- (void)testMmfAndOhfAndFuelPrePayCalculations
{
    // Test Cast #
    NSNumber *testMmfRate = [NSNumber numberWithFloat:9863.0f];
    NSNumber *testOhf = [NSNumber numberWithFloat:1986.0f];
    NSNumber *testFuel = [NSNumber numberWithFloat:1237.0f];
    NSNumber *testLease = [NSNumber numberWithFloat:0.0f];
    NSNumber *testAnnualHours = [NSNumber numberWithFloat:50.0f];
    BOOL qualified = YES;
    
    NSNumber *prepaySavings = 
    [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:@"MMF & OHF & Fuel" usingMMF:testMmfRate andOHF:testOhf andFuel:testFuel andLease:testLease havingAnnualHoursOf:testAnnualHours isQualified:qualified];
    
    NSNumber *expectedNumberValue = [NSNumber numberWithFloat:5001.32f];
    
    if( ![self doNumbersMatch:prepaySavings comparedTo:expectedNumberValue ] ){
        STFail(@"Pre-Payment Calculations not correct: Caclulated = %f Expected = %f",[prepaySavings floatValue], [expectedNumberValue floatValue]);
    }
}

- (void)testLeasePrePayCalculations
{
    // Test Cast #
    NSNumber *testMmfRate = [NSNumber numberWithFloat:0.0f];
    NSNumber *testOhf = [NSNumber numberWithFloat:0.0f];
    NSNumber *testFuel = [NSNumber numberWithFloat:0.0f];
    NSNumber *testLease = [NSNumber numberWithFloat:3477.0f];
    NSNumber *testAnnualHours = [NSNumber numberWithFloat:50.0f];
    BOOL qualified = YES;
    
    NSNumber *prepaySavings = 
    [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:@"Lease" usingMMF:testMmfRate andOHF:testOhf andFuel:testFuel andLease:testLease havingAnnualHoursOf:testAnnualHours  isQualified:qualified];
    
    NSNumber *expectedNumberValue = [NSNumber numberWithFloat:746.59f];
    
    if( ![self doNumbersMatch:prepaySavings comparedTo:expectedNumberValue ] ){
        STFail(@"Pre-Payment Calculations not correct: Caclulated = %f Expected = %f",[prepaySavings floatValue], [expectedNumberValue floatValue]);
    }
}


- (void)testLeaseAndMmfAndOhfAndFuelPrePayCalculations
{
    // Test Cast #
    NSNumber *testMmfRate = [NSNumber numberWithFloat:9863.0f];
    NSNumber *testOhf = [NSNumber numberWithFloat:1986.0f];
    NSNumber *testFuel = [NSNumber numberWithFloat:1237.0f];
    NSNumber *testLease = [NSNumber numberWithFloat:3477.0f];
    NSNumber *testAnnualHours = [NSNumber numberWithFloat:50.0f];
    BOOL qualified = YES;
    
    NSNumber *prepaySavings = 
    [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:@"Lease & MMF & OHF & Fuel" usingMMF:testMmfRate andOHF:testOhf andFuel:testFuel andLease:testLease havingAnnualHoursOf:testAnnualHours isQualified:qualified];
    
    NSNumber *expectedNumberValue = [NSNumber numberWithFloat:5747.90f];
    
    if( ![self doNumbersMatch:prepaySavings comparedTo:expectedNumberValue ] ){
        STFail(@"Pre-Payment Calculations not correct: Caclulated = %f Expected = %f",[prepaySavings floatValue], [expectedNumberValue floatValue]);
    }
}


- (void)testLeasePrePayNotQualifiedCalculations
{
    // Test Cast #
    NSNumber *testMmfRate = [NSNumber numberWithFloat:0.0f];
    NSNumber *testOhf = [NSNumber numberWithFloat:0.0f];
    NSNumber *testFuel = [NSNumber numberWithFloat:0.0f];
    NSNumber *testLease = [NSNumber numberWithFloat:6827.0f];
    NSNumber *testAnnualHours = [NSNumber numberWithFloat:25.0f];
    BOOL qualified = NO;
    
    NSNumber *leaseSavings = 
    [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForSelection:@"Lease" usingMMF:testMmfRate andOHF:testOhf andFuel:testFuel andLease:testLease havingAnnualHoursOf:testAnnualHours  isQualified:qualified];
    
    NSNumber *expectedNumberValue = [NSNumber numberWithFloat:1575.84f];
    
    if( ![self doNumbersMatch:leaseSavings comparedTo:expectedNumberValue ] ){
        STFail(@"Pre-Payment Calculations not correct: Caclulated = %f Expected = %f",[leaseSavings floatValue], [expectedNumberValue floatValue]);
    }
}


-(BOOL) doNumbersMatch:(NSNumber *) firstNumber comparedTo:(NSNumber *) secondNumber
{
    BOOL match = NO;

    NSString *firstNumberString = [NSString stringWithFormat:@"%.2f",[firstNumber floatValue]];
    NSString *secondNumberString = [NSString stringWithFormat:@"%.2f",[secondNumber floatValue]];
    
    if ( [firstNumberString isEqualToString:secondNumberString] )
        match = YES;

    return match;
    
}
@end
