//
//  NFDViewController.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightProfileAircraftSelectionViewController.h"
#import "MGSplitViewController.h"

@interface NFDViewController : UIViewController <UIPopoverControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *launchView;
@property (weak, nonatomic) IBOutlet UIImageView *aircraftImage;
@property (strong, nonatomic) IBOutlet UIButton *userSettingsButton;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIImageView *cloudView;
@property (strong, nonatomic) NFDFlightProfileAircraftSelectionViewController *flightProfileViewController;
@property (strong, nonatomic) MGSplitViewController *proposalSplitViewController;
@property (strong, nonatomic) MGSplitViewController *trackingSplitViewController;

@property (strong, nonatomic) UIViewController *flightTrackerController;

- (void)registerForNotification: (NSString *) notificationName selector:(SEL) aSelector;

- (void)launchFlightProfile;
- (void)launchFlightTracking;
- (void)launchFlightProposal;
- (void)launchEvents;
- (void)launchAIM;
- (void)launchAirport;

- (void)moveAircraftImage;
- (void)cycleBackgroundImages;
- (IBAction)openUserSettings:(id)sender;
- (BOOL)checkForNecessaryDataForSection:(NSString *)section;

@end
