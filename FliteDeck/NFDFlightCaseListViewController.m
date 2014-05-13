//
//  NFDFlightCaseListViewController.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/31/13.
//
//

#import "NFDFlightCaseListViewController.h"

@interface NFDFlightCaseListViewController ()

@end

@implementation NFDFlightCaseListViewController

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
    return [self.caseGroups objectAtIndex:section];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 66.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NFDCaseSectionHeaderCell *headerCell;

    static NSString *HeaderCellIdentifierForFlightType = @"flightCaseWithAccountNameSectionHeader";
    headerCell = (NFDCaseSectionHeaderCell *)[self.tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifierForFlightType];
    headerCell.accountNameValue.text = self.accountName;
    
    if ([self caseGroupCount] == 0) {
        headerCell.subHeadingValue.text = @"No cases for this flight";
        
        [self hideFlightInfoInHeaderCell:headerCell];
    } else {
        NFDCaseGroup *caseGroup = [self caseGroupForSection:section];
        
        [self createSubHeadingInSectionHeaderCell:headerCell forCaseGroup:caseGroup];
        
        [self showFlightInfoInHeaderCell:headerCell forCaseGroup:caseGroup];
    }
    
    return headerCell.contentView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self caseGroupCount] == 0) {
        return 0;
    }
    
    NFDCaseGroup *caseGroup = [self caseGroupForSection:section];
    
    return caseGroup.cases.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CASE_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFDCaseGroup *caseGroup = [self caseGroupForSection:indexPath.section];
    return [self caseCellForIndexPath:indexPath caseGroup:caseGroup];
}

@end
