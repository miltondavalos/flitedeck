//
//  NFDAirportSelectorViewController.h
//  FliteDeck
//
//  Created by Chad Predovich on 11/20/13.
//
//

#import <UIKit/UIKit.h>

@class NFDAirport;

@interface NFDAirportSelectorViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *airportSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NFDAirport *selectedAirport;

@end
