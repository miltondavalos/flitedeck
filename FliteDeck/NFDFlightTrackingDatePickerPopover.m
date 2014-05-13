//
//  NFDFlightTrackingDatePickerPopover.m
//  FlightTracker
//
//  Created by Geoffrey Goetz on 2/3/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightTrackingDatePickerPopover.h"

@implementation NFDFlightTrackingDatePickerPopover

@synthesize popoverController;
@synthesize textField;

@synthesize flightSearchDatePicker;
@synthesize dateSelectedButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dateSelectedButton setAction:@selector(selectedDate)];
}

- (void)viewDidUnload
{
    [self setFlightSearchDatePicker:nil];
    [self setDateSelectedButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Date Selected

- (void)selectedDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    if (self.textField){
        [textField setText:[dateFormat stringFromDate:flightSearchDatePicker.date]];
    }
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
    }
}

@end
