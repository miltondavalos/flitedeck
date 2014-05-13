//
//  LegEditorView.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OriginDestinationView.h"
#import "LegView.h"

@interface LegEditorView : UIView
@property (nonatomic,strong) NSMutableArray *legs;
@property (nonatomic,strong) NSMutableArray *airports;
@property (nonatomic,strong) OriginDestinationView *origin;
@property (nonatomic,strong) OriginDestinationView *destination;
@property int totalLegs;
@property CGRect lastFrame;

-(OriginDestinationView*) addOrigin;
-(OriginDestinationView*) addDestination;
-(LegView*) addLeg;
-(LegView*) setupLeg;
-(void) removeLeg: (NSNotification*) notification;
-(void) layoutLegs;
-(void) setupAirports: (NSMutableArray *) airports;
-(void) getAirports: (NSMutableArray *) airports;
-(void) clearAll;
@end
