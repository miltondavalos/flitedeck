//
//  NFDFlightProposalInventoryTableViewCell.h
//  FliteDeck
//
//  Created by Chad Predovich on 3/15/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDFlightProposalInventoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noAircraftAvailableMessage;
@property (weak, nonatomic) IBOutlet UILabel *column1Label;
@property (weak, nonatomic) IBOutlet UILabel *column2Label;
@property (weak, nonatomic) IBOutlet UILabel *column3Label;
@property (weak, nonatomic) IBOutlet UILabel *column4Label;
@property (weak, nonatomic) IBOutlet UILabel *column5Label;
@property (weak, nonatomic) IBOutlet UILabel *column6Label;

@end
