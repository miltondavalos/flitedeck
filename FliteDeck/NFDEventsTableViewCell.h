//
//  NFDEventsTableViewCell.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDEventInformation.h"

@interface NFDEventsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *eventCategory;
@end
