//
//  NFDFlightProposalTableViewCell.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightProposalDetailViewController.h"
#import "NFDFlightProposalManager.h"
#import "NFDProposal.h"

@interface NFDFlightProposalTableViewCell : UITableViewCell {
}

@property (strong, nonatomic) NFDFlightProposalDetailViewController *detailViewController;

@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabelView;
@property (weak, nonatomic) IBOutlet UIImageView *productIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

-(void)updateProposalParameterData;

-(void)toggleChecked;
-(void)selectProposal;

@end
