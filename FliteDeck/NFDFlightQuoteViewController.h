//
//  NFDFlightQuoteViewController.h
//  FliteDeck
//
//  Created by Mohit Jain on 2/28/12.
//  Copyright (c) 2012 Compuware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDJetResultsView.h"
#import "FlightEstimatorData.h"


// Added new PDF Estimate
#import "FlightProfileTripEstimatePDF.h"

#import "AircraftTypeResults.h"
#import "NFDAirport.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NFDProspectViewController.h"
#import "NFDLegViewContainer.h"

@interface NFDFlightQuoteViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    
    IBOutlet UILabel *message;
    NSString *pdfFileName;

}

@property (weak, nonatomic) IBOutlet UIScrollView *resultScrollView;

@property (nonatomic, weak) FlightEstimatorData *parameters;
@property (nonatomic, weak) AircraftTypeResults *results;

@property (nonatomic, retain) IBOutlet UILabel *message;

@property (nonatomic, retain) FlightProfileTripEstimatePDF *pdf;

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, retain) UINavigationController *modalController;
@property(nonatomic, retain)  NFDProspectViewController *prospectModalViewController;

@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfPassengers;
@property (weak, nonatomic) IBOutlet UILabel *labelSeason;
@property (weak, nonatomic) IBOutlet UILabel *labelProductType;


@property (weak, nonatomic) IBOutlet NFDLegViewContainer *outLegsContainer;
@property (weak, nonatomic) IBOutlet NFDLegViewContainer *retLegsContainer;

@property (weak, nonatomic) IBOutlet NFDJetResultsView *jetResultsView1;
@property (weak, nonatomic) IBOutlet NFDJetResultsView *jetResultsView2;
@property (weak, nonatomic) IBOutlet NFDJetResultsView *jetResultsView3;

- (IBAction) infoButtonTapped:(id)sender;
- (IBAction) shareButtonClicked:(id)sender;

@end
