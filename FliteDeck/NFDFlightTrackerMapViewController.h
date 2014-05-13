//
//  NFDFlightTrackerMapViewController.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/27/13.
//
//

#import <UIKit/UIKit.h>

#import "NFDFlightTrackerManager.h"

@interface NFDFlightTrackerMapViewController : UIViewController

@property (strong, nonatomic) NFDFlightTrackerManager *flightTrackerManager;
@property (strong, nonatomic) NFDFlight *flight;
@property (weak, nonatomic) IBOutlet UIView *flightDetailsView;

@end
