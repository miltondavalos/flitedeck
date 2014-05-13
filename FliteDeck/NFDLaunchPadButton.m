//
//  LaunchPadButton.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NFDLaunchPadButton.h"

@implementation NFDLaunchPadButton
@synthesize title,notification,imagename,button,titleLabel,imagenameselected;

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *topLevelObjs = nil;
        topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NFDLaunchPadButton" owner:self options:nil];
        [self addSubview: [topLevelObjs objectAtIndex:0]];
    }
    return self;
}

-(void) setup {
    UIImage *aircraftImageNormal = [UIImage imageNamed:imagename];

    [button setImage:aircraftImageNormal forState:UIControlStateNormal];
    UIImage *aircraftImageSelected = [UIImage imageNamed:imagenameselected];
    [button setImage:aircraftImageSelected forState:UIControlStateSelected];
    titleLabel.text = title;

    [button addTarget:self action:@selector(fireNotification) forControlEvents:UIControlEventTouchUpInside];

    [[[button superview] layer] setCornerRadius:10];

    [[button superview] setClipsToBounds:YES];
}

-(void) fireNotification {
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:notification 
     object:nil];
}
@end
