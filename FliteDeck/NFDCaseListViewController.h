//
//  NFDCaseListViewController.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/16/13.
//
//

#import <UIKit/UIKit.h>
#import "NFDCase.h"
#import "NFDCaseGroup.h"
#import "NFDCaseSectionHeaderCell.h"

#define CASE_CELL_HEIGHT 177.0

@interface NFDCaseListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *flightDetailsView;
@property (strong, nonatomic) NSString *accountName;

@property (strong, nonatomic) NSMutableArray *caseGroups;

- (NSUInteger)caseGroupCount;
- (NSUInteger)totalNumberOfCasesDisplayed;
- (UITableViewCell *)caseCellForIndexPath:(NSIndexPath *)indexPath caseGroup:(NFDCaseGroup *)caseGroup;
- (void)hideFlightInfoInHeaderCell:(NFDCaseSectionHeaderCell *)headerCell;
- (void)showFlightInfoInHeaderCell:(NFDCaseSectionHeaderCell *)headerCell forCaseGroup:(NFDCaseGroup *)caseGroup;
- (void)createSubHeadingInSectionHeaderCell:(NFDCaseSectionHeaderCell *)headerCell forCaseGroup:(NFDCaseGroup *)caseGroup;

@end
