//
//  NFDFlightTrackingSearchVC.m
//  FliteDeck
//
//  Created by Chad Long on 5/18/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFDFlightTrackingSearchViewController.h"
#import "NFDFlightTrackingManager.h"
#import "NFDUserManager.h"
#import "NCLFramework.h"
#import "NFDFlightTrackingDatePickerPopover.h"
#import "NFDCalendarDatePickerViewController.h"
#import "UIColor+FliteDeckColors.h"
#import "UIView+FrameUtilities.h"

@interface NFDFlightTrackingSearchViewController ()  <TSQCalendarViewDelegate>

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) NFDCalendarDatePickerViewController *calendarViewController;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (nonatomic) BOOL datePickingStarted;

@property (nonatomic) BOOL dateRangeEnabled;

@end

@implementation NFDFlightTrackingSearchViewController

@synthesize btnSearch;
@synthesize lblSearchType;
@synthesize viewSearchAirport;
@synthesize txtSearchValue;
@synthesize txtSearchDate;
@synthesize popoverController;

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dateRangeEnabled = YES;
    }
    return self;
}

- (void)changeErrorMessage:(NSString *)text
{
    if (text) {
        self.validationMessageLabel.hidden = NO;
        self.validationMessageLabel.text = text;
    } else {
        self.validationMessageLabel.hidden = YES;
    }
}

#pragma mark - UISearchBarDelegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [searchBar.text length] + [text length] - range.length;
    return (newLength > 50) ? NO : YES;
}

#pragma mark - UIPopoverControllerDelegate Methods

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // when date field gets focus, dismiss keyboard (if required), and show date picker popup
    if (textField == self.txtSearchDate)
    {
        if (self.view.tag == SEARCH_BY_AIRPORT)
            [self.viewSearchAirport.airportSearchBar resignFirstResponder];
        else
            [self.txtSearchValue resignFirstResponder];
        
        if (popoverController == nil)
        {
            self.datePickingStarted = YES;
            self.calendarViewController = [[NFDCalendarDatePickerViewController alloc]
                              initWithConfigureBlock:^(void) {
                                  [self configureCalendar];
                              } andDoneBlock:nil];
            
            self.popover = [[UIPopoverController alloc] initWithContentViewController:self.calendarViewController];
            [self.popover setPopoverContentSize:CGSizeMake(320, 630)];
            [self.popover presentPopoverFromRect:textField.frame  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            __block NFDFlightTrackingSearchViewController *weakSelf = self;
            self.calendarViewController.doneBlock = ^{
                [weakSelf.popover dismissPopoverAnimated:YES];
            };
        }
        
        [popoverController presentPopoverFromRect:txtSearchDate.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        popoverController.delegate = self;

        return NO;
    }

    return YES;
}

- (void) configureCalendar
{
    // Limit the calendar to 2 years from today's date.
    self.calendarViewController.calendarView.firstDate = [[NSDate date] dateByAddingComponent:NSMonthCalendarUnit amount:-24];
    self.calendarViewController.calendarView.lastDate = [[NSDate date] dateByAddingComponent:NSMonthCalendarUnit amount:24];
    self.calendarViewController.calendarView.backgroundColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
    self.calendarViewController.calendarView.delegate = self;
    self.calendarViewController.calendarView.pagingEnabled=NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // enforce uppercase letters for tail number
    if (self.view.tag == SEARCH_BY_AIRCRAFT)
    {
        NSRange lowercaseCharRange;
        lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
        
        if (lowercaseCharRange.location != NSNotFound)
        {
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Button actions

- (BOOL)isEmptyOrWhitespace: (NSString *) text {
    return !text.length ||
    ![text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (BOOL) dateRangeValid
{
    BOOL valid = YES;
    if (self.startDate && self.endDate) {
        NSUInteger maxDateRange = 31;  // Note date range is inclusive of start and end date
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.startDate toDate:self.endDate options:0];
        if (dateComponents.day >= maxDateRange) {
            [self changeErrorMessage:[NSString stringWithFormat: @"Selected range of %d days exceeds the %d day maximum range.", dateComponents.day+1, maxDateRange]];
            valid = NO;
        }
    }
    return valid;
}

- (IBAction)executeSearch:(id)sender
{
    [self.view findAndResignFirstResponder];
    
    [self changeErrorMessage:nil];

    NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
    NSString *endDateText = [NSString stringFromDate:self.endDate formatType:NCLDateFormatDateOnly];
    if (!endDateText || [self isEmptyOrWhitespace: endDateText]) {
        endDateText = startDateText;
    }
    
    if (![self dateRangeValid]) {
        return;
    }
    
    switch (self.view.tag)
    {
        case SEARCH_BY_SVPAE:
        {
            NSString *email = self.txtSearchValue.text;
            
            if (![email isValidEmail]) {
                email = [email createNetJetsEmail];
            }
            
            if (email.length > 4)
            { 
                [[NFDFlightTrackingManager sharedInstance] findFlightsBySVP:email startDate:startDateText endDate:endDateText];
                [self dismissModal];
            } else {
                [self changeErrorMessage:@"SVP/AE required"];
            }
            
            break;
        }
        case SEARCH_BY_AIRCRAFT:
        {
            if (self.txtSearchValue.text.length > 0)
            { 
                [[NFDFlightTrackingManager sharedInstance] findFlightsByTailNumber:txtSearchValue.text startDate:startDateText endDate:endDateText];
                [self dismissModal];
            } else {
                [self changeErrorMessage:@"Aircraft required"];
            }
            
            break;
        }
        case SEARCH_BY_AIRPORT:
        {
            if (self.viewSearchAirport.selectedAirport != nil)
            {
                BOOL onlySearchFerryFlights = [self.flightTypeSegmentedControl selectedSegmentIndex] == 1;
                
                [[NFDFlightTrackingManager sharedInstance] findFlightsByAirportId:self.viewSearchAirport.selectedAirport.airportid startDate:startDateText endDate:endDateText onlyFerryFlights:onlySearchFerryFlights];
                [self dismissModal];
            } else {
                [self changeErrorMessage:@"Airport required"];
            }
            
            break;
        }
    }
}

- (void)dismissModal
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor modalBackgroundColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModal)];
    
    [self changeErrorMessage:nil];
    
    [self.txtSearchValue setDelegate:self];
    [self.txtSearchDate setDelegate:self];
    
    // override the size of the airport picker
    self.viewSearchAirport.airportSearchBar.frame = CGRectMake(0, 0, 350, 31);
    self.viewSearchAirport.airportSearchBar.barTintColor = [UIColor clearColor];
    
    self.validationMessageLabel.layer.cornerRadius = 5.0;
    self.validationMessageLabel.backgroundColor = [UIColor errorBackgroundColor];
}

- (void)viewDidUnload
{
    [self setLblSearchType:nil];
    [self setTxtSearchValue:nil];
    [self setTxtSearchDate:nil];
    [self setBtnSearch:nil];
    
    [self setViewSearchAirport:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    // default the date to today
    self.startDate =[NSDate date];
    self.endDate = self.startDate;
    [self.txtSearchDate setText:[NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly]];
     
    // setup the search value field
    switch (self.view.tag)
    {
        case SEARCH_BY_SVPAE:
        {
            [self setTitle:@"Search by SVP/AE"];
            [self.lblSearchType setText:@"SVP/AE"];
            self.txtSearchValue.placeholder = @"Username";
            self.txtSearchValue.textAlignment = NSTextAlignmentRight;
            self.txtSearchValue.autocorrectionType = UITextAutocorrectionTypeNo;
            self.txtSearchValue.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.txtSearchValue.spellCheckingType = UITextSpellCheckingTypeNo;
            self.txtSearchValue.keyboardType = UIKeyboardTypeEmailAddress;            
            self.txtSearchValue.clearButtonMode = UITextFieldViewModeAlways;
            [self.viewSearchAirport setHidden:YES];
            [self.flightTypeSegmentedControl setHidden:YES];
            [self.txtSearchValue setHidden:NO];
            [self.netjetsEmailLabel setHidden:NO];
            
            // default the email if available
            NSString *email = [[NFDUserManager sharedManager] username];
            
            if (email &&
                email.length > 0)
            {
                [self.txtSearchValue setText:email];
            }
            
            [self.txtSearchValue becomeFirstResponder];
            
            break;
        }
        case SEARCH_BY_AIRCRAFT:
        {
            [self setTitle:@"Search by Tail"];
            [self.lblSearchType setText:@"Aircraft"];
            self.txtSearchValue.placeholder = @"Tail #  (e.g., N125QS)";
            self.txtSearchValue.textAlignment = NSTextAlignmentLeft;
            self.txtSearchValue.autocorrectionType = UITextAutocorrectionTypeYes;
            self.txtSearchValue.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            self.txtSearchValue.spellCheckingType = UITextSpellCheckingTypeNo;
            self.txtSearchValue.keyboardType = UIKeyboardTypeDefault;
            [self.viewSearchAirport setHidden:YES];
            [self.flightTypeSegmentedControl setHidden:YES];
            [self.txtSearchValue setHidden:NO];
            [self.netjetsEmailLabel setHidden:YES];
            
            [self.txtSearchValue becomeFirstResponder];
            
            break;
        }
        case SEARCH_BY_AIRPORT:
        default:
        {
            [self setTitle:@"Search by Airport"];
            [self.lblSearchType setText:@"Airport"];
            [self.viewSearchAirport setHidden:NO];
            [self.flightTypeSegmentedControl setHidden:NO];
            
            [self.txtSearchValue setHidden:YES];
            [self.netjetsEmailLabel setHidden:YES];
            
            [self.viewSearchAirport.airportSearchBar becomeFirstResponder];

            break;
        }
    }
}

#pragma mark - Device notification

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // redisplay the date picker popover when the orientation changes
    if (self.popoverController.isPopoverVisible)
    {
        [self.popoverController dismissPopoverAnimated:NO];
        [self textFieldShouldBeginEditing:txtSearchDate];
    }
    
    // redisplay the airport picker popover when the orientation changes
    if (self.viewSearchAirport.searchResultsPopover.isPopoverVisible)
    {
        [self.viewSearchAirport.searchResultsPopover dismissPopoverAnimated:NO];
        [self.viewSearchAirport findAirports:self.viewSearchAirport.airportSearchBar.text];
    }
}

#pragma mark - TSQCalendarViewDelegate delegate
- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    if (self.dateRangeEnabled) {
        [self handleDateRangeSelection:date];
    } else {
        [self handleDateSelection:date];
    }
}

- (void)handleDateRangeSelection:(NSDate *)date
{
    if (self.datePickingStarted) {
        self.datePickingStarted = NO;
        self.startDate = nil;
        self.endDate = nil;
    } else if (self.startDate && self.endDate) {
        // Start over with date picking if they already picked both dates
        self.startDate = nil;
        self.endDate = nil;
    }
    
    if (!self.startDate) {
        self.startDate = date;
        UINavigationItem *title = self.calendarViewController.calendarNavBar.items.firstObject;
        title.title = @"Select End Date";
    } else {
        
        if ([self.startDate isBefore:date]) {
            self.endDate = date;
        } else {
            self.endDate = self.startDate;
            self.startDate = date;
        }
        
        [self.popover dismissPopoverAnimated:YES];
    }
    
    if (self.txtSearchDate){
        NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
        if (self.startDate && self.endDate) {
            NSString *endDateText = [NSString stringFromDate:self.endDate formatType:NCLDateFormatDateOnly];
            
            [self.txtSearchDate setText:[NSString stringWithFormat:@"%@ - %@", startDateText, endDateText]];
        } else {
            [self.txtSearchDate setText: startDateText];
        }
    }
}

- (void)handleDateSelection:(NSDate *)date
{
    self.startDate = date;
    
    if (self.txtSearchDate){
        NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
        [self.txtSearchDate setText: startDateText];
    }
}

@end
