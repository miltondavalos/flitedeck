//
//  NFDAirportLocatorWithMapViewController.m
//  FliteDeck
//
//  Created by Chad Long on 6/20/12.
//
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDAirportLocatorWithMapViewController.h"
#import "NFDPersistenceManager.h"
#import "NFDAirport.h"
#import "NFDAlertMessage.h"
#import "NFDAirportDetailViewController.h"

@interface NFDAirportLocatorWithMapViewController()
{
    CLLocationManager *_locationMgr;
    MKCoordinateSpan _mapSpan;
    NSMutableSet *_annotationSet;
}

@end

@implementation NFDAirportLocatorWithMapViewController

@synthesize activityIndicator;
@synthesize airportMap, searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

#pragma mark - Mapping delegates

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // limit the 'zoom out' to something reasonable so we're not displaying every airport in the world
    MKCoordinateRegion maxRegionThatFits = MKCoordinateRegionMake(self.airportMap.centerCoordinate, MKCoordinateSpanMake(.8, .8));
    
    if (self.airportMap.region.span.latitudeDelta > maxRegionThatFits.span.latitudeDelta)
    {
        [mapView setRegion:maxRegionThatFits];
    }
    
    // get all airports in the visible map region
    double top = (mapView.region.center.latitude + mapView.region.span.latitudeDelta/2) * 3600.0f;
    double bottom = (mapView.region.center.latitude - mapView.region.span.latitudeDelta/2) * 3600.0f;
    double left = (mapView.region.center.longitude - mapView.region.span.longitudeDelta/2) * 3600.0f;
    double right = (mapView.region.center.longitude + mapView.region.span.longitudeDelta/2) * 3600.0f;
    
    NSPredicate *regionLatLongPredicate = [NSPredicate predicateWithFormat:@"latitude_qty > %f && latitude_qty < %f && longitude_qty > %f && longitude_qty < %f",
                                           bottom, top, left, right];
    
    NSArray *airports = [NCLPersistenceUtil executeFetchRequestForEntityName:@"Airport"
                                                                   predicate:regionLatLongPredicate
                                                                     sortKey:@"latitude_qty"
                                                                     context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                       error:nil];
    // add the airport pins
    for (int i=0; i<airports.count; i++)
    {
        NFDAirport *airport = [airports objectAtIndex:i];
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = CLLocationCoordinate2DMake([airport.latitude_qty floatValue]/3600.0f, [airport.longitude_qty floatValue]/3600.0f);
        pa.title = airport.airport_name;
        pa.subtitle = airport.airportid;
        
        if (![_annotationSet containsObject:airport.airportid]) // if it's already there, don't add it again
        {
            [_annotationSet addObject:airport.airportid];
            [self.airportMap addAnnotation:pa];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // setup the pin display for the airport
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (pinView == nil)
    {
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.pinColor = MKPinAnnotationColorRed;
    }
    
    return pinView;    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // upon annotation selection, display the detailed airport view
    NFDAirportDetailViewController *airportDetailView = [[NFDAirportDetailViewController alloc] init];
    airportDetailView.airportID = [(MKPointAnnotation*)view.annotation subtitle];
    
    airportDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:airportDetailView animated:YES completion:nil];
}

#pragma mark - Location services

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_locationMgr stopUpdatingLocation];
    
    // update the map with the users current location
    [self.airportMap setCenterCoordinate:[newLocation coordinate]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationMgr stopUpdatingLocation];

    [self displayAlertForCLError:error];
}

- (void)displayAlertForCLError:(NSError*)error
{
    // setup default error msg
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services"
                                                    message:@"An unexpected error occurred.  Please try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    // if location services is disabled, report it to the user
    if ([[error domain] isEqualToString:kCLErrorDomain] &&
        [error code] == kCLErrorDenied)
    {
        [alert setTitle:@"GPS Notification"];
        [alert setMessage:@"Location services must be enabled for the device to display your current location on the map."];
    }
    
    // network error
    else if ([[error domain] isEqualToString:kCLErrorDomain] &&
             ([error code] == kCLErrorNetwork || [error code] == kCLErrorLocationUnknown))
    {
        [alert setTitle:@"Connection Error"];
        [alert setMessage:@"Mapping requires a data connection.  Please ensure that a data connection exists and try again."];
    }
    
    // geocoding error
    else if ([[error domain] isEqualToString:kCLErrorDomain] &&
             ([error code] == kCLErrorGeocodeFoundNoResult || [error code] == kCLErrorGeocodeFoundPartialResult))
    {
        [alert setTitle:@"Mapping Error"];
        [alert setMessage:@"The specified search location could not be found."];
    }
    
    [alert show];
}

#pragma mark - Search bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [self.searchBar resignFirstResponder];
    [activityIndicator startAnimating];
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    
    [geo geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error)
    {
        [activityIndicator stopAnimating];

        if (error)
        {
            [self displayAlertForCLError:error];
        }
        else
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            [self.airportMap setCenterCoordinate:placemark.location.coordinate animated:YES];
            [self.airportMap setRegion:MKCoordinateRegionMake(placemark.location.coordinate, _mapSpan) animated:YES];
        }
    }];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Airport Locator"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor colorWithRed:0.384 green:0.383 blue:0.386 alpha:1.000];
    // init the annotation set to track where we've placed pins (don't do it twice)
    _annotationSet = [[NSMutableSet alloc] init];
    
    // init the map span, which defines the display region of the map
    _mapSpan = MKCoordinateSpanMake(.3, .3);
    
    // start at port columbus (will remain if location services is not turned on)
    NFDAirport *cmh = [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"Airport"
                                                                 predicateKey:@"airportid"
                                                               predicateValue:@"KCMH"
                                                                      context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                        error:nil];
    
    CLLocationCoordinate2D cmhCoordinates = CLLocationCoordinate2DMake([cmh.latitude_qty floatValue]/3600.0f, [cmh.longitude_qty floatValue]/3600.0f);
    MKCoordinateRegion region = MKCoordinateRegionMake(cmhCoordinates, _mapSpan);
    [self.airportMap setRegion:region animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // display the GPS location of this device
    _locationMgr = [[CLLocationManager alloc] init];
    _locationMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationMgr.delegate = self;
    [_locationMgr startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _locationMgr = nil;
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    
    _annotationSet = nil;
}

#pragma mark - Device notifications

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    NSLog(@"received memory warning in NFDAirportLocatorWithMapViewController...");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
