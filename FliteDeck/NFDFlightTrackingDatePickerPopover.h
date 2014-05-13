//
//  NFDFlightTrackingDatePickerPopover.h
//  FlightTracker
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDFlightTrackingDatePickerPopover : UIViewController

@property(nonatomic, retain) UIPopoverController *popoverController;
@property(nonatomic, retain) UITextField *textField;

@property (weak, nonatomic) IBOutlet UIDatePicker *flightSearchDatePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dateSelectedButton;

@end
