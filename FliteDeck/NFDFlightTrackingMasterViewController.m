//
//  NFDFlightTrackingMasterViewController.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightTrackingMasterViewController.h"
#import "NFDFlightTrackingTableViewCell.h"
#import "NFDFlightTrackingTableViewSearchingCell.h"
#import "NFDFlightTrackingTableViewNoResultsCell.h"
#import "NFDFlightTrackingTableViewFerryCell.h"
#import "NFDFlightTrackingManager.h"
#import "UIColor+FliteDeckColors.h"

#define CELL_IDENTIFIER @"NFDFlightTrackingTableViewCell"
#define CELL_IDENTIFIER_SEARCHING @"NFDFlightTrackingTableViewSearchingCell"
#define CELL_IDENTIFIER_NO_RESULTS @"NFDFlightTrackingTableViewNoResultsCell"
#define CELL_IDENTIFIER_FERRY @"NFDFlightTrackingTableViewFerryCell"


@implementation NFDFlightTrackingMasterViewController

@synthesize masterTableView;

@synthesize detailViewController;
@synthesize searching;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Flight Results", @"Flight Results");
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        [self setSearching:NO];
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
    
    self.view.backgroundColor = [UIColor tableViewBackgroundColor];
    self.masterTableView.backgroundColor = [UIColor tableViewBackgroundColor];
    self.masterTableView.separatorColor = [UIColor dividerLineColor];
    self.masterTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
//    [self.masterTableView setSeparatorInset:UIEdgeInsetsZero];
    
    UINib *cellNib = [UINib nibWithNibName:@"NFDFlightTrackingTableViewCell" bundle:nil];
    [self.masterTableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    cellNib = [UINib nibWithNibName:@"NFDFlightTrackingTableViewSearchingCell" bundle:nil];
    [self.masterTableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER_SEARCHING];
    
    cellNib = [UINib nibWithNibName:@"NFDFlightTrackingTableViewNoResultsCell" bundle:nil];
    [self.masterTableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER_NO_RESULTS];
    
    cellNib = [UINib nibWithNibName:@"NFDFlightTrackingTableViewFerryCell" bundle:nil];
    [self.masterTableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER_FERRY];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                        selector:@selector(updateTableViewWithNewResults)
                            name:FLIGHTS_DID_RECEIVE_NEW_RESULTS
                            object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                        selector:@selector(updateTableViewWhileSearching)
                            name:SEARCHING_FOR_RESULTS
                            object:nil];
    [self.masterTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidUnload
{
//    [[NSNotificationCenter defaultCenter] unregisterForRemoteNotifications];
    [self setMasterTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//  This is odd, because the toolbar being displayed is NOT the navigation controller's toolbar,
//  yet hiding/unhiding the navigation controller's toolbar is what makes the Flight Results toolbar
//  display appropriately. Got it?  -CP
    
    int orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight)
    {
        self.navigationController.toolbarHidden = NO;
    }
    else
    {
        self.navigationController.toolbarHidden = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Toolbar Button Methods

- (IBAction)sortByButtonAction:(id)sender {
    if ([sender isMemberOfClass:[UIBarButtonItem class]]){
        [NFDFlightTrackingManager.sharedInstance sortFlightsBy:[(UIBarButtonItem*)sender tag]];
        [self updateTableViewWithNewResults];
    };
}

#pragma mark - Notification Observer Methods

- (void) updateTableViewWithNewResults{
    [self setSearching:NO];
    [self.masterTableView reloadData];
    [detailViewController.view setTag:-1];
    [detailViewController updateViewWithFlightData];
}

- (void) updateTableViewWhileSearching{
    
    [self setSearching:YES];
    [self.masterTableView reloadData];
    [detailViewController.view setTag:-1];
    [detailViewController updateViewWithFlightData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NFDFlightTrackingManager *manager = NFDFlightTrackingManager.sharedInstance;
    if (manager.totalCountOfFlights == 0) {
        return 1;
    } else {
        return manager.totalCountOfFlights;
    }
}

- (NFDFlight *)retrieveFlightForThisView: (NSIndexPath *) indexPath
{
    NFDFlightTrackingManager *manager = NFDFlightTrackingManager.sharedInstance;
    if ( ( [manager hasRetrievedFlights] ) && ( indexPath.row > -1 ) ){
        return [manager retrieveFlightAtIndex:indexPath.row];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;

    if (self.isSearching){
        NFDFlightTrackingTableViewSearchingCell *searchingCell = (NFDFlightTrackingTableViewSearchingCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_SEARCHING forIndexPath:indexPath];
        searchingCell.contentView.backgroundColor = [UIColor tableViewBackgroundColor];
        [searchingCell.activityIndicatorView startAnimating];
        cell = searchingCell;
    }else {
        NFDFlight *flight  = [self retrieveFlightForThisView:indexPath];
        if (flight) {
            
            if ([flight.ferryFlight boolValue] == YES) {
                cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_FERRY forIndexPath:indexPath];
                [cell setTag:indexPath.row];
                [(NFDFlightTrackingTableViewFerryCell *)cell updateViewWithFlightData: flight];
                
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
                [cell setTag:indexPath.row];
                [(NFDFlightTrackingTableViewCell *)cell updateViewWithFlightData: flight searchType:NFDTrackerSearchTypeAirportSearch];
            }
        } else {
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_NO_RESULTS forIndexPath:indexPath];
            [((NFDFlightTrackingTableViewNoResultsCell *)cell).noResultsLabel setText:[NFDFlightTrackingManager.sharedInstance flightsErrorMessage]];
        }
    }
    
    cell.backgroundColor = [UIColor tableViewBackgroundColor];
    
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NFDFlightTrackingManager.sharedInstance hasRetrievedFlights]){
        [detailViewController.view setTag:indexPath.row];
        [detailViewController updateViewWithFlightData];
    }
}

@end
