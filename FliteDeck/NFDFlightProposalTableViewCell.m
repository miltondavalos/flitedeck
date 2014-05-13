//
//  NFDFlightProposalTableViewCell.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+FliteDeckColors.h"

@implementation NFDFlightProposalTableViewCell

@synthesize detailViewController = _detailViewController;

@synthesize titleLabelView;
@synthesize subtitleLabelView;
@synthesize productIconImageView;
@synthesize checkmarkImageView;
@synthesize topLabel;
@synthesize bottomLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        subtitleLabelView.text = @"";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.contentView.backgroundColor = [UIColor tableViewCellSelectedBackgroundColor];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
    } else {
        self.contentView.backgroundColor = [UIColor tableViewCellDefaultBackgroundColor];
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    }
}

#pragma mark - Manager, Proposal, Results Methods

- (NFDProposal *)retrieveProposalForThisView
{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    return [manager retrieveProposalAtIndex:self.tag];
}

- (void)updateProposalParameterData
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    if (proposal){
        [self.titleLabelView setText:proposal.title];
        [self.subtitleLabelView setText:proposal.subTitle];
        [self.topLabel setText:proposal.topLabel];
        [self.bottomLabel setText:proposal.bottomLabel];
        [self.checkmarkImageView setHidden:!proposal.selected];
    }
}

- (void)selectProposal{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    if ([manager hasProposals]){
        [self.detailViewController.view setTag:self.tag];
        [self.detailViewController updateProposalParameterData];
    }
}

- (void)toggleChecked{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    NFDProposal *proposal;
    if ([manager hasProposals]){
        proposal = [manager retrieveProposalAtIndex:self.tag];

        if ([self.checkmarkImageView isHidden])
        {
            if (proposal.relatedProposal)
            {
                if ([manager totalCountOfSelectedProposals] < MAX_SELECTED_PROPOSALS - 1)
                {
                    [self.checkmarkImageView setHidden:NO];
                    [proposal setSelected:YES];
                    [proposal.relatedProposal setSelected:YES];
                    [manager.selectedProposals setObject:proposal forKey:[NSNumber numberWithInt:self.tag]];
                    [manager.selectedProposals setObject:proposal.relatedProposal forKey:[NSNumber numberWithInt:-1*(self.tag+2)]]; //yeah, that's right: -1 * (self.tag + 2)
                }
            }
            else if ([manager totalCountOfSelectedProposals] < MAX_SELECTED_PROPOSALS)
            {
                [self.checkmarkImageView setHidden:NO];
                [proposal setSelected:YES];
                [manager.selectedProposals setObject:proposal forKey:[NSNumber numberWithInt:self.tag]];
            }
            
        }
        else
        {
            [self.checkmarkImageView setHidden:YES];
            [proposal setSelected:NO];
            [manager.selectedProposals removeObjectForKey:[NSNumber numberWithInt:self.tag]];
            if (proposal.relatedProposal)
            {
                [proposal.relatedProposal setSelected:NO];
                [manager.selectedProposals removeObjectForKey:[NSNumber numberWithInt:-1*(self.tag+2)]];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PROPOSAL_SELECTION_UPDATED object:nil];
}

@end
