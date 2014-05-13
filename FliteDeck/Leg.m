//
//  Leg.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Leg.h"

@implementation Leg
@synthesize origin,destination,fuelStops,distance,blockTime,fuelCost,hourlyCost,totalCost,originId,destinationId,originForPDF,destinationForPDF,position,californiaFee;

-(NSString *) description {
    return [NSString stringWithFormat:@"%@ -> %@",origin.airportid,destination.airportid];
}

/*-(void) dealloc  {
    origin = nil;
    destination = nil;
}*/
@end
