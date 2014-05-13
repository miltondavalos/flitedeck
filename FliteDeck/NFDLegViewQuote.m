//
//  NFDLegViewQuote.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDLegViewQuote.h"
#import "NSNumber+Utilities.h"

@implementation NFDLegViewQuote
@synthesize title,airportName,distance,showInfo,airport;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *topLevelObjs = nil;
        topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NFDLegViewQuote" owner:self options:nil];
        [self addSubview: [topLevelObjs objectAtIndex:0]];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *topLevelObjs = nil;
        topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NFDLegViewQuote" owner:self options:nil];
        [self addSubview: [topLevelObjs objectAtIndex:0]];
    }
    return self;
}

-(void) setData: (Leg*) leg  type : (int) type {
    
    switch(type){
        case 0: title.text = @"Origin:";
            airportName.text = [NSString stringWithFormat:@"%@ - %@ (%@)", leg.origin.airport_name,leg.origin.city_name,leg.origin.airportid];
            distance.text = [[NSNumber numberWithFloat:leg.distance] numberWithCommas:0];
            airport = leg.origin;
            break;
        case 1: title.text = [NSString stringWithFormat:@"Leg:"];
            airportName.text = [NSString stringWithFormat:@"%@ - %@ (%@)",leg.origin.airport_name,leg.origin.city_name, leg.origin.airportid];
            distance.text = [[NSNumber numberWithFloat:leg.distance] numberWithCommas:0];
            airport = leg.origin;
            break;
        case 2: title.text = [NSString stringWithFormat:@"Destination:"];
            airportName.text = [NSString stringWithFormat:@"%@ - %@ (%@)", leg.destination.airport_name, leg.destination.city_name, leg.destination.airportid];
            airport = leg.destination;
            distance.text = @"--";

    }
}

-(IBAction) viewAirportDetail: (id) sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewAirportDetail" object:airport];
}

-(void) dealloc {
    airport = nil;
    title = nil;
    distance = nil;
    airportName = nil;
}

@end
