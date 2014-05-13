//
//  NFDPassengerNumberSelector.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDPassengerNumberSelector.h"

@implementation NFDPassengerNumberSelector
@synthesize maxPassengers;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    //1 Get maxNumber of passengers from the service
    //2 draw icons [scaling appropiately]
    // draw slider
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
