//
//  NFDFlightTrackingTableViewCell.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightTrackingTableViewCell.h"
#import "NFDFlightTrackingManager.h"
#import "NCLFramework.h"
#import "NFDDogEarView.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAircraftTypeService.h"

@interface NFDFlightTrackingTableViewCell ()

@property (strong, nonatomic) NFDAircraftTypeService *aircraftTypeService;

@end

@implementation NFDFlightTrackingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.contentView.backgroundColor = [UIColor tableViewCellSelectedBackgroundColor];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
        
        self.tailLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
        self.departureDateLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
        self.departureAirportLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
        self.departureTimeLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
        self.arrivalAirportLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
        self.arrivalTimeLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
        self.svpNameLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
        self.arrowLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
    } else {
        self.contentView.backgroundColor = [UIColor tableViewBackgroundColor];
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        
        self.tailLabel.textColor = [UIColor tableViewCellDefaultSecondaryTextColor];
        self.departureDateLabel.textColor = [UIColor tableViewCellDefaultSecondaryTextColor];
        self.departureAirportLabel.textColor = [UIColor tableViewCellDefaultSecondaryTextColor];
        self.departureTimeLabel.textColor = [UIColor tableViewCellDefaultSecondaryTextColor];
        self.arrivalAirportLabel.textColor = [UIColor tableViewCellDefaultSecondaryTextColor];
        self.arrivalTimeLabel.textColor = [UIColor tableViewCellDefaultSecondaryTextColor];
        self.svpNameLabel.textColor = [UIColor colorWithRed:0.629 green:0.627 blue:0.632 alpha:1.000];
        self.arrowLabel.textColor = [UIColor tableViewCellDefaultSecondaryTextColor];
    }
}

-(void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor tableViewBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) commonInit
{
    _aircraftTypeService = [[NFDAircraftTypeService alloc] init];
}

#pragma mark - Manager, Flight, Tracking Methods

-(void)updateViewWithFlightData: (NFDFlight *) theFlight searchType:(NFDTrackerSearchType) searchType {
    if (theFlight) {
        NSString *tempTitle = [theFlight accountName];
        
        // For account search, display the aircraft type instead of the account name
        if (searchType == NFDTrackerSearchTypeAccountSearch) {
            tempTitle = theFlight.aircraftDisplayNameGuaranteed;
        }
        NSString *tempTailNumber = [theFlight tailNumber];
        
        NSString *tempDepartureDate = [NSString stringFromDate:theFlight.departureTimeEstimated formatType:NCLDateFormatDateOnly timezone:theFlight.departureTZ];
        NSString *tempDepartureICAO = [theFlight departureICAO];
        NSString *tempDepartureTimeEstimated = [NSString stringFromDate:theFlight.departureTimeEstimated formatType:NCLDateFormatTimeOnly timezone:theFlight.departureTZ];
        NSString *tempArrivalICAO = [theFlight arrivalICAO];
        NSString *tempArrivalTimeEstimated = [NSString stringFromDate:theFlight.arrivalTimeEstimated formatType:NCLDateFormatTimeOnly timezone:theFlight.arrivalTZ];
        NSString *tempSvpName = [theFlight svpName];
        
        if (! ( ( tempTitle ) && ( [[tempTitle stringByTrimmingCharactersInSet:
                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) )){
            tempTitle = @"";
        }
        
        if (! ( ( tempTailNumber ) && ([[tempTailNumber stringByTrimmingCharactersInSet:
                                         [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) )){
            tempTailNumber = @"TBD";
        }
        if (! ( ( tempDepartureDate ) && ( [[tempDepartureDate stringByTrimmingCharactersInSet:
                                            [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) )){
            tempDepartureDate = @"";
        }
        if (! ( ( tempDepartureICAO ) && ( [[tempDepartureICAO stringByTrimmingCharactersInSet:
                                            [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) )){
            tempDepartureICAO = @"";
        }
        if (! ( ( tempDepartureTimeEstimated ) && ( [[tempDepartureTimeEstimated stringByTrimmingCharactersInSet:
                                                     [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) )){
            tempDepartureTimeEstimated = @"";
        }
        if (! ( ( tempArrivalICAO ) && ( [[tempArrivalICAO stringByTrimmingCharactersInSet:
                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) )){
            tempArrivalICAO = @"";
        }
        if (! ( ( tempArrivalTimeEstimated ) && ( [[tempArrivalTimeEstimated stringByTrimmingCharactersInSet:
                                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) )){
            tempArrivalTimeEstimated = @"";
        }
        if (! ( ( tempSvpName ) && ( [[tempSvpName stringByTrimmingCharactersInSet:
                                      [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) )){
            tempSvpName = @"";
        }
        
        self.accountNameLabel.text = tempTitle;
        self.tailLabel.text = tempTailNumber;
        self.departureDateLabel.text = tempDepartureDate;
        self.departureAirportLabel.text = tempDepartureICAO;
        self.departureTimeLabel.text = tempDepartureTimeEstimated;
        self.arrivalAirportLabel.text = tempArrivalICAO;
        self.arrivalTimeLabel.text = tempArrivalTimeEstimated;
        self.svpNameLabel.text = [NSString stringWithFormat:@"SVP: %@",tempSvpName];
        
        [self configureImages:theFlight];
        
        if (theFlight.hasOpenLegCases) {
            NSString *casesString = ([theFlight.legOpenCount isEqualToString:@"1"]) ? @"CASE" : @"CASES";
            self.casesLabel.text = [NSString stringWithFormat:@"%@ OPEN %@", theFlight.legOpenCount, casesString];
            self.casesLabel.hidden = NO;
        } else {
            self.casesLabel.hidden = YES;
        }
    }
}

- (void) configureImages: (NFDFlight *)theFlight
{
    self.flightStatusImageView.hidden = YES;
    self.alertImageView.hidden = YES;
    
    if ([theFlight hasYellowAlert]) {
        self.alertImageView.hidden = NO;
    }
    
    BOOL showFlightStatusImage =  [FLIGHT_STATUS_IN_FLIGHT isEqualToString: theFlight.flightStatus];
    if (showFlightStatusImage) {
        self.flightStatusImageView.hidden = NO;
    }
    
    if (theFlight.isUpgradedFlight) {
        self.actualAircraftAlertImageView.image = [UIImage imageNamed:@"upgrade.png"];
    } else if (theFlight.isDowngradedFlight) {
        self.actualAircraftAlertImageView.image = [UIImage imageNamed:@"downgrade.png"];
    } else {
        self.actualAircraftAlertImageView.image = nil;
    }
}
@end
