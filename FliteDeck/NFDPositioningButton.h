//
//  NFDPositioningButton.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDPositioningPopupViewController.h"
#import "NFDPositioningMatrix.h"
#import "NFDCompany.h"


@interface NFDPositioningButton : UIButton
@property (nonatomic,strong) NFDPositioningPopupViewController *warningsContent;
@property (nonatomic,strong) NFDPositioningMatrix *aircraft;
@property (nonatomic,strong) NFDCompany *company;
@property (nonatomic,strong) UIPopoverController *popover;
-(void) showInfo;
-(NSString *) textFromEntity;
@end
