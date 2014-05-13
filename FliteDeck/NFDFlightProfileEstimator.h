//
//  FlightProfileEstimator.h
//  FlightProfile
//
//  Created by Evol Johnson on 1/11/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlightEstimatorData.h"
#import "NFDContractRate.h"
#import "NFDAirportService.h"
#import "NFDAircraftType.h"


@interface NFDFlightProfileEstimator : NSObject
@property BOOL valid;
- (NFDContractRate*)contractRateInfoForAircraftTypeGroup:(NSString*)typeGroupName;
- (NFDAircraftType*)aircraftTypeForTypeName:(NSString*)typeName;
- (BOOL)tripAndRateInfo:(FlightEstimatorData*)parameters;
@end
