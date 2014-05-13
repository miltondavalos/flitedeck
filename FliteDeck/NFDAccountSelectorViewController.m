//
//  NFDAccountSelectorViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 12/4/13.
//
//

#import "NFDAccountSelectorViewController.h"

#import "NDFAccount.h"
#import "NFDPersistenceManager.h"

#define TRACKER_RECENT_ACCOUNT_SEARCHES_KEY @"TrackerRecentAccountSearches"
#define MAX_RECENT_SEARCHES 20

@interface NFDAccountSelectorViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *recentAccountSearchIdArray;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptor;

@end

@implementation NFDAccountSelectorViewController

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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSArray *recentSearchs = [userDefaults arrayForKey:TRACKER_RECENT_ACCOUNT_SEARCHES_KEY];
    
    self.recentAccountSearchIdArray = [NSMutableArray arrayWithArray:recentSearchs];
}

- (NSFetchedResultsController *) fetchedResultsController
{
    if (!_fetchedResultsController) {
        
        NFDPersistenceManager *pm = [NFDPersistenceManager sharedInstance];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[NDFAccount entityName] inManagedObjectContext:[pm mainMOC]];
        [fetchRequest setEntity:entity];
        
        self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"account_name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:self.sortDescriptor]];
        [fetchRequest setFetchBatchSize:20];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                        managedObjectContext:[pm mainMOC] sectionNameKeyPath:nil cacheName:nil];
        
        [self updatePredicate:nil];
    }
    
    return _fetchedResultsController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performFetch];
    
    [self.searchBar becomeFirstResponder];
}


- (void)addAccountToRecents
{
    if (self.selectedAccount) {
        [self.recentAccountSearchIdArray removeObject:self.selectedAccount.account_id];
        [self.recentAccountSearchIdArray insertObject:self.selectedAccount.account_id atIndex:0];
        if ([self.recentAccountSearchIdArray count] > MAX_RECENT_SEARCHES) {
            [self.recentAccountSearchIdArray removeObjectAtIndex:MAX_RECENT_SEARCHES];
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *recentsArray = [NSArray arrayWithArray:self.recentAccountSearchIdArray];
        [userDefaults setObject:recentsArray forKey:TRACKER_RECENT_ACCOUNT_SEARCHES_KEY];
        [userDefaults synchronize];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"accountSelectedUnwind" isEqualToString:segue.identifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        self.selectedAccount = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [self addAccountToRecents];
    }
}

- (void)updatePredicate:(NSString *)searchText
{
    NSPredicate *predicate = nil;
    
    if (searchText && ![searchText isEmptyOrWhitespace]) {
        predicate = [NSPredicate predicateWithFormat:@"account_name CONTAINS[cd] %@", searchText];
        [_fetchedResultsController.fetchRequest setSortDescriptors:[NSArray arrayWithObject:self.sortDescriptor]];

    } else {
        predicate = [NSPredicate predicateWithFormat:@"account_id IN %@", self.recentAccountSearchIdArray];
        _fetchedResultsController.fetchRequest.sortDescriptors = nil;
    }
    
    _fetchedResultsController.fetchRequest.predicate = predicate;
}

- (void) modifySearch:(NSString *) searchText
{
    [self updatePredicate:searchText];
    
    [self performFetch];
}

- (void) performFetch {
    NSError *error;
    
    self.fetchedResultsController.delegate = self;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NCLErrorPresenter presentText:@"Error retrieving Account Names"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfObjects = 0;
    
    // Return the number of rows in the section.
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    numberOfObjects =[sectionInfo numberOfObjects];
    
    return numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountSearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NDFAccount *account = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell forAccount:account];
    
    return cell;
}

- (void) configureCell: (UITableViewCell *) cell forAccount: (NDFAccount *) account
{
    cell.textLabel.text = account.account_name;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchBar.text.length < 1) {
        NSUInteger numberOfRecentSearches = self.recentAccountSearchIdArray.count;
        
        return [NSString stringWithFormat:@"Recent Searches (%i)", numberOfRecentSearches];
    }
    
    return nil;
}

#pragma mark - NSFetchedResultsController
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	//Only needed if changing the order or rows
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	
	UITableView *tableView = self.tableView;
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
            
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
			
		case NSFetchedResultsChangeUpdate:
        {
            [self changeUpdateAtIndexPath: indexPath newIndexPath: newIndexPath];
			break;
        }
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
	}
}

-(void)changeUpdateAtIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath
{
    NDFAccount *account = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forAccount:account];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}

#pragma mark - SearchBar delegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self modifySearch:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self modifySearch:nil];
}



@end
