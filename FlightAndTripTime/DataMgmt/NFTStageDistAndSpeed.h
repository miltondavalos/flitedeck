//
//  NFTStageDistAndSpeed.h
//  FlightAndTripTime
//
//  Created by Long Chad on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NFTStageDistAndSpeed : NSManagedObject

@property (nonatomic, retain) NSNumber * stageDistAndSpeedId;
@property (nonatomic, retain) NSString * aircraftType;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * averageSpeed;
@property (nonatomic, retain) NSDate * lastChanged;

@end
