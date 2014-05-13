//
//  NFDFlightProposalInventoryTableViewCell.m
//  FliteDeck
//
//  Created by Chad Predovich on 3/15/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalInventoryTableViewCell.h"

@implementation NFDFlightProposalInventoryTableViewCell
@synthesize noAircraftAvailableMessage;
@synthesize column1Label;
@synthesize column2Label;
@synthesize column3Label;
@synthesize column4Label;
@synthesize column5Label;
@synthesize column6Label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
