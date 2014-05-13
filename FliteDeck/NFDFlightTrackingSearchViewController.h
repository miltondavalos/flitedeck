//
//  NFDFlightTrackingSearchVC.h
//  FliteDeck
//
//  Created by Chad Long on 5/18/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirportSelectorView.h"

@interface NFDFlightTrackingSearchViewController : UIViewController <UISearchBarDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblSearchType;
@property (weak, nonatomic) IBOutlet AirportSelectorView *viewSearchAirport;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchValue;
@property (weak, nonatomic) IBOutlet UILabel *netjetsEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (weak, nonatomic) IBOutlet UILabel *validationMessageLabel;
@property(nonatomic, retain) UIPopoverController *popoverController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *flightTypeSegmentedControl;

- (IBAction)executeSearch:(id)sender;

@end
