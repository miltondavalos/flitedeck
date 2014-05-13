//
//  NFDFlightTrackerSearchResultsTableViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/20/13.
//
//

#import "NFDFlightTrackerSearchResultsTableViewController.h"

#import "NFDFlightTrackingTableViewCell.h"
#import "NFDFlightTrackingTableViewSearchingCell.h"
#import "NFDFlightTrackingTableViewNoResultsCell.h"
#import "NFDFlightTrackingTableViewFerryCell.h"
#import "NFDFlightTrackerSortByViewController.h"
#import "NFDFlightTrackingManager.h"
#import "UIColor+FliteDeckColors.h"

#define CELL_IDENTIFIER @"NFDFlightTrackingTableViewCell"
#define CELL_IDENTIFIER_SEARCHING @"NFDFlightTrackingTableViewSearchingCell"
#define CELL_IDENTIFIER_NO_RESULTS @"NFDFlightTrackingTableViewNoResultsCell"
#define CELL_IDENTIFIER_FERRY @"NFDFlightTrackingTableViewFerryCell"

@interface NFDFlightTrackerSearchResultsTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign, getter=isSearching) BOOL searching;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UILabel *headerSearchDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerSearchDetailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NFDFlight *selectedFlight;

@end

@implementation NFDFlightTrackerSearchResultsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tableViewBackgroundColor];
    self.tableView.backgroundColor = [UIColor tableViewBackgroundColor];
    self.tableView.separatorColor = [UIColor dividerLineColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.headerView.backgroundColor = [UIColor tableViewBackgroundColor];
    
    self.headerSearchDetailDescriptionLabel.textColor = [UIColor tableViewCellSelectedSecondaryTextColor];
    
    UINib *cellNib = [UINib nibWithNibName:@"NFDFlightTrackingTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    cellNib = [UINib nibWithNibName:@"NFDFlightTrackingTableViewSearchingCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER_SEARCHING];
    
    cellNib = [UINib nibWithNibName:@"NFDFlightTrackingTableViewNoResultsCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER_NO_RESULTS];
    
    cellNib = [UINib nibWithNibName:@"NFDFlightTrackingTableViewFerryCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER_FERRY];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableViewWithNewResults)
                                                 name:[self.flightTrackerManager flightsDidReceiveNewResultsNotificatioName]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableViewWhileSearching)
                                                 name:[self.flightTrackerManager searchingDidReceiveNewResultsNotificatioName]
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[self.flightTrackerManager flightsDidReceiveNewResultsNotificatioName] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[self.flightTrackerManager searchingDidReceiveNewResultsNotificatioName] object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark - Notification Observer Methods

- (void) updateTableViewWithNewResults{
    [self setSearching:NO];
    
    if ([self.flightTrackerManager.flights count] > 0) {
        self.sortButton.enabled = YES;
    }

    [self.tableView reloadData];
    
    if (self.selectedFlight) {
        NSUInteger selectedFlightIndex = [self.flightTrackerManager.flights indexOfObject:self.selectedFlight];
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedFlightIndex inSection:0];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void) updateTableViewWhileSearching{
    self.headerSearchDescriptionLabel.text = self.flightTrackerManager.searchDescription;
    self.headerSearchDetailDescriptionLabel.text = self.flightTrackerManager.searchDetailDescription;
    self.sortButton.enabled = NO;
    
    [self setSearching:YES];
    [self.tableView reloadData];
    self.detailViewController.flight = nil;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.flightTrackerManager.totalCountOfFlights == 0) {
        return 1;
    } else {
        return self.flightTrackerManager.totalCountOfFlights;
    }
}

- (NFDFlight *)retrieveFlightForThisView: (NSIndexPath *) indexPath
{
    if ( ( [self.flightTrackerManager hasRetrievedFlights] ) && ( indexPath.row > -1 ) ){
        return [self.flightTrackerManager retrieveFlightAtIndex:indexPath.row];
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
                [(NFDFlightTrackingTableViewCell *)cell updateViewWithFlightData: flight searchType:self.flightTrackerManager.flightsSearchType];
            }
        } else {
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_NO_RESULTS forIndexPath:indexPath];
            [((NFDFlightTrackingTableViewNoResultsCell *)cell).noResultsLabel setText:[self.flightTrackerManager flightsErrorMessage]];
        }
    }
    
    cell.backgroundColor = [UIColor tableViewBackgroundColor];
    
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.flightTrackerManager hasRetrievedFlights]){
        NFDFlight *flight  = [self retrieveFlightForThisView:indexPath];

        self.detailViewController.flight = flight;
        
        self.selectedFlight = flight;
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"sortBy" isEqualToString:segue.identifier]) {
        NFDFlightTrackerSortByViewController *sortByViewController = segue.destinationViewController;
        sortByViewController.sortBy = self.flightTrackerManager.flightsSortedBy;
    }
}

- (IBAction)sortBySelectedUnwindSegue:(UIStoryboardSegue *)segue {
    NFDFlightTrackerSortByViewController *sortByViewController = segue.sourceViewController;
    
    [self.flightTrackerManager sortFlightsBy:sortByViewController.sortBy];
    [self updateTableViewWithNewResults];
}


@end
