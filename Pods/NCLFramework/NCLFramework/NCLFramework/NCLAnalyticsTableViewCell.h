//
//  NCLAnalyticsTableViewCell.h
//  NCLFramework
//
//  Created by Chad Long on 11/11/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCLAnalyticsTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *createdLabel;
@property (strong, nonatomic) UILabel *actionLabel;
@property (strong, nonatomic) UILabel *elapsedTimeLabel;
@property (strong, nonatomic) UILabel *valueLabel;
@property (strong, nonatomic) UILabel *errorLabel;

@end
