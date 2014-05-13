//
//  NFTWindCorrections.h
//  FlightAndTripTime
//
//  Created by Long Chad on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NFTWindCorrections : NSManagedObject

@property (nonatomic, retain) NSNumber * windCorrectionId;
@property (nonatomic, retain) NSNumber * springFallCorrection;
@property (nonatomic, retain) NSNumber * winterCorrection;
@property (nonatomic, retain) NSNumber * trueCourse;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * summerCorrection;
@property (nonatomic, retain) NSDate * lastChanged;

@end
