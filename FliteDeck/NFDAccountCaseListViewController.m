//
//  NFDAccountCaseListViewController.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/31/13.
//
//

#import "NFDAccountCaseListViewController.h"

@interface NFDAccountCaseListViewController ()

@end

@implementation NFDAccountCaseListViewController

-(id)init
{
    self = [super init];
    if (self) {
        _isLoading = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NFDCaseGroup *)caseGroupForSection:(NSInteger)section
{
    if (section > 0) {
        return [self.caseGroups objectAtIndex:section - 1];
    }
    
    return nil;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return 45.0;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    NFDCaseGroup *caseGroup = [self caseGroupForSection:section];
    
    static NSString *HeaderCellIdentifierForAccountType = @"flightCaseSectionHeader";
    NFDCaseSectionHeaderCell *headerCell = (NFDCaseSectionHeaderCell *)[self.tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifierForAccountType];
    
    if ([caseGroup.legID isEmptyOrWhitespace]) {
        [self hideFlightInfoInHeaderCell:headerCell];
    } else {
        [self showFlightInfoInHeaderCell:headerCell forCaseGroup:caseGroup];
    }
    
    [self createSubHeadingInSectionHeaderCell:headerCell forCaseGroup:caseGroup];
    
    return headerCell.contentView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    NFDCaseGroup *caseGroup = [self caseGroupForSection:section];
    
    return caseGroup.cases.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 73.0;
    }
    
    return CASE_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifierForAccountHeader = @"accountNameSectionHeader";
        NFDCaseSectionHeaderCell *headerCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifierForAccountHeader forIndexPath:indexPath];
        headerCell.accountNameValue.text = self.accountName;
        
        NSString *subHeadingText;
        
        if (self.isLoading) {
            headerCell.loadingCasesActivityIndicator.hidden = NO;
            headerCell.controllableCasesHeadingValue.hidden = YES;
            [headerCell.loadingCasesActivityIndicator startAnimating];
            
        } else if ([self caseGroupCount] == 0) {
            headerCell.loadingCasesActivityIndicator.hidden = YES;
            headerCell.controllableCasesHeadingValue.hidden = NO;
            subHeadingText = @"No account cases";
            
        } else {
            headerCell.loadingCasesActivityIndicator.hidden = YES;
            headerCell.controllableCasesHeadingValue.hidden = NO;
            NSString *casesString = ([self totalNumberOfCasesDisplayed] == 1) ? @"case" : @"cases";
            
            subHeadingText = [NSString stringWithFormat:@"%i controllable account %@ in the last 3 months", [self totalNumberOfCasesDisplayed], casesString];
        }
        
        headerCell.controllableCasesHeadingValue.text = subHeadingText;
        
        return headerCell;
    } else {
        NFDCaseGroup *caseGroup = [self caseGroupForSection:indexPath.section];
        return [self caseCellForIndexPath:indexPath caseGroup:caseGroup];
    }
}

@end
