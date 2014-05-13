//
//  NFDFlightTrackingDetailViewController.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "NFDFlightTrackingDetailViewController.h"
#import "NFDFlightTrackingDetailMapAnnotation.h"
#import "NFDFlightTrackingSearchViewController.h"
#import "PopoverTableViewController.h"
#import "NFDFlightTrackingManager.h"
#import "NFDAppDelegate.h"
#import "NFDAlertMessage.h"
#import "NFDAirportDetailViewController.h"
#import "NCLFramework.h"
#import "UINavigationController+KeyboardDismiss.h"
#import "NFDUserManager.h"
#import "NFDNetJetsRemoteService.h"
#import "AddressAnnotation.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAircraftTypeService.h"
#import "NFDAircraftType.h"
#import "NSString+FliteDeck.h"

#define PASSENGER_LIST_TABLE_VIEW 2
#define ACTION_COMMANDS_TABLE_VIEW 3

@interface NFDFlightTrackingDetailViewController ()
{
    BOOL viewIsVisible;
}

@property (weak, nonatomic) IBOutlet UIButton *passengerListButton;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (strong, nonatomic) NFDAircraftTypeService *aircraftTypeService;


@end

@implementation NFDFlightTrackingDetailViewController

@synthesize popover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Flight Details", @"Flight Details");
        _aircraftTypeService = [[NFDAircraftTypeService alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    viewIsVisible = false;
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displaMasterViewWhileSearching)
                                                 name:SEARCHING_FOR_RESULTS
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMapWithAircraftData) 
                                                 name:TRACKING_DID_RECEIVE_NEW_RESULTS
                                               object:nil];
    [self configureView];
    [self updateViewWithFlightData];
    [[self.detailInformationView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.detailInformationView layer] setShadowOffset:CGSizeMake(0, 1)];
    [[self.detailInformationView layer] setShadowRadius:5];
    [[self.detailInformationView layer] setShadowOpacity:0.7];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.passengerListButton.layer.cornerRadius = 4.0;
}

- (void)viewDidUnload
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEARCHING_FOR_RESULTS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRACKING_DID_RECEIVE_NEW_RESULTS object:nil];

    [NFDFlightTrackingManager.sharedInstance stopTrackingTimer];
    
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!viewIsVisible)  // viewDidAppear is firing twice... ???
    {
        viewIsVisible = YES;
        [self promptForCredentials];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    viewIsVisible = NO;
}

#pragma mark - Log in prompt

- (void)promptForCredentials
{
    BOOL shouldDisplayLoginPrompt = NO;
    NSString *user = [[NFDUserManager sharedManager] username];
    
    if (user == nil ||
        user.length <= 0)
    {
        shouldDisplayLoginPrompt = YES;
    }
    else
    {
        NSString *password = [NCLKeychainStorage userPasswordForUser:user host:[NFDNetJetsRemoteService sharedInstance].host].password;
        
        if (password == nil ||
            password.length <= 0)
        {
            shouldDisplayLoginPrompt = YES;
        }
    }
    
    if (shouldDisplayLoginPrompt)
    {
        UIAlertView *loginPrompt = [[UIAlertView alloc] initWithTitle:@"Account Setup"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
        
        [loginPrompt setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        UITextField *username = [loginPrompt textFieldAtIndex:0];
        [username setPlaceholder:@"Username"];
        [loginPrompt show];
        
        if (user != nil &&
            user.length > 0)
        {
            [username setText:user];
            [[loginPrompt textFieldAtIndex:1] becomeFirstResponder];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField *username = [alertView textFieldAtIndex:0];
        UITextField *password = [alertView textFieldAtIndex:1];
        
        [[NFDUserManager sharedManager] setInfo:username.text forKey:NFDAccountSettingsUsername];
        NCLUserPassword *userPass = [[NCLUserPassword alloc] initWithUsername:username.text password:password.text host:[NFDNetJetsRemoteService sharedInstance].host];
        [NCLKeychainStorage saveUserPassword:userPass error:nil];
    }
}

#pragma mark - UIInterfaceOrientation Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Configure View

- (void)configureView
{

    //Check reachability status...
//    NCLReachability *reach = [NCLReachability reachabilityForInternetConnection];
//    bool hasFlights = [NFDFlightTrackingManager.sharedInstance hasRetrievedFlights];
//    if (![reach isReachable] && !hasFlights) {
//        [NFDAlertMessage showReachabilityAlertWithMessage:nil title:nil];
//    } else if (!hasFlights) {
//        [self.detailMapView setHidden:YES];
//        [self.detailsGeneratedLabel setHidden:YES];
//        [self.detailInformationView setHidden:YES];
//        //NOTE: Do not automatically display default search modal...
//        //[self displaySearchModal:0];
//    }

    //Create Action List Array
    if (!actionListDctionary || actionListDctionary.count < 1){
        actionListDctionary = [NFDFlightTrackingManager.sharedInstance searchFlightsByChoices];
    }
    
    //Navigation Bar Buttons...
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] 
                                         initWithTitle:@"Search"                                            
                                         style:UIBarButtonItemStyleBordered 
                                         target:self 
                                         action:@selector(displayActionList:)];
    NSArray *buttonBarArray = [[NSArray alloc] initWithObjects:searchButtonItem, nil];
    [self.navigationItem setRightBarButtonItems:buttonBarArray];

    //Dismiss popover...
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - Manager, Flight, Tracking Methods

- (NFDFlight *)retrieveFlightForThisView
{
    NFDFlightTrackingManager *manager = NFDFlightTrackingManager.sharedInstance;
    if ( ( [manager hasRetrievedFlights] ) && ( self.view.tag > -1 ) ){
        return [manager retrieveFlightAtIndex:self.view.tag];
    }
    return nil;
}

- (NFDFlightData *)retrieveAircraftForThisView
{
    NFDFlight *theFlight = [self retrieveFlightForThisView];

    if (theFlight){
        
        //Determine tailNumber for tracking...
        NSString *tailNumber = [self findFiledTailNumber:theFlight];

        
        NFDFlightTrackingManager *manager = NFDFlightTrackingManager.sharedInstance;
        if ([manager hasTrackedTails]){
            return [manager retrieveTailWithKey:tailNumber];
        }
        
    }
    return nil;
}

- (BOOL)shouldMakeSabreCall{
    
    BOOL returnValue = NO;

    NFDFlight *theFlight = [self retrieveFlightForThisView];
    
    if (theFlight && theFlight.departureTimeActual && !theFlight.arrivalTimeActual){        
        returnValue = YES;        
    }
    
    return returnValue;
}

- (BOOL)shouldDisplayAircraftOnMap{

    BOOL returnValue = NO;
 
    NFDFlight *theFlight = [self retrieveFlightForThisView];
    NFDFlightData *theAircraft = [self retrieveAircraftForThisView];
    
    if (theFlight && theAircraft){
        if ( [self shouldMakeSabreCall] ){
            if ([[theFlight departureICAO] isEqualToString:[theAircraft Origin]]){
                returnValue = YES;
            }
        }
    }
    return returnValue;
}

- (NSString *)findFiledTailNumber:(NFDFlight *)theFlight
{
    
    NSString *tailNumber= nil;
        
    NFDAirportService *service = [[NFDAirportService alloc] init];
    
    if ( (self.tailNumberLabel.text != nil && self.tailNumberLabel.text.length != 0) &&
         ![self.tailNumberLabel.text isEqualToString:@"TBD"] ) {
        
        // Some aircraft types flight plans are registered by tail number (eg, N460QS)
        // instead of the callsign (EJA123)
        
        // Assume that Callsign is being used
        tailNumber = [NSString stringWithFormat:@"EJA%@",
                      [theFlight.tailNumber substringWithRange:NSMakeRange(1,3)]];
        
        // If this is a large cabin Gulfstream, use the tail number.
        if ([NFDFlightTrackingManager.sharedInstance isLargeCabinGulfstream:theFlight.aircraftTypeActual]) {
            return self.tailNumberLabel.text;
        }
        
        NFDAirport *departureAirport = [service findAirportWithCode:[theFlight departureICAO]];
        
        // If the departure is not in the Continental US, use the tail number
        
        if (![self isContinentalUS:departureAirport]) {
            return self.tailNumberLabel.text;
        }
        
        NFDAirport *arrivalAirport = [service findAirportWithCode:[theFlight arrivalICAO]];
        NSString *arrivalCountry = [arrivalAirport country_cd];
        
        // If the arrival is not in the Continental US and the arrival is not
        // Canada, use the tail number
        
        if (![self isContinentalUS:arrivalAirport] && 
            ![arrivalCountry isEqualToString:@"CAN"] ) {
            return self.tailNumberLabel.text;
        }
        
    }
    
    return tailNumber;
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


#pragma mark - Managing the detail item 

-(void)updateViewWithFlightData
{
    NFDFlight *theFlight = [self retrieveFlightForThisView];
    NSUInteger numberOfPassengers = theFlight.passengers.count;
    
    NSString *passengerButtonText;
    
    self.passengerListButton.enabled = YES;
    self.passengerListButton.backgroundColor = [UIColor buttonBackgroundColorEnabled];
    
    if (numberOfPassengers == 0) {
        passengerButtonText = @"No Passengers";
        self.passengerListButton.enabled = NO;
        self.passengerListButton.backgroundColor = [UIColor buttonBackgroundColorDisabled];
    } else if (numberOfPassengers == 1) {
        passengerButtonText = @"1 Passenger";
    } else {
        passengerButtonText = [NSString stringWithFormat:@"%i Passengers", numberOfPassengers];
    }
    
    [self.passengerListButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateNormal];
    [self.passengerListButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateHighlighted];
    [self.passengerListButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateSelected];
    [self.passengerListButton setTitleColor:[UIColor buttonTitleColorDisabled] forState:UIControlStateDisabled];
    
    [self.passengerListButton setTitle:passengerButtonText forState:UIControlStateNormal];
    [self.passengerListButton setTitle:passengerButtonText forState:UIControlStateHighlighted];
    [self.passengerListButton setTitle:passengerButtonText forState:UIControlStateSelected];
    [self.passengerListButton setTitle:passengerButtonText forState:UIControlStateDisabled];

    [self.trackingGeneratedLabel setHidden:YES];

    if (theFlight) {

        [self.detailMapView setHidden:NO];
        [self.detailInformationView setHidden:NO];

        //Display last update date...
        NSDate *lastUpdated = [NFDFlightTrackingManager.sharedInstance flightsLastUpdated];
        if (lastUpdated){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *timeStamp = [dateFormatter stringFromDate:lastUpdated];
            [self.detailsGeneratedLabel setHidden:NO];
            [self.detailsGeneratedLabel setText:timeStamp];
        }else {
            [self.detailsGeneratedLabel setHidden:YES];
        }
        
        //Display Account Information...
        
        if ([theFlight.ferryFlight boolValue] == YES) {
            self.accountInfoView.hidden = YES;
            self.accountInfoLabel.text = @"Ferry Flight";
        } else {
            self.accountInfoView.hidden = NO;
            self.accountInfoLabel.text = @"Account Information";
        }
        
        self.accountName.text = theFlight.accountName;
        self.accountStatus.text = theFlight.contractStatus;
        if ([theFlight.contractType isEqualToString:@"C"]){
            self.accountShareSizeLabel.text = @"Card Hours:";
            self.accountShareSize.text = theFlight.contractCardHours;
        }else{
            self.accountShareSizeLabel.text = @"Share Size:";
            self.accountShareSize.text = theFlight.contractShareSize;
        }
        self.accountFlightRule.text = theFlight.contractFlightRule;
        self.accountStartDate.text = [NSString stringFromDate:theFlight.contractStartDate formatType:NCLDateFormatDateOnly timezone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];

        [self configureContractHours:theFlight];
        
        [self configureContractEndDate:theFlight.contractEndDate];
        
        self.tollFreeNumber.text = theFlight.tollFreeNumber;
        self.productTeamName.text = theFlight.productDeliveryTeamName;
        
        //Display Departure Information...
        self.departureEstimatedTimeLabel.text = [NSString stringFromDate:theFlight.departureTimeEstimated formatType:NCLDateFormatTimeOnly timezone:theFlight.departureTZ];
        self.departureActualTimeLabel.text = [NSString stringFromDate:theFlight.departureTimeActual formatType:NCLDateFormatTimeOnly timezone:theFlight.departureTZ];
        self.departureICAOLabel.text = theFlight.departureICAO;
        self.departureFBOLabel.text = theFlight.departureFBO;

        //Display Arrival Information...
        self.arrivalEstimatedTimeLabel.text = [NSString stringFromDate:theFlight.arrivalTimeEstimated formatType:NCLDateFormatTimeOnly timezone:theFlight.arrivalTZ];
        self.arrivalActualTimeLabel.text = [NSString stringFromDate:theFlight.arrivalTimeActual formatType:NCLDateFormatTimeOnly timezone:theFlight.arrivalTZ];
        self.arrivalICAOLabel.text = theFlight.arrivalICAO;
        self.arrivalFBOLabel.text = theFlight.arrivalFBO;

        //Display Aircraft Information...
        
        if (theFlight.tailNumber == nil || theFlight.tailNumber.length == 0) {
            self.tailNumberLabel.text = @"TBD";
        } else {
            self.tailNumberLabel.text = theFlight.tailNumber;
        }
        
        self.requestedAircraftTypeLabel.text = theFlight.aircraftTypeDisplayNameRequested;
        
        [self configureActualAircraft:theFlight];
        
        self.guaranteedAircraftTypeLabel.text = theFlight.aircraftDisplayNameGuaranteed;

        //Display Flight Information...
        self.departureDateLabel.text = [NSString stringFromDate:theFlight.departureTimeEstimated formatType:NCLDateFormatDateOnly timezone:theFlight.departureTZ];
        [self configureFlightStatusLabel: theFlight.flightStatus];
        self.estimatedFlightTimeLabel.text = theFlight.flightTimeEstimated;
        self.actualFlightTimeLabel.text = theFlight.flightTimeActual;
        
        //Determine Tail for tracking...
        NSString *tailNumber = [self findFiledTailNumber:theFlight];

        //Search for detail tracking info by tailNumber...
        if ( (tailNumber) && ([self shouldMakeSabreCall]) ){
            [NFDFlightTrackingManager.sharedInstance searchTrackingByTailNumber:tailNumber];
        }

        [self updateMapWithAirportData];
        
    }else{

        [self.detailMapView setHidden:YES];
        [self.detailsGeneratedLabel setHidden:YES];
        [self.detailInformationView setHidden:YES];
        
    }
    
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

-(void) configureActualAircraft: (NFDFlight *) theFlight
{
    static CGRect actualAircraftTypeLabelRect;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actualAircraftTypeLabelRect = self.actualAircraftTypeLabel.frame;
    });
    
    BOOL highlight = NO;
    UIColor *highlightBackgroundColor = [UIColor clearColor];
    
    if ([theFlight flightInAirOrFlown]) {
        // Only highlight upgrades/downgrades if flown or in air
        
        if (theFlight )
        switch (theFlight.aircraftTypeComparision) {
            case NFDAircraftTypeSame:
                highlight = NO;
                break;
            case NFDAircraftTypeUpgrade:
                highlight = YES;
                highlightBackgroundColor = [UIColor fliteDeckGreenColor];
                break;
            case NFDAircraftTypeDowngrade:
                highlight = YES;
                highlightBackgroundColor = [UIColor fliteDeckYellowColor];
                break;
            default:
                break;
        }
    }
    
    [self highlightLabel:self.actualAircraftTypeLabel value:theFlight.aircraftTypeDisplayNameActual highlightBackgroundColor:highlightBackgroundColor highlightTextColor:[UIColor blackColor] orginalRect:actualAircraftTypeLabelRect highlight:highlight];
}

-(void) configureContractHours: (NFDFlight *) theFlight
{
    static CGRect remainingHoursRect1;
    static CGRect remainingHoursRect2;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        remainingHoursRect1 = self.remaingHours1.frame;
        remainingHoursRect2 = self.remaingHours2.frame;
    });

    NSString *remainingHoursText1 = nil;
    NSString *remainingHoursText2 = nil;
    
    BOOL highlight1 = NO;
    BOOL highlight2 = NO;

    if ([theFlight.contractType isEqualToString:@"C"]){
        // For car
        self.remainingHours1Label.text = @"Remaining Available:";
        self.remainingHours2Label.text = @"";
        remainingHoursText1 = theFlight.availableRemainingHours;
        highlight1 = [theFlight availableRemainingHoursAreNegative];

    } else {
        self.remainingHours1Label.text = @"Remaining Allotted:";
        self.remainingHours2Label.text = @"Remaining Available:";
        
        NSString *dateText = [NSString stringFromDate:theFlight.contractCurrentYearEndDate formatType:NCLDateFormatDateOnly];

        if (!dateText || [dateText isEmptyOrWhitespace]) {
            remainingHoursText1 = theFlight.allottedRemainingHours;
            remainingHoursText2 = theFlight.availableRemainingHours;
        } else {
            remainingHoursText1 = [NSString stringWithFormat:@"%@ (%@)", theFlight.allottedRemainingHours, dateText];
            remainingHoursText2 = [NSString stringWithFormat:@"%@ (%@)", theFlight.availableRemainingHours, dateText];
        }

        highlight2 = [theFlight availableRemainingHoursAreNegative];
    }
    
    
    [self highlightLabel:self.remaingHours1 value:remainingHoursText1 highlightBackgroundColor:[UIColor fliteDeckYellowColor] highlightTextColor:[UIColor blackColor] orginalRect:remainingHoursRect1 highlight:highlight1];
    
    [self highlightLabel:self.remaingHours2 value:remainingHoursText2 highlightBackgroundColor:[UIColor fliteDeckYellowColor] highlightTextColor:[UIColor blackColor] orginalRect:remainingHoursRect2 highlight:highlight2];
}

-(void) configureContractEndDate: (NSDate *) contractEndDate
{
    if (contractEndDate == nil) {
        self.accountEndDate.text = @"";
        return;
    }
        
    NSString *contractEndDateText = [NSString stringFromDate:contractEndDate formatType:NCLDateFormatDateOnly timezone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    self.accountEndDate.text = contractEndDateText;
    
    static CGRect accountEndDateRect;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountEndDateRect = self.accountEndDate.frame;
    });
    
    BOOL highLightEndDate = [self.aircraftTypeService isContractExpiringOrExpired:contractEndDate];
    
    [self highlightLabel:self.accountEndDate value:contractEndDateText highlightBackgroundColor:[UIColor fliteDeckYellowColor] highlightTextColor:[UIColor blackColor] orginalRect:accountEndDateRect highlight:highLightEndDate];
    
}

-(void) configureFlightStatusLabel: (NSString *) flightStatusText
{
    BOOL highlight = ([FLIGHT_STATUS_NOT_FLOWN isEqualToString:flightStatusText] ? NO : YES);
    
    UIColor *statusColor = [self colorForFlightStatus:flightStatusText];
    
    UIColor *textColor = [UIColor whiteColor];
    if ([FLIGHT_STATUS_FLOWN isEqualToString:flightStatusText]) {
        textColor = [UIColor blackColor];
    }
    
    static CGRect flightStatusRect;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flightStatusRect = self.flightStatusLabel.frame;
    });
    
    [self highlightLabel:self.flightStatusLabel value:flightStatusText highlightBackgroundColor:statusColor highlightTextColor:textColor orginalRect:flightStatusRect highlight:highlight];
}

-(UIColor *) colorForFlightStatus: (NSString *) flightStatusText
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

- (void)updateMapWithAirportData{

    NFDFlight *theFlight = [self retrieveFlightForThisView];
    
    //Clear Map of all Annotations and Overlays...
    [self.flightDetailMapView removeAnnotations:self.flightDetailMapView.annotations];
    [self.flightDetailMapView removeOverlays:self.flightDetailMapView.overlays];

    if (theFlight){

        //Fetch Airport data from PersistenceManager...
        NFDAirport *departureAirport = [NFDFlightTrackingManager.sharedInstance findAirportByAirportId:theFlight.departureICAO
                                                                                            context:[[NFDPersistenceManager sharedInstance] mainMOC]];
        NFDAirport *arrivalAirport = [NFDFlightTrackingManager.sharedInstance findAirportByAirportId:theFlight.arrivalICAO
                                                                                          context:[[NFDPersistenceManager sharedInstance] mainMOC]];

        //Update the map view...
        if ((departureAirport) && (arrivalAirport)) {            
            
            //Create Departure Airport Annotation...
            float departureLatitude = [departureAirport.latitude_qty floatValue]/3600;
            float departureLongitude = [departureAirport.longitude_qty floatValue]/3600;
            CLLocationCoordinate2D departureCoordinate = {departureLatitude, departureLongitude};    
            NFDFlightTrackingDetailMapAnnotation *departureAnnotation = [[NFDFlightTrackingDetailMapAnnotation alloc] initWithCoordinate:departureCoordinate];
            [departureAnnotation setTypeOfAnnotation:DEPARTURE_ANNOTIAION];
            [departureAnnotation setFlight:theFlight];
            [departureAnnotation setAirport:departureAirport];
            [self.flightDetailMapView addAnnotation:departureAnnotation];

            //Create Arrival Airport Annotation...
            float arrivalLatitude = [arrivalAirport.latitude_qty floatValue]/3600;
            float arrivalLongitude = [arrivalAirport.longitude_qty floatValue]/3600;
            CLLocationCoordinate2D arrivalCoordinate = {arrivalLatitude, arrivalLongitude};
            NFDFlightTrackingDetailMapAnnotation *arrivalAnnotation = [[NFDFlightTrackingDetailMapAnnotation alloc] initWithCoordinate:arrivalCoordinate];
            [arrivalAnnotation setTypeOfAnnotation:ARRIVAL_ANNOTIAION];
            [arrivalAnnotation setFlight:theFlight];
            [arrivalAnnotation setAirport:arrivalAirport];
            [self.flightDetailMapView addAnnotation:arrivalAnnotation];

            [self centerOnAllAnnotations];
            [self drawRoutesBetweenAnnotations];
        }
    }
}

- (void)updateMapWithAircraftData{

    NFDFlight *theFlight = [self retrieveFlightForThisView];
    NFDFlightData *theAircraft = [self retrieveAircraftForThisView];

    if ( (theFlight && theAircraft) && ([self shouldDisplayAircraftOnMap]) ){
        
        float tailLatitude = [theAircraft.Lat floatValue];
        float tailLongitude = [theAircraft.Lon floatValue];
        
        if ( ( tailLatitude != 0.0f ) && ( tailLongitude != 0.0f ) ){

            //Display last update date...
            NSDate *lastUpdated = [NFDFlightTrackingManager.sharedInstance tailsLastUpdated];
            if (lastUpdated){
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                NSString *timeStamp = [dateFormatter stringFromDate:lastUpdated];
                [self.trackingGeneratedLabel setHidden:NO];
                [self.trackingGeneratedLabel setText:timeStamp];
            }else {
                [self.trackingGeneratedLabel setHidden:YES];
            }

            //Check to see if Airctaft Annotation Already Exists...
            for (NFDFlightTrackingDetailMapAnnotation *theAnnotation in [self.flightDetailMapView annotations]){
                if ([[theAnnotation typeOfAnnotation] isEqualToString:AIRCRAFT_ANNOTIAION]){
                    [self.flightDetailMapView removeAnnotation:theAnnotation];
                }
            }

            //Create Coordinate Information for Aircraft...
            CLLocationCoordinate2D aircraftCoordinate = {tailLatitude, tailLongitude};
            NFDFlightTrackingDetailMapAnnotation *aircraftAnnotation = [[NFDFlightTrackingDetailMapAnnotation alloc] initWithCoordinate:aircraftCoordinate];

            //Find the Arrival Coordinate...
            CLLocationCoordinate2D arrivalCoordinate = {0,0};
            for (NFDFlightTrackingDetailMapAnnotation *theAnnotation in [self.flightDetailMapView annotations]){
                if ([[theAnnotation typeOfAnnotation] isEqualToString:ARRIVAL_ANNOTIAION]) {
                    arrivalCoordinate = theAnnotation.coordinate;
                }
            }

            //Calculate Dirrection from Aircraft to Arrival Location...
            if ( !((arrivalCoordinate.latitude == 0) && (arrivalCoordinate.longitude == 0)) ){
                double lat1 = aircraftCoordinate.latitude * M_PI / 180.0;
                double lon1 = aircraftCoordinate.longitude * M_PI / 180.0;
                double lat2 = arrivalCoordinate.latitude * M_PI / 180.0;
                double lon2 = arrivalCoordinate.longitude * M_PI / 180.0;
                double dLon = lon2 - lon1;
                double y = sin(dLon) * cos(lat2);
                double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
                double radiansBearing = atan2(y, x);
                CLLocationDirection directionFromAircraftToArrival = radiansBearing * 180.0/M_PI;
                [aircraftAnnotation setDirection:directionFromAircraftToArrival];
            }
            
            //Drop the Aircraft Annotation onto the MapView...
            [aircraftAnnotation setTypeOfAnnotation:AIRCRAFT_ANNOTIAION];
            [aircraftAnnotation setFlight:theFlight];
            [self.flightDetailMapView addAnnotation:aircraftAnnotation];
            
            
            [self centerOnAllAnnotations];
            [self drawRoutesBetweenAnnotations];
            
        }
    }
}

- (void)centerOnAllAnnotations
{
    if ([self.flightDetailMapView annotations]) {
        CLLocationCoordinate2D upper;
        CLLocationCoordinate2D lower;
        
        CLLocationCoordinate2D departureCoordinate = {0, 0};
        CLLocationCoordinate2D arrivalCoordinate = {0, 0};
        
        for (NFDFlightTrackingDetailMapAnnotation *theAnnotation in [self.flightDetailMapView annotations])
        {
            if ([[theAnnotation typeOfAnnotation] isEqualToString:ARRIVAL_ANNOTIAION]) {
                arrivalCoordinate = theAnnotation.coordinate;
            }else if ([[theAnnotation typeOfAnnotation] isEqualToString:DEPARTURE_ANNOTIAION]){
                departureCoordinate = theAnnotation.coordinate;
            }
        }
        
        if (departureCoordinate.latitude > arrivalCoordinate.latitude) {
            upper.latitude = departureCoordinate.latitude;
            lower.latitude = arrivalCoordinate.latitude;
        } else {
            upper.latitude = arrivalCoordinate.latitude;
            lower.latitude = departureCoordinate.latitude;
        }
        
        if (departureCoordinate.longitude > arrivalCoordinate.longitude) {
            upper.longitude = departureCoordinate.longitude;
            lower.longitude = arrivalCoordinate.longitude;
        } else {
            upper.longitude = arrivalCoordinate.longitude;
            lower.longitude = departureCoordinate.longitude;
        }
        
        // FIND REGION
        MKCoordinateSpan locationSpan;
        locationSpan.latitudeDelta = (upper.latitude - lower.latitude) * 1.8;
        locationSpan.longitudeDelta = (upper.longitude - lower.longitude) * 1.8;
        
        CLLocationCoordinate2D locationCenter;
        locationCenter.latitude = (upper.latitude + lower.latitude) / 2;
        locationCenter.longitude = (upper.longitude + lower.longitude) / 2;
        
        MKCoordinateRegion region = MKCoordinateRegionMake(locationCenter, locationSpan);
        
        [self.flightDetailMapView setRegion:region animated:YES];
    }
}

-(void)drawRoutesBetweenAnnotations{

    //Clear Map of all Overlays...
    [self.flightDetailMapView removeOverlays:self.flightDetailMapView.overlays];

    MKMapPoint departurePoint;
    MKMapPoint arrivalPoint;
    MKMapPoint aircraftPoint;
    BOOL hasAircraft = NO;

    for (NFDFlightTrackingDetailMapAnnotation *theAnnotation in [self.flightDetailMapView annotations]){
        if ([[theAnnotation typeOfAnnotation] isEqualToString:ARRIVAL_ANNOTIAION]) {
            arrivalPoint = MKMapPointForCoordinate(theAnnotation.coordinate);
        }else if ([[theAnnotation typeOfAnnotation] isEqualToString:DEPARTURE_ANNOTIAION]){
            departurePoint = MKMapPointForCoordinate(theAnnotation.coordinate);
        }else if ([[theAnnotation typeOfAnnotation] isEqualToString:AIRCRAFT_ANNOTIAION]){
            aircraftPoint = MKMapPointForCoordinate(theAnnotation.coordinate);
            hasAircraft = YES;
        }
    }

    if (hasAircraft){
        MKMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D) * 2);
        pointArray[0] = aircraftPoint;
        pointArray[1] = arrivalPoint;
        MKPolyline *routeLine = [MKPolyline polylineWithPoints:pointArray count:2];
        [self.flightDetailMapView addOverlay:routeLine];
    }
    
    MKMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D) * 2);
    pointArray[0] = departurePoint;
    pointArray[1] = arrivalPoint;
    MKPolyline *routeLine = [MKPolyline polylineWithPoints:pointArray count:2];
    [self.flightDetailMapView addOverlay:routeLine];
}

#pragma mark - Navigation Bar Button Methods

- (IBAction)displayActionList:(id)sender{
    if (!self.popover){
        PopoverTableViewController *popoverContent = [[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil];
        [popoverContent setPreferredContentSize:CGSizeMake(200, 130)];
        [popoverContent.tableView setScrollEnabled:NO];
        [popoverContent.tableView setDataSource:self];
        [popoverContent.tableView setDelegate:self];
        [popoverContent.tableView setTag:ACTION_COMMANDS_TABLE_VIEW];
        [popoverContent.tableView reloadData];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        [self.popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.popover setDelegate:self];
    }
}
    
- (void)displaySearchModal:(NSInteger)searchSelection
{
    NFDFlightTrackingSearchViewController *searchController = [[NFDFlightTrackingSearchViewController alloc] initWithNibName:@"NFDFlightTrackingSearchViewController" bundle:nil];
    [searchController.view setTag:searchSelection];
    
    UINavigationController *modalController = [[UINavigationController alloc] initWithRootViewController:searchController];

    modalController.modalPresentationStyle = UIModalPresentationFormSheet;
    modalController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    modalController.navigationBar.barTintColor = [UIColor modalNavigationBarTintColor];
    modalController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    modalController.navigationBar.translucent = NO;
    
    NFDAppDelegate *appDelegate = (NFDAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.navigationController presentViewController:modalController animated:YES completion:nil];

    modalController.view.superview.bounds = CGRectMake(
                                                     0,
                                                     0,
                                                     660,
                                                     214
                                                     );
}

- (CGPoint)screenCenterPoint
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    int orientation = [UIApplication sharedApplication].statusBarOrientation;
        
    if (orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight)
    {
        CGRect temp;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;      
    }
    
    return CGPointMake(fullScreenRect.size.width/2, fullScreenRect.size.height/2);
}

- (void)popBack{
    NFDAppDelegate *appDelegate = (NFDAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController popViewControllerAnimated:YES];
    [self.masterPopoverController dismissPopoverAnimated:YES];
}

-(void)displaMasterViewWhileSearching
{
    BOOL isPortrait = UIDeviceOrientationIsPortrait(self.interfaceOrientation);
    
    if (isPortrait &&
        self.navigationItem.leftBarButtonItem)
    {
        // TODO: crashing here when in portrait, 1) start search 2) go back to landing page 3) come back in and do another search
        @try
        {
            [self.masterPopoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem
                                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                                 animated:NO];
        }
        @catch (NSException *exception)
        {
            NSLog(@"popover error= %@", [exception description]);
        }
    }
}

#pragma mark - MKMapViewDelegate Methods

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id) annotation {
    if ([annotation isKindOfClass:[NFDFlightTrackingDetailMapAnnotation class]] ){
        NFDFlightTrackingDetailMapAnnotation *theAnnotation = (NFDFlightTrackingDetailMapAnnotation*)annotation;
        if ([[theAnnotation typeOfAnnotation] isEqualToString:AIRCRAFT_ANNOTIAION]) {
            MKAnnotationView *customAnnotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
            UIImage *aircraftImage = [UIImage imageNamed:@"NJ_Flight_Tracker_AC.png"];
            double direction = [theAnnotation direction];
            [customAnnotationView setImage:[NFDFlightTrackingManager.sharedInstance rotatedImage:aircraftImage byDegreesFromNorth:direction color:[UIColor whiteColor]]];
            [customAnnotationView setCanShowCallout:YES];
            return customAnnotationView;
        }
    }
    MKPinAnnotationView *customAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    [customAnnotationView setAnimatesDrop:YES];
    [customAnnotationView setCanShowCallout:YES];
    [customAnnotationView setSelected:YES];
    [customAnnotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    return customAnnotationView;    
}

- (MKOverlayView *) mapView:(MKMapView *) mapView viewForOverlay:(id) overlay {
    
    UIColor *color = [self colorForFlightStatus:self.flightStatusLabel.text];
    if ([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        if ([self.flightDetailMapView.annotations count] > 2){
            [polylineView setFillColor:color];
            [polylineView setStrokeColor:color];
            [polylineView setLineWidth:3];
        }else {
            [polylineView setFillColor:color];
            [polylineView setStrokeColor:color];
            [polylineView setLineWidth:3];
        }
        MKOverlayView *overlayView = polylineView;
        return overlayView;    
    }else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NFDAirport *airport = [(AddressAnnotation*)view.annotation airport];
    
    NFDAirportDetailViewController *airportDetailView = [[NFDAirportDetailViewController alloc] init];
    airportDetailView.airportID = airport.airportid;
    
    airportDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:airportDetailView animated:YES completion:nil];
}

- (void)mapView:(MKMapView *) mapView didAddAnnotationViews:(NSArray *) views {
    for (id<MKAnnotation> annotation in mapView.annotations) {       
        if ([annotation isKindOfClass:[NFDFlightTrackingDetailMapAnnotation class]] ){
            NFDFlightTrackingDetailMapAnnotation *theAnnotation = (NFDFlightTrackingDetailMapAnnotation*)annotation;
            if ([[theAnnotation typeOfAnnotation] isEqualToString:ARRIVAL_ANNOTIAION]) {
                [mapView selectAnnotation:annotation animated:NO];
            }
        }
    }
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (tableView.tag) 
    {
        case PASSENGER_LIST_TABLE_VIEW:
        {
            return 1;
            break;
        }
        case ACTION_COMMANDS_TABLE_VIEW:
        {
            return 1;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NFDFlight *theFlight = [self retrieveFlightForThisView];

    switch (tableView.tag) 
    {
        case PASSENGER_LIST_TABLE_VIEW:
        {
            int numberOfPassengers = [theFlight.passengers count];
            if (numberOfPassengers > 0) {
                return numberOfPassengers;
            } else {
                return 1;
            }
            break;
        }
        case ACTION_COMMANDS_TABLE_VIEW:
        {
            int numberOfActions = [actionListDctionary count];
            if (numberOfActions > 0) {
                return numberOfActions;
            } else {
                return 1;
            }
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

    switch (tableView.tag) 
    {
        case PASSENGER_LIST_TABLE_VIEW:
        {
            NFDFlight *theFlight = [self retrieveFlightForThisView];
            
            if ((theFlight) && [theFlight.passengers count] > 0) {
                NFDPassenger *passenger = [theFlight.passengers objectAtIndex:indexPath.row];
                
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.000 alpha:1.000];
                NSString *displayName = [NSString stringWithFormat:@"%@ %@", passenger.firstName, passenger.lastName];
                if ([[displayName stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
                    cell.textLabel.text = displayName;
                }else {
                    cell.textLabel.text = @"Unknown";
                }
                if (passenger.isLeadPassenger) {
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                    cell.detailTextLabel.text = @"Lead";
                }
            } else {
                cell.textLabel.font = [UIFont italicSystemFontOfSize:15];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.446 alpha:1.000];
                cell.textLabel.text = @"No passengers";
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            break;
        }
        case ACTION_COMMANDS_TABLE_VIEW:
        {
            NSString *command = [actionListDctionary objectForKey:[NSNumber numberWithInt: indexPath.row]];
            cell.textLabel.text = NSLocalizedString(command, command);
            break;
        }
        default:
        {
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) 
    {
        case PASSENGER_LIST_TABLE_VIEW:
        {
            break;
        }
        case ACTION_COMMANDS_TABLE_VIEW:
        {
            [self.popover dismissPopoverAnimated:YES];
            [self setPopover:nil];
            [self displaySearchModal:indexPath.row];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - UIPopoverControllerDelegate Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [self setPopover:nil];
}

#pragma mark - UISplitViewControllerDelegate Methods

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Flight Results", @"Flight Results");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    [self.popover dismissPopoverAnimated:YES];
    [self setPopover:nil];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];    
    [self.popover dismissPopoverAnimated:YES];
    [self setPopover:nil];
    self.masterPopoverController = nil;
}

- (IBAction)passengerListTapped:(id)sender {
    PopoverTableViewController *popoverContent = [[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil];
    [popoverContent setPreferredContentSize:CGSizeMake(250, 200)];
    [popoverContent.tableView setScrollEnabled:YES];
    [popoverContent.tableView setDataSource:self];
    [popoverContent.tableView setDelegate:self];
    [popoverContent.tableView setTag:PASSENGER_LIST_TABLE_VIEW];
    [popoverContent.tableView reloadData];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [self.popover presentPopoverFromRect:self.passengerListButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [self.popover setDelegate:self];
}

@end
