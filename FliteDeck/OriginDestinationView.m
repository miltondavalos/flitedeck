//
//  LegView.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OriginDestinationView.h"

@implementation OriginDestinationView
@synthesize aselector,removeLegButton,addLegButton,position,isDestination;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isDestination = NO;
        //[self setBackgroundColor: [UIColor blackColor]];
        aselector = [[AirportSelectorView alloc] initWithFrame:CGRectMake(0, 0, 368, 40)];
        [self addSubview:aselector];
        aselector.airportSearchBar.placeholder = @"Origin: Name, City or Code";
        
    }
    return self;
}

-(void) setupButtons {
    //[aselector setBackgroundColor: [UIColor greenColor]];
    
    if(!isDestination){
        addLegButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addLegButton.frame = CGRectMake(385, 8, BUTTONDIMENSION, BUTTONDIMENSION);
        [addLegButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [addLegButton addTarget:self action:@selector(addLeg) forControlEvents:UIControlEventTouchUpInside];
        
        //[addLegButton setBackgroundColor: [UIColor blueColor]];
        [self addSubview:addLegButton];
        //addLegButton.alpha = 0.0;
    }
    
}

-(void) removeLeg {
    [aselector clearSelectedAirport];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"removeLeg" 
     object:position];
    
}


-(void) addLeg {
    @try{
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"addLeg" 
     object:nil];
    addLegButton.alpha = 0.0;
    }@catch(NSError *error){
        DLog(@"%@",[error description]);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void) setAirport: (NFDAirport*) airport{
    [aselector setAirport:airport];
}

-(void) setAirportFromId: (NSString*) airportid{
    [aselector setAirportFromId:airportid];
}

@end
