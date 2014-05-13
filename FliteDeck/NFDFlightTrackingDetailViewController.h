//
//  NFDFlightTrackingDetailViewController.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MGSplitViewController.h"
#import "NFDFlight.h"
#import "NFDPassenger.h"
#import "NFDAirport.h"
#import "TTTAttributedLabel.h"

@interface NFDFlightTrackingDetailViewController : UIViewController <MKMapViewDelegate,
        MGSplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIAlertViewDelegate>
{

    UIPopoverController *popover;
    NSDictionary *actionListDctionary;

}

@property (strong, nonatomic) UIPopoverController *popover;

@property (weak, nonatomic) IBOutlet UILabel *detailsGeneratedLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackingGeneratedLabel;

@property (weak, nonatomic) IBOutlet UIView *detailInformationView;

@property (weak, nonatomic) IBOutlet UIView *accountInfoView;
@property (weak, nonatomic) IBOutlet UILabel *accountInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountStatus;
@property (weak, nonatomic) IBOutlet UILabel *accountShareSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountShareSize;
@property (weak, nonatomic) IBOutlet UILabel *accountFlightRule;
@property (weak, nonatomic) IBOutlet UILabel *accountStartDate;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *accountEndDate;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tollFreeNumber;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *productTeamName;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *remaingHours1;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *remaingHours2;

@property (weak, nonatomic) IBOutlet UILabel *remainingHours1Label;
@property (weak, nonatomic) IBOutlet UILabel *remainingHours2Label;


@property (weak, nonatomic) IBOutlet UILabel *departureEstimatedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureActualTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureICAOLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureFBOLabel;

@property (weak, nonatomic) IBOutlet UILabel *arrivalEstimatedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalActualTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalICAOLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalFBOLabel;

@property (weak, nonatomic) IBOutlet UILabel *departureDateLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *flightStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedFlightTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualFlightTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tailNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestedAircraftTypeLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualAircraftTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteedAircraftTypeLabel;

@property (weak, nonatomic) IBOutlet UIView *detailMapView;

@property (weak, nonatomic) IBOutlet MKMapView *flightDetailMapView;

//Navigation Bar Button Methods
- (IBAction)displayActionList:(id)sender;
- (void)displaySearchModal:(NSInteger)searchSelection;
- (void)popBack;

//View and Map Data Display Methods
- (void)updateViewWithFlightData;
- (void)updateMapWithAirportData;
- (void)updateMapWithAircraftData;
- (void)centerOnAllAnnotations;

@end
