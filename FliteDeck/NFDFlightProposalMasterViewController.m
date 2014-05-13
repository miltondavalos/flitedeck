//
//  NFDFlightProposalMasterViewController.m
//  SplitViewTest
//
//  Created by Geoffrey Goetz on 2/1/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalMasterViewController.h"
#import "NFDFlightProposalTableViewCell.h"
#import "NFDFlightProposalManager.h"
#import "NFDProposal.h"
#import "UIColor+FliteDeckColors.h"

#define CELL_IDENTIFIER_PRODUCT @"NFDFlightProposalTableViewCell"
#define CELL_IDENTIFIER_NO_RESULTS @"NFDFlightProposalNoResultsTableViewCell"

@interface NFDFlightProposalMasterViewController ()
{
    BOOL viewIsVisible;
}
@end

@implementation NFDFlightProposalMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize masterTableView = _masterTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Proposals", @"Proposals");
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        viewIsVisible = NO;
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

    [[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Clear"
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(clearButtonAction:)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Add"
                                            style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(addButtonAction:)];
    
    [self.navigationItem setLeftBarButtonItem:clearButton];
    [self.navigationItem setRightBarButtonItem:addButton];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINib *productCellNib = [UINib nibWithNibName:@"NFDFlightProposalTableViewCell" bundle:nil];
    [self.masterTableView registerNib:productCellNib forCellReuseIdentifier:CELL_IDENTIFIER_PRODUCT];
    
    UINib *noResultsCellNib = [UINib nibWithNibName:@"NFDFlightProposalNoResultsTableViewCell" bundle:nil];
    [self.masterTableView registerNib:noResultsCellNib forCellReuseIdentifier:CELL_IDENTIFIER_NO_RESULTS];
    
    self.masterTableView.backgroundColor = [UIColor tableViewBackgroundColor];
    self.masterTableView.separatorColor = [UIColor dividerLineColor];
    self.masterTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.cancelsTouchesInView = NO;
    
    [self.masterTableView addGestureRecognizer:doubleTapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!viewIsVisible) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateProposalParameterData)
                                                     name:PROPOSAL_LIST_UPDATED
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateSelectedRow)
                                                     name:PROPOSAL_SUBTITLE_UPDATED
                                                   object:nil];
        
        NSIndexPath *selectedIndexPath = [self.masterTableView indexPathForSelectedRow];
        
        if (selectedIndexPath) {
            NFDFlightProposalTableViewCell *cell = (NFDFlightProposalTableViewCell *)[self.masterTableView cellForRowAtIndexPath:selectedIndexPath];
            [cell selectProposal];
        }
        viewIsVisible = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PROPOSAL_SUBTITLE_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PROPOSAL_LIST_UPDATED object:nil];
    
    viewIsVisible = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setMasterTableView:nil];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.masterTableView.separatorColor = [UIColor dividerLineColor];
}

#pragma mark - Manager, Proposal, Results Methods

- (void)updateProposalParameterData
{
//    NSUInteger numberOfProposals = [[NFDFlightProposalManager.sharedInstance proposals] count];
//    NSInteger numberOfRowsInTable = [self.masterTableView numberOfRowsInSection:0];
//    
//    if (numberOfProposals != numberOfRowsInTable) {
//        [self.masterTableView reloadData];
//    }
//    
//    int maxProposal = ( [[NFDFlightProposalManager.sharedInstance proposals] count] -1 );
//    
//    if (maxProposal > -1)
//    {
//        NSIndexPath *newProposalIndexPath = [NSIndexPath indexPathForRow:maxProposal inSection:0];
//        [self.masterTableView selectRowAtIndexPath:newProposalIndexPath animated:NO scrollPosition:0];
//        [self.detailViewController.view setTag:maxProposal];
//        [self.detailViewController updateProposalParameterData];
//    }
//    else
//    {
//        [self.detailViewController.view setTag:-1];
//        [self.detailViewController updateProposalParameterData];
//    }

    
    int maxProposal = ( [[NFDFlightProposalManager.sharedInstance proposals] count] -1 );
    
    if (maxProposal > -1)
    {
        
        [self.detailViewController.view setTag:maxProposal];
        [self.detailViewController updateProposalParameterData];
    }
    else
    {
        [self.detailViewController.view setTag:-1];
        [self.detailViewController updateProposalParameterData];
    }
}

- (void)updateSelectedRow
{
    NSUInteger numberOfProposals = [[NFDFlightProposalManager.sharedInstance proposals] count];
    NSInteger numberOfRowsInTable = [self.masterTableView numberOfRowsInSection:0];
    
    if (numberOfProposals != numberOfRowsInTable || numberOfProposals == 1) {
        [self.masterTableView reloadData];
        int maxProposal = ( [[NFDFlightProposalManager.sharedInstance proposals] count] -1 );
        NSIndexPath *newProposalIndexPath = [NSIndexPath indexPathForRow:maxProposal inSection:0];
        
        [self.masterTableView selectRowAtIndexPath:newProposalIndexPath animated:NO scrollPosition:0];
    }
    
    NSIndexPath *selectedIndexPath = [self.masterTableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.masterTableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.masterTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint tapLocation = [gestureRecognizer locationInView:self.masterTableView];
    NSIndexPath *tappedIndexPath = [self.masterTableView indexPathForRowAtPoint:tapLocation];
    NFDFlightProposalTableViewCell *tappedCell = (NFDFlightProposalTableViewCell *)[self.masterTableView cellForRowAtIndexPath:tappedIndexPath];
    
    [tappedCell toggleChecked];
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    if (manager.totalCountOfProposals == 0) {
        return 1;
    } else {
        return manager.totalCountOfProposals;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NFDFlightProposalTableViewCell *cell;
    
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    NFDProposal *proposal;
    if ([manager hasProposals]){
        cell = (NFDFlightProposalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_PRODUCT forIndexPath:indexPath];
        proposal = [manager retrieveProposalAtIndex:indexPath.row];
        [cell setTag:indexPath.row];
        [cell setDetailViewController:self.detailViewController];
        [cell updateProposalParameterData];
    } else {
        cell = (NFDFlightProposalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_NO_RESULTS forIndexPath:indexPath];
        [cell updateProposalParameterData];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectProposalForRowAtIndexPath:indexPath];
}

- (void)selectProposalForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFDFlightProposalTableViewCell *cell = (NFDFlightProposalTableViewCell *)[self.masterTableView cellForRowAtIndexPath:indexPath];
    
    [cell selectProposal];
}

#pragma mark - Toolbar Button Action Methods

- (IBAction)addButtonAction:(id)sender 
{
    [self.detailViewController displayProductsModalView];
}

- (IBAction)clearButtonAction:(id)sender
{
    [NFDFlightProposalManager.sharedInstance clearAllProposals];
    [self.detailViewController updateProposalParameterData];
    [self.masterTableView reloadData];
}

@end
