//
//  NFDEventsMasterViewController.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDEventsDetailViewController.h"
#import "NFDEventsService.h"
#import "NFDEventInformation.h"
#import "NFDEventsTableViewCell.h"
#import "NFDPDFViewController.h"
#import "ReaderViewController.h"

@interface NFDEventsMasterViewController : UIViewController <UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *masterTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *eventSearchBar;

@property (strong, nonatomic) NFDPDFViewController *pdfViewController;
@property (strong, nonatomic) ReaderViewController *readerViewController;

@property (strong,nonatomic) NFDEventsDetailViewController *detailViewController;
@property (strong,nonatomic) NFDEventsService *service;
@property (strong,nonatomic) NSArray *events;
@property (strong,nonatomic) NFDEventInformation *selectedEvent;
- (void) updateTableViewWithNewevents;

@end
