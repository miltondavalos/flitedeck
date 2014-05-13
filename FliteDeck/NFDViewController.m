//
//  NFDViewController.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDViewController.h"
#import "NFDLaunchPadPage.h"
#import "MGSplitViewController.h"
#import "NFDFlightTrackingMasterViewController.h"
#import "NFDFlightTrackingDetailViewController.h"
#import "NFDFlightProposalMasterViewController.h"
#import "NFDFlightProposalDetailViewController.h"
#import "NFDEventsMasterViewController.h"
#import "NFDEventsDetailViewController.h"
#import "NFDFlightProfileAircraftSelectionViewController.h"
#import "NFDNeedsAnalysisViewController.h"
#import "NFDAirportLocatorWithMapViewController.h"
#import "NFDPositioningViewController.h"
#import "NFDAppDelegate.h"
#import "Prospect.h"
#import "NFDUserSettingsMainViewController.h"
#import "UIView+FrameUtilities.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDUserManager.h"
#import "NFDNetJetsRemoteService.h"
#import "NFDLaunchPadButton.h"

@interface NFDViewController ()

@property (strong, nonatomic) NFDLaunchPadButton *proposalLaunchButton;
@property (strong, nonatomic) NFDLaunchPadButton *aimLaunchButton;

@property (nonatomic) NFDCompanySetting companySetting;

@end

@implementation NFDViewController

@synthesize aircraftImage;
@synthesize launchView;
@synthesize userSettingsButton = _userSettingsButton;
@synthesize popover = _popover;
@synthesize cloudView = _cloudView;

NFDLaunchPadPage *page;
UIImageView *backgroundImage;
int imageCount;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Turn off the gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    page = [[NFDLaunchPadPage alloc] initWithFrame:self.view.frame];
    [page setExclusiveTouch:NO];

    [page addLauncher:@"PROFILE" imageName:@"Landing_tile_profile.png" notificationToFire:@"LAUNCH_FLIGHT_PROFILE"];  
    [self registerForNotification: @"LAUNCH_FLIGHT_PROFILE" selector:@selector(launchFlightProfile)];
    
    [page addLauncher:@"TRACKING" imageName:@"Landing_tile_tracking.png" notificationToFire:@"LAUNCH_FLIGHT_TRACKER"];
    [self registerForNotification: @"LAUNCH_FLIGHT_TRACKER" selector:@selector(launchFlightTracker)];
    
    [page addLauncher:@"EVENTS" imageName:@"Landing_tile_event.png" notificationToFire:@"LAUNCH_EVENTS"]; 
    [self registerForNotification: @"LAUNCH_EVENTS" selector:@selector(launchEvents)];
    
    self.proposalLaunchButton = [page addLauncher:@"PROPOSAL" imageName:@"Landing_tile_proposal.png" notificationToFire:@"LAUNCH_FLIGHT_PROPOSAL"];
    [self registerForNotification: @"LAUNCH_FLIGHT_PROPOSAL" selector:@selector(launchFlightProposal)];      
    
    self.aimLaunchButton = [page addLauncher:@"AIM" imageName:@"Landing_tile_positioning.png" notificationToFire:@"LAUNCH_POSITIONING"];
    [self registerForNotification: @"LAUNCH_POSITIONING" selector:@selector(launchAIM)];
    
    [page addLauncher:@"AIRPORTS" imageName:@"Landing_tile_airport.png" notificationToFire:@"LAUNCH_MAP"]; 
    [self registerForNotification: @"LAUNCH_MAP" selector:@selector(launchAirport)];
    
//    [page addLauncher:@"OLD TRACKING" imageName:@"Landing_tile_tracking.png" notificationToFire:@"LAUNCH_OLD_FLIGHT_TRACKER"];
//    [self registerForNotification: @"LAUNCH_OLD_FLIGHT_TRACKER" selector:@selector(launchFlightTracking)];


    [self customizeViewForCompany];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:page];
       
    [self.view addSubview:self.userSettingsButton];
    [self.view bringSubviewToFront:self.userSettingsButton];
    [self.userSettingsButton setUserInteractionEnabled:YES];
    
    UIImage *cloudImage = [UIImage imageNamed:@"CloudPattern.png"];
    
    self.cloudView = [[UIImageView alloc] initWithImage:cloudImage];
    
    [self.cloudView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.cloudView setFrame:CGRectMake(0, 0, 2400, 1200)];   
    
    [self.launchView addSubview:self.cloudView];
    [self.launchView sendSubviewToBack:self.cloudView];
    [aircraftImage setCenter:CGPointMake(1500, 400)];
    [self.launchView bringSubviewToFront:aircraftImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChange) name:NFD_USER_MANAGER_USER_INFO_DID_CHANGE_NOTIFICATION object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFD_USER_MANAGER_USER_INFO_DID_CHANGE_NOTIFICATION object:nil];
}

- (void) customizeViewForCompany
{
    self.companySetting = [[NFDUserManager sharedManager] companySetting];
    if (self.companySetting == NFDCompanySettingNJE) {
        self.proposalLaunchButton.hidden = YES;
        self.aimLaunchButton.hidden = YES;
    } else {
        self.proposalLaunchButton.hidden = NO;
        self.aimLaunchButton.hidden = NO;
    }
    // nil out profile controller so correct jets will be show when they re-open it.
    self.flightProfileViewController = nil;
    
    [page doLayout];

}

- (void) handleUserInfoChange
{
    if (self.companySetting != [[NFDUserManager sharedManager] companySetting])
    {
        [UIView animateWithDuration:0.33 animations:^{
            [self customizeViewForCompany];
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)cycleBackgroundImages
{
    [UIView animateWithDuration:120 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
    {
        [self.cloudView offsetViewHorizontally:-1200];
    } 
    completion:^ (BOOL finished) 
    {
        if (finished)
        {
            [self.cloudView offsetViewHorizontally:1200];
            [self cycleBackgroundImages];
        }
    }];
}

- (void)moveAircraftImage
{    
    [UIView animateWithDuration:8 delay:9 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        [aircraftImage offsetViewByAmount:CGPointMake(-1800, -200)];
    }
    completion:^ (BOOL finished) 
    {
        if (finished)
        {
            int y = ( arc4random() % 700 ) + 100;
            [aircraftImage moveViewOriginToPoint:CGPointMake(1500, y)];
            [self moveAircraftImage];
        }
    }];
}

-(void) registerForNotification: (NSString *) notificationName selector:(SEL) aSelector
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:aSelector
                                                 name:notificationName
                                               object:nil];
}

-(void) launchFlightProfile
{
    if (!self.flightProfileViewController) {
        self.flightProfileViewController = [[NFDFlightProfileAircraftSelectionViewController alloc] initWithNibName:@"NFDFlightProfileAircraftSelectionViewController" bundle:nil];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:self.flightProfileViewController animated:YES];
}

-(void) launchFlightProposal
{
    if ([self checkForNecessaryDataForSection:@"Proposal"] && !self.proposalSplitViewController)
    {
        self.proposalSplitViewController = [[MGSplitViewController alloc] init];
        self.proposalSplitViewController.edgesForExtendedLayout=UIRectEdgeNone;
        NFDFlightProposalMasterViewController *masterViewController = [[NFDFlightProposalMasterViewController alloc] initWithNibName:@"NFDFlightProposalMasterViewController" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        NFDFlightProposalDetailViewController *detailViewController = [[NFDFlightProposalDetailViewController alloc] initWithNibName:@"NFDFlightProposalDetailViewController" bundle:nil];
        [masterViewController setDetailViewController:detailViewController];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        [self.proposalSplitViewController setDelegate:detailViewController];
        [self.proposalSplitViewController setViewControllers:[NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil]];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:self.proposalSplitViewController animated:YES];
}

-(void) launchAirport
{
    NFDAirportLocatorWithMapViewController *mapSelector = [[NFDAirportLocatorWithMapViewController alloc] init];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:mapSelector animated:YES];
}

-(void) launchFlightTracking
{
    if (!self.trackingSplitViewController) {
        self.trackingSplitViewController = [[MGSplitViewController alloc] init];
        self.trackingSplitViewController.edgesForExtendedLayout=UIRectEdgeNone;
        NFDFlightTrackingMasterViewController *masterViewController = [[NFDFlightTrackingMasterViewController alloc] initWithNibName:@"NFDFlightTrackingMasterViewController" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        NFDFlightTrackingDetailViewController *detailViewController = [[NFDFlightTrackingDetailViewController alloc] initWithNibName:@"NFDFlightTrackingDetailViewController" bundle:nil];
        [masterViewController setDetailViewController:detailViewController];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        [self.trackingSplitViewController setDelegate:detailViewController];
        [self.trackingSplitViewController setViewControllers:[NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil]];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:self.trackingSplitViewController animated:YES];
}

-(void) launchFlightTracker
{
    BOOL shouldDisplayLoginPrompt = NO;
    NSString *user = [[NFDUserManager sharedManager] username];
    
    if (user == nil ||
        user.length <= 0)
    {
        shouldDisplayLoginPrompt = YES;
    }
    else
    {
        NSString *password = [NCLKeychainStorage userPasswordForUser:user host:[NFDNetJetsRemoteService sharedInstance].host].password;
        
        if (password == nil ||
            password.length <= 0)
        {
            shouldDisplayLoginPrompt = YES;
        }
    }
    
    if (shouldDisplayLoginPrompt) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Required" message:@"You must be logged in to perform searches." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
        alert.delegate = self;
        [alert show];
    } else {
        if (!self.flightTrackerController) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FlightTracker" bundle:nil];
            self.flightTrackerController = [sb instantiateInitialViewController];
        }
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:self.flightTrackerController animated:YES];
    }
}

-(void) launchEvents
{    
    NFDPDFViewController *pdfViewer = [[NFDPDFViewController alloc] initWithNibName:@"NFDPDFViewController" bundle:nil];
    [self.navigationController pushViewController:pdfViewer animated:YES];
}

-(void) launchAIM 
{
    NFDPositioningViewController *controller = [[NFDPositioningViewController alloc] init];
    // Hide nav bar so that new controller doesn't have awkward transition
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)checkForNecessaryDataForSection:(NSString *)section
{
    if ([section isEqualToString:@"Proposal"] || [section isEqualToString:@"Profile"])
    {
        int rows = -1;
        
        NSManagedObjectContext *ctx = [[NFDPersistenceManager sharedInstance] mainMOC];
        rows = [NCLPersistenceUtil countForFetchRequestForEntityName:@"ContractRate" predicate:nil includeSubEntities:NO context:ctx error:nil];

        if (rows == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Data" message:@"Login information and data synchronization are required to enable this feature.\n\nOn the FliteDeck Landing Page, tap the gear icon at the bottom of the page.  Enter your NetJets username and password and then tap the Data Sync button to complete the data synchronization process." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }

    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self openUserSettings:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [aircraftImage setHidden:YES];
    [aircraftImage setCenter:CGPointMake(1500, 400)];
    [self.cloudView moveViewOriginToPoint:CGPointZero];
    [self.navigationController setNavigationBarHidden:YES];
    NFDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    Prospect *p = (Prospect*)[delegate.session objectForKey:@"currentProspect"];
    [p reset];
    
    self.navigationController.navigationBar.barTintColor = [UIColor barTintColorDefault];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [aircraftImage setHidden:NO];
    [self cycleBackgroundImages];
    [self moveAircraftImage];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([self.popover isPopoverVisible])
    {    
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            [self.popover setPopoverLayoutMargins:UIEdgeInsetsMake(284, 20, 0, 20)];
        }
        else 
        {
            [self.popover setPopoverLayoutMargins:UIEdgeInsetsMake(20, 20, 0, 20)];
        }
        [self.popover dismissPopoverAnimated:NO];
        [self.popover presentPopoverFromRect:self.userSettingsButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)openUserSettings:(id)sender
{
    if ([self.popover isPopoverVisible])
	{
		[self.popover dismissPopoverAnimated:YES];
		return;
	}
    
    NFDUserSettingsMainViewController *usvc = [[NFDUserSettingsMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:usvc];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [self.popover setPopoverLayoutMargins:UIEdgeInsetsMake(284, 20, 0, 20)];
    }
    [self.popover presentPopoverFromRect:self.userSettingsButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.popover setDelegate:self];
}

@end
