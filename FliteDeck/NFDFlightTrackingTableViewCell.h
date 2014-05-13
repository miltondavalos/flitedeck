//
//  NFDFlightTrackingTableViewCell.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlight.h"
#import "NFDFlightTrackerManager.h"

@class NFDDogEarView;

@interface NFDFlightTrackingTableViewCell : UITableViewCell{
}

@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet UIImageView *flightStatusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *actualAircraftAlertImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tailLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *svpNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *casesLabel;

-(void)updateViewWithFlightData: (NFDFlight *) theFlight searchType:(NFDTrackerSearchType) searchType;

@end
