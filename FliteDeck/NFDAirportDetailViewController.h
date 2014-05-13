//
//  NFDAirportDetailViewController.h
//  FliteDeck
//
//  Created by Chad Long on 6/13/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>

@interface NFDAirportDetailViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *airportID;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *airportSummaryView;
@property (weak, nonatomic) IBOutlet UILabel *navBarTitle;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIImageView *customsImage;
@property (weak, nonatomic) IBOutlet UIImageView *fuelImage;
@property (weak, nonatomic) IBOutlet UIImageView *slotsImage;
@property (weak, nonatomic) IBOutlet UIImageView *vfrImage;
@property (weak, nonatomic) IBOutlet UIButton *restrictionsBtn;
@property (weak, nonatomic) IBOutlet UIButton *fboOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *fboTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *fboThreeBtn;
@property (weak, nonatomic) IBOutlet UIView *runwayView;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLbl;
@property (weak, nonatomic) IBOutlet UILabel *runwayLbl;

- (IBAction)fboOneSelected:(id)sender;
- (IBAction)fboTwoSelected:(id)sender;
- (IBAction)fboThreeSelected:(id)sender;
- (IBAction)prohibitedSelected:(id)sender;

- (IBAction)closeMapView:(id)sender;

@end