//
//  NFDLegViewContainer.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDLegViewContainer.h"
#import "NFDLegViewQuote.h"
#import "Leg.h"
#import "NSNumber+Utilities.h"

@implementation NFDLegViewContainer
@synthesize legs,returnTrip;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        returnTrip = NO;
    }
    return self;
}

-(void) setData : (NSMutableArray*) legs_ {
    for(UIView *legview in [self subviews]){
        [legview removeFromSuperview];
    }
    float y=0;
    int cont=0;
    
    int type = 0;
    float distance = 0.0;
    if(returnTrip){
        int index = legs_.count-1;
        for(;index>=0;index--){
            Leg *leg = [legs_ objectAtIndex:index];
            //DLog(@"%@ %@",leg.origin.airportid,leg.destination.airportid);
            NFDLegViewQuote *lvq = [[NFDLegViewQuote alloc] initWithFrame:CGRectMake(0,y,768,30)];
            [lvq setData:leg type:type];
            distance += leg.distance;
            [self addSubview: lvq];
            y+= 30;
            cont++;
            type = 1;
        }
        Leg *leg = [legs_ objectAtIndex:0];
        NFDLegViewQuote *lvq = [[NFDLegViewQuote alloc] initWithFrame:CGRectMake(0,y,768,30)];
        [lvq setData:leg type:2];
        [self addSubview: lvq];
        
        y+=30;
        
        
        
    }else{
        for(Leg *leg in legs_){
            //DLog(@"%@ %@",leg.origin.airportid,leg.destination.airportid);
            NFDLegViewQuote *lvq = [[NFDLegViewQuote alloc] initWithFrame:CGRectMake(0,y,768,30)];
            [lvq setData:leg type:type];
            distance += leg.distance;
            [self addSubview: lvq];
            y+= 30;
            cont++;
            type = 1;
        }
        Leg *leg = [legs_ lastObject];
        NFDLegViewQuote *lvq = [[NFDLegViewQuote alloc] initWithFrame:CGRectMake(0,y,768,30)];
        [lvq setData:leg type:2];
        [self addSubview: lvq];
        
        y+=30;
    }
    
    NFDLegViewQuote *lvqTotal = [[NFDLegViewQuote alloc] initWithFrame:CGRectMake(0,y,768,30)];
    lvqTotal.title.text = @"Total Distance";
    lvqTotal.airportName.text = @"";
    lvqTotal.showInfo.hidden = YES;
    lvqTotal.distance.text = [[NSNumber numberWithFloat:distance] numberWithCommas:0];
    [self addSubview: lvqTotal];
    
}

/*-(void) dealloc {
    [legs removeAllObjects];
    legs = nil;
}*/

@end
