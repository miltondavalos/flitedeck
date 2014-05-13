//
//  NFDRemoteSyncCell.h
//  FliteDeck
//
//  Created by Chad Long on 5/7/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDRemoteSyncCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *syncType;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateDate;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
