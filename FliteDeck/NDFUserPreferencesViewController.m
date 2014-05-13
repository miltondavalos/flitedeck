//
//  NDFUserPreferencesViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 12/16/13.
//
//

#import "NDFUserPreferencesViewController.h"

#import "NFDUserManager.h"
#import "NFDMasterSynchService.h"
#import "MMProgressHUD.h"

@interface NDFUserPreferencesViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *companySegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *showCostSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showAverageHourlyCostSwitch;

@end

@implementation NDFUserPreferencesViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.companySegmentedControl.selectedSegmentIndex = [[NFDUserManager sharedManager] companySetting];
    [self updateViewForSettingValues];

}
- (IBAction)companyChanged:(id)sender {
    
    NFDCompanySetting companySetting =self.companySegmentedControl.selectedSegmentIndex;
    
    [[NFDUserManager sharedManager] setCompanySetting:companySetting];
    
    [self.tableView reloadData];
    [self updateViewForSettingValues];
    
    NSString *companyText = [NFDUserManager stringForCompanySetting:companySetting];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status: [NSString stringWithFormat: @"Configuring FliteDeck for %@", companyText]];
    [self performBlock:^{
        [self updateAppForCompany];
    } afterDelay:0.0];

}


- (void) updateAppForCompany
{
    NFDCompanySetting companySetting = [[NFDUserManager sharedManager] companySetting];
    
    NFDMasterSynchService *masterSyncService = [NFDMasterSynchService new];
    [masterSyncService syncFromMasterForCompany:companySetting];
    
    NSString *companyText = [NFDUserManager stringForCompanySetting:companySetting];

    [MMProgressHUD dismissWithSuccess:[NSString stringWithFormat: @"FliteDeck is configured for %@", companyText] title:@"Success" afterDelay:2.0];
}

- (IBAction)showCostValueChanged:(id)sender {
    
    [[NFDUserManager sharedManager] setProfileShowMoney:self.showCostSwitch.on];
    
}

- (IBAction)showAverageHourlyCostValueChanged:(id)sender {
    [[NFDUserManager sharedManager] setProposalShowHourly:self.showAverageHourlyCostSwitch.on];
}

- (void)updateViewForSettingValues
{
    self.showCostSwitch.on = [[NFDUserManager sharedManager] profileShowMoney];
    self.showAverageHourlyCostSwitch.on = [[NFDUserManager sharedManager] proposalShowHourly];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 3;
    
    NFDCompanySetting companySetting = [[NFDUserManager sharedManager] companySetting];
    if (companySetting == NFDCompanySettingNJE) {
        numberOfSections = 1;
    }
    return numberOfSections;
}


@end
