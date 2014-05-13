//
//  NFDPositioningself.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/23/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDPositioningCell.h"
#define ITEM_HEIGHT  35

@implementation NFDPositioningCell
@synthesize firstColumn,maxColumns,totalColumns,columnWidth,rowHeight,company;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    //UIImageView *imageView = [[UIImageView alloc] init];
    //imageView.image = [UIImage imageNamed:@"gridbackground.jpg"];
    //self.backgroundView = imageView;
    totalColumns = 0;
    maxColumns = 6;
    //rowHeight = 200;
    return self;
}


-(void) doLayout : (CGRect) frame {
    columnWidth = (int) (frame.size.width/maxColumns);
    //DLog(@"COLUMNWIDTH %d", columnWidth);
    if ([self subviews]){
        for (UIView *subview in [self subviews]) {
            if([subview isKindOfClass: [UIButton class]] || [subview isKindOfClass: [NFDAircraftMiniList class]]){
                [subview removeFromSuperview];
            }
            
        }
    }
    totalColumns=0;
    rowHeight = [NFDPositioningRowHeightHelper getMaxHeight:company];
    NFDPositioningService *service = [[NFDPositioningService alloc] init];
    
    NFDPositioningButton *button = [NFDPositioningButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:button action:@selector(showInfo) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    button.company = company;
    button.userInteractionEnabled = YES;
    button.frame = CGRectMake(5, 5, self.columnWidth-10,[rowHeight intValue]-10);
    [button setTitle:company.name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor clearColor];
    //---->>button.tag = indexPath.row;
    [button setBackgroundImage:[UIImage imageNamed:@"Positioning_Against_Competitors_Button_Normal@6x.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Positioning_Against_Competitors_Button_Highlighted@6x.png"] forState:UIControlStateHighlighted];
    [self setViewAtIndex:button index:0];
    
    
    
    NFDAircraftMiniList *lightList = [[NFDAircraftMiniList alloc] initWithFrame:CGRectMake(0, 0, self.columnWidth,[rowHeight intValue])];
    [lightList setData: [service getAircraftForCompany: company.name size:@"Light Cabin"]];
    [self setViewAtIndex:lightList index:1]; 
    
    
    
    NFDAircraftMiniList *midList = [[NFDAircraftMiniList alloc] initWithFrame:CGRectMake(0, 0, self.columnWidth,[rowHeight intValue])];
    [midList setData: [service getAircraftForCompany: company.name size:@"Midsize Cabin"]];
    [self setViewAtIndex:midList index:2]; 
    
    
    
    NFDAircraftMiniList *superList = [[NFDAircraftMiniList alloc] initWithFrame:CGRectMake(0, 0, self.columnWidth,[rowHeight intValue])];
    [superList setData: [service getAircraftForCompany: company.name size:@"Super Midsize Cabin"]];
    [self setViewAtIndex:superList index:3];
    
    
    NFDAircraftMiniList *largeList = [[NFDAircraftMiniList alloc] initWithFrame:CGRectMake(0, 0, self.columnWidth,[rowHeight intValue])];
    [largeList setData: [service getAircraftForCompany: company.name size:@"Large Cabin"]];
    [self setViewAtIndex:largeList index:4];
    
    
    NFDAircraftMiniList *tpropList = [[NFDAircraftMiniList alloc] initWithFrame:CGRectMake(0, 0, self.columnWidth,[rowHeight intValue])];
    [tpropList setData: [service getAircraftForCompany: company.name size:@"TPROP-VLJ"]];
    [self setViewAtIndex:tpropList index:5];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) setViewAtIndex: (UIView*) columnView index: (NSInteger) position {
    UIView *view = [self viewWithTag: (position+200)];
    if(view == nil){
        if(totalColumns < maxColumns){
            columnView.tag = (position+200);
            [self addSubview:columnView]; 
            columnView.frame = CGRectMake(totalColumns*(columnWidth), 0, columnWidth, [rowHeight intValue]);
        }
        totalColumns++;
        
    }else{
        view = columnView;
    }
    
    
}

@end
