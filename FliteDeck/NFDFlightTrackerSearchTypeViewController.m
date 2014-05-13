//
//  NFDFlightTrackerTailSearchViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/19/13.
//
//

#import "NFDFlightTrackerSearchTypeViewController.h"

#import "NFDFlightTrackerDetailViewController.h"
#import "NFDFlightTrackerSearchResultsTableViewController.h"
#import "UIColor+FliteDeckColors.h"

@interface NFDFlightTrackerSearchTypeViewController ()
@property (weak, nonatomic) IBOutlet UIView *searchViewContainer;

@property (strong, nonatomic) NFDFlightTrackerSearchResultsTableViewController *searchResultsController;
@property (strong, nonatomic) NFDFlightTrackerDetailViewController *detailController;

@property (strong, nonatomic) UIPopoverController *searchPopover;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchResultsWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *detailViewContainer;

@end

@implementation NFDFlightTrackerSearchTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    _flightTrackerManager = [NFDFlightTrackerManager new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResultsWidthConstraint.constant = 0.0;
    
    self.detailViewContainer.backgroundColor = [UIColor mainBackgroundColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSearchStarted)
                                                 name:[self.flightTrackerManager searchingDidReceiveNewResultsNotificatioName]
                                               object:nil];    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.searchPopover) {
        [self.searchPopover dismissPopoverAnimated:NO];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[self.flightTrackerManager searchingDidReceiveNewResultsNotificatioName] object:nil];
}


- (void) showSearch: (UIBarButtonItem *) searchItem
{
    if (!self.searchPopover) {
        self.searchPopover = [[UIPopoverController alloc] initWithContentViewController:self.searchNavController];
    }
    
    if ([self.searchNavController.topViewController respondsToSelector:@selector(setPresentingPopoverController:)]) {
        [self.searchNavController.topViewController performSelector:@selector(setPresentingPopoverController:) withObject:self.searchPopover];
    }
    
    [self.searchPopover presentPopoverFromBarButtonItem:searchItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) handleSearchStarted
{
    [self.searchPopover dismissPopoverAnimated:YES];
    
    if (self.searchResultsWidthConstraint.constant == 0.0) {
        [UIView animateWithDuration:.75 animations:^{
            self.searchResultsWidthConstraint.constant = 320;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([@"embedSearchResults" isEqualToString:segue.identifier]) {
        self.searchResultsController = segue.destinationViewController;
        self.searchResultsController.flightTrackerManager = self.flightTrackerManager;
    } else if ([@"embedDetailView" isEqualToString:segue.identifier]) {
        UINavigationController *navController = segue.destinationViewController;
        self.detailController = (NFDFlightTrackerDetailViewController *)navController.topViewController;
        self.detailController.flightTrackerManager = self.flightTrackerManager;
        self.searchResultsController.detailViewController = self.detailController;
    }
}
@end
