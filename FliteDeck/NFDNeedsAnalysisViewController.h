//
//  NFDNeedsAnalysisViewController.h
//  FliteDeck
//
//  Created by Mohit Jain on 2/17/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightQuoteViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "AirportSelectorView.h"
#import "PopoverTableViewController.h"
#import "NFDPersistenceService.h"

@interface NFDNeedsAnalysisViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, UITextViewDelegate> {
    
    IBOutlet AirportSelectorView *originA;
    IBOutlet AirportSelectorView *destinationA;
    IBOutlet AirportSelectorView *originB;
    IBOutlet AirportSelectorView *destinationB;    
    IBOutlet AirportSelectorView *originC;
    IBOutlet AirportSelectorView *destinationC; 
    
    
}


// Setting properties for Custom Labels, textfields, ...
@property (nonatomic, retain) IBOutlet UILabel *campaign_NFDNeedsAnalysisLabel;
@property (nonatomic, retain) IBOutlet UILabel *travelType_NFDNeedsAnalysisLabel;;
@property (nonatomic, retain) IBOutlet UILabel *leadCurrentlyTravel_NFDNeedsAnalysisLabel;;
@property (nonatomic, retain) IBOutlet UILabel *leadFlyWithCompetitors_NFDNeedsAnalysisLabel;;
@property (nonatomic, retain) IBOutlet UILabel *leadFlyEachYearTrips_NFDNeedsAnalysisLabel;
@property (nonatomic, retain) IBOutlet UILabel *leadFlyEachYearhours_NFDNeedsAnalysisLabel;
@property (nonatomic, retain) IBOutlet UILabel *peopleTypicallyFly_NFDNeedsAnalysisLabel;

@property (nonatomic, retain) IBOutlet UILabel *typicalDestinationFrom_NFDNeedsAnalysisLabel;
@property (nonatomic, retain) IBOutlet UILabel *typicalDestinationTo_NFDNeedsAnalysisLabel;
@property (nonatomic, retain) IBOutlet UILabel *typicalDestinationFrequency_NFDNeedsAnalysisLabel;

@property (nonatomic, retain) IBOutlet UILabel *purchasingTimeline_NFDNeedsAnalysisLabel;
@property (nonatomic, retain) IBOutlet UILabel *additionalInformation_NFDNeedsAnalysisLabel;
@property (nonatomic, retain) IBOutlet UILabel *recommendedProducts_NFDNeedsAnalysisLabel;
@property (nonatomic, retain) IBOutlet UILabel *tripsEachYrLabel;
@property (nonatomic, retain) IBOutlet UILabel *hrsEachYrLabel;
@property (nonatomic, retain) IBOutlet UILabel *peopleTypicallyFlyEachYrLabel;
//@property (nonatomic, retain) IBOutlet UILabel *purchasingTimeline;
@property (nonatomic, retain) UIStepper *tripsPerYearStepper;
@property (nonatomic, retain) UIStepper *hrsPerYearStepper;
@property (nonatomic, retain) UIStepper *peopleFlyEachYrStepper;

@property (nonatomic, retain) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UIScrollView *needsAnalysisScrollView;

@property (nonatomic, retain) IBOutlet UITextField *frequencyLabel1;
@property (nonatomic, retain) IBOutlet UITextField *frequencyLabel2;
@property (nonatomic, retain) IBOutlet UITextField *frequencyLabel3;

@property (nonatomic, strong) IBOutlet UITextView *textViewForAdditionalInformation;

@property (nonatomic, retain) NFDFlightQuoteViewController *fq;
@property (nonatomic, retain) NFDPersistenceService *service;

// Setting properties for Airport Selector View Components
@property (nonatomic, retain) IBOutlet AirportSelectorView *originA;
@property (nonatomic, retain) IBOutlet AirportSelectorView *destinationA;
@property (nonatomic, retain) IBOutlet AirportSelectorView *originB;
@property (nonatomic, retain) IBOutlet AirportSelectorView *destinationB;    
@property (nonatomic, retain) IBOutlet AirportSelectorView *originC;
@property (nonatomic, retain) IBOutlet AirportSelectorView *destinationC; 


// Needs Analysis trip Options 

@property (nonatomic, retain) IBOutlet UITableView *needsAnalysisOptionsTable;
@property (nonatomic, retain) PopoverTableViewController *popoverContent;
@property (nonatomic, retain) NSArray *campaignArray;
@property (nonatomic, retain) NSArray *travelTypeArray;
@property (nonatomic, retain) NSArray *leadTravelTypeArray;
@property (nonatomic, retain) NSArray *flyWithCompetitorsArray;
@property (nonatomic, retain) NSArray *purchasingTimelineArray;
@property (nonatomic, retain) NSMutableArray *tableDataArray;
@property (nonatomic, retain) UIPopoverController *popover;

// Custom Actions
- (IBAction) gotoLaunchpad:(id)sender;
- (IBAction) shareNeedsAnalysis:(id)sender;
- (IBAction) adjustTripsPerYr:(id)sender;
- (IBAction) adjustHrsPerYr:(id)sender;
- (IBAction) adjustPeopleTravelPerYr:(id)sender;


- (void)initializeWithData;
- (void)setSizeforUIComponentsinPortraitMode;
- (void)setSizeforUIComponentsinLandscapeMode;
- (void)setProperties;


// Email Methods
-(void)launchMailAppOnDevice;
-(void)displayComposerSheet;
-(void)showPicker;
-(void)configureButtons;

@end
