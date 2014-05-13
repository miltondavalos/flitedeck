//
//  NFDEventsDetailViewController.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"
#import "NFDEventInformation.h"
#import "NFDEventsService.h"

#import "iCarousel.h"

@interface NFDEventsDetailViewController : UIViewController <MGSplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UILabel *name IBOutlet;
@property (strong, nonatomic) UILabel *description IBOutlet;
@property (strong, nonatomic) UILabel *startDate IBOutlet;
@property (strong, nonatomic) UILabel *endDate IBOutlet;
@property (strong, nonatomic) UILabel *location IBOutlet;
@property (strong, nonatomic) iCarousel *carousel IBOutlet;
@property (strong, nonatomic) NFDEventInformation *event;
@property (strong, nonatomic) NFDEventsService *service;
- (void) setData: (NFDEventInformation *) event;
- (IBAction)viewPDF;
@end
