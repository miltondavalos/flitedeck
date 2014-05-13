//
//  NFDFlightTrackerAbstractSearchViewController.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/21/13.
//
//

#import <UIKit/UIKit.h>

#import "NFDFlightTrackerSearchResultsTableViewController.h"

#import "NFDCalendarDateRangePickerViewController.h"

@interface NFDFlightTrackerBaseSearchViewController : UITableViewController <NFDDataRangeSelectedDelegate>

@property (strong, nonatomic) NFDFlightTrackerManager *flightTrackerManager;

@property (strong, nonatomic) UIPopoverController *presentingPopoverController;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateRangePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateRangeLabel;

@property (strong, nonatomic) NFDAirport *selectedAirport;
@property (strong, nonatomic) NSNumber *initialHeight;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

- (void) dateRangeChangedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;


@end
