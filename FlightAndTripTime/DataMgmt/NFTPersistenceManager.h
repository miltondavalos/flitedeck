//
//  PersistenceManager.h
//  FlightAndTripTime
//
//  Created by Long Chad on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NCLFramework.h"

@interface NFTPersistenceManager : NCLPersistenceManager

+ (NFTPersistenceManager*)sharedInstance;

@end
