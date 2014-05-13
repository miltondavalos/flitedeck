//
//  NJAppDelegate.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFileSystemHelper.h"
#import "Prospect.h"
#import "NFDPersistenceManager.h"
#import <HockeySDK/HockeySDK.h>

@class NFDViewController;

@interface NFDAppDelegate : UIResponder <UIApplicationDelegate, BITHockeyManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NFDViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableDictionary *session;
@property (strong, nonatomic) NFDPersistenceManager *pm;

@end
