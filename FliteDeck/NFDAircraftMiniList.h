//
//  NFDAircraftMiniList.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AddLine.h"
#import "NFDPositioningButton.h"

@interface NFDAircraftMiniList : UIView 
@property (nonatomic,strong) UITableView *list;
@property (nonatomic,strong) NSArray *aircraft;
@property float  myHeight;
-(void) setData: (NSArray*) records;
@end
