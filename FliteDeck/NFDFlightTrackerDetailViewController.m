//
//  NFDFlightTrackerDetailViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/27/13.
//
//

#import "NFDFlightTrackerDetailViewController.h"
#import "NFDFlightTrackerMapViewController.h"
#import "NFDCaseListViewController.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAircraftTypeService.h"
#import "NFDAirportService.h"
#import "NFDFlightTrackingManager.h"
#import "NFDFlightTrackerPassengerTableViewController.h"
#import "NFDAccountCaseSummaryTableViewController.h"
#import "NFDAccountCaseListViewController.h"
#import "NFDFlightCaseListViewController.h"

#import "NSDate+CommonUtilities.h"

static CGRect originalFlightDetailsFrame;

@interface NFDFlightTrackerDetailViewController ()
@property (nonatomic, strong) NSArray *descriptorLabels;
@property (nonatomic, strong) NSArray *valueLabels;
@property (strong, nonatomic) NFDAircraftTypeService *aircraftTypeService;

@property (nonatomic, strong) NFDFlightTrackerMapViewController *mapViewController;
@property (nonatomic, strong) NFDCaseListViewController *caseViewController;
@property (nonatomic, strong) NFDAccountCaseListViewController *accountCaseViewController;
@property (nonatomic, strong) NFDFlightCaseListViewController *flightCaseViewController;
@property (nonatomic, strong) NFDAccountCaseSummaryTableViewController *accountCaseSummaryController;

@property (strong, nonatomic) UIImage *flightStatusLandedImage;

@property (nonatomic) CGRect originalFlightDetailsContainerFrame;
@end

@implementation NFDFlightTrackerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flightStatusLandedImage = [UIImage imageNamed:@"NJ_Flight_Tracker_AC_Right.png"];
    self.flightStatusLandedImage = [[NFDFlightTrackingManager sharedInstance] rotatedImage:_flightStatusLandedImage byDegreesFromNorth:0.0 color:[UIColor flightLandedColor]];
    
    self.aircraftTypeService = [[NFDAircraftTypeService alloc] init];
    
    self.descriptorLabels = [NSArray arrayWithObjects:
                             self.statusDescriptor, self.companyDescriptor,
                             self.shareSizeDescriptor, self.flightRuleDescriptor, self.contractAircraftDescriptor,
                              self.remainingAllottedDescriptor, self.remainingAvailableDescriptor,
                              self.requestedAircraftDescriptor, self.actualDepartureTimeDescriptor, self.estimatedDepartureTimeDescriptor, self.flightContractAircraftDescriptor,
                              self.actualArrivalTimeDescriptor, self.estimatedArrivalTimeDescriptor,
                              self.departureDateDescriptor, self.flightStatusDescriptor,
                              self.estimatedFlightDurationDescriptor, self.actualFlightDurationDescriptor, nil];
    
    self.valueLabels = [NSArray arrayWithObjects:self.detailTitleValue, self.companyValue, self.statusValue, self.shareSizeValue, self.flightRuleValue, self.flightContractAircraftValue,
                         self.contractAircraftValue, self.contractStartValue, self.contractEndValue,
                         self.remainingAllottedValue, self.remainingAvailableValue, self.tollFreeNumberValue,
                         self.productDeliveryTeamValue, nil];
    
    [self setupDescriptorLabels];
    [self setupValueLabels];
    
    self.departureFBOValue.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.arrivalFBOValue.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    
    // border
    [self.accountDetailsContainer.layer setCornerRadius:7.0f];
    [self.accountDetailsContainer.layer setBorderColor:[UIColor flightDetailsBorderColor].CGColor];
    [self.accountDetailsContainer.layer setBorderWidth:1.0f];
    
    [self.flightDetailsContainer.layer setCornerRadius:7.0f];
    [self.flightDetailsContainer.layer setBorderColor:[UIColor flightDetailsBorderColor].CGColor];
    [self.flightDetailsContainer.layer setBorderWidth:1.0f];
    
    if (!self.flight) {
        self.view.hidden = YES;
    }
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        originalFlightDetailsFrame = self.flightDetailsContainer.frame;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAccountCases:) name:DID_RECEIVE_ACCOUNT_CASES object:self.flightTrackerManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorFetchingAccountCases) name:ERROR_FETCHING_ACCOUNT_CASES object:self.flightTrackerManager];
    
    // Checking to see if the case activity indicators are spinning and if so
    // updating the case data for selected flight fixes a defect, FLIDEC-203.
    // This happens when a user clicks the map view button before we receieve a
    // DID_RECEIVE_ACCOUNT_CASES notification and the spinners spin indefinitely.
    if([self isCaseActivityIndicatorsAnimating]) {
        [self updateViewWithCaseData];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (![self isModalViewControllerDisplayedOfClass:[self.accountCaseViewController class]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_RECEIVE_ACCOUNT_CASES object:self.flightTrackerManager];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ERROR_FETCHING_ACCOUNT_CASES object:self.flightTrackerManager];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Calling this method here fixes an issue where the layout does not get updated
    // when you navigate away from this view and return
    [self layoutDetailContainers];
}

- (void)setupDescriptorLabels
{
    for (UILabel *descriptorLabel in self.descriptorLabels) {
        descriptorLabel.textColor = [UIColor descriptorLabelTextColor];
    }
}

- (void)setupValueLabels
{
    for (UILabel *valueLabel in self.valueLabels) {
        valueLabel.textColor = [UIColor valueLabelTextColor];
    }
}

- (void)layoutDetailContainers
{
    if (self.flightTrackerManager.didSearchForFerryFlights) {
        self.accountDetailsContainer.hidden = YES;
        self.flightDetailsContainer.frame = CGRectMake(originalFlightDetailsFrame.origin.x,
                                                       72,
                                                       originalFlightDetailsFrame.size.width,
                                                       originalFlightDetailsFrame.size.height);
        
        self.flightContractAircraftDescriptor.hidden = YES;
        self.flightContractAircraftValue.hidden = YES;
        self.requestedAircraftDescriptor.hidden = YES;
        self.requestedAircraftValue.hidden = YES;
    } else {
        self.accountDetailsContainer.hidden = NO;
        
        self.flightDetailsContainer.frame = originalFlightDetailsFrame;
        
        self.flightContractAircraftDescriptor.hidden = NO;
        self.flightContractAircraftValue.hidden = NO;
        self.requestedAircraftDescriptor.hidden = NO;
        self.requestedAircraftValue.hidden = NO;
    }
}

- (void)configureAccountCaseLabels
{
    NSDate *customerSinceDate = self.flight.customerSinceDate;
    
    if (customerSinceDate) {
        NSString *customerSinceString = [NSString stringFromDate:customerSinceDate formatType:NCLDateFormatDateOnly timezone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        self.customerSinceValue.text = [NSString stringWithFormat:@"Customer since %@", customerSinceString];
        self.customerSinceValue.hidden = NO;
    } else {
        self.customerSinceValue.hidden = YES;
    }
    
    NSString *accountCases = [NSString stringWithFormat:@"%@ Account Cases・%@ Currently Open",
                              self.flight.accountTotalCount,
                              self.flight.accountOpenCount];
    
    self.accountCaseSummaryValue.text = accountCases;
    
    NSString *casesString = ([self.flight.accountControllableRecentCount isEqualToString:@"1"]) ? @"Case" : @"Cases";
    
    NSString *recentCases = [NSString stringWithFormat:@"%@ Controllable %@ in the Last 3 Months",
                             self.flight.accountControllableRecentCount, casesString];
    
    [self configureButton:self.accountRecentCasesButton withTitle:recentCases enabled:self.flight.hasRecentAccountCases];
    
    [self showAccountCaseInfo];
}

- (void)fetchAccountCases
{
    if (self.flight.accountCaseDetailsRef) {
        [self showCaseActivityIndicators];
        
        [self.flightTrackerManager findCasesWithURL:self.flight.accountCaseDetailsRef];
        
        [self.totalCasesActivityIndicator startAnimating];
        self.totalCasesActivityIndicator.hidden = NO;
        
        [self.recentCasesActivityIndicator startAnimating];
        self.recentCasesActivityIndicator.hidden = NO;
    } else {
        [self errorFetchingAccountCases];
    }
}

- (void)showAccountCaseInfo
{
    [self.totalCasesActivityIndicator stopAnimating];
    self.totalCasesActivityIndicator.hidden = YES;
    
    [self.recentCasesActivityIndicator stopAnimating];
    self.recentCasesActivityIndicator.hidden = YES;
    
    self.accountCaseSummaryValue.hidden = NO;
    self.accountRecentCasesButton.hidden = NO;
    
    self.accountCaseViewController.isLoading = NO;
    [self updateAccountCaseViewController];
}

- (BOOL)isCaseActivityIndicatorsAnimating
{
    return (self.totalCasesActivityIndicator.isAnimating == YES || self.recentCasesActivityIndicator.isAnimating == YES);
}

- (void)showCaseActivityIndicators
{
    [self.totalCasesActivityIndicator startAnimating];
    self.totalCasesActivityIndicator.hidden = NO;
    
    [self.recentCasesActivityIndicator startAnimating];
    self.recentCasesActivityIndicator.hidden = NO;
    
    self.customerSinceValue.hidden = YES;
    self.accountCaseSummaryValue.hidden = YES;
    self.accountRecentCasesButton.hidden = YES;
    
    self.accountCaseViewController.isLoading = YES;
    [self updateAccountCaseViewController];
}

- (void)didReceiveAccountCases:(NSNotification *)notification
{
    [self updateFlightWithAccountCaseData:notification.userInfo];
}

- (void)updateFlightWithAccountCaseData:(NSDictionary *)caseData
{
    NSString *caseRef = [caseData objectForKey:ACCOUNT_CASES_DETAIL_REF];
    
    // Make sure the notification data is for this flight
    if ([caseRef isEqualToString:self.flight.accountCaseDetailsRef]) {
        NSArray *caseGroups = [caseData objectForKey:ACCOUNT_CASES_KEY];
        
        self.flight.accountTotalCount = [caseData objectForKey:TOTAL_CASES_COUNT_KEY];
        self.flight.accountOpenCount = [caseData objectForKey:OPEN_CASES_COUNT_KEY];
        self.flight.accountControllableCount = [caseData objectForKey:CONTROLLABLE_CASES_COUNT_KEY];
        self.flight.accountControllableRecentCount = [caseData objectForKey:TOTAL_RECENT_CASES_COUNT_KEY];
        self.flight.accountCaseGroups = [NSArray arrayWithArray:caseGroups];
        
        [self configureAccountCaseLabels];
    }
}

- (void)errorFetchingAccountCases
{
    self.customerSinceValue.hidden = YES;
    self.accountCaseSummaryValue.text = @"--";
    [self configureButton:self.accountRecentCasesButton withTitle:@"--" enabled:NO];
    [self showAccountCaseInfo];
    
    [self updateAccountCaseViewController];
}

- (void)updateViewWithCaseData
{
    if(self.flight) {
        NSDictionary *accountCaseData = [NSDictionary dictionaryWithDictionary:[self.flightTrackerManager.fetchedCases objectForKey:self.flight.accountCaseDetailsRef]];
        
        if (self.flight.accountCaseGroups) {
            [self configureAccountCaseLabels];
        } else if (accountCaseData.count > 0) {
            [self updateFlightWithAccountCaseData:accountCaseData];
        } else {
            [self fetchAccountCases];
        }
    }
}

- (void)updateViewWithFlightData
{
    if (self.flight) {
        [self layoutDetailContainers];
        
        [self updateViewWithCaseData];
        
        NSUInteger numberOfPassengers = self.flight.passengers.count;
        
        NSString *passengerButtonText;
        
        if (numberOfPassengers == 0) {
            passengerButtonText = @"No Passengers";
        } else if (numberOfPassengers == 1) {
            passengerButtonText = @"1 Passenger";
        } else {
            passengerButtonText = [NSString stringWithFormat:@"%i Passengers", numberOfPassengers];
        }
        
        [self configureButton:self.passengersButton withTitle:passengerButtonText enabled:self.flight.hasPassengers];
        
        //Display last update date...
        NSDate *lastUpdated = [self.flightTrackerManager flightsLastUpdated];
        if (lastUpdated){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *timeStamp = [dateFormatter stringFromDate:lastUpdated];
            [self.refreshedDateValue setText:timeStamp];
        }else {
            [self.refreshedDateValue setText:@""];
        }
        
        if (self.flightTrackerManager.didSearchForFerryFlights) {
            self.detailTitleValue.text = @"Ferry Flight";
        } else {
            self.detailTitleValue.text = self.flight.accountName;
        }
        
        self.companyValue.text = self.flight.companyName;
        self.statusValue.text = self.flight.contractStatus;
        
        if ([self.flight.contractType isEqualToString:@"C"]) {
            self.shareSizeDescriptor.text = @"card hours";
            self.shareSizeValue.text = self.flight.contractCardHours;
        } else {
            self.shareSizeDescriptor.text = @"share size";
            self.shareSizeValue.text = self.flight.contractShareSize;
        }
        
        self.flightRuleValue.text = self.flight.contractFlightRule;
        
        [self configureContractHours:self.flight];
        
        [self configureContractDates:self.flight];
        
        self.tollFreeNumberValue.text = self.flight.tollFreeNumber;
        self.productDeliveryTeamValue.text = self.flight.productDeliveryTeamName;
        
        //Display Departure Information...

        self.estimatedDepartureTimeValue.text = [NSString stringFromDate:self.flight.departureTimeEstimated formatType:NCLDateFormatTimeOnly timezone:self.flight.departureTZ];
        self.actualDepartureTimeValue.text = [NSString stringFromDate:self.flight.departureTimeActual formatType:NCLDateFormatTimeOnly timezone:self.flight.departureTZ];
        self.departureAirportValue.text = self.flight.departureICAO;
        self.departureFBOValue.text = self.flight.departureFBO;
    
        [self formatEmptyLabel:self.estimatedDepartureTimeValue];
        [self formatEmptyLabel:self.actualDepartureTimeValue];
        
        //Display Arrival Information...

        self.estimatedArrivalTimeValue.text = [NSString stringFromDate:self.flight.arrivalTimeEstimated formatType:NCLDateFormatTimeOnly timezone:self.flight.arrivalTZ];
        self.actualArrivalTimeValue.text = [NSString stringFromDate:self.flight.arrivalTimeActual formatType:NCLDateFormatTimeOnly timezone:self.flight.arrivalTZ];
        self.arrivalAirportValue.text = self.flight.arrivalICAO;
        self.arrivalFBOValue.text = self.flight.arrivalFBO;
        
        [self formatEmptyLabel:self.estimatedArrivalTimeValue];
        [self formatEmptyLabel:self.actualArrivalTimeValue];
        
        //Display Aircraft Information...
        if (self.flight.tailNumber == nil || self.flight.tailNumber.length == 0) {
            self.tailValue.text = @"TBD";
        } else {
            self.tailValue.text = self.flight.tailNumber;
        }
        
        self.requestedAircraftValue.text = self.flight.aircraftTypeDisplayNameRequested;
        
        [self configureActualAircraft:self.flight];
        
        self.contractAircraftValue.text = self.flight.aircraftDisplayNameGuaranteed;
        self.flightContractAircraftValue.text = self.flight.aircraftDisplayNameGuaranteed;

        //Display Flight Information...
        self.departureDateValue.text = [NSString stringFromDate:self.flight.departureTimeEstimated formatType:NCLDateFormatDateOnly timezone:self.flight.departureTZ];
        [self configureFlightStatus: self.flight.flightStatus];
        self.estimatedFlightDurationValue.text = self.flight.flightTimeEstimated;
        self.actualFlightDurationValue.text = self.flight.flightTimeActual;
        
        [self formatEmptyLabel:self.estimatedFlightDurationValue];
        [self formatEmptyLabel:self.actualFlightDurationValue];

        //Determine Tail for tracking...
        NSString *tailNumber = [self findFiledTailNumber:self.flight];
        
        //Search for detail tracking info by tailNumber...
        if ( (tailNumber) && ([self shouldMakeSabreCall]) ){
            [NFDFlightTrackingManager.sharedInstance searchTrackingByTailNumber:tailNumber];
        }
        
        NSString *flightCasesButtonTitle;
        
        if (self.flight.showLegCaseCount) {
            flightCasesButtonTitle = [NSString stringWithFormat:@"%@",
                                     [self appendCaseOrCasesWithCount:self.flight.legTotalCount]];
        } else {
            flightCasesButtonTitle = @"--";
        }
        
        [self configureButton:self.flightCasesButton withTitle:flightCasesButtonTitle enabled:self.flight.hasLegCases];
        
        self.view.hidden = NO;
    } else {
        self.view.hidden = YES;
    }
}

- (NSString *)appendCaseOrCasesWithCount:(NSString *)countString
{
    return [countString isEqualToString:@"1"] ? @"1 Case" : [NSString stringWithFormat:@"%@ Cases", countString];
}

- (void)configureButton:(UIButton *)button withTitle:(NSString *)title enabled:(BOOL)enabled
{
    [button setTitleColor:[UIColor tintColorDefault] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor buttonTitleColorDisabled] forState:UIControlStateDisabled];
    
    [UIView setAnimationsEnabled:NO];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateDisabled];
    [UIView setAnimationsEnabled:YES];
    
    button.enabled = enabled;
}

- (void) formatEmptyLabel: (UILabel *) label
{
    if (!label.text || [label.text isEmptyOrWhitespace]) {
//        label.text = @"--";
        label.text = @"";
    }
}

- (NSString *)findFiledTailNumber:(NFDFlight *)theFlight
{
    
    NSString *tailNumber= nil;
    
    NFDAirportService *service = [[NFDAirportService alloc] init];
    
    NSString *tailValueText = (NSString *)self.tailValue.text;
    
    if ( (tailValueText != nil) &&
        ![tailValueText isEqualToString:@"TBD"] &&
        (tailValueText.length > 4)) {
        
        // Some aircraft types flight plans are registered by tail number (eg, N460QS)
        // instead of the callsign (EJA123)
        
        // Assume that Callsign is being used
        tailNumber = [NSString stringWithFormat:@"EJA%@",
                      [theFlight.tailNumber substringWithRange:NSMakeRange(1,3)]];
        
        // If this is a large cabin Gulfstream, use the tail number.
        if ([NFDFlightTrackingManager.sharedInstance isLargeCabinGulfstream:theFlight.aircraftTypeActual]) {
            return self.tailValue.text;
        }
        
        NFDAirport *departureAirport = [service findAirportWithCode:[theFlight departureICAO]];
        
        // If the departure is not in the Continental US, use the tail number
        
        if (![self isContinentalUS:departureAirport]) {
            return self.tailValue.text;
        }
        
        NFDAirport *arrivalAirport = [service findAirportWithCode:[theFlight arrivalICAO]];
        NSString *arrivalCountry = [arrivalAirport country_cd];
        
        // If the arrival is not in the Continental US and the arrival is not
        // Canada, use the tail number
        
        if (![self isContinentalUS:arrivalAirport] &&
            ![arrivalCountry isEqualToString:@"CAN"] ) {
            return self.tailValue.text;
        }
        
    }
    
    return tailNumber;
}

- (BOOL)shouldMakeSabreCall{
    
    BOOL returnValue = NO;
    
    NFDFlight *theFlight = [self retrieveFlightForThisView];
    
    if (theFlight && theFlight.departureTimeActual && !theFlight.arrivalTimeActual){
        returnValue = YES;
    }
    
    return returnValue;
}

- (NFDFlight *)retrieveFlightForThisView
{
    NFDFlightTrackingManager *manager = NFDFlightTrackingManager.sharedInstance;
    if ( ( [manager hasRetrievedFlights] ) && ( self.view.tag > -1 ) ){
        return [manager retrieveFlightAtIndex:self.view.tag];
    }
    return nil;
}

-(BOOL)isContinentalUS:(NFDAirport *)airport {
    
    NSString *country = [airport country_cd];
    
    if (country == nil || ![country isEqualToString:@"USA"] ) {
        return NO;
    }
    
    NSString *state = [airport state_cd];
    
    if (state != nil && ([state isEqualToString:@"AK"] || [state isEqualToString:@"HI"]) ) {
        return NO;
    }
    
    return YES;
}

-(void) configureActualAircraft: (NFDFlight *) theFlight
{
    self.actualAircraftValue.text = theFlight.aircraftTypeDisplayNameActual;
    
    if (theFlight.isUpgradedFlight) {
        self.actualAircraftAlertImageView.image = [UIImage imageNamed:@"upgrade.png"];
    } else if (theFlight.isDowngradedFlight) {
        self.actualAircraftAlertImageView.image = [UIImage imageNamed:@"downgrade.png"];
    } else {
        self.actualAircraftAlertImageView.image = nil;
    }
}

- (void) configureContractHours: (NFDFlight *) theFlight
{
    self.remainingAllottedValue.text = theFlight.allottedRemainingHours;
    self.remainingAvailableValue.text = theFlight.availableRemainingHours;
    
    if ([theFlight.contractType isEqualToString:@"C"]){
        // For card
        self.remainingAllottedDescriptor.text = @"";
        self.remainingAllottedValue.text = @"";
        
        self.remainingAvailableValue.text = theFlight.availableRemainingHours;
        
    } else {
        self.remainingAllottedDescriptor.text = @"remaining allotted";
        
        NSString *dateText = [NSString stringFromDate:theFlight.contractCurrentYearEndDate formatType:NCLDateFormatDateOnly];
        
        if (!dateText || [dateText isEmptyOrWhitespace]) {
            self.remainingAllottedValue.text = self.flight.allottedRemainingHours;
            self.remainingAvailableValue.text = self.flight.availableRemainingHours;
        } else {
            self.remainingAllottedValue.text = [NSString stringWithFormat:@"%@ (%@)", theFlight.allottedRemainingHours, dateText];
            self.remainingAvailableValue.text = [NSString stringWithFormat:@"%@ (%@)", theFlight.availableRemainingHours, dateText];
        }
    }
}

- (void) configureContractDates: (NFDFlight *) theFlight;
{
    if (theFlight.contractStartDate == nil) {
        self.contractStartValue.text = @"";
    } else {
        self.contractStartValue.text = [NSString stringFromDate:self.flight.contractStartDate formatType:NCLDateFormatDateOnly timezone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    
    if (theFlight.contractEndDate == nil) {
        self.contractEndValue.text = @"";
    } else {
        self.contractEndValue.text = [NSString stringFromDate:theFlight.contractEndDate formatType:NCLDateFormatDateOnly timezone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    
    if (theFlight.contractStartDate && theFlight.contractEndDate) {
        BOOL highLightEndDate = [self.aircraftTypeService isContractExpiringOrExpired:theFlight.contractEndDate];
        
        self.contractProgressView.progressTintColor = (highLightEndDate ? [UIColor fliteDeckYellowColor] : [UIColor fliteDeckGreenColor]);
        self.contractProgressView.progress = 0.5;
        
        NSUInteger contractLengthDays = [theFlight.contractStartDate numberOfDaysUntil:theFlight.contractEndDate];
        NSUInteger daysIntoContract = [theFlight.contractStartDate numberOfDaysUntil:[NSDate date]];
        
        [self.contractProgressView setProgress:(float)daysIntoContract/(float)contractLengthDays animated:YES];
        
    } else {
        self.contractProgressView.progress = 0.0f;
    }
}

- (void) configureFlightStatus: (NSString *) flightStatusText
{
    self.flightStatusValue.text = flightStatusText;

    if ([FLIGHT_STATUS_NOT_FLOWN isEqualToString: flightStatusText]) {
        self.flightStatusImageView.hidden = YES;
    } else if ([FLIGHT_STATUS_IN_FLIGHT isEqualToString: flightStatusText]) {
        self.flightStatusImageView.hidden = NO;
    } else if ([FLIGHT_STATUS_FLOWN isEqualToString: flightStatusText]) {
        self.flightStatusImageView.hidden = YES;
    } else {
        self.flightStatusImageView.hidden = YES;
    }
}

- (UIColor *) colorForFlightStatus: (NSString *) flightStatusText
{
    UIColor *color = [UIColor whiteColor];
    if ([FLIGHT_STATUS_NOT_FLOWN isEqualToString: flightStatusText]) {
        color = [UIColor flightNotDepartedColor];
    } else if ([FLIGHT_STATUS_IN_FLIGHT isEqualToString: flightStatusText]) {
        color = [UIColor flightInAirColor];
    } else if ([FLIGHT_STATUS_FLOWN isEqualToString: flightStatusText]) {
        color = [UIColor flightLandedColor];
    } else {
        color = [UIColor whiteColor];
    }
    
    return color;
}

-(void) highlightLabel: (TTTAttributedLabel *) label value:(NSString *) value highlightBackgroundColor: (UIColor *) highlightBackgroundColor  highlightTextColor: (UIColor *) highlightTextColor orginalRect:(CGRect) orginalRect highlight:(BOOL) highlight
{
    if (highlight)
    {
        NSDictionary *attributes = @{NSFontAttributeName: label.font};
        CGRect labelSize = [value boundingRectWithSize:orginalRect.size options:0 attributes:attributes context:nil];
        label.frame = CGRectMake(orginalRect.origin.x, orginalRect.origin.y + 2, labelSize.size.width + 10, labelSize.size.height + 2);
        label.backgroundColor = highlightBackgroundColor;
        label.textColor = highlightTextColor;
        label.layer.cornerRadius = 4;
        label.textAlignment = NSTextAlignmentCenter;
        label.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    }
    else
    {
        label.frame = orginalRect;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 0;
        label.textAlignment = NSTextAlignmentLeft;
    }
    label.text = value;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([@"mapSegue" isEqualToString:segue.identifier]) {
        self.mapViewController = segue.destinationViewController;
        self.mapViewController.flightTrackerManager = self.flightTrackerManager;
        self.mapViewController.flight = self.flight;
    } else if ([@"passengerSegue" isEqualToString:segue.identifier]) {
        NFDFlightTrackerPassengerTableViewController *passengerController = segue.destinationViewController;
        passengerController.flight = self.flight;
    } else if ([@"caseSegue" isEqualToString:segue.identifier]) {
        if (sender == self.flightCasesButton)
        {
            self.flightCaseViewController = segue.destinationViewController;
            self.flightCaseViewController.accountName = self.flight.accountName;
            self.flightCaseViewController.caseGroups = [NSMutableArray arrayWithArray:self.flight.flightCaseGroups];
        }
        else if (sender == self.accountRecentCasesButton)
        {
            self.accountCaseViewController = segue.destinationViewController;
            self.accountCaseViewController.accountName = self.flight.accountName;
            self.accountCaseViewController.caseGroups = [NSMutableArray arrayWithArray:self.flight.accountCaseGroups];
        }
    } else if ([@"caseSummarySegue" isEqualToString:segue.identifier]) {
        self.accountCaseSummaryController = segue.destinationViewController;
        self.accountCaseSummaryController.flight = self.flight;
    }
}

- (IBAction)mapUnwindSegue:(UIStoryboardSegue *)segue {
    self.mapViewController = nil;
}

- (IBAction)caseUnwindSegue:(UIStoryboardSegue *)segue {
    self.caseViewController = nil;
}

- (void)setFlight:(NFDFlight *)flight
{
    _flight = flight;
    [self updateViewWithFlightData];

    if (!flight) {
        if ([self isModalViewControllerDisplayedOfClass:[self.accountCaseViewController class]]) {
            [self.accountCaseViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if ([self isModalViewControllerDisplayedOfClass:[self.flightCaseViewController class]]) {
            [self.flightCaseViewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
    [self updateFlightCaseViewController];
    self.mapViewController.flight = _flight;
}

- (BOOL)isModalViewControllerDisplayedOfClass:(Class)class
{
    BOOL modalPresent = (BOOL)(self.presentedViewController);
    
    return (modalPresent && [self.presentedViewController isKindOfClass:class]);
}

- (void)updateAccountCaseViewController
{
    if ([self isModalViewControllerDisplayedOfClass:[self.accountCaseViewController class]]) {
        self.accountCaseViewController.accountName = self.flight.accountName;
        self.accountCaseViewController.caseGroups = [NSMutableArray arrayWithArray:self.flight.accountCaseGroups];
        
        [self.accountCaseViewController.tableView reloadData];
    }
}

- (void)updateFlightCaseViewController
{
    if ([self isModalViewControllerDisplayedOfClass:[self.flightCaseViewController class]]) {
        self.flightCaseViewController.accountName = self.flight.accountName;
        self.flightCaseViewController.caseGroups = [NSMutableArray arrayWithArray:self.flight.flightCaseGroups];
        
        [self.flightCaseViewController.tableView reloadData];
    }
}

@end
