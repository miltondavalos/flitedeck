//
//  NFDFlightQuoteViewController.m
//  FliteDeck
//
//  Created by Mohit Jain on 2/28/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightQuoteViewController.h"
#import "NFDAirport.h"
#import "NFDProspectViewController.h"
#import "Leg.h"
#import "NFDAirportDetailViewController.h"

#define ORIGIN_AIRPORT_INFO_BUTTON_DEPART 0
#define LEG_1_AIRPORT_INFO_BUTTON_DEPART 1
#define LEG_2_AIRPORT_INFO_BUTTON_DEPART 2
#define LEG_3_AIRPORT_INFO_BUTTON_DEPART 3
#define DESTINATION_AIRPORT_INFO_BUTTON_DEPART 4
#define ORIGIN_AIRPORT_INFO_BUTTON_RETURN 5
#define LEG_1_AIRPORT_INFO_BUTTON_RETURN 6
#define LEG_2_AIRPORT_INFO_BUTTON_RETURN 7
#define LEG_3_AIRPORT_INFO_BUTTON_RETURN 8
#define DESTINATION_AIRPORT_INFO_BUTTON_RETURN 9

#define DEPART_AIRPORT_LINE_1_Y_COORD 25
#define DEPART_AIRPORT_LINE_2_Y_COORD 50
#define DEPART_AIRPORT_LINE_3_Y_COORD 75
#define DEPART_AIRPORT_LINE_4_Y_COORD 100
#define DEPART_AIRPORT_LINE_5_Y_COORD 125

#define RETURN_AIRPORT_LINE_1_Y_COORD 0
#define RETURN_AIRPORT_LINE_2_Y_COORD 25
#define RETURN_AIRPORT_LINE_3_Y_COORD 50
#define RETURN_AIRPORT_LINE_4_Y_COORD 75
#define RETURN_AIRPORT_LINE_5_Y_COORD 100

#define AIRPORT_LINE_HEIGHT 25

@implementation NFDFlightQuoteViewController

@synthesize labelNumberOfPassengers;
@synthesize labelSeason;
@synthesize labelProductType;

@synthesize jetResultsView1;
@synthesize jetResultsView2;
@synthesize jetResultsView3;

@synthesize resultScrollView, results;
@synthesize message;
@synthesize parameters;
@synthesize pdf;
@synthesize backgroundImageView;
@synthesize modalController,prospectModalViewController;
@synthesize outLegsContainer,retLegsContainer;

# pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Flight Profile Estimate";
        
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoButtonTapped:) name:@"viewAirportDetail" object:nil];
    }
    return self;
}

# pragma mark - Button Taps

- (IBAction)shareButtonClicked:(id)sender {
    
    pdf = [[FlightProfileTripEstimatePDF alloc] init];
    pdf.parameters = parameters;
    [pdf generatePDF];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //[self showPicker];
    }
    
}

- (void) infoButtonTapped: (NSNotification *) notification
{
    NFDAirport *airport = [notification object];
    
    NFDAirportDetailViewController *airportDetailView = [[NFDAirportDetailViewController alloc] init];
    airportDetailView.airportID = airport.airportid;
    
    airportDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:airportDetailView animated:YES completion:nil];
}

# pragma mark - Display Modal

- (void)displayFlightDetailsModal:(id)sender {
    
    if(prospectModalViewController == nil){
        prospectModalViewController = [[NFDProspectViewController alloc] initWithNibName:@"NFDProspectViewController" bundle:nil];
    }
    
    prospectModalViewController.parameters = parameters;
        
    //Display modal view
    modalController = [[UINavigationController alloc] initWithRootViewController:prospectModalViewController];
    [modalController setNavigationBarHidden:NO animated:NO];
    modalController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    modalController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:modalController animated:YES completion:nil];
    
    modalController.view.superview.bounds = CGRectMake(0, 0, 750, 230);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting properties for labels
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] 
                                    initWithTitle:@"Share"                                            
                                    style:UIBarButtonItemStyleBordered 
                                    target:self 
                                    action:@selector(displayFlightDetailsModal:)];
    
    self.navigationItem.rightBarButtonItem = shareButton;
    
}

- (void)viewDidUnload
{
    [self setResultScrollView:nil];
    [self setLabelNumberOfPassengers:nil];
    [self setLabelSeason:nil];
    [self setLabelProductType:nil];
    [self setJetResultsView1:nil];
    [self setJetResultsView2:nil];
    [self setJetResultsView3:nil];
    [self setOutLegsContainer:nil];
    [self setRetLegsContainer:nil];
    [super viewDidUnload];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    labelNumberOfPassengers.text = [NSString stringWithFormat:@"Passengers: %d", parameters.passengers];
    labelSeason.text = [NSString stringWithFormat:@"Season: %@", parameters.season];
    labelProductType.text = [NSString stringWithFormat:@"Product Type: %@", parameters.product];
    
    AircraftTypeResults *result = [parameters.results objectAtIndex:0];    
        [outLegsContainer setData:result.outLegs];
    outLegsContainer.frame = CGRectMake(0, 64, 768, (result.outLegs.count+2) * 30);
    
    CGRect lastPosition = outLegsContainer.frame;
    
    if (parameters.roundTrip) {
        retLegsContainer.hidden = NO;
        retLegsContainer.returnTrip = YES;
        [retLegsContainer setData:result.retLegs];
        retLegsContainer.frame = CGRectMake(0, (outLegsContainer.frame.origin.y+outLegsContainer.frame.size.height+10), 768, (result.retLegs.count+2) * 30);
        lastPosition = retLegsContainer.frame;

    } else {
        retLegsContainer.hidden = YES;
        
    }

    [jetResultsView1 setHidden:YES];
    [jetResultsView2 setHidden:YES];
    [jetResultsView3 setHidden:YES];
    
    float contentHeight = 0;//outLegsContainer.frame.size.height + retLegsContainer.frame.size.height;
    
    for(int i=0; i < [parameters.results count]; i++){
        AircraftTypeResults *result = [parameters.results objectAtIndex:i];
        int newJetResultsViewYCoord = jetResultsView1.frame.origin.y;

        switch (i) {
            case 0:
                [jetResultsView1 setData:result];
                [jetResultsView1 setHidden:NO];
                newJetResultsViewYCoord = lastPosition.origin.y + retLegsContainer.frame.size.height + AIRPORT_LINE_HEIGHT;
                jetResultsView1.frame = CGRectMake(jetResultsView1.frame.origin.x, newJetResultsViewYCoord, jetResultsView1.frame.size.width, jetResultsView1.frame.size.height);
                contentHeight += jetResultsView1.frame.size.height;
                jetResultsView1.showMoney = [self shouldShowMoney:[[result aircraft] typeName]];
                break;
                
            case 1:
                [jetResultsView2 setData:result];
                [jetResultsView2 setHidden:NO];
                newJetResultsViewYCoord = jetResultsView1.frame.origin.y + jetResultsView1.frame.size.height + AIRPORT_LINE_HEIGHT;
                jetResultsView2.frame = CGRectMake(jetResultsView2.frame.origin.x, newJetResultsViewYCoord, jetResultsView2.frame.size.width, jetResultsView2.frame.size.height);
                
                contentHeight += jetResultsView2.frame.size.height;
                jetResultsView2.showMoney = [self shouldShowMoney:[[result aircraft] typeName]];  
                break;
                
            case 2:
                [jetResultsView3 setData:result];
                [jetResultsView3 setHidden:NO];
                newJetResultsViewYCoord = jetResultsView2.frame.origin.y + jetResultsView2.frame.size.height + AIRPORT_LINE_HEIGHT;
                jetResultsView3.frame = CGRectMake(jetResultsView3.frame.origin.x, newJetResultsViewYCoord, jetResultsView3.frame.size.width, jetResultsView3.frame.size.height);
                
                contentHeight += jetResultsView3.frame.size.height;
                jetResultsView3.showMoney = [self shouldShowMoney:[[result aircraft] typeName]];
                break;
                
            default:
                break;
        }
        
    }
    [self.resultScrollView setContentSize:CGSizeMake(self.resultScrollView.frame.size.width, contentHeight)];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        // portrait orientation
        resultScrollView.contentSize = CGSizeMake(768, 1150);
    } else
    {
        // landscape orientation
        resultScrollView.contentSize = CGSizeMake(1024, 1150);

    }
    
}

/**
 Check the user preferences to determine if costs (money) should be shown.  Note 
 that costs for CE-560 (Cit V Ultra) are never shown.
 **/

-(BOOL)shouldShowMoney:(NSString *) aircraftTypeName
{
    BOOL showMoney = NO;
    
    // Never show costs for CE-560
    if ([aircraftTypeName caseInsensitiveCompare:@"CE-560"] != NSOrderedSame) {
        showMoney = [[NFDUserManager sharedManager] profileShowMoney];        
    }
    
    return showMoney;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        resultScrollView.contentSize = CGSizeMake(768, 1150);
    } else {
        resultScrollView.contentSize = CGSizeMake(1024, 1150);
    }
}

// Starting with iOS6+, this method is not needed here
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void) dealloc {
    prospectModalViewController = nil;
}

@end
