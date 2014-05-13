//
//  NFDFlightTrackerAccountSearchViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 12/3/13.
//
//

#import "NFDFlightTrackerAccountSearchViewController.h"

#import "NFDAccountSelectorViewController.h"

#import "NDFAccount.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDNetJetsRemoteService.h"

#define LAST_TEN_FLIGHTS_SEGMENT 0
#define LAST_TWENTY_FLIGHTS_SEGMENT 1
#define DATE_RANGE_SEGMENT 2

@interface NFDFlightTrackerAccountSearchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;


@property (weak, nonatomic) IBOutlet UISegmentedControl *searchScopeSegmentedControl;

@property (strong, nonatomic) NSString *selectedAccountID;
@property (strong, nonatomic) NSString *selectedAccountName;

@property (weak, nonatomic) IBOutlet UITableViewCell *selectAccountCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateRangeCell;

@end

@implementation NFDFlightTrackerAccountSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.searchScopeSegmentedControl.tintColor = [UIColor tintColorForLightBackground];
    
    UIImage *disclosureImage = [UIImage imageNamed:@"disclosureArrow"];
    
    self.dateRangeCell.accessoryView = [[UIImageView alloc] initWithImage:disclosureImage];
    self.selectAccountCell.accessoryView = [[UIImageView alloc] initWithImage:disclosureImage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NFDNetJetsRemoteService sharedInstance] displayRequiredSetupWarningForFlightTrackingAccountSearch];
}

- (IBAction)searchTapped:(id)sender {
    
    NSString *accountIDText = self.selectedAccountID;
    
    if (accountIDText && ![accountIDText isEmptyOrWhitespace]) {
        
        if (self.searchScopeSegmentedControl.selectedSegmentIndex == DATE_RANGE_SEGMENT) {
            NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
            NSString *endDateText = [NSString stringFromDate:self.endDate formatType:NCLDateFormatDateOnly];
            
            [self.flightTrackerManager findFlightsByAccount:accountIDText accountName: self.selectedAccountName startDate:startDateText endDate:endDateText maxResults:nil];
        } else {
            NSUInteger maxResults = self.searchScopeSegmentedControl.selectedSegmentIndex == LAST_TEN_FLIGHTS_SEGMENT ? 10 : 20;
            [self.flightTrackerManager findFlightsByAccount:accountIDText accountName: self.selectedAccountName startDate:nil endDate:nil maxResults:[NSNumber numberWithInt:maxResults]];
        }
        
    } else {
        self.errorLabel.text = @"Account required";
    }
    
}

- (IBAction)accountSelectedUnwindSegue:(UIStoryboardSegue *)segue {
    NFDAccountSelectorViewController *accountSelectorViewController = segue.sourceViewController;
    self.selectedAccountID = [NSString stringFromObject: accountSelectorViewController.selectedAccount.account_id];
    self.selectedAccountName = accountSelectorViewController.selectedAccount.account_name;
    
    self.accountLabel.text = self.selectedAccountName;
}

- (IBAction)searchScopeChanged:(id)sender {
    
    if (self.searchScopeSegmentedControl.selectedSegmentIndex == DATE_RANGE_SEGMENT) {
        self.dateRangeCell.hidden = NO;
        [self dateRangeSelected];
        
//        [self performSelector:@selector(dateRangeSelected) withObject:self afterDelay:0.3];
        
    } else {
        self.dateRangeCell.hidden = YES;
    }
    
}

- (void) dateRangeSelected
{
    [self performSegueWithIdentifier:@"selectDates" sender:self];
}

@end
