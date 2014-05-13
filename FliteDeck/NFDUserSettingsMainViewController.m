//
//  NFDUserSettingsViewController.m
//  FliteDeck
//
//  Created by Ryan Smith on 3/15/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDUserSettingsMainViewController.h"
#import "NFDUserManager.h"
#import "NFDAccountSettingsVC.h"
#import "NCLFramework.h"
#import "NFDPersistenceManager.h"
#import "NFDNetJetsRemoteService.h"
#import "NFDRemoteSyncVC.h"
#import "UIColor+FliteDeckColors.h"

@implementation NFDUserSettingsMainViewController

@synthesize tView = _tView;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        [self setPreferredContentSize:CGSizeMake(320, 625)];
        [self.view setAutoresizesSubviews:YES];
        self.tView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 625) style:UITableViewStyleGrouped];
        [self.tView setDelegate:self];
        [self.tView setDataSource:self];
        [self.view addSubview:self.tView];
        
        //[self.navigationController setDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:NFD_USER_MANAGER_USER_INFO_DID_CHANGE_NOTIFICATION object:nil];
        [self.navigationItem setTitle:@"Settings"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)updateTable
{
    [self.tView reloadData];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = @"";
    UIKeyboardType keyboardType = UIKeyboardTypeDefault;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0)
    {
        key = NFDAccountSettingsUsername;
        keyboardType = UIKeyboardTypeAlphabet;
    }
    else if (indexPath.section == 1)
    {
        //NFDAccountSettingsVC *vc = [[NFDAccountSettingsVC alloc] initWithFrame:self.view.frame key:key];
        switch (indexPath.row)
        {  
            case kNFDUserSettingsName:
                key = NFDUserSettingsName;
                keyboardType = UIKeyboardTypeNamePhonePad;
                break;
                
            case kNFDUserSettingsTitle:
                key = NFDUserSettingsTitle;
                keyboardType = UIKeyboardTypeDefault;
                break;
                
            case kNFDUserSettingsEmail:
                key = NFDUserSettingsEmail;
                keyboardType = UIKeyboardTypeEmailAddress;
                break;
                
            case kNFDUserSettingsPhoneWork:
                key = NFDUserSettingsPhoneWork;
                keyboardType = UIKeyboardTypePhonePad;
                break;
                
            case kNFDUserSettingsPhoneMobile:
                key = NFDUserSettingsPhoneMobile;
                keyboardType = UIKeyboardTypePhonePad;
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserPreferences" bundle:nil];
        UIViewController *vc = [sb instantiateInitialViewController];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3)
    {
        NFDRemoteSyncVC *vc = [[NFDRemoteSyncVC alloc] initWithFrame:self.view.frame];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 4)
    {
        [self sendFeedback:nil];
    }
    
    if (indexPath.section <= 1)
    {
        NFDAccountSettingsVC *vc = [[NFDAccountSettingsVC alloc] initWithFrame:self.view.frame key:key];
        if (key == NFDAccountSettingsUsername)
        {
            NSString *username = [[NFDUserManager sharedManager] objectForKey:key];
            [vc.textField setText:username];

            NSString *password = [NCLKeychainStorage userPasswordForUser:username host:[NFDNetJetsRemoteService sharedInstance].host].password;
            [vc.passwordBox setText:password];
        }
        else 
        {
            [vc.textField setText:[[NFDUserManager sharedManager] objectForKey:key]];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    int cellStyle = UITableViewCellStyleValue2;

    if (indexPath.section > 1)
    {
        cellIdentifier = @"SimpleCell";
        cellStyle = UITableViewCellStyleDefault;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.section)
    {
        case 0:
            [[cell textLabel] setText:@"Account"];
            [[cell detailTextLabel] setText:[[NFDUserManager sharedManager] username]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 1:
            switch (indexPath.row)
            {
                case kNFDUserSettingsName:
                    [[cell textLabel] setText:@"Name"];
                    [[cell detailTextLabel] setText:[[NFDUserManager sharedManager] name]];
                    break;
                    
                case kNFDUserSettingsTitle:
                    [[cell textLabel] setText:@"Title"];
                    [[cell detailTextLabel] setText:[[NFDUserManager sharedManager] objectForKey:NFDUserSettingsTitle]];
                    break;
                    
                case kNFDUserSettingsPhoneWork:
                    [[cell textLabel] setText:@"Office"];
                    [[cell detailTextLabel] setText:[[NFDUserManager sharedManager] objectForKey:NFDUserSettingsPhoneWork]];
                    break;
                    
                case kNFDUserSettingsPhoneMobile:
                    [[cell textLabel] setText:@"Mobile"];
                    [[cell detailTextLabel] setText:[[NFDUserManager sharedManager] objectForKey:NFDUserSettingsPhoneMobile]];
                    break;
                    
                case kNFDUserSettingsEmail:
                    [[cell textLabel] setText:@"Email"];
                    [[cell detailTextLabel] setText:[[NFDUserManager sharedManager] objectForKey:NFDUserSettingsEmail]];
                    break;
                    
                default:
                    break;
            }
            break;
        
        case 2:
            switch (indexPath.row)
            {
                case 0:
                    [[cell textLabel] setText:@"Preferences"];
                    [[cell textLabel] setTextAlignment:NSTextAlignmentLeft];
                    [[cell textLabel] setFont:[cell.textLabel.font fontWithSize:14.0f]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        case 3:
            switch (indexPath.row)
            {
                case 0:
                    [[cell textLabel] setText:@"Data Sync"];
                    [[cell textLabel] setTextAlignment:NSTextAlignmentLeft];
                    [[cell textLabel] setFont:[cell.textLabel.font fontWithSize:14.0f]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                    break;
                    
                default:
                    break;
            }

            break;

        case 4:
            switch (indexPath.row)
            {
                case 0:
                    [[cell textLabel] setText:@"Send feedback"];
                    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
                    [[cell textLabel] setFont:[cell.textLabel.font fontWithSize:14.0f]];
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
            

        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
            
        case 1:
            return 5;
            break;
            
        default:
            break;
    }

    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section)
    {
        case 0:
            return @"User Information";
            break;
        case 3:
            return @"Data Management";
            break;
        case 4:
            return [NSString stringWithFormat:@"Version %@ (%@.%@)\nBuild Date:  %@",
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"BuildSHA"],
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildDate"]
                    ];
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)sendFeedback:(id)sender
{
    MFMailComposeViewController *feedback = [[MFMailComposeViewController alloc] init];
    feedback.mailComposeDelegate = self;
    
    NSString *subject = @"FliteDeck Feedback";
    NSString *name = [[NFDUserManager sharedManager] name];
    
    if (name != nil && [name length] > 0) {
        subject = [NSString stringWithFormat:@"%@ from %@", subject, name];
    }
    
    [feedback setSubject:subject];
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"flitedeck@netjets.com"];
    [feedback setToRecipients:toRecipients];
    
    NSString *versionNumber = [NSString stringWithFormat:@"%@ (%@.%@)\nBuild Date:  %@",
                               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], 
                               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"BuildSHA"],
                               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildDate"]];
    
    NSLog(@"BuildSHA = %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"BuildSHA"]);
    
    
    NSString *body = [NSString stringWithFormat:@"Please add the details of your comment or issue below this line:\n\n\n\n\n\nEmail:  %@\nOffice:  %@\nMobile:  %@\n\nFliteDeck Version %@", 
                      [[NFDUserManager sharedManager] email], 
                      [[NFDUserManager sharedManager] phoneWork], 
                      [[NFDUserManager sharedManager] phoneMobile], 
                      versionNumber];
    
    [feedback setMessageBody:body isHTML:NO];
    [self presentViewController:feedback animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tView deselectRowAtIndexPath:[self.tView indexPathForSelectedRow] animated:NO];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setTintColor:[UIColor tintColorForLightBackground]];
    [self.navigationController.view setTintColor:[UIColor tintColorForLightBackground]];

    [self.tView deselectRowAtIndexPath:[self.tView indexPathForSelectedRow] animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
