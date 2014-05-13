//
//  NFDFlightProposalDetailViewController.m
//  SplitViewTest
//
//  Created by Geoffrey Goetz on 2/1/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalDetailViewController.h"
#import "NFDFlightProposalCompareViewController.h"
#import "NFDFlightProposalProductsModalController.h"
#import "NFDFlightProposalInventoryModalController.h"
#import "NFDFlightProposalShareProductView.h"
#import "NFDFlightProposalCardProductView.h"
#import "NFDFlightProposalPhenomTransitionProductView.h"
#import "NFDNetJetsRemoteService.h"
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    kCompare = 0,
    kAggregate,
} kCompareType;

@interface NFDFlightProposalDetailViewController ()
{
    BOOL viewIsVisible;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
- (void)updateNavigationBarButtons;

@end

@implementation NFDFlightProposalDetailViewController

@synthesize masterPopoverController = _masterPopoverController;
@synthesize modalController;
@synthesize compareButton = _compareButton;
@synthesize aggregateButton = _aggregateButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
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
    [self configureView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProposalResultData)
                                                 name:PROPOSAL_RESULTS_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProposalParameterFields)
                                                 name:PROPOSAL_PARAMETERS_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNavigationBarButtons)
                                                 name:PROPOSAL_LIST_UPDATED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNavigationBarButtons)
                                                 name:PROPOSAL_SELECTION_UPDATED
                                               object:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!viewIsVisible)  // viewDidAppear is firing twice... ???
    {
        viewIsVisible = YES;
        [[NFDNetJetsRemoteService sharedInstance] displayRequiredSetupWarning:self];
        
        if (![NFDFlightProposalManager.sharedInstance hasProposals]){
            [self displayProductsModalView];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    viewIsVisible = NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (productView && [productView respondsToSelector:@selector(dismissPopover)]) {
        [productView performSelector:@selector(dismissPopover) withObject:nil];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ( (productView) && ([productView conformsToProtocol:@protocol(NFDFlightProposalDetailViewControllerOrientationDelegate)]) )
    {
        UIView <NFDFlightProposalDetailViewControllerOrientationDelegate> *rotatableView = (UIView <NFDFlightProposalDetailViewControllerOrientationDelegate> *) productView;
        [rotatableView interfaceDidChangeOrientation];
        
        [self updateProposalParameterData];
    }
}

- (void)configureView
{
    self.title = NSLocalizedString(@"Proposal Calculator", @"Proposal Calculator");
    
    //Create Navigation Bar Buttons
    self.compareButton = [[UIBarButtonItem alloc] 
                            initWithTitle:@"Review"  // <- "Compare", when number of proposals > 1                                        
                            style:UIBarButtonItemStyleBordered 
                            target:self 
                            action:@selector(displayCompareView:)];

    self.aggregateButton = [[UIBarButtonItem alloc] 
                            initWithTitle:@"Aggregate"                                            
                            style:UIBarButtonItemStyleBordered 
                            target:self 
                            action:@selector(displayCompareView:)];
    
    [self.compareButton setTag:kCompare];
    [self.aggregateButton setTag:kAggregate];
    
    [self.compareButton setEnabled:NO];
    [self.aggregateButton setEnabled:NO];
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    [buttons addObject:self.compareButton];   
    [buttons addObject:self.aggregateButton];
    
    [[self navigationItem] setRightBarButtonItems:buttons];
    [[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlack];

    [self updateNavigationBarButtons];
}

- (void)updateNavigationBarButtons
{
    NSArray *proposals = [[NFDFlightProposalManager sharedInstance] retrieveAllSelectedProposals];
    if (proposals.count > 0)
    {
        if (proposals.count == 1)
        {
            [self.aggregateButton setEnabled:NO];
            [self.compareButton setEnabled:YES];
            [self.compareButton setTitle:@"Review"];
        }
        else if (proposals.count == 2)
        {
            BOOL hasPhenom = NO;
            for (NFDProposal *proposal in proposals)
            {
                if (proposal.productType.intValue == PHENOM_TRANSITION_PRODUCT_TYPE)
                {
                    hasPhenom = YES;
                }
            }
            if (hasPhenom)
            {
                [self.aggregateButton setEnabled:NO];
                [self.compareButton setEnabled:YES];
                [self.compareButton setTitle:@"Review"];
            }
            else
            {
                [self.compareButton setEnabled:YES];
                [self.aggregateButton setEnabled:YES];
                [self.compareButton setTitle:@"Propose"];
            }
        }
        else 
        {
            [self.compareButton setEnabled:YES];
            [self.aggregateButton setEnabled:YES];
            [self.compareButton setTitle:@"Propose"];
        }
    }
    else 
    {
        [self.compareButton setEnabled:NO];
        [self.aggregateButton setEnabled:NO];
        [self.compareButton setTitle:@"Review"];
    }
    
    if ([NFDFlightProposalManager.sharedInstance canDispalyCompareView])
    {
        self.aggregateButton.enabled = YES;
        self.compareButton.enabled = YES;
    }
    else
    {
        self.aggregateButton.enabled = NO;
        self.compareButton.enabled = NO;
    }
}

#pragma mark - Manager, Proposal, Results Methods

- (NFDProposal *)retrieveProposalForThisView
{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    return [manager retrieveProposalAtIndex:self.view.tag];
}

- (void)updateProposalParameterData
{
    self.title = NSLocalizedString(@"Proposal Calculator", @"Proposal Calculator");

    //Retrieve proposal for currently selected detail view 
    NFDProposal *proposal = [self retrieveProposalForThisView];
    UIViewController *viewController;
    productView = nil;

    //Check for proposal, switch to respective view
    if (proposal){
        switch ([proposal.productType intValue]) {
            case SHARE_PRODUCT_TYPE:{
                viewController = [[UIViewController alloc] initWithNibName:@"NFDFlightProposalShareProductView" bundle:nil];
                NFDFlightProposalShareProductView *shareFinanceProductView = (NFDFlightProposalShareProductView *)viewController.view;
                [shareFinanceProductView setDetailViewController:self];
                [shareFinanceProductView setTag:self.view.tag];
                [shareFinanceProductView configureView];
                [shareFinanceProductView updateProposalParameterData];
                [shareFinanceProductView updateProposalResultData];
                productView = shareFinanceProductView;
                break;
            }
            case CARD_PRODUCT_TYPE:{
                viewController = [[UIViewController alloc] initWithNibName:@"NFDFlightProposalCardProductView" bundle:nil];
                NFDFlightProposalCardProductView *cardProductView = (NFDFlightProposalCardProductView *)viewController.view;
                [cardProductView setDetailViewController:self];
                [cardProductView setTag:self.view.tag];
                [cardProductView configureView];
                [cardProductView updateProposalParameterData];
                [cardProductView updateProposalResultData];
                productView = cardProductView;
                self.title = NSLocalizedString(proposal.title, proposal.title);
                break;
            }
            case PHENOM_TRANSITION_PRODUCT_TYPE:{
                viewController = [[UIViewController alloc] initWithNibName:@"NFDFlightProposalPhenomTransitionProductView" bundle:nil];
                NFDFlightProposalPhenomTransitionProductView *phenomTransitionProductView = (NFDFlightProposalPhenomTransitionProductView *)viewController.view;
                [phenomTransitionProductView setDetailViewController:self];
                [phenomTransitionProductView setTag:self.view.tag];
                [phenomTransitionProductView configureView];
                [phenomTransitionProductView updateProposalParameterData];
                [phenomTransitionProductView updateProposalResultData];
                productView = phenomTransitionProductView;
                self.title = NSLocalizedString(proposal.title, proposal.title);
                break;
            }
            default:{
                break;
            }
        }
    }
    
    //Clear all views from detail view
    for (UIView *subView in [self.productScrollView subviews]) {
        [subView removeFromSuperview];
    }

    //Add product view to detail view
    if (productView){
        //NOTE: Do not dismiss the popover so double tapping works in portrait
        //if (self.masterPopoverController != nil) {
        //    [self.masterPopoverController dismissPopoverAnimated:YES];
        //}
        [productView setTag:self.view.tag];
        self.productScrollView.contentSize = productView.frame.size;
        [self.productScrollView addSubview:productView];
    }
    
}

- (void)updateProposalParameterFields
{
    if ( (productView) && ([productView conformsToProtocol:@protocol(NFDProposalParameterUpdater)]) )
    {
        UIView <NFDProposalParameterUpdater> *updatableView = (UIView <NFDProposalParameterUpdater> *) productView;
        [updatableView updateProposalParameterData];
    }
    [self updateNavigationBarButtons];
}

- (void)updateProposalResultData
{
    if ( (productView) && ([productView conformsToProtocol:@protocol(NFDProposalResultUpdater)]) )
    {
        UIView <NFDProposalResultUpdater> *updatableView = (UIView <NFDProposalResultUpdater> *) productView;
        [updatableView updateProposalResultData];
    }
    
    [self updateNavigationBarButtons];
}

#pragma mark - Launch Modal Dispay Views

- (void)displayProductsModalView
{
    //TODO: Figure out why modal view is not going away...
    //    if (!modalController){
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
    NFDFlightProposalProductsModalController *modalViewController = [[NFDFlightProposalProductsModalController alloc] initWithNibName:@"NFDFlightProposalProductsModalController" bundle:nil];
    [modalViewController setTitle:NSLocalizedString(@"Products", @"Products")];
    //[modalViewController.view setBackgroundColor:[UIColor whiteColor]];
    [modalViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalView)]];
    modalController = [[UINavigationController alloc] initWithRootViewController:modalViewController];
    modalController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // TODO IOS7 - Had to change the transition styl to CrossDissolve to position the modal correctly
    modalController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    NFDAppDelegate *appDelegate = (NFDAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.navigationController presentViewController:modalController animated:YES completion:nil];
    
    modalController.view.superview.bounds = CGRectMake(0, 0, 700, 320);
    //    }
}

- (void)displayInventoryModalView
{
    //TODO: Figure out why modal view is not going away...
    //    if (!modalController){
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
    NFDFlightProposalInventoryModalController *modalViewController = [[NFDFlightProposalInventoryModalController alloc] initWithNibName:@"NFDFlightProposalInventoryModalController" bundle:nil];
    [modalViewController setTitle:NSLocalizedString(@"Inventory", @"Inventory")];
    [modalViewController.view setBackgroundColor:[UIColor whiteColor]];
    [modalViewController.view setTag:self.view.tag];
    [modalViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalView)]];
    modalController = [[UINavigationController alloc] initWithRootViewController:modalViewController];
    modalController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // TODO IOS7 - Had to change the transition styl to CrossDissolve to position the modal correctly
    modalController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    NFDAppDelegate *appDelegate = (NFDAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.navigationController presentViewController:modalController animated:YES completion:nil];
    
    modalController.view.superview.bounds = CGRectMake(0, 0, 700, 550);
    //    }
}

- (void)dismissModalView
{
    NFDAppDelegate *appDelegate = (NFDAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    //TODO: Figure out why modal view is not going away...
    [super dismissModalViewControllerAnimated:animated];
    [self setModalController:nil];
}

#pragma mark - Navigation Bar Button Actions

- (void)displayCompareView:(id)sender
{
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    if ([NFDFlightProposalManager.sharedInstance canDispalyCompareView])
    {
        NFDFlightProposalCompareViewController *compareViewController = [[NFDFlightProposalCompareViewController alloc] init];
        if ([(UIBarButtonItem *)sender tag] == kCompare)
        {
            [compareViewController setTitle:NSLocalizedString(@"Proposal", @"Proposal")];
            [compareViewController setAggregate:NO];
            [[NFDFlightProposalManager sharedInstance] setAggregated:NO];
        }
        else {
            [compareViewController setTitle:NSLocalizedString(@"Summary", @"Summary")];
            [compareViewController setAggregate:YES];
            [[NFDFlightProposalManager sharedInstance] setAggregated:YES];
        }
        [compareViewController.view setBackgroundColor:[UIColor whiteColor]];
        NFDAppDelegate *appDelegate = (NFDAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.navigationController pushViewController:compareViewController animated:YES];
    }
}

- (void)popBack{
    NFDAppDelegate *appDelegate = (NFDAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController popViewControllerAnimated:YES];
    [appDelegate.navigationController setNavigationBarHidden:YES animated:NO];
    [self.masterPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Proposals", @"Proposals");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
