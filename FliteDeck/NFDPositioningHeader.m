//
//  NFDPositioningHeader.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDPositioningHeader.h"
#import "PopoverTableViewController.h"

@implementation NFDPositioningHeader
@synthesize operators,manufacturers,light,mid,superMid,large,tprop;
- (id)init
{
    self = [super init];
    if (self) {
        NSArray *topLevelObjs = nil;
        topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NFDPositioningHeader" owner:self options:nil];
        [self addSubview: [topLevelObjs objectAtIndex:0]];
        UIView *view = [self.subviews objectAtIndex:0];
        
        [view setBackgroundColor: UIColorFromHex(0xf5f5f5)];
        [self addHorizontalLineWithWidth:1 color:[UIColor blackColor]  atY:38];
        //self.popoverContent = [[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil];
        //self.popoverContent.tableView.dataSource = self;
        //self.popoverContent.tableView.delegate = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *topLevelObjs = nil;
        topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NFDPositioningHeader" owner:self options:nil];
        [self addSubview: [topLevelObjs objectAtIndex:0]];
        [self doLayout: frame];
    }
    return self;
}


-(IBAction) showOperators:(id) sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPACOperators" object:nil];
    [operators setBackgroundImage:[UIImage imageNamed:@"Positioning_Against_Competitors_Button_Highlighted.png"] forState:UIControlStateNormal];
    [operators setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [manufacturers setBackgroundImage:[UIImage imageNamed:@"Positioning_Against_Competitors_Button_Normal.png"] forState:UIControlStateNormal];
    
    [manufacturers setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

-(IBAction) showManufacturers:(id) sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPACManufacturers" object:nil];
    [operators setBackgroundImage:[UIImage imageNamed:@"Positioning_Against_Competitors_Button_Normal.png"] forState:UIControlStateNormal];
    [operators setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [manufacturers setBackgroundImage:[UIImage imageNamed:@"Positioning_Against_Competitors_Button_Highlighted.png"] forState:UIControlStateNormal];
    
    [manufacturers setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void) doLayout : (CGRect) frame {
    int columnWidth = (int) (frame.size.width/6);

    if ([self subviews]){
        int cont = 0;
        float x=0;
        UIView *container = [[self subviews] objectAtIndex:0];
        for (UIView *subview in [container subviews]) {
            if([subview isKindOfClass: [UIButton class]]){
                subview.frame = CGRectMake(x,0,columnWidth/2,38);
                x += (columnWidth/2);
                [subview addVerticalLineWithWidth:1 color:[UIColor blackColor]  atX:0];
            }
            
            if([subview isKindOfClass: [UILabel class]]){
                subview.frame = CGRectMake(x,0,columnWidth,38);
                x+= columnWidth;
                [subview addVerticalLineWithWidth:1 color:[UIColor blackColor]  atX:0];
            }
            cont++;
        }
        [self addHorizontalLineWithWidth:1 color:[UIColor blackColor]  atY:38];
    }
    
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
