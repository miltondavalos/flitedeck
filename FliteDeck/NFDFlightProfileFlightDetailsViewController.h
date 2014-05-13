//
//  NFDFlightProfileFlightDetailsViewController.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightEstimatorData.h"
#import "NFDFlightProfileEstimator.h"
#import "PopoverTableViewController.h"
#import "NFDAircraftTile.h"
#import "AircraftTypeGroup+Custom.h"
#import "LegEditorView.h"

@interface NFDFlightProfileFlightDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate> {
    PopoverTableViewController *popoverContent;
    NSArray *seasonsArray;
    NSArray *typeArray;
    NSMutableArray *tableDataArray;
    UIPopoverController *popover;
      
    NSMutableDictionary *selectedAircraftTypes;
    
    NSIndexPath *seasonsIndexPath;
    NSIndexPath *typeIndexPath;
    
}


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


//Additional Selection Controls
@property (weak, nonatomic) IBOutlet UIStepper *adjustPassengersStepper;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPassengers;

//Trip Option Controls
@property (weak, nonatomic) IBOutlet UITableView *tripOptionsTable;
@property (strong, nonatomic) PopoverTableViewController *popoverContent;
@property (strong, nonatomic) NSArray *seasonsArray;
@property (strong, nonatomic) NSArray *typeArray;
@property (strong, nonatomic) NSMutableArray *tableDataArray;
@property (strong, nonatomic) UIPopoverController *popover;

//Custom Properties
@property (strong, nonatomic) FlightEstimatorData *parameters;
@property (strong, nonatomic) NFDFlightProfileEstimator *estimator;
@property (strong, nonatomic) NSMutableDictionary *selectedAircraftTypes;



//Aircraft Tiles
@property (weak, nonatomic) IBOutlet UIView *aircraftTileContainer;
@property (weak, nonatomic) IBOutlet NFDAircraftTile *aircraft1;
@property (weak, nonatomic) IBOutlet NFDAircraftTile *aircraft2;
@property (weak, nonatomic) IBOutlet NFDAircraftTile *aircraft3;

@property (strong, nonatomic) IBOutlet LegEditorView *legEditor;
@property (strong, nonatomic) NSMutableArray *airports;
//Custom Actions
- (IBAction) adjustNumberOfPassengers:(id)sender;

- (void) saveParameters;
- (void) dismissModal;
- (void) cancelModal;
- (void) resetControls;

-(void) madeAirportSelection : (NSNotification *) notification;
-(void) checkParameters;

- (void) showAircrafts;
- (void) updateAircraftWarnings;

-(void) setupAirports;
-(void) prepareParameters;
- (void) hideAircrafts;

- (void)keyboardWillHide;
- (void)positionTripOptionsPopoverOnOrientationChange;
- (void)tableView:(UITableView*)tableView showTripOptionsPopoverForIndexPath:(NSIndexPath *)indexPath;

@end
