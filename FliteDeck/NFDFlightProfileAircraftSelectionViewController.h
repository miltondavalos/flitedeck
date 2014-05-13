//
//  NFDFlightProfileAircraftSelectionViewController.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDAircraftTile.h"
#import "FlightEstimatorData.h"
#import "NFDFlightProfileFlightDetailsViewController.h"
#import "NFDFlightQuoteViewController.h"

#import "NFDFlightProfileEstimator.h"

@interface NFDFlightProfileAircraftSelectionViewController : UIViewController {

    //One Modal per View
    UINavigationController *modalController;
    
    //Aircraft Scroll View Selection Variables
    NSMutableDictionary *aircraftTypes;
    NSMutableDictionary *checkMarks;
    NSMutableDictionary *selectedAircraftTypes;
    FlightEstimatorData *parameters;

}

//Aircraft Scroll View Outlets
@property (weak, nonatomic) IBOutlet UIView *aircraftSelectionView;
@property (weak, nonatomic) IBOutlet UIImageView *aircraftSelectorTab;
@property (weak, nonatomic) IBOutlet UIScrollView *aircraftSelectionScrollView;
@property (weak, nonatomic) IBOutlet UIView *aircraftThumbnailsView;

//Displayed Aircraft View Outlets
@property (weak, nonatomic) IBOutlet NFDAircraftTile *displayedAircraftPhoto;
@property (weak, nonatomic) IBOutlet UILabel *displayedAircraftType;
@property (weak, nonatomic) IBOutlet UIImageView *displayedAircraftCheckmark;
@property (weak, nonatomic) IBOutlet UIScrollView *displayedAircraftScrollView;
@property (weak, nonatomic) IBOutlet UIView *displayedAircraftPhotosView;

// Labels for Aircraft information:

@property (weak, nonatomic) IBOutlet UILabel *passengerCapacity_Label;
@property (weak, nonatomic) IBOutlet UILabel *baggageCapacity_Label;
@property (weak, nonatomic) IBOutlet UILabel *cruiseSpeed_Label;
@property (weak, nonatomic) IBOutlet UILabel *range_Label;
@property (weak, nonatomic) IBOutlet UILabel *cabinLength_Label;
@property (weak, nonatomic) IBOutlet UILabel *cabinHeight_Label;
@property (weak, nonatomic) IBOutlet UILabel *cabinWidth_Label;
@property (weak, nonatomic) IBOutlet UILabel *altitude_Label;
@property (weak, nonatomic) IBOutlet UILabel *cabinAmenities_Label;

@property (weak, nonatomic) IBOutlet UILabel *capacity;
@property (weak, nonatomic) IBOutlet UILabel *rangeInHours;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *cabinHeight;
@property (weak, nonatomic) IBOutlet UILabel *cabinWidth;
@property (weak, nonatomic) IBOutlet UILabel *baggageCapacity;

@property (strong, nonatomic) FlightEstimatorData *parameters;
@property (strong, nonatomic) NSMutableDictionary *selectedAircraftTypes;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *viewForAircraftDetailComponent;

@property (strong, nonatomic) NFDFlightQuoteViewController *flightQuoteViewController;
@property (strong, nonatomic) NFDFlightProfileFlightDetailsViewController *flightDetailController;

@property BOOL canSelectMore;

@property (nonatomic) BOOL isFirstLoad;

//One Modal per View
@property(nonatomic, retain) UINavigationController *modalController;


@property (strong, nonatomic) NFDFlightProfileEstimator *estimator;


- (void)updateGestureRecognizers;
- (void)loadAllAircraft;
- (void)createAircraftScrollView;
- (void)addAircraftImageToScrollViewAtPosition:(int)position;
- (void)updateMoneyShotWithKey:(int)index;
//- (void)toggleAircraftViewCheckmark;
- (void)updateSelectedAircraftListWithKey:(int)key;
- (void)updateAircraftDetailPhotoScrollView;
- (void)updateAircraftDetailImageInModal:(int)numberOfPhoto;
- (void)setDataForAircraftDetails:(NFDAircraftTypeGroup *)aircraft;
- (void) setupMoneyShotCheckmark : (BOOL) selected;

- (void) updateWarnings;
- (void) flightDetailsDismissed: (NSNotification*) notification;
- (void) canEstimate;
- (void) prepareParameters;
- (void)configureButtons;
- (void)clearAllFieldsInFlightProfileDetailViewModal;
@end
