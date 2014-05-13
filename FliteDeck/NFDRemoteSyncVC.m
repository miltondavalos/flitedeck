//
//  NFDRemoteSyncVC.m
//  FliteDeck
//
//  Created by Chad Long on 5/4/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFDRemoteSyncVC.h"
#import <QuartzCore/QuartzCore.h>
#import "NFDRemoteSyncCell.h"
#import "NFDNetJetsRemoteService.h"
#import "NFDPersistenceManager.h"
#import "NFDUserManager.h"
#import "NCLFramework.h"
#import "NFDServerSettingsVC.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@interface NFDRemoteSyncVC ()
{
    NSUserDefaults *userDefaults;
    NSDateFormatter *dateFormatter;
    UITableView *tblSyncStatus;
    UIFont *errorFont;
    NSArray *swipes;
    int swipeIndex;
    int numDataSourcesToSync;
}

- (CGRect)labelRectForString:(NSString*)text;
- (CGFloat)rowHeightForErrorKey:(NSString*)key;
- (void)updateDisplayForCell:(NFDRemoteSyncCell*)cell
                    syncType:(NSString*)syncType
                   urlString:(NSString*)urlString
                   statusKey:(NSString*)statusKey
                    errorKey:(NSString*)errorKey;

@end

@implementation NFDRemoteSyncVC

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
        [self.view setFrame:frame];
        [self setPreferredContentSize:frame.size];
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        tblSyncStatus = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        [tblSyncStatus setDelegate:self];
        [tblSyncStatus setDataSource:self];
        [tblSyncStatus setBackgroundColor:[UIColor clearColor]];
        [[self view] addSubview:tblSyncStatus];
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        
        errorFont = [UIFont fontWithName:@"Helvetica" size:12.0f];
        
        [tblSyncStatus setScrollEnabled:NO];
        
        UISwipeGestureRecognizer *swiperUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(checkSwipe:)];
        [swiperUp setDirection:UISwipeGestureRecognizerDirectionUp];
        [self.view addGestureRecognizer:swiperUp];
        
        UISwipeGestureRecognizer *swiperDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(checkSwipe:)];
        [swiperDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [self.view addGestureRecognizer:swiperDown];
        
        UISwipeGestureRecognizer *swiperLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(checkSwipe:)];
        [swiperLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.view addGestureRecognizer:swiperLeft];
        
        UISwipeGestureRecognizer *swiperRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(checkSwipe:)];
        [swiperRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:swiperRight];
        
        swipes = [NSArray arrayWithObjects:[NSNumber numberWithInt:UISwipeGestureRecognizerDirectionUp], [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionDown], [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionLeft], [NSNumber numberWithInt:UISwipeGestureRecognizerDirectionRight], nil];
        
        swipeIndex = 0;
    }
    
    return self;
}

#pragma mark - User action processing

- (void)checkSwipe:(id)sender
{
    UISwipeGestureRecognizer *swiper = (UISwipeGestureRecognizer *)sender;
    NSNumber *direction = [NSNumber numberWithInt:[swiper direction]];
    
    if ([[swipes objectAtIndex:swipeIndex] isEqual:direction])
    {
        swipeIndex++;
    }
    else 
    {
        swipeIndex = 0;
    }
    
    if (swipeIndex == swipes.count)
    {
        [self openServerSettings];
        swipeIndex = 0;
    }
}

- (void)swapServicesHostAddress:(id)sender
{
    [[NFDNetJetsRemoteService sharedInstance] swapServicesHost];
    NSLog(@"services host:%@", [[NFDNetJetsRemoteService sharedInstance] servicesHost]);
    [tblSyncStatus reloadData];

}

- (void)openServerSettings
{
    CGRect frame = self.view.frame;
    NFDServerSettingsVC *vc = [[NFDServerSettingsVC alloc] initWithFrame:frame];
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [tblSyncStatus deselectRowAtIndexPath:indexPath animated:NO];

        // don't allow double-clicks
        if(![NFDUserManager sharedManager].syncInProgress) {

            [NFDUserManager sharedManager].syncInProgress = YES;
            [NFDUserManager sharedManager].remoteDataSyncProgress = [[NSMutableSet alloc] init];
            numDataSourcesToSync = 1;

            [tblSyncStatus reloadData];
            
            // prime the DB before we initialize it by kicking off a background thread
            [[NFDPersistenceManager sharedInstance] mainMOC];
            
            NFDNetJetsRemoteService *service = [NFDNetJetsRemoteService sharedInstance];
            [service ifAuthenticatedProcessBlock:^() {
                
                NSLog(@"Login attempt succeeded");
                // execute data sync in background
                [[NFDNetJetsRemoteService sharedInstance] updateInventoryData]; numDataSourcesToSync++;
                [[NFDNetJetsRemoteService sharedInstance] updateFuelData]; numDataSourcesToSync++;
                [[NFDNetJetsRemoteService sharedInstance] updateSalesData]; numDataSourcesToSync++;
                [[NFDNetJetsRemoteService sharedInstance] updateFeaturesData]; numDataSourcesToSync++;
                [[NFDNetJetsRemoteService sharedInstance] updateAccountData]; numDataSourcesToSync++;
                
            } ifErrorProcessBlock:^(NSError * error) {
                
                NSLog(@"Login attempt failed");
                [service handleErrorForContext:nil userDefaultsKey:LAST_CONTRACT_RATE_SYNC_ERROR errorString:[error description]];
                [service handleErrorForContext:nil userDefaultsKey:LAST_FUEL_SYNC_ERROR errorString:[error description]];
                [service handleErrorForContext:nil userDefaultsKey:LAST_INVENTORY_SYNC_ERROR errorString:[error description]];
                [service handleErrorForContext:nil userDefaultsKey:LAST_FEATURES_SYNC_ERROR errorString:[error description]];
                [service handleErrorForContext:nil userDefaultsKey:LAST_ACCOUNT_SYNC_ERROR errorString:[error description]];
            }];
        }
    }
    else if (indexPath.section == 2)
    {
        [self openServerSettings];
    }
}

- (void)dataSyncCompleted:(NSNotification*)notification
{
    [[NFDUserManager sharedManager].remoteDataSyncProgress addObject:[[notification userInfo] objectForKey:HTTP_REQUEST_ID_NOTIFICATION_KEY]];
    
    NSLog(@"data sync [%d of %d] completed", [NFDUserManager sharedManager].remoteDataSyncProgress.count, numDataSourcesToSync);
    
    if ([NFDUserManager sharedManager].remoteDataSyncProgress.count >= numDataSourcesToSync)
        [NFDUserManager sharedManager].syncInProgress = NO;
    
    [tblSyncStatus reloadData];

}

#pragma mark - Table view display

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    #if TARGET_IPHONE_SIMULATOR
        
        return 3;
        
    #else
        
        return 2;
        
    #endif
}

- (NSString *) findWiFiSSID
{
    // get the network WiFi SSID if available
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    for (NSString *ifnam in ifs)
    {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info[@"SSID"])
        {
            ssid = info[@"SSID"];
        }
    }
    
    return ssid;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footerText = nil;
    
    if (section == 1)
    {
        footerText = [[NFDNetJetsRemoteService sharedInstance] servicesHost];
        NSString *ssid = [self findWiFiSSID];
        if (ssid) {
            footerText = [NSString stringWithFormat:@"%@\n%@", footerText, ssid];
        }
    }
    
    return footerText;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 5;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
            return [self rowHeightForErrorKey:LAST_INVENTORY_SYNC_ERROR];
        if (indexPath.row == 1)
            return [self rowHeightForErrorKey:LAST_CONTRACT_RATE_SYNC_ERROR];
        if (indexPath.row == 2)
            return [self rowHeightForErrorKey:LAST_FUEL_SYNC_ERROR];
        if (indexPath.row == 3)
            return [self rowHeightForErrorKey:LAST_FEATURES_SYNC_ERROR];
        if (indexPath.row == 4)
            return [self rowHeightForErrorKey:LAST_ACCOUNT_SYNC_ERROR];
    }
    
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    // process display for sync status of each entity
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"NFDRemoteSyncCell";
        NFDRemoteSyncCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (customCell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NFDRemoteSyncCell" owner:self options:nil];
            
            for (id object in topLevelObjects)
            {
                if ([object isKindOfClass:[NFDRemoteSyncCell class]])
                {
                    customCell = (NFDRemoteSyncCell*)object;
                    [[customCell resultsLabel] setFont:errorFont];
                    [customCell setUserInteractionEnabled:NO];
                }
            }
        }
        
        if (indexPath.row == 0)
        {
            [self updateDisplayForCell:customCell
                              syncType:@"Aircraft Inventory"
                             urlString:AIRCRAFT_INVENTORY_URL
                             statusKey:LAST_INVENTORY_SYNC
                              errorKey:LAST_INVENTORY_SYNC_ERROR];
        }
        else if (indexPath.row == 1)
        {
            [self updateDisplayForCell:customCell
                              syncType:@"Contract Rates"
                             urlString:CONTRACT_RATE_URL
                             statusKey:LAST_CONTRACT_RATE_SYNC
                              errorKey:LAST_CONTRACT_RATE_SYNC_ERROR];
        }
        else if (indexPath.row == 2)
        {
            [self updateDisplayForCell:customCell
                              syncType:@"Fuel Rates"
                             urlString:FUEL_RATE_URL
                             statusKey:LAST_FUEL_SYNC
                              errorKey:LAST_FUEL_SYNC_ERROR];
        }
        else if (indexPath.row == 3)
        {
            [self updateDisplayForCell:customCell
                              syncType:@"Features"
                             urlString:FEATURES_URL
                             statusKey:LAST_FEATURES_SYNC
                              errorKey:LAST_FEATURES_SYNC_ERROR];
        }
        else if (indexPath.row == 4)
        {
            [self updateDisplayForCell:customCell
                              syncType:@"Account"
                             urlString:ACCOUNT_URL
                             statusKey:LAST_ACCOUNT_SYNC
                              errorKey:LAST_ACCOUNT_SYNC_ERROR];
        }
        
        cell = customCell;
    }
    
    // display the manual sync button
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
        
        if (indexPath.section == 2)
        {
            [cell.textLabel setText:@"Environment"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
        else
        {
            if ([NFDUserManager sharedManager].syncInProgress)
            {
                [cell setUserInteractionEnabled:NO];
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
            else
            {
                [cell setUserInteractionEnabled:YES];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            
            [cell.textLabel setText:@"Sync"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
    }
    
    return cell;
}

- (CGFloat)rowHeightForErrorKey:(NSString*)key
{
    if ([userDefaults objectForKey:key] != nil)
    {
        return (38.0f + [self labelRectForString:[userDefaults objectForKey:key]].size.height + 11.0f);
    }
    
    return 44.0f;
}

- (void)updateDisplayForCell:(NFDRemoteSyncCell*)cell
                    syncType:(NSString*)syncType
                   urlString:(NSString*)urlString
                   statusKey:(NSString*)statusKey
                    errorKey:(NSString*)errorKey
{
    cell.syncType.text = syncType;
    
    // last update display
    if ([userDefaults objectForKey:statusKey] != nil) {
        cell.lastUpdateDate.text = [dateFormatter stringFromDate:[userDefaults objectForKey:statusKey]];
    }
    else
    {
        cell.lastUpdateDate.text = @"";
    }
    
    // activity indicator display
    if ([NFDUserManager sharedManager].syncInProgress &&
        ![[NFDUserManager sharedManager].remoteDataSyncProgress containsObject:urlString])
    {
        [cell.statusImage setHidden:YES];
        [cell.activityIndicator startAnimating];
    }
    else if (cell.statusImage.isHidden)
    {
        [cell.activityIndicator stopAnimating];
        [cell.statusImage setHidden:NO];
    }
    
    // error icon and label display
    if ([userDefaults objectForKey:errorKey] != nil)
    {
        cell.statusImage.image = [UIImage imageNamed: @"cross.png"];
        cell.resultsLabel.frame = [self labelRectForString:[userDefaults objectForKey:errorKey]];
        cell.resultsLabel.text = [userDefaults objectForKey:errorKey];
    }
    else
    {
        int rows = -1;
        
        NSManagedObjectContext *ctx = [[NFDPersistenceManager sharedInstance] mainMOC];
        rows = [NCLPersistenceUtil countForFetchRequestForEntityName:@"ContractRate" predicate:nil context:ctx error:nil];
        
        if (rows == 0)
        {
            cell.statusImage.image = [UIImage imageNamed: @"cross.png"];
            cell.resultsLabel.text = @"";
        } else {            
            cell.statusImage.image = [UIImage imageNamed: @"checkmark.png"];
            cell.resultsLabel.text = @"";
        }
        
    }
}

- (CGRect)labelRectForString:(NSString*)text
{
    // error label is not required when an error does not exist
    if (text == nil ||
        text.length <= 0)
    {
        return CGRectMake(0, 0, 0, 0);
    }
    
    CGFloat cellWidth = tblSyncStatus.frame.size.width - 70;
    CGSize maximumLabelSize = CGSizeMake(cellWidth, CGFLOAT_MAX);
    
    CGRect errorLabelRect = [text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:errorFont} context:nil];
    CGSize errorLabelSize = errorLabelRect.size;

    return CGRectMake(43.0f, 38.0f, cellWidth, errorLabelSize.height);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSyncCompleted:)
                                                 name:HTTP_REQUEST_DID_COMPLETE_NOTIFICATION
                                               object:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [tblSyncStatus reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Device notifications

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
