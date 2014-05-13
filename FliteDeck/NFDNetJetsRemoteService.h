//
//  NFDRemoteDataService.h
//  FliteDeck
//
//  Created by Chad Long on 4/24/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCLFramework.h"

#define LAST_CONTRACT_RATE_SYNC @"LastContractRateSync"
#define LAST_CONTRACT_RATE_SYNC_ERROR @"ContractRateSyncError"
#define LAST_FUEL_SYNC @"LastFuelRateSync"
#define LAST_FUEL_SYNC_ERROR @"FuelRateSyncError"
#define LAST_INVENTORY_SYNC @"LastAircraftInventorySync"
#define LAST_INVENTORY_SYNC_ERROR @"AircraftInventorySyncError"
#define LAST_FEATURES_SYNC @"LastFeatureSync"
#define LAST_FEATURES_SYNC_ERROR @"FeatureSyncError"
#define LAST_ACCOUNT_SYNC @"LastAccountSync"
#define LAST_ACCOUNT_SYNC_ERROR @"AccountSyncError"
#define SERVICES_HOST_KEY @"ServicesHost"

#define USER_INFO_URL @"/synch/jGetUserInfo"
#define CONTRACT_RATE_URL @"/synch/jGetSalesData"
#define FUEL_RATE_URL @"/synch/jGetFuelData"
#define AIRCRAFT_INVENTORY_URL @"/synch/jGetCMSData"
#define FEATURES_URL @"/synch/jGetFeaturesData"
#define ACCOUNT_URL @"/synch/jGetAccounts"

#define TRACKER_LEGS_URL @"/flightTracker/jGetFlightLegs"

#define FLITE_DECK_APP @"/flitedeck/v1"

@interface NFDNetJetsRemoteService : NCLHTTPClient

@property (nonatomic, strong) NSString *servicesHost;

+ (NFDNetJetsRemoteService*)sharedInstance;

- (void)ifAuthenticatedProcessBlock:(void(^)())onSuccess;
- (void)ifAuthenticatedProcessBlock:(void(^)())onSuccess ifErrorProcessBlock:(void(^)(NSError *error))onFailure;

- (void)updateSalesData;
- (void)updateFuelData;
- (void)updateInventoryData;
- (void)updateFeaturesData;
- (void)updateAccountData;
- (void)handleErrorForContext:(NSManagedObjectContext*)context userDefaultsKey:(NSString*)key errorString:(NSString*)error;
- (void)displayRequiredSetupWarning:(NSObject*)caller;
- (void)displayRequiredSetupWarningForFlightTrackingAccountSearch;
- (void)swapServicesHost;
- (NSString *) buildPath:(NSString *) serviceName;

@end
