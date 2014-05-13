//
//  LaunchPadPage.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NFDLaunchPadButton;
@interface NFDLaunchPadPage : UIView

@property(strong,nonatomic) NSMutableArray *buttons;

-(NFDLaunchPadButton *) addLauncher : (NSString *) title  imageName: (NSString *) imageName  notificationToFire: (NSString *) notificationToFire;
-(void) doLayout;
@end
