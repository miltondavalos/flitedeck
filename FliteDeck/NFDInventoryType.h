//
//  NFDInventoryType.h
//  FliteDeck
//
//  Created by Chad Predovich on 4/17/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDAircraftTypeGroup.h"
#import "NFDAircraftType.h"

@interface NFDInventoryType : NSObject
@property (nonatomic,strong) NFDAircraftTypeGroup *aircraftTypeGroup;
@property (nonatomic,strong) NFDAircraftType *aircraftType;
@property (nonatomic,strong) NSNumber *displayOrder;
@end
