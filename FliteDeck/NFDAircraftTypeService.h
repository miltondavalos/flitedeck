//
//  NFDAircraftTypeService.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDPersistenceService.h"
#import "NFDMasterAircraftType.h"


typedef NS_ENUM(NSInteger, NFDAircraftTypeComparisionResult) {
    NFDAircraftTypeUnknown = 0,
    NFDAircraftTypeDowngrade,
    NFDAircraftTypeSame,
    NFDAircraftTypeUpgrade,
};


@interface NFDAircraftTypeService : NFDPersistenceService
- (NSArray *) getAllAircraft;
- (NSString *)displayNameForTypeName:(NSString *)typeName moc:(NSManagedObjectContext *)moc;
- (NSNumber *) maximumNumberOfPassengersInFleet;
- (NFDAircraftType *) queryAircraftTypesByTypeName : (NSString *) criteria;
- (NFDMasterAircraftType*)queryMasterAircraftTypesByTypeName:(NSString*)typeName;
- (NSArray *) queryAircraftTypes : (NSString *) criteria;
- (NSArray *) queryAircraftTypesByTypeGroupName : (NSString *) criteria;

- (NFDAircraftTypeComparisionResult) compareAircraftTypes: (NSString *) requestedAircraftTypeText actualType: (NSString *) actualAircraftTypeText;

- (BOOL) isContractExpiringOrExpired: (NSDate *) contractEndDate;

@end
