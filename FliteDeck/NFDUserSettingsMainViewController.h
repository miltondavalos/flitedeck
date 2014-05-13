//
//  NFDUserSettingsViewController.h
//  FliteDeck
//
//  Created by Ryan Smith on 3/15/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface NFDUserSettingsMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UITableView *tView;

- (void)sendFeedback:(id)sender;

@end
