//
//  LegView.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirportSelectorView.h"
#define BUTTONDIMENSION 23

@interface OriginDestinationView : UIView{
    AirportSelectorView *aselector;
    UIButton *removeLegButton;
    UIButton *addLegButton;
    NSNumber *position;
    BOOL isDestination;
}
@property (nonatomic,strong) AirportSelectorView *aselector;
@property (nonatomic,strong) UIButton *removeLegButton;
@property (nonatomic,strong) UIButton *addLegButton;
@property (nonatomic,strong) NSNumber *position;
@property  BOOL isDestination;
-(void) addLeg;
-(void) removeLeg;
-(void) setAirport: (NFDAirport*) airport;
-(void) setAirportFromId: (NSString*) airportid;
-(void) setupButtons;
@end
