//
//  NFDRemoteSyncVC.h
//  FliteDeck
//
//  Created by Chad Long on 5/4/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDRemoteSyncVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithFrame:(CGRect)frame;
- (void)dataSyncCompleted:(NSNotification*)notification;

@end
