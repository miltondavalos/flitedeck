//
//  NFDFlightTrackerMapViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/27/13.
//
//

#import "NFDFlightTrackerMapViewController.h"

#import "NFDFlightTrackingDetailMapAnnotation.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAirportService.h"
#import "NFDAirport.h"
#import "AddressAnnotation.h"
#import "NFDAirportDetailViewController.h"

#import <MapKit/MapKit.h>



@interface NFDFlightTrackerMapViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet MKMapView *flightDetailMapView;

@property (weak, nonatomic) IBOutlet UILabel *trackingGeneratedLabel;

@property (nonatomic) CGRect flightDetailsViewFrame;

@end

@implementation NFDFlightTrackerMapViewController

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
	// Do any additional setup after loading the view.
    
    [self.backButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateHighlighted];
    [self.backButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateSelected];
    [self.backButton setTitleColor:[UIColor buttonTitleColorDisabled] forState:UIControlStateDisabled];
    
    self.backButton.backgroundColor = [UIColor contentBackgroundColor];
    self.backButton.layer.cornerRadius = 4.0;

    self.view.backgroundColor = [UIColor contentBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMapWithAircraftData)
                                                 name:[self.flightTrackerManager trackingDidReceiveNewResultsNotificatioName]
                                               object:nil];
    
    self.flightDetailsView.layer.cornerRadius = 5.0;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModal)];
    [tapRecognizer setNumberOfTapsRequired:1];
    
    [self.flightDetailsView addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateMap];
    
    self.flightDetailsView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.flightDetailsViewFrame = self.flightDetailsView.frame;
    
    self.flightDetailsView.frame = CGRectMake(self.flightDetailsViewFrame.origin.x,
                                              705,
                                              self.flightDetailsViewFrame.size.width,
                                              self.flightDetailsViewFrame.size.height);
    
    self.flightDetailsView.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        self.flightDetailsView.frame = self.flightDetailsViewFrame;
    } completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[self.flightTrackerManager trackingDidReceiveNewResultsNotificatioName] object:nil];
}

- (void)dismissModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateMap{
    
    NFDFlight *theFlight = self.flight;
    
    if (!theFlight) {
        self.view.hidden = YES;
        return;
    }
    
    if (self.view.hidden) {
        self.view.hidden = NO;
    }
    
    //Clear Map of all Annotations and Overlays...
    [self.flightDetailMapView removeAnnotations:self.flightDetailMapView.annotations];
    [self.flightDetailMapView removeOverlays:self.flightDetailMapView.overlays];
    
    //Search for detail tracking info by tailNumber...
    //Determine Tail for tracking...
    NSString *tailNumber = [self findFiledTailNumber:theFlight];
    if ( (tailNumber) && ([self shouldMakeSabreCall]) ){
        [self.flightTrackerManager searchTrackingByTailNumber:tailNumber];
    }
    
    if (theFlight){
        
        //Fetch Airport data from PersistenceManager...
        NFDAirport *departureAirport = [self.flightTrackerManager findAirportByAirportId:theFlight.departureICAO
                                                                                               context:[[NFDPersistenceManager sharedInstance] mainMOC]];
        NFDAirport *arrivalAirport = [self.flightTrackerManager findAirportByAirportId:theFlight.arrivalICAO
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
            [self updateMapWithAircraftData];
        }
    }
}

- (void)updateMapWithAircraftData{
    
    NFDFlight *theFlight = self.flight;
    NFDFlightData *theAircraft = [self retrieveAircraftForThisView];
    
    if ( (theFlight && theAircraft) && ([self shouldDisplayAircraftOnMap]) ){
        
        float tailLatitude = [theAircraft.Lat floatValue];
        float tailLongitude = [theAircraft.Lon floatValue];
        
        if ( ( tailLatitude != 0.0f ) && ( tailLongitude != 0.0f ) ){
            
            //Display last update date...
            NSDate *lastUpdated = [self.flightTrackerManager tailsLastUpdated];
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
        MKPolyline *routeLine = [MKGeodesicPolyline polylineWithPoints:pointArray count:2];
        [self.flightDetailMapView addOverlay:routeLine];
    }
    
    MKMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D) * 2);
    pointArray[0] = departurePoint;
    pointArray[1] = arrivalPoint;
    MKPolyline *routeLine = [MKGeodesicPolyline polylineWithPoints:pointArray count:2];
    [self.flightDetailMapView addOverlay:routeLine];
}

- (NFDFlightData *)retrieveAircraftForThisView
{
    NFDFlight *theFlight =  self.flight;
    
    if (theFlight){
        
        //Determine tailNumber for tracking...
        NSString *tailNumber = [self findFiledTailNumber:theFlight];
        
        
        if ([self.flightTrackerManager hasTrackedTails]){
            return [self.flightTrackerManager retrieveTailWithKey:tailNumber];
        }
        
    }
    return nil;
}

- (BOOL)shouldMakeSabreCall{
    
    BOOL returnValue = NO;
    
    NFDFlight *theFlight = self.flight;
    
    if (theFlight && theFlight.departureTimeActual && !theFlight.arrivalTimeActual){
        returnValue = YES;
    }
    
    return returnValue;
}

- (BOOL)shouldDisplayAircraftOnMap{
    
    BOOL returnValue = NO;
    
    NFDFlight *theFlight = self.flight;
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
    
    if ( (theFlight.tailNumber != nil && ![theFlight.tailNumber isEmptyOrWhitespace]) &&
        ![theFlight.tailNumber isEqualToString:@"TBD"] ) {
        
        // Some aircraft types flight plans are registered by tail number (eg, N460QS)
        // instead of the callsign (EJA123)
        
        // Assume that Callsign is being used
        tailNumber = [NSString stringWithFormat:@"EJA%@",
                      [theFlight.tailNumber substringWithRange:NSMakeRange(1,3)]];
        
        // If this is a large cabin Gulfstream, use the tail number.
        if ([self.flightTrackerManager isLargeCabinGulfstream:theFlight.aircraftTypeActual]) {
            return theFlight.tailNumber;
        }
        
        NFDAirport *departureAirport = [service findAirportWithCode:[theFlight departureICAO]];
        
        // If the departure is not in the Continental US, use the tail number
        
        if (![self isContinentalUS:departureAirport]) {
            return theFlight.tailNumber;
        }
        
        NFDAirport *arrivalAirport = [service findAirportWithCode:[theFlight arrivalICAO]];
        NSString *arrivalCountry = [arrivalAirport country_cd];
        
        // If the arrival is not in the Continental US and the arrival is not
        // Canada, use the tail number
        
        if (![self isContinentalUS:arrivalAirport] &&
            ![arrivalCountry isEqualToString:@"CAN"] ) {
            return theFlight.tailNumber;
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

#pragma mark - MKMapViewDelegate Methods

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id) annotation {
    if ([annotation isKindOfClass:[NFDFlightTrackingDetailMapAnnotation class]] ){
        NFDFlightTrackingDetailMapAnnotation *theAnnotation = (NFDFlightTrackingDetailMapAnnotation*)annotation;
        if ([[theAnnotation typeOfAnnotation] isEqualToString:AIRCRAFT_ANNOTIAION]) {
            MKAnnotationView *customAnnotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
            UIImage *aircraftImage = [UIImage imageNamed:@"NJ_Flight_Tracker_AC.png"];
            double direction = [theAnnotation direction];
            [customAnnotationView setImage:[self.flightTrackerManager rotatedImage:aircraftImage byDegreesFromNorth:direction color:[UIColor whiteColor]]];
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
    
    UIColor *color = [UIColor flightPathColor];
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

- (void)setFlight:(NFDFlight *)flight
{
    _flight = flight;
    [self updateMap];
}


@end
