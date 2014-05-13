//
//  NCLErrorView.m
//  Waypoint
//
//  Created by Chad Long on 3/14/13.
//  Copyright (c) 2013 NetJets. All rights reserved.
//

#import "NCLMessageView.h"
#import <NCLFramework.h>
#import "UIApplication+Utility.h"
#import "NCLMessagePresenter.h"
#import "UIImage+Utility.h"

@interface NCLMessageView()

@property (nonatomic, strong) NSMutableArray *viewConstraints;

@end

@implementation NCLMessageView
{
    UIColor *gradientColor;
    BOOL isDark;
    NSLayoutConstraint *heightConstraint;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // register for orientation change notifications
        self.viewConstraints = [NSMutableArray new];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = YES;

        self.topBorder = [CALayer layer];
        self.topBorder.frame = CGRectMake(0, 0, self.frame.size.width, 1.0f);
        self.topBorder.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
        [[self layer] addSublayer:self.topBorder];
        
        self.rectLayer = [CALayer layer];
        self.rectLayer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
        self.rectLayer.frame = CGRectInset(self.bounds, 2, 2);
        self.rectLayer.borderColor = [UIColor clearColor].CGColor;
        self.rectLayer.borderWidth = 1.0;
        [self.layer addSublayer:self.rectLayer];
        
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.bounds;
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.text = @"";
        [self addSubview:self.textLabel];
        
        // setup the close image w/ proper overlay
        self.closeImage = [[UIImageView alloc] init];
        self.closeImage.translatesAutoresizingMaskIntoConstraints = NO;
        self.closeImage.frame = CGRectMake(0, 0, 20, 20);
        self.closeImage.backgroundColor = [UIColor clearColor];
        [self addSubview:self.closeImage];
        
        // setup tap to close
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self setGestureRecognizers:@[tap]];
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    gradientColor = backgroundColor;
    
    // depending on the back color setting, use white or black
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    isDark = red + green + blue > 1.5 ? NO : YES;
    
    if (isDark)
    {
        self.closeImage.image = [UIImage imageNamed:@"close.png"];
        self.rectLayer.borderColor = [UIColor colorWithWhite:1.0 alpha:.75].CGColor;
        self.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.closeImage.image = [[UIImage imageNamed:@"close.png"] imageWithOverlayColor:[UIColor blackColor]];
        self.rectLayer.borderColor = [UIColor colorWithWhite:0.0 alpha:.75].CGColor;
        self.textLabel.textColor = [UIColor blackColor];
    }
    
    // update gradient layer
    [gradientColor getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor *start = [UIColor colorWithRed:MIN(red*1.2, 1) green:MIN(green*1.2, 1) blue:MIN(blue*1.2, 1) alpha:1];
    self.gradientLayer.colors = [NSArray arrayWithObjects:(id)start.CGColor, (id)gradientColor.CGColor, nil];
}

- (void)handleTap:(UIGestureRecognizer*)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         [self setAlpha:0.0];
     }
                     completion:^(BOOL finished)
     {
         [self.delegate popViewWithText:self.textLabel.text];
         [self removeFromSuperview];
     }];
}

#pragma mark - autolayout constraint management

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    [super updateConstraints];

    [self removeConstraints:self.viewConstraints];
    [self.viewConstraints removeAllObjects];
    
    [self.viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[_textLabel]-5-[_closeImage(==20)]-10-|"
                                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                                      metrics:nil
                                                                                        views:NSDictionaryOfVariableBindings(_textLabel, _closeImage)]];
    
    [self.viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=10)-[_textLabel]-(>=10)-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:NSDictionaryOfVariableBindings(_textLabel)]];

    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_textLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
    
    NSLayoutConstraint *minHeightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:44];
    minHeightConstraint.priority = UILayoutPriorityFittingSizeLevel;
    [self.viewConstraints addObject:minHeightConstraint];

    NSLayoutConstraint *heightLimitConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1
                                                                              constant:320];
    heightLimitConstraint.priority = UILayoutPriorityDefaultLow;
    [self.viewConstraints addObject:heightLimitConstraint];
    
    [self addConstraints:self.viewConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.textLabel setPreferredMaxLayoutWidth:self.frame.size.width - (35+5+20+10)];
    });
}

-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    // reset frames for the border layers
    self.topBorder.frame = CGRectMake(0, 0, self.frame.size.width, 1.0f);
    self.rectLayer.frame = CGRectInset(self.bounds, 2, 2);
    self.gradientLayer.frame = self.bounds;
}

@end

