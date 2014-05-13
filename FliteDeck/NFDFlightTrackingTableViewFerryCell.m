//
//  NFDFlightTrackingTableViewFerryCell.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/13/13.
//
//

#import "NFDFlightTrackingTableViewFerryCell.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDFlightTrackingManager.h"

@implementation NFDFlightTrackingTableViewFerryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.contentView.backgroundColor = [UIColor tableViewCellSelectedBackgroundColor];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
        
        [self updateSecondaryTextColor:[UIColor tableViewCellSelectedSecondaryTextColor]];
    } else {
        self.contentView.backgroundColor = [UIColor tableViewBackgroundColor];
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        
        [self updateSecondaryTextColor:[UIColor tableViewCellDefaultSecondaryTextColor]];
    }
}

- (void) updateSecondaryTextColor: (UIColor *) color
{
    self.departureTimeLabel.textColor = color;
    self.arrivalTimeLabel.textColor = color;
    
    self.departureAirportLabel.textColor = color;
    self.arrivalAirportLabel.textColor = color;
    
    self.arrowLabel.textColor = color;
}

-(void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor tableViewBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.aircraftNameValue.textColor = [UIColor whiteColor];
    self.tailLabel.textColor = [UIColor whiteColor];
    self.departureDateLabel.textColor = [UIColor whiteColor];
    self.flightStatusImageView.hidden = NO;

}

-(void)updateViewWithFlightData: (NFDFlight *) theFlight {
    
    self.tailLabel.text = !theFlight.tailNumber || [theFlight.tailNumber isEmptyOrWhitespace] ? @"TBD" : theFlight.tailNumber;
    
    NSString *tempDepartureDate = [NSString stringFromDate:theFlight.departureTimeEstimated formatType:NCLDateFormatDateOnly timezone:theFlight.departureTZ];
    NSString *tempDepartureICAO = [theFlight departureICAO];
    NSString *tempDepartureTimeEstimated = [NSString stringFromDate:theFlight.departureTimeEstimated formatType:NCLDateFormatTimeOnly timezone:theFlight.departureTZ];
    NSString *tempArrivalICAO = [theFlight arrivalICAO];
    NSString *tempArrivalTimeEstimated = [NSString stringFromDate:theFlight.arrivalTimeEstimated formatType:NCLDateFormatTimeOnly timezone:theFlight.arrivalTZ];
    
    self.aircraftNameValue.text = theFlight.aircraftTypeDisplayNameActual;
    self.departureDateLabel.text = tempDepartureDate;
    self.departureTimeLabel.text = tempDepartureTimeEstimated;
    self.arrivalTimeLabel.text = tempArrivalTimeEstimated;
    self.departureAirportLabel.text = tempDepartureICAO;
    self.arrivalAirportLabel.text = tempArrivalICAO;
    
    [self configureImages:theFlight];
}

- (void) configureImages: (NFDFlight *)theFlight
{
    BOOL showFlightStatusImage =  [FLIGHT_STATUS_IN_FLIGHT isEqualToString: theFlight.flightStatus];
    self.flightStatusImageView.hidden = !showFlightStatusImage;
}
@end
