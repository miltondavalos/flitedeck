//
//  NFDPositioningHeader.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverTableViewController.h"
#import "NFDNetJetsStyleHelper.h"
#import "UIView+AddLine.h"
#import <QuartzCore/QuartzCore.h>

@interface NFDPositioningHeader : UIView
@property (nonatomic,strong) IBOutlet UIButton *operators;
@property (nonatomic,strong) IBOutlet UIButton *manufacturers;
@property (nonatomic,strong) IBOutlet UILabel *light;
@property (nonatomic,strong) IBOutlet UILabel *mid;
@property (nonatomic,strong) IBOutlet UILabel *superMid;
@property (nonatomic,strong) IBOutlet UILabel *large;
@property (nonatomic,strong) IBOutlet UILabel *tprop;
-(IBAction) showOperators:(id) sender;
-(IBAction) showManufacturers:(id) sender;
-(void) doLayout : (CGRect) frame;
@end
