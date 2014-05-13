//
//  NFDFlightTrackerPassengerTableViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/29/13.
//
//

#import "NFDFlightTrackerPassengerTableViewController.h"

#import "NFDPassenger.h"

@interface NFDFlightTrackerPassengerTableViewController ()

@end

@implementation NFDFlightTrackerPassengerTableViewController

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
    if (self.flight && self.flight.passengers) {
        return [self.flight.passengers count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PassengerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NFDFlight *theFlight = self.flight;
    
    if ((theFlight) && [theFlight.passengers count] > 0) {
        NFDPassenger *passenger = [theFlight.passengers objectAtIndex:indexPath.row];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.000 alpha:1.000];
        NSString *displayName = [NSString stringWithFormat:@"%@ %@", passenger.firstName, passenger.lastName];
        if (![displayName isEmptyOrWhitespace]){
            cell.textLabel.text = displayName;
        }else {
            cell.textLabel.text = @"Unknown";
        }
    } else {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.446 alpha:1.000];
        cell.textLabel.text = @"No passengers";
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
@end
