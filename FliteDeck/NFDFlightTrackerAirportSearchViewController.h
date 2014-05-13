//
//  NFDFlightTrackerAirportSearchViewController.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/21/13.
//
//

#import <UIKit/UIKit.h>

#import "NFDFlightTrackerSearchResultsTableViewController.h"
#import "NFDFlightTrackerBaseSearchViewController.h"

@interface NFDFlightTrackerAirportSearchViewController : NFDFlightTrackerBaseSearchViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *airportSelectorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateSelectorCell;


@end
