//
//  LaunchPadButton.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDLaunchPadButton : UIView
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *notification;
@property (strong,nonatomic) NSString *imagename;
@property (strong,nonatomic) NSString *imagenameselected;
@property  (strong,nonatomic) UIButton *button IBOutlet;
@property  (strong,nonatomic) UILabel *titleLabel IBOutlet;
-(void) setup;

@end
