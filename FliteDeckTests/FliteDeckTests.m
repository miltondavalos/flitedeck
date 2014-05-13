//
//  FliteDeckTests.m
//  FliteDeckTests
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "FliteDeckTests.h"
#import "NSString+Utility.h"
#import "AircraftTypeResults.h"
//#import "NFPBaseUpdateManagerImpl.h"
#import "NFDImportService.h"
#import "NFDAirportService.h"
#import "NFDAircraftTypeService.h"
#import "GeoHelper.h"
#import "NFDFlightProfileEstimator.h"

#import "FlightProfileTripEstimatePDF.h"
#import "Leg.h"
#import "NFDUserManager.h"

#define TOTAL_AIRCRAFT_INLASTIMPORT 29

@implementation FliteDeckTests
@synthesize parameters;
@synthesize airportService,aircraftService;

- (void)setUp
{
    [super setUp];
    parameters = [[FlightEstimatorData alloc] init];
    // Set-up code here.
    airportService = [[NFDAirportService alloc] init];
    aircraftService = [[NFDAircraftTypeService alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    //ph = nil;
    [super tearDown];
}


// This test case will import data from the Documents folder in the simulator to
// the sqllite database in the simulator.  This is a pre-cursor to creating a new
// sqlite for inclusive in the application.  It is typically commented out until
// needed.

-(void) testImportService {
//    NFDImportService *service = [[NFDImportService alloc] init];
//    [service importFromFiles];
}


- (void) testTotalNumberOfAirportsImported
{
    
    @try{
        int  totalAirportsInCSV = 9555;   
        
        int countFound = [airportService getEntityCount:@"Airport"];
        if( countFound != totalAirportsInCSV ){
            STFail(@"Total Imported Airports DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalAirportsInCSV);
        }else {
            NSLog(@"Total Imported Airports MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalAirportsInCSV);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}

- (void) testTotalNumberOfFBOImported
{
    @try{
        int  totalEntries = 12994;   
        
        int countFound = [airportService getEntityCount:@"FBO"];
        if( countFound != totalEntries ){
            STFail(@"Total Imported FBO's DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
        }else {
            NSLog(@"Total Imported FBO's MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}

- (void) testTotalNumberOfFBOAddressImported
{
    @try{
        int  totalEntries = 4487;   
        
        int countFound = [airportService getEntityCount:@"FBOAddress"];
        if( countFound != totalEntries ){
            STFail(@"Total Imported FBO Addresss DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
        }else {
            NSLog(@"Total Imported FBO Address MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}


- (void) testTotalNumberOfFBOPhoneImported
{
    @try{
        int  totalEntries = 29542;   
        
        int countFound = [airportService getEntityCount:@"FBOPhone"];
        if( countFound != totalEntries ){
            //STFail(@"Total Imported FBO Phone DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
        }else {
            NSLog(@"Total Imported FBO Phone MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}


- (void) testforFBOPhone
{
    @try {
        
        // Phone no for DTW FBO is used here
        
        NSString  *phoneNo_1 = @"1657243";
        NSString  *phoneNo_2 = @"1657244";
        
        
        NSSet *PhoneNoImported = [airportService getFBOPhone:[NSNumber numberWithInteger:[@"1147482" integerValue]]];
        if(PhoneNoImported != nil){
            NSLog(@"Phone no set: %@", PhoneNoImported);
            NSMutableArray *array = [NSMutableArray arrayWithArray:[PhoneNoImported allObjects]];
            NSLog(@"Phone no array: %@", array);
            if([array count] > 2){
                NFDFBOPhone *phone1 = (NFDFBOPhone *)[array objectAtIndex:0];
                NFDFBOPhone *phone2 = (NFDFBOPhone *)[array objectAtIndex:1];
                NSString *phoneNoimported_1 =  phone1.telephone_nbr_txt;
                NSString *phoneNoimported_2 =  phone2.telephone_nbr_txt;
                
                if([phoneNo_1 isEqualToString:phoneNoimported_1]) {
                    NSLog(@"Phone no %@ matches with the imported phone no %@", phoneNo_1, phoneNoimported_1);
                }
                
                else {
                    STFail(@"Phone no %@ does not match with the imported phone no %@", phoneNo_1, phoneNoimported_1 );
                }
                
                if([phoneNo_2 isEqualToString:phoneNoimported_2]) {
                    NSLog(@"Phone no %@ matches with the imported phone no %@", phoneNo_2, phoneNoimported_2);
                }
                
                else {
                    STFail(@"Phone no %@ does not match with the imported phone no %@", phoneNo_2, phoneNoimported_2 );
                }
            }
        }
        
    }
    
    @catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
        
    }
    
}




- (void) testTotalNumberOfAircraftTypesImported
{
    @try{
        int  totalEntries = 23;   
        
        int countFound = [airportService getEntityCount:@"AircraftType"];
        if( countFound != totalEntries ){
            STFail(@"Total Imported AircraftRestriction DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
        }else {
            NSLog(@"Total Imported AircraftRestriction MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}

- (void) testTotalNumberOfAirportRestrictions
{
    @try{
        int  totalEntries = 44301;   
        
        int countFound = [airportService getEntityCount:@"AircraftTypeRestriction"];
        if( countFound != totalEntries ){
            STFail(@"Total Imported AircraftRestriction DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
        }else {
            NSLog(@"Total Imported AircraftRestriction MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}

- (void) testTotalNumberEvents
{
    @try{
        int  totalEntries = 18;   
        
        int countFound = [airportService getEntityCount:@"EventInformation"];
        if( countFound != totalEntries ){
            STFail(@"Total Imported Event Information DOES NOT MATCH NUMBER OF ROWS ON INPUT DATA  %d != %d",countFound, totalEntries);
        }else {
            NSLog(@"Total Imported Event Information MATCHES NUMBER OF ROWS ON INPUT DATA  %d == %d",countFound , totalEntries);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}

- (void) testTotalDistanceBetweenOriginAndDestination
{
    @try
    {

        
        NFDAirport *origin = [airportService findAirportWithCode:@"KDTW"];
        NFDAirport *destination = [airportService findAirportWithCode:@"KMCO"];
        
        float distance = 959.182129; 
        
        float actualDistance = [GeoHelper distanceBetweenAirports:origin destination:destination]; 
        if((int) actualDistance != (int) distance)
        {
            NSLog(@"actual distance is %f",actualDistance);
            
            STFail(@"Mismatched distance between airports. %f != %f",distance,actualDistance);
        }
        
        //
        else
        {
            NSLog(@"Actual distance between origin and destination matches the input distance is %f  == %f ",actualDistance, distance);
            
        }
        //
    }
    
    @catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}



- (void) testTotalDistanceBetweenOriginAndDestinationWithOneLeg
{
    @try
    {
        
        NFDAirport *origin = [airportService findAirportWithCode:@"KDTW"];
        NFDAirport *leg1 = [airportService findAirportWithCode:@"KORD"];
        NFDAirport *destination = [airportService findAirportWithCode:@"KDFW"];
        
        float distance = 1036.00769; 
        
        float Distance = [GeoHelper distanceBetweenAirports:origin destination:leg1]; 
        float totalDistanceWithOneLeg = Distance + [GeoHelper distanceBetweenAirports:leg1 destination:destination]; 
        
        if((int)totalDistanceWithOneLeg != (int)distance)
        {
            NSLog(@"actual distance with one leg is %f",totalDistanceWithOneLeg);
            STFail(@"Mismatched distance between airports. %f != %f",distance,totalDistanceWithOneLeg);
        }
        
        //
        
        else {
            NSLog(@"Actual distance with one leg matches with input distance  %f  == %f ",totalDistanceWithOneLeg, distance);
            
        }
        //
    }
    
    @catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}


- (void) testTotalDistanceBetweenOriginAndDestinationWithTwoLegs
{
    @try
    {

        
        NFDAirport *origin = [airportService findAirportWithCode:@"KDTW"];
        NFDAirport *leg1 = [airportService findAirportWithCode:@"KORD"];
        NFDAirport *leg2 = [airportService findAirportWithCode:@"KDFW"];
        NFDAirport *destination = [airportService findAirportWithCode:@"KATL"];
        
        
        float distance = 1765.81909;
        
        float tempDistance = [GeoHelper distanceBetweenAirports:origin destination:leg1]; 
        
        tempDistance = tempDistance + [GeoHelper distanceBetweenAirports:leg1 destination:leg2]; 
        float totalDistanceWithTwoLegs = tempDistance + [GeoHelper distanceBetweenAirports:leg2 destination:destination];
        
        if((int)totalDistanceWithTwoLegs != (int)distance)
        {
            NSLog(@"Actual distance with two legs  %f",totalDistanceWithTwoLegs);
            STFail(@"Mismatched distance between airports. %f != %f 2 Legs",distance,totalDistanceWithTwoLegs);
        }
        
        //
        
        else {
            NSLog(@"Actual distance with two legs matches with input distance  %f  == %f ",totalDistanceWithTwoLegs, distance);
            
        }
        //
        
    }
    
    @catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}


- (void) testTotalDistanceBetweenOriginAndDestinationWithThreeLegs
{
    @try
    {

        
        NFDAirport *origin = [airportService findAirportWithCode:@"KDTW"];
        NFDAirport *leg1 = [airportService findAirportWithCode:@"KORD"];
        NFDAirport *leg2 = [airportService findAirportWithCode:@"KDFW"];
        NFDAirport *leg3 = [airportService findAirportWithCode:@"KATL"];
        NFDAirport *destination = [airportService findAirportWithCode:@"KMCO"];
        
        
        float distance = 2170.18188;
        
        float tempDistance = [GeoHelper distanceBetweenAirports:origin destination:leg1]; 
        
        tempDistance = tempDistance + [GeoHelper distanceBetweenAirports:leg1 destination:leg2]; 
        tempDistance = tempDistance + [GeoHelper distanceBetweenAirports:leg2 destination:leg3];
        float totalDistanceWithThreeLegs = tempDistance + [GeoHelper distanceBetweenAirports:leg3 destination:destination];
        
        if((int)totalDistanceWithThreeLegs != (int)distance)
        {
            NSLog(@"Actual distance with three legs  %f %f",totalDistanceWithThreeLegs,
                  totalDistanceWithThreeLegs);
            STFail(@"Mismatched distance between airports. %f != %f 3 Legs",distance,totalDistanceWithThreeLegs);
        }
        
        //
        
        else {
            NSLog(@"Actual distance with three legs matches with input distance  %f  == %f ",totalDistanceWithThreeLegs, distance);
            
        }
        //
        
    }
    
    @catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}



- (void) testForPDFGeneration
{
    
    @try{
        
        NFDFlightProfileEstimator *estimator = [[NFDFlightProfileEstimator alloc] init];
        // FlightProfilePDFGeneration *pdf = [[FlightProfilePDFGeneration alloc] init];
        FlightProfileTripEstimatePDF *pdf = [[FlightProfileTripEstimatePDF alloc] init];
        //AircraftTypeResults *res = [[AircraftTypeResults alloc] init];
        
        parameters.airports = [[NSMutableArray alloc] init];
        [parameters.airports addObject:[airportService findAirportWithCode:@"KDTW"]];
        [parameters.airports addObject:[airportService findAirportWithCode:@"KLAX"]];
        [parameters.airports addObject:[airportService findAirportWithCode:@"KORD"]];
        [parameters.airports addObject:[airportService findAirportWithCode:@"KSEA"]];                                                                
        [parameters.airports addObject:[airportService findAirportWithCode:@"MMMX"]];
        
        parameters.passengers = 2;
        parameters.roundTrip = YES;
        parameters.product = @"Share";
        parameters.season = @"Annual";
        parameters.results = [[NSMutableArray alloc] init];
        
        
        
        parameters.aircrafts = [[NSMutableArray alloc] init];
        
        for(NFDAircraftType *ac in [aircraftService queryAircraftTypes:@"Phenom"] ){
            [parameters.aircrafts addObject:ac];
        }

        [estimator tripAndRateInfo:parameters];
        
        
        
        // Properties for PDF page 
        CGSize pageSize;
        pageSize = CGSizeMake(1250,900);
        NSString *fileName = @"FlightTripEstimate.pdf";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pdfFileName;
        pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        
        pdf.parameters = parameters;
        [pdf generatePDF];  
        
        
        
        
        NSFileManager *man = [[NSFileManager alloc] init];
        NSDictionary *attrs = [man attributesOfItemAtPath: pdfFileName error: NULL];
        int result = [attrs fileSize];
        
        
        // Checking if the pdf is generated or not at the expected path
        
        if(result == 0)
        {
            
            STFail(@"Pdf is not generated as Size of pdf is %d bytes", result);
            
        }
        
        else {
            
            NSLog(@"Pdf is generated as Size of pdf is %d bytes ", result);
            
        }
        
        
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
    
}



- (void) testQueryMaximumNumberOfPassengersInFleet
{
    NSNumber *maxPassengers = [aircraftService maximumNumberOfPassengersInFleet];
    STAssertNotNil(maxPassengers, @"Could not obtain maximum number of passengers from storage");
}




- (void) testQueryLongestName
{
    
    @try{
        // NSString *longestName = @"North Shore University Hospital, No. 2 Heliport ";
        NSString *longestName = @"SOUTH WEYMOUTH NAS (CLOSED & PROHIBITED)";
        NSArray *recordsFound = [airportService queryAirports:longestName];
        if([recordsFound count] <= 0){
            STFail(@"Longest name was not found %@",longestName);
        }else{
            NSLog(@"Longest Airport name is %@",longestName);
        }
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
}


//TODO: need to test syncservice
-(void) testDownloadFilesAndImport {
    //    
    //NFPBaseUpdateManagerImpl *manager = [[NFPBaseUpdateManagerImpl alloc] init];
    //[manager getDownloadList];
}



 - (void) testforFBOAddress
 {
 @try {
 
 // Address for DTW FBO is used here
 
 NSString  *addressLine1 = @"1229192_address_line1";
 NSString  *addressLine2 = @"1229192_address_line2";
 
 
 NSSet *AddressImported = [airportService getFBOAddress:[NSNumber numberWithInteger:[@"1147482"integerValue]]];
 
 NSLog(@"Phone no set: %@", AddressImported);
 NSMutableArray *array = [NSMutableArray arrayWithArray:[AddressImported allObjects]];
 NSLog(@"Phone no array: %@", array);
 if([array count] < 6){
 //STFail(@"Address count is not 6 for FBO 1147482");
 }
 NFDFBOAddress *address1 = (NFDFBOAddress *)[array objectAtIndex:4];
 NFDFBOAddress *address2 = (NFDFBOAddress *)[array objectAtIndex:5];
 NSString *addressimported_1 =  address1.address_line4_txt;
 NSString *addressimported_2 =  address2.address_line5_txt;
 
 if([addressLine1 isEqualToString:addressimported_1]) {
 NSLog(@"Address %@ matches with the imported address %@", addressLine1, addressimported_1);
 }
 
 else {
 STFail(@"Address %@ does not match with the imported address %@", addressLine1, addressimported_1 );
 }
 
 if([addressLine2 isEqualToString:addressimported_2]) {
 NSLog(@"Address %@ matches with the imported address %@", addressLine2, addressimported_2);
 }
 
 else {
 STFail(@"Address %@ does not match with the imported address %@", addressLine2, addressimported_2 );
 }
 
 }
 
 @catch(NSException *exception){
 NSLog(@"%@",[exception reason]);
 
 }
 
 }
 



-(void) testPDFLegInfo
{
    
    @try{
        
        NFDFlightProfileEstimator *estimator = [[NFDFlightProfileEstimator alloc] init];
        // FlightProfilePDFGeneration *pdf = [[FlightProfilePDFGeneration alloc] init];
        FlightProfileTripEstimatePDF *pdf = [[FlightProfileTripEstimatePDF alloc] init];
        //AircraftTypeResults *res = [[AircraftTypeResults alloc] init];
        
        parameters.airports = [[NSMutableArray alloc] init];
        [parameters.airports addObject:[airportService findAirportWithCode:@"KTVC"]];
        [parameters.airports addObject:[airportService findAirportWithCode:@"KOSU"]];
        [parameters.airports addObject:[airportService findAirportWithCode:@"KMIA"]];
    
        parameters.prospect = [[Prospect alloc] init];
        parameters.prospect.title = @"MR.";
        parameters.prospect.first_name = @"John";
        parameters.prospect.last_name = @"Doe";
        parameters.prospect.email = @"john.doe@netjets.com";
        
        parameters.userInfo = [[NFDUserManager sharedManager] userInfo];
        
        parameters.passengers = 2;
        parameters.roundTrip = YES;
        parameters.product = @"Share";
        parameters.season = @"Annual";
        parameters.results = [[NSMutableArray alloc] init];
        
        
        
        parameters.aircrafts = [[NSMutableArray alloc] init];
        
        for(NFDAircraftType *ac in [aircraftService queryAircraftTypes:@"Hawker 400XP"] ){
            [parameters.aircrafts addObject:ac];
        }
        [estimator tripAndRateInfo:parameters];
        
    
        
        for(AircraftTypeResults *result in parameters.results){
//            int cont = 1;
           /* for(Leg *leg in result.outLegs ){
                switch (cont) {
                    case 1:
                        if(leg.blockTime != 1.0){
                            STFail(@"Error in Blocktime for Leg %@ - %f", [leg description],leg.blockTime);
                        }
                        if(leg.fuelCost != 184.9){
                            STFail(@"Error in Fuel for Leg %@ - %f", [leg description],leg.fuelCost);
                        }
                        if(leg.hourlyCost != 14.9){
                            STFail(@"Error in Hourly for Leg %@ - %f", [leg description],leg.hourlyCost);
                        }
                        break;
                        
                    default:
                        break;
                }
                
            }*/
            
        }
        
        
        // Properties for PDF page 
//        CGSize pageSize = CGSizeMake(1250,900);
        NSString *fileName = @"FlightTripEstimate.pdf";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pdfFileName;
        pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        
        pdf.parameters = parameters;
        [pdf generatePDF];  
        
        
        
        
        NSFileManager *man = [[NSFileManager alloc] init];
        NSDictionary *attrs = [man attributesOfItemAtPath: pdfFileName error: NULL];
        int result = [attrs fileSize];
        
        
        // Checking if the pdf is generated or not at the expected path
        
        if(result == 0)
        {
            
            STFail(@"Pdf is not generated as Size of pdf is %d bytes", result);
            
        }
        
        else {
            
            NSLog(@"Pdf is generated as Size of pdf is %d bytes ", result);
            
        }
        
        
        
    }@catch(NSException *exception){
        NSLog(@"%@",[exception reason]);
    }
    
    
}
@end
