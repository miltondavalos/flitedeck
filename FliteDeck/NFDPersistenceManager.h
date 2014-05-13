//
//  NFDPersistenceManager.h
//  FliteDeck
//
//  Created by Chad Long on 3/12/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NCLFramework.h"

@interface NFDPersistenceManager : NCLPersistenceManager

+ (NFDPersistenceManager*)sharedInstance;

@end