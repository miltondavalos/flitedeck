//
//  NFDAircraftSelector.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "NFDAircraftTile.h"
#import "NFDAircraftTypeService.h"

@interface NFDAircraftSelector : UIView <iCarouselDataSource, iCarouselDelegate> {
   IBOutlet iCarousel *carousel;
   int maximunSelectable;
   int howManySelected;
}
@property (nonatomic,strong) IBOutlet iCarousel *carousel;
@property (nonatomic,strong) NSArray *aircrafts;
@property (nonatomic,strong) NSMutableArray *selectedAircraft;
@property int maximunSelectable;
@property int howManySelected;

-(NSMutableArray*) getSelectedAircrafts;
-(void) loadAircraft: (NSArray *) listOfAircraft;
-(void) setup;
@end
