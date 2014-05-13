//
//  NFDFlightTrackerAirportSearchViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/21/13.
//
//

#import "NFDFlightTrackerBaseSearchViewController.h"

#import "NFDCalendarDateRangePickerViewController.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAirportSelectorViewController.h"
#import "UIView+FrameUtilities.h"

@interface NFDFlightTrackerBaseSearchViewController ()

@end

@implementation NFDFlightTrackerBaseSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor tintColorForLightBackground];
        
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.searchButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateHighlighted];
    [self.searchButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateSelected];
    [self.searchButton setTitleColor:[UIColor buttonTitleColorDisabled] forState:UIControlStateDisabled];
    
    self.searchButton.backgroundColor = [UIColor buttonBackgroundColorEnabled];
    self.searchButton.layer.cornerRadius = 4.0;
    
    self.startDate = [NSDate date];
    self.dateRangeLabel.text = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.errorLabel.text = @"";

    if (self.presentingPopoverController && self.initialHeight) {
        CGSize size = CGSizeMake(self.view.frame.size.width, [self.initialHeight floatValue]);
        [self.presentingPopoverController setPopoverContentSize:size animated:YES];
    }
    
    if (!self.initialHeight) {
        self.initialHeight = [NSNumber numberWithFloat:self.view.frame.size.height];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"selectDates" isEqualToString:segue.identifier]) {
        
        __block __weak NFDCalendarDateRangePickerViewController *calendarViewController = segue.destinationViewController;
        
        calendarViewController.configureBlock = ^{
        
            // Limit the calendar to 2 years from today's date.
            calendarViewController.calendarView.firstDate = [[NSDate date] dateByAddingComponent:NSMonthCalendarUnit amount:-24];
            calendarViewController.calendarView.lastDate = [[NSDate date] dateByAddingComponent:NSMonthCalendarUnit amount:24];
            calendarViewController.calendarView.pagingEnabled=NO;
            
            calendarViewController.view.tintColor = [UIColor tintColorForLightBackground];
            calendarViewController.calendarView.tintColor = [UIColor tintColorForLightBackground];
        
        };

        calendarViewController.delegate = self;
    }
    
    
}


- (void) dateRangeChangedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if (startDate) self.startDate = startDate;  // Only update a non-nil startDate
    self.endDate = endDate;
    
    if (self.startDate) {
        NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
        if (self.startDate && self.endDate) {
            NSString *endDateText = [NSString stringFromDate:self.endDate formatType:NCLDateFormatDateOnly];
            
            [self.dateRangeLabel setText:[NSString stringWithFormat:@"%@ - %@", startDateText, endDateText]];
        } else {
            [self.dateRangeLabel setText: startDateText];
        }
    }
}


@end
