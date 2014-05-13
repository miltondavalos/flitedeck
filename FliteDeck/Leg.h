//
//  Leg.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDAirport.h"

@interface Leg : NSObject
@property(nonatomic,strong) NFDAirport *origin;
@property(nonatomic,strong) NFDAirport *destination;
@property(nonatomic,strong) NSString *originId;
@property(nonatomic,strong) NSString *destinationId;

@property(nonatomic,weak) NSString *originForPDF;
@property(nonatomic,weak) NSString *destinationForPDF;
@property int fuelStops;
@property int position;
@property float distance;
@property float blockTime;
@property float fuelCost;
@property float hourlyCost;
@property int californiaFee;
@property float totalCost;
@end
