//
//  NCLAnalyticsTableViewCell.m
//  NCLFramework
//
//  Created by Chad Long on 11/11/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLAnalyticsTableViewCell.h"

@interface NCLAnalyticsTableViewCell()

@property (nonatomic, strong) NSMutableArray *viewConstraints;

@end

@implementation NCLAnalyticsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.viewConstraints = [NSMutableArray new];
        
        self.createdLabel = [[UILabel alloc] init];
        self.createdLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.createdLabel];
        
        self.actionLabel = [[UILabel alloc] init];
        self.actionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.actionLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.actionLabel];

        self.elapsedTimeLabel = [[UILabel alloc] init];
        self.elapsedTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.elapsedTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.elapsedTimeLabel];
        
        self.errorLabel = [[UILabel alloc] init];
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.errorLabel.textColor = [UIColor redColor];
        self.errorLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.errorLabel];

        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.valueLabel.textColor = [UIColor darkGrayColor];
        self.valueLabel.numberOfLines = 1;
        [self.contentView addSubview:self.valueLabel];
    }
    
    return self;
}

#pragma mark - autolayout constraint management

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    [super updateConstraints];

    // reset constraints
    [self.contentView removeConstraints:self.viewConstraints];
    [self.viewConstraints removeAllObjects];

    // build constraints
    NSDictionary *variableBindings = NSDictionaryOfVariableBindings(_createdLabel, _actionLabel, _elapsedTimeLabel, _errorLabel, _valueLabel);

    [self.createdLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.actionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.elapsedTimeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.errorLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [self.viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_createdLabel]-10-[_valueLabel]-10-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:variableBindings]];

    [self.viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_createdLabel]-10-[_actionLabel]-(>=10)-[_elapsedTimeLabel]-10-[_errorLabel]-10-|"
                                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                                      metrics:nil
                                                                                        views:variableBindings]];

    [self.viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_valueLabel]-10-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:variableBindings]];

    [self.contentView addConstraints:self.viewConstraints];
}

@end