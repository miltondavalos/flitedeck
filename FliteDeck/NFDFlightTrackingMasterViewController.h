//
//  NFDFlightTrackingMasterViewController.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightTrackingDetailViewController.h"

@interface NFDFlightTrackingMasterViewController : UIViewController <UITableViewDelegate>{

    BOOL searching;

}

@property (weak, nonatomic) IBOutlet UITableView *masterTableView;

@property(nonatomic, assign, getter=isSearching) BOOL searching;
@property (strong, nonatomic) NFDFlightTrackingDetailViewController *detailViewController;

- (IBAction)sortByButtonAction:(id)sender;

- (void) updateTableViewWithNewResults;

@end
