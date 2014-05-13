//
//  NFDAirportDetailViewController.m
//  FliteDeck
//
//  Created by Chad Long on 6/13/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AddressBookUI/AddressBookUI.h>

#import "NFDPersistenceManager.h"
#import "NCLFramework.h"

#import "NFDAirportDetailViewController.h"
#import "NFDAirport.h"
#import "NFDFBO.h"
#import "NFDFBOAddress.h"
#import "NFDFBOPhone.h"
#import "NFDAircraftTypeRestriction.h"
#import "NFDAircraftType.h"
#import "NFDAlternateFBODetailViewController.h"
#import "NFDGestureRecognizer.h"
#import "CalloutMapAnnotationView.h"
#import "CalloutMapAnnotation.h"

@interface NFDAirportDetailViewController ()
{
    NFDFBO *_preferredFBO;
    NFDFBO *_secondFBO;
    NFDFBO *_thirdFBO;
    NFDAlternateFBODetailViewController *_alternateFBOView;
    UIPopoverController *_prohibitedPopover;
    NSArray *prohibitedTypes;
    MKAnnotationView *_selectedAnnotationView;
}

@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;

- (void)displayAirportOnMap;
- (void)placeFboOnMapWithGeocoder:(CLGeocoder*)geo fboArray:(NSArray*)fboArray index:(int)i;
- (NSString*)geocoderAddressForFBOAddress:(NFDFBOAddress*)fboAddress;

@end

@implementation NFDAirportDetailViewController

@synthesize airportID;
@synthesize mapView = _mapView;
@synthesize airportSummaryView;
@synthesize navBarTitle;
@synthesize navItem;
@synthesize customsImage;
@synthesize fuelImage;
@synthesize slotsImage;
@synthesize vfrImage;
@synthesize restrictionsBtn;
@synthesize fboOneBtn;
@synthesize fboTwoBtn;
@synthesize fboThreeBtn;
@synthesize runwayView;
@synthesize altitudeLbl;
@synthesize runwayLbl;
@synthesize calloutAnnotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - FBO selection

- (IBAction)fboOneSelected:(id)sender
{
    [self displayFBO:_preferredFBO buttonFrame:self.fboOneBtn.frame];
}

- (IBAction)fboTwoSelected:(id)sender
{
    [self displayFBO:_secondFBO buttonFrame:self.fboTwoBtn.frame];
}

- (IBAction)fboThreeSelected:(id)sender
{
    [self displayFBO:_thirdFBO buttonFrame:self.fboThreeBtn.frame];
}

- (void)displayFBO:(NFDFBO*)fbo buttonFrame:(CGRect)frame
{
    if (fbo != nil)
    {
        // first priority is to select the appropriate map annotation if one exists
        BOOL hasAnnotation = NO;
        NSArray *annotations = [self.mapView annotations];
        
        for (int i=0; i < annotations.count; i++)
        {
            MKPointAnnotation *pa = [annotations objectAtIndex:i];
            
            if ([pa.title isEqualToString:fbo.vendor_name])
            {
                [self.mapView setSelectedAnnotations:[NSArray arrayWithObject:pa]];
                hasAnnotation = YES;
                [_alternateFBOView.view removeFromSuperview];
                
                break;
            }
        }
        
        // if no annotations match the selected FBO, make sure currently displayed annotations are deselected before displaying the alternate FBO view
        if (!hasAnnotation &&
            self.mapView.selectedAnnotations.count > 0)
        {
            [self.mapView deselectAnnotation:[self.mapView.selectedAnnotations objectAtIndex:0] animated:NO];
        }

        // if no map annotation matches (meaning the address data is no good), animate a view from the button to display/hide the information
        if (!hasAnnotation)
        {
            if ([_alternateFBOView.view isDescendantOfView:self.view] && // use close animation only when touching the FBO currently opened
                _alternateFBOView.view.frame.origin.y == frame.origin.y+1)
            {
                [UIView animateWithDuration:0.5
                                 animations:^
                                 {
                                     [_alternateFBOView.view setBounds:CGRectMake(366, 0, 0, 32)];
                                     _alternateFBOView.view.frame = CGRectMake(frame.origin.x+19, frame.origin.y+1, 0, 32);
                                 }
                                 completion:^(BOOL finished)
                                 {
                                     [_alternateFBOView.view removeFromSuperview];
                                 }];
            }
            else
            {
                _alternateFBOView.fboName.text = fbo.vendor_name;
                _alternateFBOView.fboPhone.text = [self phoneForFBO:fbo];
                
                [_alternateFBOView.view setFrame:CGRectMake(frame.origin.x+19, frame.origin.y+1, 0, 32)];
                [_alternateFBOView.view setBounds:CGRectMake(366, 0, 0, 32)];
                [_alternateFBOView.view setClipsToBounds:YES];
                [self.view insertSubview:_alternateFBOView.view aboveSubview:self.mapView];
                [UIView animateWithDuration:0.5
                                 animations:^
                                 {
                                     [_alternateFBOView.view setBounds:CGRectMake(0, 0, 366, 32)];
                                     _alternateFBOView.view.frame = CGRectMake(frame.origin.x-347, frame.origin.y+1, 366, 32);
                                 }];
            }
        }
    }
}

#pragma mark - Prohibited popup

- (IBAction)prohibitedSelected:(id)sender
{
    UITableViewController *popoverContent = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [popoverContent.tableView setScrollEnabled:NO];
    [popoverContent.tableView setDataSource:self];
    [popoverContent.tableView setDelegate:self];
    [popoverContent setPreferredContentSize:CGSizeMake(250, prohibitedTypes.count*44)];

    _prohibitedPopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [_prohibitedPopover presentPopoverFromRect:CGRectMake(0, 0, [(UIButton *)sender frame].size.width, [(UIButton *)sender frame].size.height)
                                        inView:sender
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return prohibitedTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"AircraftTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [prohibitedTypes objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - Map construction/destruction and display

- (IBAction)closeMapView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayAirportOnMap
{
    // display the airport summary data in the nav bar
    NFDAirport *airport = [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"Airport"
                                                                     predicateKey:@"airportid"
                                                                   predicateValue:self.airportID
                                                                          context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                            error:nil];
    
    navBarTitle.text = [NSString stringWithFormat:@"%@ - %@ (%@)", airport.airport_name, airport.city_name, airport.airportid];
    
    // set the runway & altitiude
    altitudeLbl.text = [NSString stringFromObject:airport.elevation_qty];
    runwayLbl.text = [NSString stringFromObject:airport.longest_runway_length_qty];

    // set the airport service icons
    if ([airport.customs_available intValue] == 1)
        [self.customsImage setImage:[UIImage imageNamed:@"checkmark.png"]];
    else
        [self.customsImage setImage:[UIImage imageNamed:@"uncheckmark.png"]];

    if ([airport.fuel_available intValue] == 1)
        [self.fuelImage setImage:[UIImage imageNamed:@"checkmark.png"]];
    else
        [self.fuelImage setImage:[UIImage imageNamed:@"uncheckmark.png"]];

    if ([airport.slots_required intValue] == 1)
        [self.slotsImage setImage:[UIImage imageNamed:@"checkmark.png"]];
    else
        [self.slotsImage setImage:[UIImage imageNamed:@"uncheckmark.png"]];
    
    if ([airport.instrument_approach_flag intValue] == 0)
        [self.vfrImage setImage:[UIImage imageNamed:@"checkmark.png"]];
    else
        [self.vfrImage setImage:[UIImage imageNamed:@"uncheckmark.png"]];
    
    // setup prohibited aircraft type list
    NSArray *prohibitedCodes = [NSArray arrayWithObjects:[NSNumber numberWithInt:552], [NSNumber numberWithInt:553], nil];
    NSArray *restrictions = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftTypeRestriction"
                                                                       predicate:[NSPredicate predicateWithFormat:@"airportID == %@ && approvalStatusID IN %@", self.airportID, prohibitedCodes]
                                                                         context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                           error:nil];
    
    if (restrictions.count > 0)
    {
        NSMutableArray *restrictionTypes = [[NSMutableArray alloc] init];
        
        for (int i=0; i<restrictions.count; i++)
        {
            [restrictionTypes addObject:((NFDAircraftTypeRestriction*)[restrictions objectAtIndex:i]).typeName];
        }

        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
        
        NSArray *types = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                    predicate:[NSPredicate predicateWithFormat:@"typeName IN %@", [NSArray arrayWithArray:restrictionTypes]]
                                                                      sortDescriptors:sortDescriptors
                                                                     includeSubEntities:NO
                                                                      context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                       returnObjectsAsFaults:NO
                                                                        error:nil];
        NSMutableArray *typeGroups = [[NSMutableArray alloc] init]; // using array to guarantee order
        
        for (int i=0; i<types.count; i++)
        {
            NSString *typeGroupName = ((NFDAircraftType*)[types objectAtIndex:i]).typeGroupName;
            
            if (![typeGroups containsObject:typeGroupName])
                  [typeGroups addObject:typeGroupName];
        }
        
        prohibitedTypes = [NSArray arrayWithArray:typeGroups];

        [self.restrictionsBtn setAlpha:1];
        [self.restrictionsBtn setUserInteractionEnabled:YES];
    }
    else
    {
        [self.restrictionsBtn setAlpha:0.15];
        [self.restrictionsBtn setUserInteractionEnabled:NO];
    }

    // show the airport on the map
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(([airport.latitude_qty floatValue]/3600.0f),
                                                                    ([airport.longitude_qty floatValue]/3600.0f));
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinates, span);
    
    [self.mapView setRegion:region animated:YES];
    
    // add map annotations for the FBO's
    NSArray *fboArray = [NCLPersistenceUtil executeFetchRequestForEntityName:@"FBO"
                                                                   predicate:[NSPredicate predicateWithFormat:@"airportid == %@ && fbo_ranking_qty < 99", self.airportID]
                                                                     sortKey:@"fbo_ranking_qty"
                                                                     context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                       error:nil];
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [self placeFboOnMapWithGeocoder:geo fboArray:fboArray index:0]; // initial call to recurse through FBO's
}

// i blame apple for the unnecessary complexity here, forcing us to use recursion from the completion block to place the FBO's on the map...
- (void)placeFboOnMapWithGeocoder:(CLGeocoder*)geo fboArray:(NSArray*)fboArray index:(int)i
{
    // if any of the top 3 FBO's have been annotated/setup, make sure the associated button is visible
    if (_preferredFBO != nil)
        [self.fboOneBtn setHidden:NO];
    if (_secondFBO != nil)
        [self.fboTwoBtn setHidden:NO];
    if (_thirdFBO != nil)
        [self.fboThreeBtn setHidden:NO];
    
    // stop the recursion if we've recursed through the entire FBO array
    if (fboArray != nil &&
        fboArray.count > i)
    {
        NFDFBO *fbo = [fboArray objectAtIndex:i];
        
        // identify the preferred FBOs... established for alternate displayand pin colors
        if (_preferredFBO == nil)
            _preferredFBO = fbo;
        
        else if (_secondFBO == nil)
            _secondFBO = fbo;
        
        else if (_thirdFBO == nil)
            _thirdFBO = fbo;
        
        // for each FBO with an adresss, add a map annotation
        NFDFBOAddress *fboAddress = [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"FBOAddress"
                                                                               predicateKey:@"fbo_id"
                                                                             predicateValue:fbo.fbo_id
                                                                                    context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                                      error:nil];
        NSString *geoLookupAddress = [self geocoderAddressForFBOAddress:fboAddress];
        
        if (geoLookupAddress)
        {
            [geo geocodeAddressString:geoLookupAddress completionHandler:^(NSArray *placemarks, NSError *error)
            {
                if (error)
                {
                    // it will be common for the address to not be found... ignore it and move on
                }
                else
                {
                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                    MKMapPoint addressPoint = MKMapPointForCoordinate(placemark.location.coordinate);
                    MKMapRect mapRect = self.mapView.visibleMapRect;
                    
                    if (MKMapRectContainsPoint(mapRect, addressPoint)) // if annotation would be visible on map, add it - otherwise, it is likely an invalid address
                    {
                        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
                        pa.coordinate = placemark.location.coordinate;
                        pa.title = fbo.vendor_name;
                        pa.subtitle = [self subtitleForFBOAnnotation:fbo placemark:placemark];
                        
                        [self.mapView addAnnotation:pa];
                    }
                }
                
                // recursive call in async completion block because Apple does not allow more than one geoCoder call at a time
                [self placeFboOnMapWithGeocoder:geo fboArray:fboArray index:i+1];
            }];
        }
        // if no address for this FBO, move on to the next
        else
        {
            [self placeFboOnMapWithGeocoder:geo fboArray:fboArray index:i+1];
        }
    }
}

- (NSString*)geocoderAddressForFBOAddress:(NFDFBOAddress*)fboAddress
{
    // get a formatted address for the geocoder... use some intelligence to determine which address line in the data is the street address
    NSString *geoLookupAddress = nil;
    NSString *addressStreetLine = fboAddress.address_line2_txt;
    NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
    BOOL valid = ([addressStreetLine stringByTrimmingCharactersInSet:numericSet].length != addressStreetLine.length);
    
    if (addressStreetLine.length <= 3 ||
        !valid)
    {
        addressStreetLine = fboAddress.address_line1_txt;
        NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
        valid = ([addressStreetLine stringByTrimmingCharactersInSet:numericSet].length != addressStreetLine.length);
    }
    
    if (addressStreetLine.length <= 3 ||
        !valid)
    {
        addressStreetLine = fboAddress.address_line3_txt;
        NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
        valid = ([addressStreetLine stringByTrimmingCharactersInSet:numericSet].length != addressStreetLine.length);
    }
    
    if (addressStreetLine.length > 3 &&
        ![addressStreetLine contains:@"UNKNOWN"])
    {
        if (fboAddress.state_province_name != nil &&
            fboAddress.state_province_name.length > 0 &&
            ![fboAddress.state_province_name contains:@"UNKNOWN"])
        {
            geoLookupAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", addressStreetLine, fboAddress.city_name, fboAddress.state_province_name, fboAddress.country_cd];
        }
        else
        {
            geoLookupAddress = [NSString stringWithFormat:@"%@, %@, %@", addressStreetLine, fboAddress.city_name, fboAddress.country_cd];
        }
    }
    
    return geoLookupAddress;
}

- (NSString*)subtitleForFBOAnnotation:(NFDFBO*)fbo placemark:(CLPlacemark*)placemark
{
    // gets a address | phone formatted string for the annotations
    NSString *phone = [self phoneForFBO:fbo];
    NSString *address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
    
    if (phone)
    {
        return [NSString stringWithFormat:@"%@  |  %@", address, phone];
    }
    else
    {
        return address;
    }
}

- (NSString*)phoneForFBO:(NFDFBO*)fbo
{
    NFDFBOPhone *fboPhone = [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"FBOPhone"
                                                                       predicateKey:@"fbo_id"
                                                                     predicateValue:fbo.fbo_id
                                                                            context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                              error:nil];
    
    if (fboPhone)
    {
        NSString *phoneNbr = [fboPhone.telephone_nbr_txt stringByRemovingCharactersInCharacterSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        
        return [NSString stringWithFormat:@"%@.%@.%@", fboPhone.area_code_txt, [phoneNbr substringToIndex:3], [phoneNbr substringFromIndex:3]];
    }
    else
        return nil;
}

#pragma mark - Map delegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
//    if (annotation == self.calloutAnnotation)
//    {
//        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
//        
//        if (!calloutMapAnnotationView)
//        {
//            calloutMapAnnotationView = [[CalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutAnnotation"];
//        }
//        
//        calloutMapAnnotationView.parentAnnotationView = _selectedAnnotationView;
//        calloutMapAnnotationView.mapView = self.mapView;
//        
//        return calloutMapAnnotationView;
//    }
//    
//    
//    return nil;
    
    
    // manages changing the pin color for the preferred FBO
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (pinView == nil)
    {
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        
        if ([annotation.title isEqualToString:_preferredFBO.vendor_name])
        {
            pinView.pinColor = MKPinAnnotationColorPurple;
        }
        else
            pinView.pinColor = MKPinAnnotationColorRed;
    }
    
    return pinView;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                    message: @"Mapping requires a data connection.  Please ensure that a data connection exists and try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mapView setDelegate:self];
    
    // Add a custom gesture recognizer to intercept map touches without suppressing the standard map events
    NFDGestureRecognizer *tapInterceptor = [[NFDGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event)
    {
        [_alternateFBOView.view removeFromSuperview];
    };

    [self.mapView addGestureRecognizer:tapInterceptor];
    
    // setup the alternate display for FBO info (used when the FBO address cannot be resolved)
    _alternateFBOView = [[NFDAlternateFBODetailViewController alloc] init];
    [[_alternateFBOView.view layer] setCornerRadius:6];
    
    [[self.runwayView layer] setCornerRadius:6];
    [self.runwayView setClipsToBounds:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // clear local FBO info
    _preferredFBO = nil;
    _secondFBO = nil;
    _thirdFBO = nil;
    prohibitedTypes = nil;
    
    [self.fboOneBtn setHidden:YES];
    [self.fboTwoBtn setHidden:YES];
    [self.fboThreeBtn setHidden:YES];
    
    // default to CMH if not specified
    if (self.airportID == nil)
    {
        self.airportID = @"KCMH";
    }
    
    [self displayAirportOnMap];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setAirportSummaryView:nil];
    [self setNavItem:nil];
    [self setNavBarTitle:nil];
    [self setCustomsImage:nil];
    [self setFuelImage:nil];
    [self setSlotsImage:nil];
    [self setRestrictionsBtn:nil];
    [self setFboOneBtn:nil];
    [self setFboTwoBtn:nil];
    [self setFboThreeBtn:nil];
    [self setVfrImage:nil];
    [self setRunwayView:nil];
    [self setAltitudeLbl:nil];
    [self setRunwayLbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Device orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
