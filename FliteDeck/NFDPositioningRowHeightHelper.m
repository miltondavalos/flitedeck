//
//  NFDPositioningRowHeightHelper.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDPositioningRowHeightHelper.h"
#define ITEM_HEIGHT  35

@implementation NFDPositioningRowHeightHelper

+(NSNumber*) getMaxHeight : (NFDCompany *) company {
    
    NFDPositioningService *service = [[NFDPositioningService alloc] init];
    float tempRowHeight = 0;
    
    
    float tempHeight = [[service getAircraftForCompany: company.name size:@"Light Cabin"]count] * ITEM_HEIGHT;
    if( tempHeight > tempRowHeight){
        tempRowHeight =   tempHeight; 
    }
    
    
    tempHeight = [[service getAircraftForCompany: company.name size:@"Midsize Cabin"]count] * ITEM_HEIGHT;
    if( tempHeight > tempRowHeight){
        tempRowHeight =   tempHeight; 
    }
    
    tempHeight = [[service getAircraftForCompany: company.name size:@"Large Cabin"]count] * ITEM_HEIGHT;
    if( tempHeight > tempRowHeight){
        tempRowHeight =   tempHeight; 
    }
    
    tempHeight = [[service getAircraftForCompany: company.name size:@"Super Midsize Cabin"]count] * ITEM_HEIGHT;
    if( tempHeight > tempRowHeight){
        tempRowHeight =   tempHeight; 
    }
    
    tempHeight = [[service getAircraftForCompany: company.name size:@"TPROP-VLJ"]count] * ITEM_HEIGHT;
    if( tempHeight > tempRowHeight){
        tempRowHeight =   tempHeight; 
    }
    if(tempRowHeight < ITEM_HEIGHT){
        return [NSNumber numberWithFloat:ITEM_HEIGHT];
    }
    return [NSNumber numberWithFloat:tempRowHeight];
    
}
@end
