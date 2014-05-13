//
//  NCLErrorView.h
//  Waypoint
//
//  Created by Chad Long on 3/14/13.
//  Copyright (c) 2013 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class NCLMessagePresenter;

@interface NCLMessageView : UIView

@property (nonatomic, strong) CALayer *topBorder;
@property (nonatomic, strong) CALayer *rectLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *closeImage;
@property (nonatomic, strong) NCLMessagePresenter *delegate;

@end
