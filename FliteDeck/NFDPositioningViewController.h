//
//  NFDPositioningViewController.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/23/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDPositioningCell.h"
#import "NFDPositioningService.h"
#import "NFDPositioningRowHeightHelper.h"
#import "NFDCompany.h"
#import "NFDPositioningMatrix.h"
#import "NFDAircraftMiniList.h"
#import "NFDPositioningHeader.h"
#import "NFDPositioningModal.h"
#import "NFDPositioningButton.h"
#import "NFDNetJetsStyleHelper.h"

@interface NFDPositioningViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) IBOutlet UITableView *theTable;
@property (nonatomic,strong) NSArray *competitors;
@property (nonatomic,strong) NSArray *manufacturers;
@property (nonatomic,strong) NSArray *infoRows;
@property (nonatomic,strong) NSMutableDictionary *heights;
@property (nonatomic,strong) NFDPositioningService *service;
@property (nonatomic,strong) UINavigationController *modalNavigationController;
@property (nonatomic,strong) NFDPositioningHeader *header;
-(void) displayAircraftPopup : (NSNotification*)  notification;
-(void) displayCompanyPopup : (NSNotification*)  notification;
-(void) resetPopupSize;
-(void) showOperators: (NSNotification *) notification ;
-(void) showManufacturers: (NSNotification *) notification;
@end
