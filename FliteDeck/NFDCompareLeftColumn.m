//
//  NFDCompareLeftColumn.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDCompareLeftColumn.h"

@implementation NFDCompareLeftColumn

- (id) initWithCoder: (NSCoder*) coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self loadNib:@"NFDCompareLeftColumn"];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadNib:@"NFDCompareLeftColumn"];
        [self addVerticalLineWithWidth:1 color:[UIColor whiteColor]  atX:0];
        [self addVerticalLineWithWidth:1 color:[UIColor whiteColor]  atX:frame.size.width];
    }
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
