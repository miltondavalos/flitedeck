//
//  NFDAircraftMiniList.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDAircraftMiniList.h"
#import "NFDPositioningMatrix.h"
#import <QuartzCore/QuartzCore.h>

@implementation NFDAircraftMiniList
@synthesize list, aircraft, myHeight;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addVerticalLineWithWidth:1 color:[UIColor whiteColor]  atX:0];
        [self setBackgroundColor:[UIColor clearColor]];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void) setData: (NSArray*) records {
    aircraft = records;
    float y = 5;
    for(NFDPositioningMatrix *ac in aircraft){
        NFDPositioningButton *button = [NFDPositioningButton buttonWithType:UIButtonTypeCustom];
        button.aircraft = ac;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"Positioning_Against_Competitors_Button_Normal.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"Positioning_Against_Competitors_Button_Highlighted.png"] forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor clearColor];
       [button addTarget:button action:@selector(showInfo) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
        [button setTitle:ac.acshortname forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Arial" size:10];
        button.frame = CGRectMake(5, y, self.frame.size.width-10, 25);
        [self addSubview:button];
        y+= 35;
    }
    
}

@end
