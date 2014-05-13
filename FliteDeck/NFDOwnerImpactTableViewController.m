//
//  NFDOwnerImpactTableViewController.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/26/13.
//
//

#import "NFDOwnerImpactTableViewController.h"

@interface NFDOwnerImpactTableViewController ()

@end

@implementation NFDOwnerImpactTableViewController

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ownerImpacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OwnerImpactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *ownerImpact = [self.ownerImpacts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = ownerImpact;
    
    return cell;
}

@end
