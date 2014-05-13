//
//  NFDFlightProfileManager.h
//  FliteDeck
//
//  Created by Chad Predovich on 2/22/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDAirport.h"
#import "FlightEstimatorData.h"
#import "NFDFlightProfileEstimator.h"

@interface NFDFlightProfileManager : NSObject

+ (id)sharedInstance;

@property (strong, nonatomic) NFDAirport *originAirport;
@property (strong, nonatomic) NFDAirport *leg1Airport;
@property (strong, nonatomic) NFDAirport *leg2Airport;
@property (strong, nonatomic) NFDAirport *leg3Airport;
@property (strong, nonatomic) NFDAirport *destinationAirport;

@property (strong, nonatomic) NSString *originString;
@property (strong, nonatomic) NSString *leg1String;
@property (strong, nonatomic) NSString *leg2String;
@property (strong, nonatomic) NSString *leg3String;
@property (strong, nonatomic) NSString *destinationString;

@property (strong, nonatomic) NSString *season;
@property (strong, nonatomic) NSString *type;
@property int passengers;
@property BOOL roundTrip;

@property (strong, nonatomic) FlightEstimatorData *estimatorData;
@property (strong, nonatomic) NFDFlightProfileEstimator *estimator;

+(void) resetInformation;
@end
