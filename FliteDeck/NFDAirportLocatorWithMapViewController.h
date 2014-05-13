//
//  NFDAirportLocatorWithMapViewController.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/21/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NFDAirportLocatorWithMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
{
}

@property (weak, nonatomic) IBOutlet MKMapView *airportMap;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
