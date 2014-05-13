//
//  NFDFlightTrackingTableViewFerryCell.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/13/13.
//
//

#import <UIKit/UIKit.h>
#import "NFDFlight.h"


@interface NFDFlightTrackingTableViewFerryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *aircraftNameValue;
@property (weak, nonatomic) IBOutlet UILabel *tailLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalAirportLabel;

@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flightStatusImageView;

-(void)updateViewWithFlightData: (NFDFlight *) theFlight;

@end
