//
//  FliteDeckProposalTests.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FliteDeckProposalTests.h"


@implementation FliteDeckProposalTests
@synthesize  serviceProposal, serviceAircraft;
- (void)setUp
{
    [super setUp];
    serviceProposal = [[NFDProposalCalculatorService alloc] init];
    serviceAircraft = [[NFDAircraftTypeProposalService alloc] init];
}

// All code under test must be linked into the Unit Test bundle
- (void) testRetrieveAcquisitionCost {
    
    NSArray *aircrafts = [serviceAircraft queryAircraftTypes:@"Phenom 300"];     
    if([aircrafts count] > 0){
        AircraftTypeProposal *ac = [aircrafts objectAtIndex:0];
        NSNumber *number = [serviceProposal getAcquisitionCostACValue:ac hoursCode:@"h50"];
        
        if([number intValue] != 550000){
            STFail(@"Fail retriving getAdquisitionCostACValue %d != 550000", [number intValue]);
        }else{
            NSLog(@"%d",[number intValue]);
        }
    }
    
}


- (void) testRetrieveFuelChoice {
    NSArray *fuelChoices = [serviceProposal getFuelChoice:@""];
    for(FuelChoice *choice in fuelChoices){
        NSLog(@"%@",[choice name]);
        
    }
    
    
}

- (void) testRetrieveProducts {
    NSArray *records = [serviceProposal getProductType:@""];
    for(ProductType *record in records){
        NSLog(@"%@",[record name]);
        NSArray *products = [serviceProposal getProductForProductType: record.producttype_id];
        for(Product *p in products){
            NSLog(@"%@",[p name]);
        }
    }
}

- (void) testRetrieveAnnualHours {
    NSArray *records = [serviceProposal getAnnualHour:@""];
    for(AnnualHour *record in records){
        NSLog(@"%@",[record hours]);
    }
} 
    

- (void) testCreateProposalSharePurchase {
    
    NSArray *aircrafts = [serviceAircraft queryAircraftTypes:@"Falcon 2000"];     
    if([aircrafts count] > 0){
        AircraftTypeProposal *ac = [aircrafts objectAtIndex:0];
        
        
        
        FuelVariable *fv = [serviceProposal getFuelVariableForAC:ac];
        ShareOHR *ohr = [serviceProposal getShareOHRForAC:ac];
        
        
        
        NSNumber *fuel3Months = fv.avg_3_month;
        
        //Is Share Purchare
        Product *product = [[serviceProposal getProduct:@"Purchase"] objectAtIndex:0];
        AnnualLeaseHours *hours = [[serviceProposal getAnnualLeaseHours:@"25 Hours Multi"] objectAtIndex:0];

        ShareMMF *mmf = [serviceProposal getShareMMFForAC:ac];
        NSLog(@"%@",[mmf h25_ms]);
        
        
        
        
        BOOL preowned = NO;
        BOOL showOH= YES;
        
        ContractDisposal *aircraftTail = [[serviceProposal getContractDisposal:@"Citation Encore/+"] objectAtIndex:0];
        
        int vintage = 2008;
        
        NSString *availability = @"03/08/2012";
        
        
        
        
        
        
        
        
    }
    
}



    
    - (void) testTotalNumberAircraftTypeProposalImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"AircraftTypeProposal"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported AircraftTypeProposal DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported AircraftTypeProposal MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberShareSizeHourImported
    {
        @try{
            int  totalEntries = 32;   
            
            int countFound = [serviceProposal getEntityCount:@"ShareSizeHour"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported ShareSizeHour DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported ShareSizeHour MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberAdquisitionCostACImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"AcquisitionCostAC"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported AcquisitionCostAC DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported AcquisitionCostAC MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberShareMMFImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"ShareMMF"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported ShareMMF DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported ShareMMF MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberShareMMFAcceleratorImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"ShareMMFAccelerator"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported ShareMMFAccelerator DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported ShareMMFAccelerator MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberShareOHRImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"ShareOHR"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported ShareOHR DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported ShareOHR MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberShareOHRAcceleratorImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"ShareOHRAccelerator"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported ShareOHRAccelerator DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported ShareOHRAccelerator MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberFuelChoiceImported
    {
        @try{
            int  totalEntries = 4;   
            
            int countFound = [serviceProposal getEntityCount:@"FuelChoice"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported FuelChoice DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported FuelChoice MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberFuelVariableImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"FuelVariable"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported FuelVariable DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported FuelVariable MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberSalesVPImported
    {
        @try{
            int  totalEntries = 47;   
            
            int countFound = [serviceProposal getEntityCount:@"SalesVP"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported SalesVP DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported SalesVP MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberProductTypeImported
    {
        @try{
            int  totalEntries = 3;   
            
            int countFound = [serviceProposal getEntityCount:@"ProductType"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported ProductType DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported ProductType MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberProductImported
    {
        @try{
            int  totalEntries = 8;   
            
            int countFound = [serviceProposal getEntityCount:@"Product"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported Product DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported Product MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberAircraftRemarketingFeeImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"AircraftRemarketingFee"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported AircraftRemarketingFee DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported AircraftRemarketingFee MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberCardTypeImported
    {
        @try{
            int  totalEntries = 4;   
            
            int countFound = [serviceProposal getEntityCount:@"CardType"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported CardType DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported CardType MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberHoursPerCardImported
    {
        @try{
            int  totalEntries = 11;   
            
            int countFound = [serviceProposal getEntityCount:@"HoursPerCard"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported HoursPerCard DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported HoursPerCard MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberAnnualHourImported
    {
        @try{
            int  totalEntries = 34;   
            
            int countFound = [serviceProposal getEntityCount:@"AnnualHour"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported AnnualHour DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported AnnualHour MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberCardPricingImported
    {
        @try{
            int  totalEntries = 11;   
            
            int countFound = [serviceProposal getEntityCount:@"CardPricing"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported CardPricing DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported CardPricing MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberAircraftCombinationImported
    {
        @try{
            int  totalEntries = 73;   
            
            int countFound = [serviceProposal getEntityCount:@"AircraftCombination"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported AircraftCombination DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported AircraftCombination MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberContractDisposalImported
    {
        @try{
            int  totalEntries = 58;   
            
            int countFound = [serviceProposal getEntityCount:@"ContractDisposal"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported ContractDisposal DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported ContractDisposal MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberAnnualLeaseHoursImported
    {
        @try{
            int  totalEntries = 35;   
            
            int countFound = [serviceProposal getEntityCount:@"AnnualLeaseHours"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported AnnualLeaseHours DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported AnnualLeaseHours MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberMonthlyLease12Imported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"MonthlyLease12"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported MonthlyLease12 DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported MonthlyLease12 MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberMonthlyLease24Imported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"MonthlyLease24"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported MonthlyLease24 DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported MonthlyLease24 MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberMonthlyLease36Imported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"MonthlyLease36"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported MonthlyLease36 DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported MonthlyLease36 MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberMonthlyLease48Imported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"MonthlyLease48"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported MonthlyLease48 DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported MonthlyLease48 MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberMonthlyLease60Imported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"MonthlyLease60"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported MonthlyLease60 DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported MonthlyLease60 MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberLeaseMMFImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"LeaseMMF"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported LeaseMMF DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported LeaseMMF MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberLeaseOHFImported
    {
        @try{
            int  totalEntries = 23;   
            
            int countFound = [serviceProposal getEntityCount:@"LeaseOHF"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported LeaseOHF DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported LeaseOHF MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    - (void) testTotalNumberLeaseTermImported
    {
        @try{
            int  totalEntries = 5;   
            
            int countFound = [serviceProposal getEntityCount:@"LeaseTerm"];
            if( countFound != totalEntries ){
                STFail(@"Total Imported LeaseTerm DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
            }else {
                NSLog(@"Total Imported LeaseTerm MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
            }
            
        }@catch(NSException *exception){
            NSLog(@"%@",[exception reason]);
        }
        
    }
    
- (void) testTotalNumberPrepayEstimateImported
{
    @try{
        int  totalEntries = 0;   
        
        int countFound = [serviceProposal getEntityCount:@"PrepayEstimate"];
        if( countFound != totalEntries ){
            STFail(@"Total Imported PrepayEstimate DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
        }else {
            NSLog(@"Total Imported PrepayEstimate MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}  
    

@end
