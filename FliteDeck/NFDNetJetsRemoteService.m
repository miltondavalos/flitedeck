//
//  NFDRemoteDataService.m
//  FliteDeck
//
//  Created by Chad Long on 4/24/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDNetJetsRemoteService.h"
#import "NFDPersistenceManager.h"
#import "NCLFramework.h"
#import "NFDAircraftInventory.h"
#import "NFDFuelRate.h"
#import "NDFAccount.h"
#import "NFDContractRate.h"
#import "NFDUserManager.h"
#import "NFDFlightProfileAircraftSelectionViewController.h"
#import "NFDFlightProposalDetailViewController.h"
#import "NFDFeatures.h"
#import "NFDFeaturesService.h"
#import "NFDFlightTrackerAccountSearchViewController.h"
#import "NFDMasterSynchService.h"

@implementation NFDNetJetsRemoteService

#define JSON_TAG @"tag"
#define JSON_VALUE @"value"
#define SHOULD_USE_CROSS_COUNTRY @"SHOULD_USE_CROSS_COUNTRY"
#define CROSS_COUNTRY_PURCHASE_PRICE @"CROSS_COUNTRY_PURCHASE_PRICE"
#define NEXT_YEAR_PERCENTAGE_OHF @"NEXT_YEAR_PERCENTAGE_OHF"
#define NEXT_YEAR_PERCENTAGE_MMF @"NEXT_YEAR_PERCENTAGE_MMF"
#define NEXT_YEAR_PERCENTAGE_CARD @"NEXT_YEAR_PERCENTAGE_CARD"
#define SHOULD_USE_NEXT_YEAR_PERCENTAGE @"SHOULD_USE_NEXT_YEAR_PERCENTAGE"
#define SHOULD_USE_CARD_36_MONTHS_INCENTIVE @"SHOULD_USE_CARD_INCENTIVE_36_MONTHS"
#define SHOULD_USE_CARD_UPGRADE_INCENTIVE @"SHOULD_USE_CARD_INCENTIVE_UPGRADE"
#define USER_DEFAULT_COMPANY @"USER_DEFAULT_COMPANY"

@synthesize servicesHost = _servicesHost;

+ (NFDNetJetsRemoteService*)sharedInstance
{
	static dispatch_once_t pred;
	static NFDNetJetsRemoteService *sharedInstance = nil;
    
	dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
        sharedInstance.servicesHost = BASE_SERVICES_HOST;
    });
	
    return sharedInstance;
}

- (NSString*)authValidationUrlPath
{
    return @"/utility/pingAuth";
}

- (BOOL)requiresAuthentication
{
    return YES;
}

- (NSString*)user
{
    return [[NFDUserManager sharedManager] username];
}

- (NSString*)host
{
    return self.servicesHost;
}

- (int)port
{
    #ifdef BASE_SERVICES_PORT
        return BASE_SERVICES_PORT;
    #endif

    return 0;
}

- (BOOL)isSecure
{
    #ifdef BASE_SERVICES_SECURE
        return BASE_SERVICES_SECURE;
    #endif

    return YES;
}

- (void)updateAccountData
{
    NSLog(@"Updating accounts...");
    
    NCLURLRequest *request = [self urlRequestWithPath:[self buildPath: ACCOUNT_URL]];
    
    request.notificationID = @5;
    request.notificationName = HTTP_REQUEST_DID_COMPLETE_NOTIFICATION;
    
    [self sendHttpRequest:request withBackgroundProcessingBlock:^(NSData *data, NSError *error)
     {
         if (error)
         {
             [self handleErrorForContext:nil userDefaultsKey:LAST_ACCOUNT_SYNC_ERROR errorString:[error description]];
         }
         else
         {
             //             NSLog(@"data=\n%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
             NSLog(@"Processing the account json");
             NSError *jsonError = nil;
             NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
             
             if (result &&
                 result.count > 0)
             {
                 // get a managed context for this background thread
                 NSManagedObjectContext *ctx = [[NFDPersistenceManager sharedInstance] privateMOC];
                 
                 // truncate the existing account table
                 NSError *deleteError = nil;
                 [NCLPersistenceUtil deleteAllObjectsForEntityName:@"Account" context:ctx error:&deleteError];
                 
                 // reload the account table with the remote json data
                 for (NSDictionary *account in result)
                 {
                     NDFAccount *newAccount = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:ctx];
                     newAccount.account_id = [NSNumber numberFromObject:[account objectForKey:@"accountId"] shouldUseZeroDefault:YES decimalPlaces:0];
                     newAccount.account_name = [NSString stringFromObject:[account objectForKey:@"accountName"]];
                 }
                 
                 // save and merge to main context
                 if ([ctx save: nil])
                 {
                     // record results in userdefaults
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:[NSDate date] forKey:LAST_ACCOUNT_SYNC];
                     [defaults removeObjectForKey:LAST_ACCOUNT_SYNC_ERROR];
                     [defaults synchronize];
                 }
             }
             else
             {
                 [self handleErrorForContext:nil userDefaultsKey:LAST_ACCOUNT_SYNC_ERROR errorString:@"No data received from host"];
             }
         }
     }];
    
}

- (void)updateSalesData
{
    NSLog(@"Updating contract rates...");
    
    NCLURLRequest *request = [self urlRequestWithPath:[self buildPath: CONTRACT_RATE_URL]];
    request.notificationID = @1;
    request.notificationName = HTTP_REQUEST_DID_COMPLETE_NOTIFICATION;

    [self sendHttpRequest:request withBackgroundProcessingBlock:^(NSData *data, NSError *error)
     {
         if (error)
         {
             [self handleErrorForContext:nil userDefaultsKey:LAST_CONTRACT_RATE_SYNC_ERROR errorString:[error description]];
         }
         else
         {
//             NSLog(@"data=\n%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
             NSError *jsonError = nil;
             NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
             
             if (result &&
                 result.count > 0)
             {
                 // get a managed context for this background thread
                 NSManagedObjectContext *ctx = [[NFDPersistenceManager sharedInstance] privateMOC];
                 
                 // truncate the existing contract rate table
                 NSError *deleteError = nil;
                 [NCLPersistenceUtil deleteAllObjectsForEntityName:@"ContractRate" context:ctx error:&deleteError];
                 
                 // reload the contract rate table with the remote json data
                 for (NSDictionary *aircraft in result)
                 {
                     for (NSString *key in aircraft)
                     {
                         NSArray *rateValues = [aircraft objectForKey:key];
                         
                         if (rateValues.count != 19)
                         {
                             [self handleErrorForContext:ctx userDefaultsKey:LAST_CONTRACT_RATE_SYNC_ERROR errorString:@"Received unexpected data format from host"];
                             
                             return;
                         }
                         NFDContractRate *newContractRate = [NSEntityDescription insertNewObjectForEntityForName:@"ContractRate" inManagedObjectContext:ctx];
                         newContractRate.typeGroupName = key;
                         int x = 0;
                         newContractRate.shareMonthlyMgmtFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.shareMonthlyMgmtFeePremium = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.shareMonthlyMgmtFeeAccel1 = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.shareOccupiedHourlyFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.shareOccupiedHourlyFeeAccel1 = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.shareOccupiedHourlyFeeAccel2 = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.shareOccupiedHourlyFeeAccel3 = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.lease12MonthFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.lease24MonthFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.lease36MonthFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.lease48MonthFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.lease60MonthFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.leaseMonthlyMgmtFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.leaseOccupiedHourlyFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.cardPurchase25Hour = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.cardPurchase50Hour = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.cardHalfPremium = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.demoOccupiedHourlyFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newContractRate.californiaFee = [NSNumber numberFromObject:[rateValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         
                         NSArray *types = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                                  predicateKey:@"typeGroupName"
                                                                                predicateValue:key
                                                                                       sortKey:nil
                                                                            includeSubEntities:NO
                                                                                       context:ctx
                                                                                         error:nil];
                         if (types != nil)
                            newContractRate.aircraftTypes = [NSSet setWithArray:types];
                     }
                 }
                 
                 // save and merge to main context
                 if ([ctx save: nil])
                 {
                     // record results in userdefaults
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:[NSDate date] forKey:LAST_CONTRACT_RATE_SYNC];
                     [defaults removeObjectForKey:LAST_CONTRACT_RATE_SYNC_ERROR];
                     [defaults synchronize];
                 }
             }
             else
             {
                 [self handleErrorForContext:nil userDefaultsKey:LAST_CONTRACT_RATE_SYNC_ERROR errorString:@"No data received from host"];
             }
         }
     }];
}


- (void)updateFuelData
{
    NSLog(@"Updating fuel...");
    
    NCLURLRequest *request = [self urlRequestWithPath:[self buildPath: FUEL_RATE_URL]];
    request.notificationID = @2;
    request.notificationName = HTTP_REQUEST_DID_COMPLETE_NOTIFICATION;
    
    [self sendHttpRequest:request withBackgroundProcessingBlock:^(NSData *data, NSError *error)
     {
         if (error)
         {
             [self handleErrorForContext:nil userDefaultsKey:LAST_FUEL_SYNC_ERROR errorString:[error description]];
         }
         else
         {
//             NSLog(@"data=\n%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
             NSError *jsonError = nil;
             NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
             
             if (result &&
                 result.count > 0)
             {
                 // get a managed context for this background thread
                 NSManagedObjectContext *ctx = [[NFDPersistenceManager sharedInstance] privateMOC];
                 
                 // truncate the existing fuel table
                 NSError *deleteError = nil;
                 [NCLPersistenceUtil deleteAllObjectsForEntityName:@"FuelRate" context:ctx error:&deleteError];
                 
                 // reload the fuel table with the remote json data
                 for (NSDictionary *aircraft in result)
                 {
                     for (NSString *key in aircraft)
                     {
                         NSArray *fuelValues = [aircraft objectForKey:key];
                         
                         if (fuelValues.count != 8)
                         {
                             [self handleErrorForContext:ctx userDefaultsKey:LAST_FUEL_SYNC_ERROR errorString:@"Received unexpected data format from host"];
                             
                             return;
                         }
                         
                         NFDFuelRate *newFuelRate = [NSEntityDescription insertNewObjectForEntityForName:@"FuelRate" inManagedObjectContext:ctx];
                         newFuelRate.typeName = key;
                         int x = 0;
                         newFuelRate.qualified1MonthRate = [NSNumber numberFromObject:[fuelValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newFuelRate.qualified3MonthRate = [NSNumber numberFromObject:[fuelValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newFuelRate.qualified6MonthRate = [NSNumber numberFromObject:[fuelValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newFuelRate.qualified12MonthRate = [NSNumber numberFromObject:[fuelValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newFuelRate.nonQualified1MonthRate = [NSNumber numberFromObject:[fuelValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newFuelRate.nonQualified3MonthRate = [NSNumber numberFromObject:[fuelValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newFuelRate.nonQualified6MonthRate = [NSNumber numberFromObject:[fuelValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         newFuelRate.nonQualified12MonthRate = [NSNumber numberFromObject:[fuelValues objectAtIndex:x++] shouldUseZeroDefault:YES decimalPlaces:0];
                         
                         newFuelRate.aircraftType = [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"AircraftType"
                                                                                                predicateKey:@"typeName"
                                                                                                predicateValue:key
                                                                                            includeSubEntities:NO
                                                                                                       context:ctx
                                                                                                         error:nil];
                     }
                 }
                 
                 // save and merge to main context
                 if ([ctx save:nil])
                 {
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:[NSDate date] forKey:LAST_FUEL_SYNC];
                     [defaults removeObjectForKey:LAST_FUEL_SYNC_ERROR];
                     [defaults synchronize];
                 }
             }
             else
             {
                 [self handleErrorForContext:nil userDefaultsKey:LAST_FUEL_SYNC_ERROR errorString:@"No data received from host"];
             }
         }
     }];
}

- (void)ifAuthenticatedProcessBlock:(void(^)())onSuccess
{
    [self ifAuthenticatedProcessBlock:onSuccess ifErrorProcessBlock:nil];
}


- (void)ifAuthenticatedProcessBlock:(void(^)())onSuccess
                ifErrorProcessBlock:(void(^)(NSError *error))onFailure
{
    NSLog(@"Running block in authenticated context...");
    
    NCLURLRequest *request = [self urlRequestWithPath:[self buildPath: USER_INFO_URL]];
    request.notificationID = @0;
    request.notificationName = HTTP_REQUEST_DID_COMPLETE_NOTIFICATION;

    [self sendHttpRequest:request withBackgroundProcessingBlock:^(NSData *data, NSError *error)
     {
         if (error)
         {
             NSLog(@"Error validating user credentials: %@", error.description );
             if(onFailure) {
                 onFailure(error);
             }
         }
         else
         {
             if (onSuccess) {
                 onSuccess();
             }
         }
     }
    ];
    
}

- (void)updateInventoryData
{
    NSLog(@"Updating inventory...");
    
    NCLURLRequest *request = [self urlRequestWithPath:[self buildPath: AIRCRAFT_INVENTORY_URL]];
    request.notificationID = @3;
    request.notificationName = HTTP_REQUEST_DID_COMPLETE_NOTIFICATION;
     
    [self sendHttpRequest:request withBackgroundProcessingBlock:^(NSData *data, NSError *error)
    {
        if (error)
        {
            [self handleErrorForContext:nil userDefaultsKey:LAST_INVENTORY_SYNC_ERROR errorString:[error description]];
        }
        else
        {
            NSError *jsonError = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (result &&
                result.count > 0)
            {
                // get a managed context for this background thread
                NSManagedObjectContext *ctx = [[NFDPersistenceManager sharedInstance] privateMOC];
                
                // truncate the existing inventory table
                NSError *deleteError = nil;
                [NCLPersistenceUtil deleteAllObjectsForEntityName:@"AircraftInventory" context:ctx error:&deleteError];
                
                // reload the inventory table with the remote json data
                NSDictionary *records = [result objectForKey:@"CMSData"];
                
                for (NSDictionary *item in records)
                {
                    NSDictionary *jInventoryItem = [(NSDictionary*)item objectForKey:@"rowData"];
                    NSString* aircraftType = [jInventoryItem objectForKey:@"ijet_type"];
                    NSNumber* year = [jInventoryItem objectForKey:@"air_year"];
                    
                    if (aircraftType &&
                        year &&
                        [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"AircraftType" predicateKey:@"typeName" predicateValue:aircraftType includeSubEntities:YES context:ctx error:nil])
                    {
                        NFDAircraftInventory *newInventoryItem = [NSEntityDescription insertNewObjectForEntityForName:@"AircraftInventory" inManagedObjectContext:ctx];
                        newInventoryItem.type = aircraftType;
                        newInventoryItem.year = [year stringValue];
                        NSString *warrantyDate = [NSString stringFromObject:[jInventoryItem objectForKey:@"air_warranty_date"]];
                        NSString *deliveryDate = [NSString stringFromObject:[jInventoryItem objectForKey:@"air_anticipated_delivery_date"]];
                        if ([deliveryDate isEqualToString:warrantyDate])
                        {
                            newInventoryItem.anticipated_delivery_date = [NSDate dateFromISOString:[jInventoryItem objectForKey:@"air_anticipated_delivery_date"]];
                        }
                        else if (![warrantyDate  isEqual: @""])
                        {
                            newInventoryItem.anticipated_delivery_date = [NSDate dateFromISOString:[jInventoryItem objectForKey:@"air_warranty_date"]];
                        }
                        else 
                        {
                            newInventoryItem.anticipated_delivery_date = [NSDate dateFromISOString:[jInventoryItem objectForKey:@"air_anticipated_delivery_date"]];
                        }
                        
                        newInventoryItem.contracts_until_date = [NSDate dateFromISOString:[jInventoryItem objectForKey:@"air_contracts_until_date"]];
                        newInventoryItem.legal_name = [NSString stringFromObject:[jInventoryItem objectForKey:@"aty_legal_name"]];
                        newInventoryItem.serial = [NSString stringFromObject:[jInventoryItem objectForKey:@"air_serial_number"]];
                        newInventoryItem.tail = [NSString stringFromObject:[jInventoryItem objectForKey:@"air_tail_number"]];
                        newInventoryItem.sales_value = [NSString stringFromObject:[jInventoryItem objectForKey:@"sales_value"]];
                        newInventoryItem.share_immediately_available = [NSString stringFromObject:[jInventoryItem objectForKey:@"share_immediately_available"]];
                    }
                }
            
                // save and merge to main context
                if ([ctx save: nil])
                {
                    NSDate *lastSync = [NSDate dateFromISOString:[result objectForKey:@"CMSDataTimeStamp"]];

                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:lastSync forKey:LAST_INVENTORY_SYNC];
                    [defaults removeObjectForKey:LAST_INVENTORY_SYNC_ERROR];
                    [defaults synchronize];
                }
            }
            else
            {
                [self handleErrorForContext:nil userDefaultsKey:LAST_INVENTORY_SYNC_ERROR errorString:@"No data received from host"];
            }
        }
    }];
}

- (void)updateFeaturesData
{
    NSLog(@"Updating features...");
        
    NCLURLRequest *request = [self urlRequestWithPath:[self buildPath: FEATURES_URL]];
    request.notificationID = @4;
    request.notificationName = HTTP_REQUEST_DID_COMPLETE_NOTIFICATION;
    
    [self sendHttpRequest:request withBackgroundProcessingBlock:^(NSData *data, NSError *error)
        {
         if (error)
         {
             [self handleErrorForContext:nil userDefaultsKey:LAST_FEATURES_SYNC_ERROR errorString:[error description]];
         }
         else
         {
             
             NSError *jsonError = nil;
             NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];

             if (result &&
                 result.count > 0)
             {
                 
                 NFDFeatures *features = [[NFDFeatures alloc] init];
                 
                 for (NSDictionary *featureDictionary in result) {
                     NSString *tag = [featureDictionary objectForKey:JSON_TAG];
                     
                     if ([tag isEqualToString:SHOULD_USE_CROSS_COUNTRY]) {
                         
                         bool crossCountryBool = [[featureDictionary objectForKey:JSON_VALUE] boolValue];
                         
                         features.shouldUseCrossCountry = crossCountryBool;
                         
                     } else if ([tag isEqualToString:CROSS_COUNTRY_PURCHASE_PRICE]) {
                         
                         double crossCountryPurchasePrice = [[featureDictionary objectForKey:JSON_VALUE] doubleValue];
                         NSNumber *crossCountryPurchasePriceNumber = [NSNumber numberWithDouble:crossCountryPurchasePrice];
                         
                         features.crossCountryPurchasePrice = crossCountryPurchasePriceNumber;
                         
                     } else if ([tag isEqualToString:SHOULD_USE_NEXT_YEAR_PERCENTAGE]) {
                         
                         bool nextYearBool = [[featureDictionary objectForKey:JSON_VALUE] boolValue];
                         
                         features.shouldUseNextYearPercentage = nextYearBool;
                         
                     } else if ([tag isEqualToString:NEXT_YEAR_PERCENTAGE_OHF]) {
                         
                         double nextYearPercentage = [[featureDictionary objectForKey:JSON_VALUE] doubleValue];
                         NSNumber *nextYearPercentageNumber = [NSNumber numberWithDouble:nextYearPercentage];
                         
                         features.nextYearPercentageOHF = nextYearPercentageNumber;
                         
                     } else if ([tag isEqualToString:NEXT_YEAR_PERCENTAGE_MMF]) {
                         
                         double nextYearPercentage = [[featureDictionary objectForKey:JSON_VALUE] doubleValue];
                         NSNumber *nextYearPercentageNumber = [NSNumber numberWithDouble:nextYearPercentage];
                         
                         features.nextYearPercentageMMF = nextYearPercentageNumber;
                         
                     } else if ([tag isEqualToString:NEXT_YEAR_PERCENTAGE_CARD]) {
                         
                         double nextYearPercentage = [[featureDictionary objectForKey:JSON_VALUE] doubleValue];
                         NSNumber *nextYearPercentageNumber = [NSNumber numberWithDouble:nextYearPercentage];
                         
                         features.nextYearPercentageCard = nextYearPercentageNumber;
                         
                     } else if ([tag isEqualToString:SHOULD_USE_CARD_36_MONTHS_INCENTIVE]) {
                         
                         bool card36MonthsIncentiveBool = [[featureDictionary objectForKey:JSON_VALUE] boolValue];
                         
                         features.shouldUseCard36MonthsIncentive = card36MonthsIncentiveBool;
                         
                     } else if([tag isEqualToString:SHOULD_USE_CARD_UPGRADE_INCENTIVE]) {
                         bool cardUpgradeIncentiveBool = [[featureDictionary objectForKey:JSON_VALUE] boolValue];
                         
                         features.shouldUseCardUpgradeIncentive = cardUpgradeIncentiveBool;
                     } else if([tag isEqualToString:USER_DEFAULT_COMPANY]) {
                         
                         NSString *companyString = [featureDictionary objectForKey:JSON_VALUE];
                         NFDCompanySetting companySetting = [NFDUserManager companySettingForString:companyString];
                         
                         BOOL isNewCompanySettingValid = companySetting >= 0;
                         BOOL isNewCompanySettingDifferentThanPrevious = companySetting != [NFDUserManager sharedManager].companySetting;
                         
                         if( isNewCompanySettingValid ) {
                             if(isNewCompanySettingDifferentThanPrevious) {
                                 [self performBlock:^{
                                     [NFDUserManager sharedManager].companySetting = companySetting;
                                     NFDMasterSynchService *masterSyncService = [NFDMasterSynchService new];
                                     [masterSyncService syncFromMasterForCompany:companySetting];
                                 } afterDelay:0.0];
                             } else {
                                 NSLog(@"No company sync necessary company was already set to [%@]", companyString);
                             }
                         } else {
                             NSLog(@"[%@] is not supported, cannot sync the company", companyString);
                         }
                         
                     }
                    
                 }
                 
                 [NFDFeaturesService updateAndSaveFeatures:features];
                 
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:[NSDate date] forKey:LAST_FEATURES_SYNC];
                 [defaults removeObjectForKey:LAST_FEATURES_SYNC_ERROR];
                 [defaults synchronize];
             }
             else
             {
                 [self handleErrorForContext:nil userDefaultsKey:LAST_FEATURES_SYNC_ERROR errorString:@"No data received from host"];
             }
         }
    }];
}

- (void)handleErrorForContext:(NSManagedObjectContext*)context userDefaultsKey:(NSString*)key errorString:(NSString*)error
{
    if (context != 0)
        [context rollback];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:error forKey:key];
    [defaults synchronize];
}

- (void)displayRequiredSetupWarning:(NSObject*)caller
{
    int rows = -1;
    
    if ([caller isMemberOfClass:[NFDFlightProfileAircraftSelectionViewController class]] ||
        [caller isMemberOfClass:[NFDFlightProposalDetailViewController class]])
    {
        NSManagedObjectContext *ctx = [[NFDPersistenceManager sharedInstance] mainMOC];
        rows = [NCLPersistenceUtil countForFetchRequestForEntityName:@"ContractRate" predicate:nil includeSubEntities:NO context:ctx error:nil];
    }
    
    if (rows == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:  Incomplete Data" message:@"Login information and data synchronization are required to enable this feature.\n\nOn the FliteDeck Landing Page, tap the gear icon at the bottom of the page.  Enter your NetJets username and password and then tap the Data Sync button to complete the data synchronization process." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)displayRequiredSetupWarningForFlightTrackingAccountSearch
{
    int rows = -1;
    NSManagedObjectContext *ctx = [[NFDPersistenceManager sharedInstance] mainMOC];
    rows = [NCLPersistenceUtil countForFetchRequestForEntityName:@"Account" predicate:nil includeSubEntities:NO context:ctx error:nil];
    
    if (rows == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:  Incomplete Data" message:@"Data synchronization is required to enable Account Search.\n\nOn the FliteDeck Landing Page, tap the gear icon at the bottom of the page.  Tap the Data Sync button to complete the data synchronization process." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)swapServicesHost
{
    if ([self.servicesHost isEqualToString:(NSString *)BASE_SERVICES_HOST_FOR_PRODUCTION])
    {
        NSLog(@"switch to qa");
        [self setServicesHost:BASE_SERVICES_HOST_FOR_QA];
    }
    else 
    {
        NSLog(@"switch to prod");
        [self setServicesHost:BASE_SERVICES_HOST_FOR_PRODUCTION];
    }
}

- (NSString *) buildPath:(NSString *) serviceName
{
    return [FLITE_DECK_APP stringByAppendingString:serviceName];
}

- (void) setServicesHost:(NSString *)servicesHost
{
    _servicesHost = servicesHost;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:servicesHost forKey:SERVICES_HOST_KEY];
    [defaults synchronize];
}

@end
