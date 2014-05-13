//
//  NFDFlightTrackerTailSearchViewController.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/19/13.
//
//

#import <UIKit/UIKit.h>

#import "NFDFlightTrackerManager.h"

#import "NFDFlightTrackerDetailViewController.h"

#define SEARCH_TYPE_SVP @"SVP/AE"
#define SEARCH_TYPE_AIRPORT @"Airport"
#define SEARCH_TYPE_TAIL @"Tail"
#define SEARCH_TYPE_ACCOUNT @"Account"


@interface NFDFlightTrackerSearchTypeViewController : UIViewController

@property (strong, nonatomic) NFDFlightTrackerManager *flightTrackerManager;
@property (strong, nonatomic) UINavigationController *searchNavController;

- (void) showSearch: (UIBarButtonItem *) popoverFromView;

@end
