//
//  FlightProfileTripEstimatePDF.h
//  FliteDeck
//
//  Created by Mohit Jain on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FlightEstimatorData.h"
#import "AircraftTypeResults.h"
#import "NFDJetResultsView.h"
#import "NFDPDFView.h"

@interface FlightProfileTripEstimatePDF : NFDPDFView <MFMailComposeViewControllerDelegate> 

@property (nonatomic, retain) FlightEstimatorData *parameters;

- (void)setAircraftData:(AircraftTypeResults *)result position: (int) position;

@end
