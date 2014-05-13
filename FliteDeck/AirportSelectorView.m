//
//  AirportSelectorView.m
//  FlightProfile
//
//  Created by Evol Johnson on 1/9/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//


#import "AirportSelectorView.h"
#import "SearchResultsTableViewController.h"
#import "NFDAirport.h"
#import "NCLFramework.h"

//#pragma clang diagnostic ignored "-Warc-performSelector-leaks" 

@interface AirportSelectorView()
{
    NSManagedObjectContext *cdContext;
    dispatch_queue_t searchQueue;
}

@end

@implementation AirportSelectorView

@synthesize searchResultsTableView, airportSearchBar, searchResultsPopover, selectedAirport, legNumber, results;

#pragma mark - Initialization

- (void)baseInit {
    self.backgroundColor = [UIColor clearColor];
    
    hasSelectedAirport = NO;
    legNumber = 0;
    
    cdContext = [[NFDPersistenceManager sharedInstance] mainMOC];
    
    CGRect searchBarFrame = CGRectMake(0, 0, 374, 44);
    self.airportSearchBar = [[UISearchBar alloc] initWithFrame:searchBarFrame];
    self.airportSearchBar.placeholder = @"Name, City or Code";
    self.airportSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.airportSearchBar.delegate = self;
    self.airportSearchBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.airportSearchBar];
    
    // setup the popover table view
    self.searchResultsTableView = [[SearchResultsTableViewController alloc] initWithNibName:@"SearchResultsTableViewController" bundle:nil];
    self.searchResultsTableView.tableView.dataSource = self;
    self.searchResultsTableView.tableView.delegate = self;
    [self.searchResultsTableView setPreferredContentSize:CGSizeMake(525, 900)];
    self.searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:searchResultsTableView];
    
    // observe search completion notifications to update the UI
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSearchResultsDisplay:)
                                                 name:AIRPORT_SEARCH_DID_COMPLETE_NOTIFICATION
                                               object:nil];
    
    searchQueue = dispatch_queue_create("com.netjets.airportsearch", 0);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

#pragma mark - SearchBar delegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (selectedAirport == nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    selectedAirport = nil;
    hasSelectedAirport = NO;

    [self findAirports:[searchText stringByRemovingExtraWhiteSpace]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self findAirports:[searchBar.text stringByRemovingExtraWhiteSpace]];
}

#pragma mark - Airport search

- (void)findAirports:(NSString*)searchText
{
    dispatch_async(searchQueue, ^
    {
        NSArray *searchResults;
        
        // if no text exists, no need to search
        if (searchText.length <= 1)
        {
            searchResults = [[NSArray alloc] init];
        }

        // else... find the airports for the given search string
        else
        {
            NSString *partialPredicate = @"(airportid CONTAINS[cd] %@) OR (iata_cd CONTAINS[cd] %@)";
            NSString *fullPredicate = @"(airportid CONTAINS[cd] %@) OR (iata_cd CONTAINS[cd] %@) OR (airport_name CONTAINS[cd] %@) OR (city_name CONTAINS[cd] %@)";
            NSPredicate *predicate = nil;
            
            if (searchText.length > 2)
            {
                predicate = [NSPredicate predicateWithFormat:fullPredicate, searchText, searchText, searchText, searchText];
            }
            else
            {
                predicate = [NSPredicate predicateWithFormat:partialPredicate, searchText, searchText];
            }
            
            // WARNING - this code is using the main moc in a background thread which is dangerous.
            // On top of that it then passes the results in a notification back to the main thread.  Also
            // bad.  Hopefully this code will die soon with the Profile rewrite.
            searchResults = [NCLPersistenceUtil executeFetchRequestForEntityName:@"Airport"
                                                                       predicate:predicate
                                                                         sortKey:@"airport_name"
                                                                         context:cdContext
                                                                           error:nil];
        }
        
        // post a notification with appropriate search result data
        NSArray *keys = [NSArray arrayWithObjects:
                         AIRPORT_SEARCH_TEXT_NOTIFICATION_KEY,
                         AIRPORT_SEARCH_RESULTS_NOTIFICATION_KEY, nil];
        NSArray *objects = [NSArray arrayWithObjects:
                            searchText,
                            searchResults, nil];
        NSDictionary *notificationData = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:AIRPORT_SEARCH_DID_COMPLETE_NOTIFICATION object:self userInfo:notificationData];
        });
    });
}

- (void)updateSearchResultsDisplay:(NSNotification*)notification
{
    NSString *searchText = [[[[notification userInfo] objectForKey:AIRPORT_SEARCH_TEXT_NOTIFICATION_KEY] stringByTrimmingWhiteSpaceAndNewLines] uppercaseString];
    NSString *currentSearchText = [[airportSearchBar.text stringByTrimmingWhiteSpaceAndNewLines] uppercaseString];
    
    // Occasionally this notification is called after the view has been dismissed.  In
    // that case there's nothing to do.  This occurs because the code doesn't register
    // for the notification until the dealloc.  It will stems back to the fact that
    // this is a view class which shouldn't have all this controller code buried into it.
    // Hopefully this class will die a peaceful death in the Profile redesign.
    if (!self.window) {
        return;
    }
    
    if (![searchText isEqualToString:[currentSearchText stringByRemovingExtraWhiteSpace]])
    {
        // do nothing - the search text has changed since this process was initiated
    }
    
    else
    {
        // update the underlying data, and then the display
        self.results = [[notification userInfo] objectForKey:AIRPORT_SEARCH_RESULTS_NOTIFICATION_KEY];
        [self.searchResultsTableView.tableView reloadData];
        
        // toggle popover visibility depending on the result count
        if (self.results.count > 0 &&
            !self.searchResultsPopover.isPopoverVisible)
        {
            CGRect popoverRect = CGRectMake(airportSearchBar.frame.origin.x, airportSearchBar.frame.origin.y, airportSearchBar.frame.size.width, (airportSearchBar.frame.size.height - 9));
            [self.searchResultsPopover presentPopoverFromRect:popoverRect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else if (self.results.count == 0 &&
                 self.searchResultsPopover.isPopoverVisible)
        {
            [self.searchResultsPopover dismissPopoverAnimated:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
    NFDAirport *airport = [results objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat: @"%@ - %@ (%@)",airport.airport_name, airport.city_name, airport.airportid];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    hasSelectedAirport = YES;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.airportSearchBar.text = cell.textLabel.text;
    
    [self.searchResultsPopover dismissPopoverAnimated:YES];
    
    NFDAirport *airport = [results objectAtIndex:indexPath.row];
    selectedAirport = [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"Airport"
                                                                    predicateKey:@"airportid"
                                                                  predicateValue:airport.airportid
                                                                         context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                           error:nil];
    
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"madeAirportSelection" 
     object:self];
    //DLog(@"Selected Airport: %@",selectedAirport.airport_name);
    [airportSearchBar.inputView setUserInteractionEnabled:NO];
    [airportSearchBar resignFirstResponder];
}

-(void) setAirportFromId: (NSString *) airportid {
    
    //DLog(@"SETTING AIRPORT TO %@",airport.airportid);
    if(airportid != nil){
        [self setAirport:[service findAirportWithCode:airportid]];
    }else{
        [airportSearchBar.inputView setUserInteractionEnabled:YES];
    }
}

-(void) setAirport: (NFDAirport *) airport {
    
    //DLog(@"SETTING AIRPORT TO %@",airport.airportid);
    if(airport != nil){
        //NSString *acode  = [NSString stringWithFormat: @"%@",airport.airportid];
        selectedAirport = airport;
        self.airportSearchBar.text = [NSString stringWithFormat: @"%@ - %@ (%@)",airport.airport_name,airport.city_name,airport.airportid];
        hasSelectedAirport = YES;
        [airportSearchBar.inputView setUserInteractionEnabled:NO];
        [airportSearchBar resignFirstResponder];
    }else{
        [self clearSelectedAirport];
    }
}

- (void)clearSelectedAirport {
    selectedAirport = nil;
    airportSearchBar.text = @"";
    [airportSearchBar resignFirstResponder];
    hasSelectedAirport = NO;
}

- (void)dealloc
{
    results = nil;
    selectedAirport = nil;
    searchQueue = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AIRPORT_SEARCH_DID_COMPLETE_NOTIFICATION object:nil];
}

@end
