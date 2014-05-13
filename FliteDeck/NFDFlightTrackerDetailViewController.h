//
//  NFDFlightTrackerDetailViewController.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/27/13.
//
//

#import <UIKit/UIKit.h>

#import "NFDFlightTrackerManager.h"
#import "TTTAttributedLabel.h"

@interface NFDFlightTrackerDetailViewController : UIViewController

@property (strong, nonatomic) NFDFlightTrackerManager *flightTrackerManager;
@property (strong, nonatomic) NFDFlight *flight;


@property (weak, nonatomic) IBOutlet UIView *accountDetailsContainer;
@property (weak, nonatomic) IBOutlet UIView *flightDetailsContainer;


@property (weak, nonatomic) IBOutlet TTTAttributedLabel *refreshedDateValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *detailTitleValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *companyDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *companyValue;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *statusDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *statusValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *shareSizeDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *shareSizeValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *flightRuleDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *flightRuleValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contractAircraftDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contractAircraftValue;
//@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contractStartDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contractStartValue;
//@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contractEndDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contractEndValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *remainingAllottedDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *remainingAllottedValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *remainingAvailableDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *remainingAvailableValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tollFreeNumberValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *productDeliveryTeamValue;

@property (weak, nonatomic) IBOutlet UILabel *customerSinceValue;
@property (weak, nonatomic) IBOutlet UILabel *accountCaseSummaryValue;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tailValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *flightContractAircraftDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *flightContractAircraftValue;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualAircraftDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualAircraftValue;
@property (weak, nonatomic) IBOutlet UIImageView *actualAircraftAlertImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *requestedAircraftDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *requestedAircraftValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *departureAirportValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualDepartureTimeDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualDepartureTimeValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *estimatedDepartureTimeDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *estimatedDepartureTimeValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *departureFBOValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *arrivalAirportValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualArrivalTimeDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualArrivalTimeValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *estimatedArrivalTimeDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *estimatedArrivalTimeValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *arrivalFBOValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *departureDateDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *departureDateValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *flightStatusDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *flightStatusValue;
@property (weak, nonatomic) IBOutlet UIImageView *flightStatusImageView;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *estimatedFlightDurationDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *estimatedFlightDurationValue;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualFlightDurationDescriptor;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actualFlightDurationValue;

@property (weak, nonatomic) IBOutlet UIProgressView *contractProgressView;

@property (weak, nonatomic) IBOutlet UIButton *accountRecentCasesButton;

@property (weak, nonatomic) IBOutlet UIButton *passengersButton;
@property (weak, nonatomic) IBOutlet UIButton *flightCasesButton;
@property (weak, nonatomic) IBOutlet UIButton *flightMapButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *totalCasesActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *recentCasesActivityIndicator;


- (void)updateViewWithFlightData;

@end
