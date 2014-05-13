//
//  NFDFlightTrackerTailSearchViewController.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/20/13.
//
//

#import <UIKit/UIKit.h>

#import "NFDFlightTrackerManager.h"
#import "NFDFlightTrackerBaseSearchViewController.h"


@interface NFDFlightTrackerTailSearchViewController : NFDFlightTrackerBaseSearchViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *dateSelectorCell;

@end
