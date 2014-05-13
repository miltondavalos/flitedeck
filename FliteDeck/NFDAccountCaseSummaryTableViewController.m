//
//  NFDAccountCaseSummaryTableViewController.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/30/13.
//
//

#import "NFDAccountCaseSummaryTableViewController.h"
#import "NFDCaseSummaryCell.h"

@interface NFDAccountCaseSummaryTableViewController ()

@end

@implementation NFDAccountCaseSummaryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.flight) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 35.0;
    }
    
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CaseSummaryHeaderCellIdentifier = @"CaseSummaryHeader";
        NFDCaseSummaryCell *cell = (NFDCaseSummaryCell *)[tableView dequeueReusableCellWithIdentifier:CaseSummaryHeaderCellIdentifier forIndexPath:indexPath];
        
        if (self.flight.customerSinceDate) {
            NSString *sinceString = [NSString stringFromDate:self.flight.customerSinceDate formatType:NCLDateFormatDateOnly timezone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
            cell.customerSinceValue.text = [NSString stringWithFormat:@"Customer since %@", sinceString];
        } else {
            cell.customerSinceValue.text = @"";
        }
        
        return cell;
        
    } else {
        static NSString *CaseSummaryCellIdentifier = @"CaseSummaryCell";
        NFDCaseSummaryCell *cell = (NFDCaseSummaryCell *)[tableView dequeueReusableCellWithIdentifier:CaseSummaryCellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == 1) {
            cell.countValue.text = self.flight.accountTotalCount;
            cell.countDescriptor.text = @"Account Cases";
        } else if (indexPath.row == 2) {
            cell.countValue.text = self.flight.accountOpenCount;
            cell.countDescriptor.text = @"Open Account Cases";
        } else if (indexPath.row == 3) {
            cell.countValue.text = self.flight.accountControllableCount;
            cell.countDescriptor.text = @"Open Controllable Account Cases";
        }
        
        return cell;
    }
}

@end
