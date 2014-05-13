//
//  NFDFlightTrackerSearchResultsTableViewController.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/20/13.
//
//

#import <UIKit/UIKit.h>

#import "NFDFlightTrackerManager.h"
#import "NFDFlightTrackerDetailViewController.h"

@interface NFDFlightTrackerSearchResultsTableViewController : UIViewController

@property (strong, nonatomic) NFDFlightTrackerManager *flightTrackerManager;

@property (strong, nonatomic) NFDFlightTrackerDetailViewController *detailViewController;

@end
