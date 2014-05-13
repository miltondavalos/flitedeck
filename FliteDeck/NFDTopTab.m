//
//  NFDTopTab.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDTopTab.h"

@implementation NFDTopTab
@synthesize extended,flightButton,aircraftTypesButton,flightView,aircraftView,aircraftSelector;

- (id)initWithCoder : (NSCoder*) coder {
    
    self = [super initWithCoder: coder ];
    if (self) { 
        NSArray *topLevelObjs = nil;
        topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NFDTopTab" owner:self options:nil];
        flightView = [topLevelObjs objectAtIndex:1];
        aircraftView = [topLevelObjs objectAtIndex:0];
        [self addSubview: flightView ];
        [self addSubview: aircraftView ];
        extended = NO;
        [self setupGestures];
        
        
    }
    return self;
}

-(void) setupGestures {
    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swippedDown:)];
    [swipeDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:swipeDownGesture];
    
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swippedUp:)];
    [swipeUpGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipeUpGesture];
}

- (void) swippedUp:(UISwipeGestureRecognizer *)gestureRecognizer {
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"swippedUPTopTab" 
     object:nil];
    extended = NO;
}

- (void)swippedDown:(UISwipeGestureRecognizer *)gestureRecognizer {
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"swippedDOWNTopTab" 
     object:nil];
    extended = YES;
}

-(void) showAircraftTab {
    [self bringSubviewToFront:aircraftView];
}

-(void)  showFlightTab {
    [self bringSubviewToFront:flightView];
}

-(IBAction)clickedFlight:(id) sender {
    
    [self showFlightTab];
    
}
-(IBAction)clickedAircraft:(id) sender {
    [self showAircraftTab];
}

@end
