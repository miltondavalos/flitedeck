//
//  NFDFlightProposalMasterViewController.h
//  SplitViewTest
//
//  Created by Geoffrey Goetz on 2/1/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightProposalDetailViewController.h"

@interface NFDFlightProposalMasterViewController :  UIViewController <UITableViewDelegate, NFDProposalParameterUpdater>

@property (weak, nonatomic) IBOutlet UITableView *masterTableView;

@property (strong, nonatomic) NFDFlightProposalDetailViewController *detailViewController;

- (IBAction)clearButtonAction:(id)sender;
- (IBAction)addButtonAction:(id)sender;

- (void)updateProposalParameterData;

@end
