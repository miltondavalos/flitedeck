//
//  NFDPositioningCell.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/23/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDCompany.h"
#import "NFDAircraftMiniList.h"
#import "NFDPositioningButton.h"
#import "NFDPositioningService.h"
#import "NFDPositioningRowHeightHelper.h"

@interface NFDPositioningCell : UITableViewCell {
    NSInteger maxColumns;
    NSInteger totalColumns;
}
@property (nonatomic,strong) UIButton *firstColumn;
@property (nonatomic,strong) NFDCompany *company;
@property  NSInteger maxColumns;
@property  NSInteger totalColumns;
@property  NSInteger columnWidth;
@property (nonatomic,strong) NSNumber *rowHeight;

-(void) setViewAtIndex: (UIView*) columnView index: (NSInteger) position;
-(void) doLayout : (CGRect) frame;
@end
