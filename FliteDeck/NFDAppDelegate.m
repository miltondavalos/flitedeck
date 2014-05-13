//
//  NJAppDelegate.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDAppDelegate.h"

#import "NFDViewController.h"
#import "NFDLaunchPadPage.h"
#import "NCLFramework.h"
#import "NFDNetJetsRemoteService.h"
#import "NFDUserManager.h"
#import "UIColor+FliteDeckColors.h"
#import "NCLAnalytics.h"
#import "NFDMasterSynchService.h"
#import "NFDFlightProposalManager.h"

@implementation NFDAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController, navigationController;
@synthesize session, pm;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // set NCL framework logging level
    #ifdef NCL_DEBUG_LOG
    [NCLFramework setLogLevel:LogLevelTRACE];
    #endif
    
//    NSString *path = [[NFDFileSystemHelper directoryForDocuments] stringByAppendingString:@"/FliteDeck.sqlite"];
//    
//    if (![NFDFileSystemHelper fileExist: path]) {
//        [self initDatabase];
//    }
    
    // HockeyApp SDK Integration
    [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:@"aac17939aa3d977b400cc460577a2e1d"
                                                         liveIdentifier:@"LIVE_IDENTIFIER"
                                                               delegate:self];
    // automatically send report without user interaction
    [[[BITHockeyManager sharedHockeyManager] crashManager] setCrashManagerStatus:BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = [UIColor tintColorDefault];
    
    // Override point for customization after application launch.
    self.viewController = [[NFDViewController alloc] initWithNibName:@"NFDViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] init];
    self.navigationController.viewControllers = [NSArray arrayWithObjects:self.viewController, nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    self.session = [[NSMutableDictionary alloc] init];
    pm = [NFDPersistenceManager sharedInstance];
    //initilializes prospect information that will be used through the session.
    //This will be managed by NFDProspectViewController
    Prospect *currentProspect = [[Prospect alloc] init];
    [self.session setValue:currentProspect forKey:@"currentProspect"];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // prime the DB before we initialize it by kicking off a background thread
    [[NFDPersistenceManager sharedInstance] mainMOC];
    
    
    NFDMasterSynchService *masterSyncService = [NFDMasterSynchService new];
    NFDCompanySetting companySetting = [[NFDUserManager sharedManager] companySetting];
    
    if ([masterSyncService isSyncFromMasterNeeded]) {
        [masterSyncService syncFromMasterForCompany:companySetting];
    }
    
    // attempt to auto-sync once a day
    static NSString *syncKey = @"LastAutoSyncAttempt";
    static NSString *syncVersionKey = @"LastAutoSyncVersion";

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

    NSString *servicesHostKey = [defaults objectForKey:SERVICES_HOST_KEY];
    // Release 1.8.1 switched to the Layer 7 URL scheme and existing installs of FliteDeck need the prod URL scheme automatically updated.
    if([servicesHostKey isEqualToString:LEGACY_BASE_SERVICES_HOST_FOR_PRODUCTION]) {
        servicesHostKey = BASE_SERVICES_HOST_FOR_PRODUCTION;
    }
    if (servicesHostKey) {
        [[NFDNetJetsRemoteService sharedInstance] setServicesHost:servicesHostKey];
    }

    NSDate *lastAutoSyncAttempt = [defaults objectForKey:syncKey];
    NSDate *now = [NSDate date];
    
    NSString *user = [[NFDUserManager sharedManager] username];
    NSString *password = [NCLKeychainStorage userPasswordForUser:user host:[NFDNetJetsRemoteService sharedInstance].host].password;

    if (user != nil &&
        user.length > 0 &&
        password != nil &&
        password.length > 0)
    {
        NSString *version = [defaults objectForKey:syncVersionKey];
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        BOOL isNewAppVersion = version == nil || ![version isEqualToString:currentVersion];
        
        if (isNewAppVersion ||
            ([lastAutoSyncAttempt dateComponent:NSMonthCalendarUnit] != [now dateComponent:NSMonthCalendarUnit] ||
            [lastAutoSyncAttempt dateComponent:NSDayCalendarUnit] != [now dateComponent:NSDayCalendarUnit]))
        {
         
            NFDNetJetsRemoteService *service = [NFDNetJetsRemoteService sharedInstance];
            [service ifAuthenticatedProcessBlock:^() {
                [defaults setObject:now forKey:syncKey];
                [defaults setObject:currentVersion forKey:syncVersionKey];
                [defaults synchronize];

                [service updateInventoryData];
                [service updateFuelData];
                [service updateSalesData];
                [service updateFeaturesData];
                [service updateAccountData];
           
            } ifErrorProcessBlock:^(NSError *error) {
                [service handleErrorForContext:nil userDefaultsKey:LAST_CONTRACT_RATE_SYNC_ERROR errorString:[error description]];
                [service handleErrorForContext:nil userDefaultsKey:LAST_FUEL_SYNC_ERROR errorString:[error description]];
                [service handleErrorForContext:nil userDefaultsKey:LAST_INVENTORY_SYNC_ERROR errorString:[error description]];
                [service handleErrorForContext:nil userDefaultsKey:LAST_FEATURES_SYNC_ERROR errorString:[error description]];
                [service handleErrorForContext:nil userDefaultsKey:LAST_ACCOUNT_SYNC_ERROR errorString:[error description]];
            }];
            
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - BITHockeyManagerDelegate methods

- (BOOL)shouldUseLiveIdentifierForHockeyManager:(BITHockeyManager *)hockeyManager
{
    // probably need a 'QA' scheme and return NO and then return YES for RELEASE scheme
    // #ifdef QA
    // return YES;
#ifdef RELEASE
    return NO;
#endif
    return NO;
}

- (NSString *)userIDForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager
{
    return nil;
}

- (NSString *)userNameForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager
{
    return [[NFDUserManager sharedManager] username];
}

- (NSString *)userEmailForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager
{
    return nil;
}

- (NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager
{
    NSString *deviceName = [NSString stringWithFormat:@">>> device name: %@", [[UIDevice currentDevice] name]];
    
    NSString *logString = [NSString stringWithFormat:@"%@", deviceName];
    
    if ([[[NFDFlightProposalManager sharedInstance] proposals] count] > 0)
    {
        logString = [NSString stringWithFormat:@"%@\n\n>>> proposals:%@", logString, [[NFDFlightProposalManager sharedInstance] proposals]];
    }
//    NSManagedObjectContext *moc = [[NCLAnalyticsPersistenceManager sharedInstance] privateMOCWithParent:nil];
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"createdTS > %@", [NSDate dateWithTimeIntervalSinceNow:-(15*60)]];
//    
//    NSArray *events = [moc executeFetchRequestForEntityName:@"Event" predicate:pred error:nil];
//    
//    logString = [NSString stringWithFormat:@"%@\n\nEvents ------\ncreated | component | action | value\n", logString];
//    
//    for (NCLAnalyticsEvent *event in events)
//    {
//        logString = [NSString stringWithFormat:@"%@%@ | %@ | %@ | %@\n", logString, event.createdTS, event.component, event.action, event.value];
//    }
//    
//    logString = [NSString stringWithFormat:@"%@------ Events\n\n", logString];
    
    return logString;
}


@end
