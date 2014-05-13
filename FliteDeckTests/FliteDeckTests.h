//
//  FliteDeckTests.h
//  FliteDeckTests
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NFDAirportService.h"
#import "NFDAircraftTypeService.h"
#import "FlightEstimatorData.h"

@interface FliteDeckTests : SenTestCase

@property (nonatomic, retain) FlightEstimatorData *parameters;
@property (nonatomic, retain) NFDAirportService *airportService;
@property (nonatomic, retain) NFDAircraftTypeService *aircraftService;

@end
