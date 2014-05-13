//
//  NFDFlightTrackerSortByViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 12/5/13.
//
//

#import "NFDFlightTrackerSortByViewController.h"

#import "UIColor+FliteDeckColors.h"

@interface NFDFlightTrackerSortByViewController ()

@end

@implementation NFDFlightTrackerSortByViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.tintColor = [UIColor tintColorForLightBackground];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.sortBy inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"sortBySelectedUnwind" isEqualToString:segue.identifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        self.sortBy = indexPath.row;
    }
}

#pragma mark - Table view data source


@end
