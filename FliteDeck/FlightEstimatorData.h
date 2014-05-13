//
//  FlightEstimatorParameters.h
//  FlightProfile
//
//  Created by Evol Johnson on 1/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prospect.h"
#import "NFDAirport.h"
#import "NFDAircraftTypeGroup.h"
#import "NFDAirportService.h"


@interface FlightEstimatorData : NSObject
@property(nonatomic, strong) NSMutableArray *aircrafts;
@property(nonatomic, strong) NSMutableArray *airports;
@property(nonatomic, strong) NSMutableArray *airportIds;
@property(nonatomic, strong) NSNumber *totalDistance;
@property(nonatomic, strong) NSString *season;
@property(nonatomic, strong) NSString *product;
@property int passengers;
@property BOOL roundTrip;
@property(nonatomic, strong) NSMutableArray *results;

@property(nonatomic, strong) Prospect *prospect;
@property (nonatomic, strong) NSMutableDictionary *userInfo;


-(void) addAirport: (NFDAirport *) airport;
-(void) resetInformation;
-(void) retrieveAirportsFromIds;

@end
