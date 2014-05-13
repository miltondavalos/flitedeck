//
//  JetResultsData.h
//  FlightProfile
//
//  Created by Evol Johnson on 1/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDAircraftType.h"
#import "NFDContractRate.h"

@interface AircraftTypeResults : NSObject

@property (nonatomic,retain) NFDAircraftType * aircraft;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * totalHr;
@property (nonatomic,retain) NSString * ohfAndFuelHr;
@property (nonatomic,retain) NSString * outInfo;
@property (nonatomic,retain) NSString * returnInfo;
@property (nonatomic,retain) NSString * subTotal;
@property (nonatomic,retain) NSString * total;
@property (nonatomic,retain) NSString * asapStop;
@property (nonatomic,retain) NFDContractRate *rates;
@property (nonatomic,retain) NSMutableArray *outLegs;
@property (nonatomic,retain) NSMutableArray *retLegs;
@end
