//
//  NFDFlightProposalInventoryModalController.h
//  ProposalCalculatorPrototype
//
//  Created by Geoffrey Goetz on 3/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDAppDelegate.h"
#import "NFDAircraftType.h"
#import "NFDAircraftTypeGroup.h"
#import "NFDAircraftTile.h"
#import "NFDNetJetsStyleHelper.h"
#import "NFDFlightProposalManager.h"
//#import "NFDAircraftTypeProposalService.h"

//Aircract Scroll View Constants for Pulldown Shade
#define SHADE_HEIGHT_TO_HIDE 247

#define PADDING_BETWEEN_AIRCRAFT 10
#define PADDING_ABOVE_AIRCRAFT 10
#define AIRCRAFT_IMAGE_HEIGHT_2 127
#define AIRCRAFT_IMAGE_WIDTH_2 145

@interface NFDFlightProposalInventoryModalController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

    //Aircraft Scroll View Selection Variables
    NSMutableArray *aircraftTypes;
//    NFDAircraftTypeProposalService *aircraftTypeProposalService;
    NFDAircraftTile *selectedTile;
    NFDAircraftTypeGroup *selectedAircraftTypeGroup;

    NSMutableArray *aircrafts;
    NSArray *sortedInventoryTypes;
}

@property (weak, nonatomic) IBOutlet UIView *aircraftSelectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *aircraftSelectionScrollView;
@property (weak, nonatomic) IBOutlet UIView *aircraftThumbnailsView;
@property (weak, nonatomic) IBOutlet UILabel *selectedAircraftName;
@property (weak, nonatomic) IBOutlet UITableView *inventoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *column1Heading;
@property (weak, nonatomic) IBOutlet UILabel *column2Heading;
@property (weak, nonatomic) IBOutlet UILabel *column3Heading;
@property (weak, nonatomic) IBOutlet UILabel *column4Heading;
@property (weak, nonatomic) IBOutlet UILabel *column5Heading;
@property (weak, nonatomic) IBOutlet UILabel *column6Heading;
@property (strong, nonatomic) IBOutlet UIToolbar *columnHeadingToolbar;
@property (strong, nonatomic) IBOutlet UILabel *inventorySyncDateLabel;

- (void)loadAllAircraft;
- (void)createAircraftScrollView;
- (void)addAircraftImageToScrollViewAtPosition:(int)position;

- (IBAction)sortAircrafts:(id)sender;

@end
