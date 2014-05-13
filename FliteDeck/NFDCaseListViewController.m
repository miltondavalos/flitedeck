//
//  NFDCaseListViewController.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/16/13.
//
//

#import "NFDCaseListViewController.h"
#import "NFDCaseTableViewCell.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDCaseDetailViewController.h"
#import "NFDOwnerImpactTableViewController.h"

@interface NFDCaseListViewController ()
@property (strong, nonatomic) NFDCaseTableViewCell *selectedCell;
@property (strong, nonatomic) NFDCaseDetailViewController *caseDetailViewController;
@property (nonatomic) CGRect flightDetailsViewFrame;
@end

@implementation NFDCaseListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flightDetailsView.layer.cornerRadius = 5.0;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModal)];
    [tapRecognizer setNumberOfTapsRequired:1];
    
    [self.flightDetailsView addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deselectRow)
                                                 name:CASE_DETAILS_DISMISSED_NOTIFICATION
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.flightDetailsView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.flightDetailsViewFrame = self.flightDetailsView.frame;
    
    self.flightDetailsView.frame = CGRectMake(self.flightDetailsViewFrame.origin.x,
                                              705,
                                              self.flightDetailsViewFrame.size.width,
                                              self.flightDetailsViewFrame.size.height);
    
    self.flightDetailsView.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        self.flightDetailsView.frame = self.flightDetailsViewFrame;
    } completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CASE_DETAILS_DISMISSED_NOTIFICATION object:nil];
}

- (NSUInteger)caseGroupCount
{
    if (self.caseGroups) {
        return self.caseGroups.count;
    }
    
    return 0;
}

- (void)deselectRow
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)totalNumberOfCasesDisplayed
{
    NSUInteger numberOfCases = 0;
    for (NFDCaseGroup *caseGroup in self.caseGroups) {
        numberOfCases = numberOfCases + caseGroup.cases.count;
    }
    return numberOfCases;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self caseGroupCount] + 1;
}

- (UITableViewCell *)caseCellForIndexPath:(NSIndexPath *)indexPath caseGroup:(NFDCaseGroup *)caseGroup
{
    static NSString *CellIdentifier = @"caseCell";
    NFDCaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NFDCase *thisCase = [caseGroup.cases objectAtIndex:indexPath.row];
    
    cell.flightCase = thisCase;
    
    return cell;
}

- (void)hideFlightInfoInHeaderCell:(NFDCaseSectionHeaderCell *)headerCell
{
    headerCell.departureAirportValue.hidden = YES;
    headerCell.departureDateValue.hidden = YES;
    headerCell.arrivalAirportValue.hidden = YES;
    headerCell.arrivalDateValue.hidden = YES;
    headerCell.arrowLabel.hidden = YES;
}

- (void)showFlightInfoInHeaderCell:(NFDCaseSectionHeaderCell *)headerCell forCaseGroup:(NFDCaseGroup *)caseGroup
{
    headerCell.departureAirportValue.hidden = NO;
    headerCell.departureDateValue.hidden = NO;
    headerCell.arrivalAirportValue.hidden = NO;
    headerCell.arrivalDateValue.hidden = NO;
    headerCell.arrowLabel.hidden = NO;
    
    headerCell.departureAirportValue.text = caseGroup.departureFBO;
    headerCell.departureDateValue.text = [NSString stringFromDate:caseGroup.departureDate formatType:NCLDateFormatDateOnly];
    headerCell.arrivalAirportValue.text = caseGroup.arrivalFBO;
    headerCell.arrivalDateValue.text = [NSString stringFromDate:caseGroup.arrivalDate formatType:NCLDateFormatDateOnly];
}

- (void)createSubHeadingInSectionHeaderCell:(NFDCaseSectionHeaderCell *)headerCell forCaseGroup:(NFDCaseGroup *)caseGroup
{
    NSString *subHeading = caseGroup.numberOfCasesAsString;
    
    if (caseGroup.tail && ![caseGroup.tail isEmptyOrWhitespace]) {
        subHeading = [NSString stringWithFormat:@"%@・%@", subHeading, caseGroup.tail];
    }
    
    if (caseGroup.leadPax && ![caseGroup.leadPax isEmptyOrWhitespace]) {
        subHeading = [NSString stringWithFormat:@"%@・%@", subHeading, caseGroup.leadPax];
    }
    
    if ([caseGroup.legID isEmptyOrWhitespace]) {
        subHeading = [NSString stringWithFormat:@"%@・%@", subHeading, @"No Flight"];
    }
    
    headerCell.subHeadingValue.text = subHeading;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    self.selectedCell = (NFDCaseTableViewCell*)sender;
    
    if ([@"caseDetailSegue" isEqualToString:segue.identifier]) {
        self.caseDetailViewController = segue.destinationViewController;
        NFDCaseTableViewCell *selectedCell = self.selectedCell;
        self.caseDetailViewController.typeCategoryDetailsString = selectedCell.typeCategoryDetailsValue.attributedText;
        self.caseDetailViewController.flightCase = selectedCell.flightCase;
    }
}

- (void)dismissModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
