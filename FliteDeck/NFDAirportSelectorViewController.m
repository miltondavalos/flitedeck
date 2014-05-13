//
//  NFDAirportSelectorViewController.m
//  FliteDeck
//
//  Created by Chad Predovich on 11/20/13.
//
//

#import "NFDAirportSelectorViewController.h"
#import "NFDAirportSelectorCell.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAirport.h"
#import "NCLFramework.h"
#import "NFDPersistenceManager.h"
#import "NFDAirportSearchManager.h"

@interface NFDAirportSelectorViewController ()
@property (nonatomic, strong) NFDAirportSearchManager *airportSearchManager;



@end

@implementation NFDAirportSelectorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.airportSearchManager = [NFDAirportSearchManager new];
    [self.airportSearchManager convertCodesToAirports];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(airportsUpdated)
                                                 name:AIRPORTS_UPDATED_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.airportSearchManager
                                             selector:@selector(updateAirports:)
                                                 name:AIRPORT_SEARCH_DID_FINISH_NOTIFICATION
                                               object:nil];
    
    [self.airportSearchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AIRPORTS_UPDATED_NOTIFICATION
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.airportSearchManager
													name:AIRPORT_SEARCH_DID_FINISH_NOTIFICATION
												  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)airportsUpdated
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.airportSearchManager.airports.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.airportSearchBar.text.length < 1) {
        NSUInteger numberOfRecentSearches = self.airportSearchManager.airports.count;
        
        return [NSString stringWithFormat:@"Recent Searches (%i)", numberOfRecentSearches];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultCell";
    NFDAirportSelectorCell *cell = (NFDAirportSelectorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NFDAirport *airport = [self.airportSearchManager.airports objectAtIndex:indexPath.row];
    
    cell.airportNameLabel.text = airport.airport_name;
    cell.airportCityLabel.text = airport.city_name;
    cell.airportCodeLabel.text = airport.airportid;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"airportSelectedUnwind" isEqualToString:segue.identifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        self.selectedAirport = [self.airportSearchManager.airports objectAtIndex:indexPath.row];
        
        [self.airportSearchManager addAirportCode:self.selectedAirport.airportid];
    }
}

#pragma mark - SearchBar delegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.airportSearchManager.searchFieldText = searchText;
    
    [self.airportSearchManager findAirports:[searchText stringByRemovingExtraWhiteSpace]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.airportSearchManager findAirports:[searchBar.text stringByRemovingExtraWhiteSpace]];
}

@end
