//
//  NFDFliteTrackerViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/19/13.
//
//

#import "NFDFlightTrackerViewController.h"

#import "NFDFlightTrackerSearchTypeViewController.h"

#import "NFDFlightTrackerAccountSearchViewController.h"
#import "NFDFlightTrackerSVPSearchViewController.h"
#import "NFDFlightTrackerTailSearchViewController.h"
#import "NFDFlightTrackerAirportSearchViewController.h"
#import "NCLSegmentedControl.h"


@interface NFDFlightTrackerViewController ()

@property (strong, nonatomic) IBOutlet UIView *searchTypeContainer;

@property (nonatomic, strong) NCLSegmentedControl *searchTypesControl;

@property (nonatomic, strong) NFDFlightTrackerSearchTypeViewController *svpSearchTypeController;
@property (nonatomic, strong) NFDFlightTrackerSearchTypeViewController *airportSearchTypeController;
@property (nonatomic, strong) NFDFlightTrackerSearchTypeViewController *tailSearchTypeController;
@property (nonatomic, strong) NFDFlightTrackerSearchTypeViewController *accountSearchTypeController;


@property (nonatomic, strong) NFDFlightTrackerSearchTypeViewController *currentSearchTypeController;

@end

@implementation NFDFlightTrackerViewController

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
    
    self.searchTypesControl = [[NCLSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:SEARCH_TYPE_ACCOUNT, SEARCH_TYPE_AIRPORT, SEARCH_TYPE_SVP, SEARCH_TYPE_TAIL, nil]];
    self.searchTypesControl.enableSelectingCurrentSegment = YES;
    
    self.searchTypesControl.selectedSegmentIndex = 0;
    
    [self.searchTypesControl addTarget:self
                         action:@selector(searchTypeTapped)
               forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.searchTypesControl;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchTapped)];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.currentSearchTypeController) {
        [self setCurrentSearchTypeController: [self accountSearchTypeController]];
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.currentSearchTypeController.flightTrackerManager.hasRetrievedFlights) {
        [self searchTapped];
    }
}

- (NFDFlightTrackerSearchTypeViewController *)svpSearchTypeController
{
    if (!_svpSearchTypeController) {
        _svpSearchTypeController =  [self.storyboard instantiateViewControllerWithIdentifier:@"NFDFlightTrackerSearchTypeViewController"];
        _svpSearchTypeController.flightTrackerManager.flightsSearchType = NFDTrackerSearchTypeSVPSearch;
        
        _svpSearchTypeController.searchNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFDSVPSearchNavController"];

        NFDFlightTrackerSVPSearchViewController *searchController = (NFDFlightTrackerSVPSearchViewController *)_svpSearchTypeController.searchNavController.topViewController;
        searchController.title = @"SVP/AE Search";
        searchController.flightTrackerManager = _svpSearchTypeController.flightTrackerManager;
    }
    
    return _svpSearchTypeController;
}

- (NFDFlightTrackerSearchTypeViewController *)airportSearchTypeController
{
    if (!_airportSearchTypeController) {
        _airportSearchTypeController =  [self.storyboard instantiateViewControllerWithIdentifier:@"NFDFlightTrackerSearchTypeViewController"];
        _airportSearchTypeController.flightTrackerManager.flightsSearchType = NFDTrackerSearchTypeAirportSearch;
        
        _airportSearchTypeController.searchNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFDAirportSearchNavController"];
        _airportSearchTypeController.searchNavController.topViewController.title=@"Airport Search";

        NFDFlightTrackerAirportSearchViewController *searchController = (NFDFlightTrackerAirportSearchViewController *)_airportSearchTypeController.searchNavController.topViewController;
        searchController.flightTrackerManager = _airportSearchTypeController.flightTrackerManager;
    }
    
    return _airportSearchTypeController;
}

- (NFDFlightTrackerSearchTypeViewController *)tailSearchTypeController
{
    if (!_tailSearchTypeController) {
        _tailSearchTypeController =  [self.storyboard instantiateViewControllerWithIdentifier:@"NFDFlightTrackerSearchTypeViewController"];
        _tailSearchTypeController.flightTrackerManager.flightsSearchType = NFDTrackerSearchTypeTailSearch;
        
        _tailSearchTypeController.searchNavController = [self.storyboard  instantiateViewControllerWithIdentifier:@"NFDTailSearchNavController"];
        _tailSearchTypeController.searchNavController.topViewController.title=@"Tail Search";
        
        NFDFlightTrackerTailSearchViewController *searchController = (NFDFlightTrackerTailSearchViewController *)_tailSearchTypeController.searchNavController.topViewController;
        searchController.flightTrackerManager = _tailSearchTypeController.flightTrackerManager;
        
        
    }
    
    return _tailSearchTypeController;
}

- (NFDFlightTrackerSearchTypeViewController *)accountSearchTypeController
{
    if (!_accountSearchTypeController) {
        _accountSearchTypeController =  [self.storyboard instantiateViewControllerWithIdentifier:@"NFDFlightTrackerSearchTypeViewController"];
        _accountSearchTypeController.flightTrackerManager.flightsSearchType = NFDTrackerSearchTypeAccountSearch;
        
        _accountSearchTypeController.searchNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFDAccountSearchNavController"];
        _accountSearchTypeController.searchNavController.topViewController.title=@"Account Search";

        
        NFDFlightTrackerAccountSearchViewController *searchController = (NFDFlightTrackerAccountSearchViewController *)_accountSearchTypeController.searchNavController.topViewController;
        searchController.flightTrackerManager = _accountSearchTypeController.flightTrackerManager;
    }
    
    return _accountSearchTypeController;
}


-(void) searchTypeTapped
{

    NSString *searchType = [self.searchTypesControl titleForSegmentAtIndex:self.searchTypesControl.selectedSegmentIndex];
    
    self.currentSearchTypeController = [self searchTypeControllerForName:searchType];
    
    [self searchTapped];
}

- (NFDFlightTrackerSearchTypeViewController *) searchTypeControllerForName: (NSString *) name
{
    NFDFlightTrackerSearchTypeViewController *controller;
    
    if ([SEARCH_TYPE_SVP isEqualToString: name]) {
        controller = self.svpSearchTypeController;
    } else if ([SEARCH_TYPE_AIRPORT isEqualToString: name]) {
        controller = self.airportSearchTypeController;
    } else if ([SEARCH_TYPE_TAIL isEqualToString: name]) {
        controller = self.tailSearchTypeController;
    } else if ([SEARCH_TYPE_ACCOUNT isEqualToString: name]) {
        controller = self.accountSearchTypeController;
    } else {
        DLog(@"Unknown search type: %@", name);
        controller = self.accountSearchTypeController;
    }

    return controller;
}


- (void)setCurrentSearchTypeController:(NFDFlightTrackerSearchTypeViewController *)newSearchTypeController
{
    
    if (!_currentSearchTypeController) {
        _currentSearchTypeController = newSearchTypeController;
        [self addChildViewController:_currentSearchTypeController];
        _currentSearchTypeController.view.frame = CGRectMake(0, 0, self.searchTypeContainer.frame.size.width, self.searchTypeContainer.frame.size.height);
        [self.searchTypeContainer addSubview:_currentSearchTypeController.view];
        [_currentSearchTypeController didMoveToParentViewController:self];
    } else {
        
        // Remove the current search type controller
        [_currentSearchTypeController willMoveToParentViewController:nil];
        [_currentSearchTypeController removeFromParentViewController];
        [_currentSearchTypeController.view removeFromSuperview];
        
        _currentSearchTypeController = newSearchTypeController;
        [self addChildViewController:_currentSearchTypeController];
        _currentSearchTypeController.view.frame = CGRectMake(0, 0, self.searchTypeContainer.frame.size.width, self.searchTypeContainer.frame.size.height);
        [self.searchTypeContainer addSubview:_currentSearchTypeController.view];
        [_currentSearchTypeController didMoveToParentViewController:self];
        
    }
}


-(void) searchTapped
{
    [self.currentSearchTypeController showSearch:self.navigationItem.rightBarButtonItem];
}

@end
