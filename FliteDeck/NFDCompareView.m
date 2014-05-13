//
//  NFDCompareView.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDCompareView.h"

@implementation NFDCompareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addVerticalLineWithWidth:1 color:[UIColor whiteColor]  atX:0];
        [self addVerticalLineWithWidth:1 color:[UIColor whiteColor]  atX:frame.size.width];
    }
    return self;
}

-(void) loadNib : (NSString*) nibName {
    NSArray *topLevelObjs = nil;
    topLevelObjs = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    [self addSubview: [topLevelObjs objectAtIndex:0]];
}



@end
