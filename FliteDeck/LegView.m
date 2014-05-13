//
//  LegView.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LegView.h"

@implementation LegView



-(void) setupButtons {
    //[aselector setBackgroundColor: [UIColor greenColor]];
    
    addLegButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addLegButton.frame = CGRectMake(425, 8, BUTTONDIMENSION, BUTTONDIMENSION);
    [addLegButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [addLegButton addTarget:self action:@selector(addLeg) forControlEvents:UIControlEventTouchUpInside];
    
    //[addLegButton setBackgroundColor: [UIColor blueColor]];
    [self addSubview:addLegButton];
    addLegButton.alpha = 1.0;
    
    removeLegButton = [UIButton buttonWithType:UIButtonTypeCustom];
    removeLegButton.frame = CGRectMake(385, 8, BUTTONDIMENSION, BUTTONDIMENSION);
    [removeLegButton setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    [removeLegButton addTarget:self action:@selector(removeLeg) forControlEvents:UIControlEventTouchUpInside];
    
    //[removeLegButton setBackgroundColor: [UIColor redColor]];
    [self addSubview:removeLegButton];
    removeLegButton.alpha = 1.0;
}



@end
