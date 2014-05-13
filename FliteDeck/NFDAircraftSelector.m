//
//  NFDAircraftSelector.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDAircraftSelector.h"
#import "NFDAircraftTypeService.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#define ITEM_SPACING 250
#define TILE_HEIGHT 175
#define TILE_WIDTH 215


@implementation NFDAircraftSelector
@synthesize aircrafts,carousel,maximunSelectable,selectedAircraft,howManySelected;


- (id)initWithCoder : (NSCoder*) coder {
    
    self = [super initWithCoder: coder ];
    if (self) { 
        [self setup];
    }
    return self;
}

- (id)initWithFrame : (CGRect) frame
{
    self = [super initWithFrame: frame ];
    if (self) {
        
        [self setup];
    }
    return self;
}

-(void) loadAircraft: (NSArray *) listOfAircraft {
    aircrafts = listOfAircraft;
    [carousel reloadData];
    [carousel scrollToItemAtIndex:0 animated:YES];
    //select #1
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"touchedAircraft" 
     object:[aircrafts objectAtIndex:0]];
}



-(void) setup {
    carousel = [[iCarousel alloc] initWithFrame: self.frame];
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.type = iCarouselTypeLinear;
    
    NFDAircraftTypeService *service = [[NFDAircraftTypeService alloc] init];
    aircrafts = [service getAllAircraft];
    [self loadAircraft:aircrafts];
    
    [carousel setBackgroundColor:[UIColor clearColor]];
    [self addSubview: carousel];
    
    maximunSelectable = 3;
    howManySelected = 0;
}


-(NSMutableArray*) getSelectedAircrafts {
    if(selectedAircraft != nil){
        [selectedAircraft removeAllObjects];
    }
    selectedAircraft = [[NSMutableArray alloc]init ];
    for(NFDAircraftTile *tile in [carousel visibleItemViews]){
        if(tile.selected == YES){
            [selectedAircraft addObject:tile.aircraft];
        }
    }
    return selectedAircraft;
}


#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [aircrafts count];
    
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return [aircrafts count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	NFDAircraftTile *tile = nil;
	//create new view if no view is available for recycling
    NFDAircraftTypeGroup *aircraft = [aircrafts objectAtIndex:index];
	if (view == nil)
	{
        
        tile = [[NFDAircraftTile alloc] initWithFrame:CGRectMake(0, 0, TILE_WIDTH, TILE_HEIGHT)];
        tile.position = [NSNumber numberWithInt: index];
        //Set Selector for Pressing of Aircraft Button
        [tile setData:aircraft];
        tile.belongs = self;
	}
	return tile;
}


- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return NO;
}

@end
