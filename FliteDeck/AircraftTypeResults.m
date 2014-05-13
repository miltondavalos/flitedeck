//
//  AircraftTypeResults.m
//
//  Created by Evol Johnson on 1/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "AircraftTypeResults.h"

@implementation AircraftTypeResults

@synthesize aircraft,name,totalHr,ohfAndFuelHr,outInfo,returnInfo,subTotal,total,asapStop,rates,outLegs,retLegs;

-(id) init {
    self = [super init];
    if(self){
        outLegs = [[NSMutableArray alloc] init];
        retLegs = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSString *) description {
    NSString *data = [NSString stringWithFormat:@"%@, Speed:%.2f totalHr=%@ ohfAndFuelHr=%@ outInfo=%@ returnInfo=%@ subTotal=%@ total=%@ asapStop=%@",aircraft.typeFullName, [aircraft.highCruiseSpeed  floatValue], totalHr,ohfAndFuelHr,outInfo,returnInfo,subTotal,total,asapStop];
    return data;
}

@end