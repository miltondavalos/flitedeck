//
//  NFDCalendarDateRangePickerViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/22/13.
//
//

#import "NFDCalendarDateRangePickerViewController.h"

#import "NFDCalendarRowCell.h"
#import "NFDCalenderMonthHeaderCell.h"

@interface NFDCalendarDateRangePickerViewController () <TSQCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;


@property (weak, nonatomic) IBOutlet UILabel *startDatePromptLabel;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *endDatePromptLabel;

@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@property (nonatomic) BOOL datePickingStarted;


@end

@implementation NFDCalendarDateRangePickerViewController

- (id)initWithConfigureBlock: (void (^)(void))configureBlock andDoneBlock: (void (^)(void)) doneBlock
{
    self = [super initWithNibName:@"NFDCalendarDatePickerViewController" bundle:nil];
    if (self) {
        // Custom initialization
        _configureBlock = configureBlock;
        _doneBlock = doneBlock;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) configureCalendar
{
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    _calendar.locale = [NSLocale currentLocale];
    
    _calendarView.calendar = self.calendar;
    _calendarView.rowCellClass = [NFDCalendarRowCell class];
    _calendarView.headerCellClass = [NFDCalenderMonthHeaderCell class];
    _calendarView.pagingEnabled = YES;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    _calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
    
    // Set some default first and last dates.  Typically override in the configureBlock.
    _calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
    _calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureCalendar];
    
    self.calendarView.delegate = self;
    
    if (self.configureBlock) {
        self.configureBlock();
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.startDatePromptLabel.alpha = 0.0;
    self.endDatePromptLabel.alpha = 0.0;
    
    self.startDateLabel.text = @"";
    self.endDateLabel.text = @"";
}

- (void)viewDidLayoutSubviews;
{
    // Set the calendar view to show today date on start
    [self.calendarView scrollToDate:[NSDate date] animated:NO];
}

- (IBAction)doneTapped:(id)sender {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

- (IBAction)todayTapped:(id)sender {
    [self.calendarView scrollToDate:[NSDate date] animated:YES];
}

#pragma mark TSQCalendarViewDelegate

- (BOOL)calendarView:(TSQCalendarView *)calendarView shouldSelectDate:(NSDate *)date
{
    BOOL validRange = YES;
    if (self.startDate && !self.endDate) {
        validRange = [self isDateRangeValidWithStartDate: self.startDate andEndDate:date];
    }
    
    return validRange;
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    [self handleDateRangeSelection:date];
}

- (void)handleDateRangeSelection:(NSDate *)date
{
    
    self.promptLabel.textColor = [UIColor blackColor];

    if (self.datePickingStarted) {
        self.datePickingStarted = NO;
        self.startDate = nil;
        self.endDate = nil;
        self.promptLabel.text = @"Select Start Date";
    } else if (self.startDate && self.endDate) {
        // Start over with date picking if they already picked both dates
        self.startDate = nil;
        self.endDate = nil;
        self.promptLabel.text = @"Select Start Date";
    }
    
    if (!self.startDate) {
        self.startDate = date;
        self.promptLabel.text = @"Select Optional End Date";
    } else {
        self.promptLabel.text = @"";

        if ([self.startDate isBefore:date]) {
            self.endDate = date;
        } else {
            self.endDate = self.startDate;
            self.startDate = date;
        }
        
    }
    
    self.promptLabel.alpha = 0.0;
    self.startDatePromptLabel.alpha = 0.0;
    self.endDatePromptLabel.alpha = 0.0;
    
    self.startDateLabel.alpha = 0.0;
    self.endDateLabel.alpha = 0.0;
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.promptLabel.alpha = 1.0;

        NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
        if (self.startDate && self.endDate) {
            NSString *endDateText = [NSString stringFromDate:self.endDate formatType:NCLDateFormatDateOnly];
            
            self.startDateLabel.text = startDateText;
            self.endDateLabel.text = endDateText;
            
            self.startDatePromptLabel.alpha = 1.0;
            self.endDatePromptLabel.alpha = 1.0;
            
            self.startDateLabel.alpha = 1.0;
            self.endDateLabel.alpha = 1.0;
        } else {
            self.startDateLabel.text = startDateText;
            self.endDateLabel.text = @"";
            
            self.startDatePromptLabel.alpha = 1.0;
            self.endDatePromptLabel.alpha = 0.0;
            
            self.startDateLabel.alpha = 1.0;
            self.endDateLabel.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
    }];

    
    if ( (self.delegate) && ([self.delegate conformsToProtocol:@protocol(NFDDataRangeSelectedDelegate)]) ) {
        [self.delegate dateRangeChangedWithStartDate:self.startDate endDate:self.endDate];
    }
}

- (BOOL) isDateRangeValidWithStartDate: (NSDate *) startDate andEndDate:(NSDate *) endDate
{
    if (![startDate isBefore:endDate]) {
        NSDate *tempDate = endDate;
        endDate = startDate;
        startDate = tempDate;
    }
    
    BOOL valid = YES;
    if (startDate && endDate) {
        NSUInteger maxDateRange = 31;  // Note date range is inclusive of start and end date
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:startDate toDate:endDate options:0];
        if (dateComponents.day >= maxDateRange) {
//            [self changeErrorMessage:[NSString stringWithFormat: @"Selected range of %d days exceeds the %d day maximum range.", dateComponents.day+1, maxDateRange]];
            [self changeErrorMessage:[NSString stringWithFormat: @"Max date range is %d days", maxDateRange]];
            valid = NO;
        }
    }
    return valid;
}

- (void)changeErrorMessage:(NSString *)text
{
    self.promptLabel.alpha = 0.0;
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.promptLabel.alpha = 1.0;

        self.promptLabel.text = text;
        self.promptLabel.textColor = [UIColor redColor];
    } completion:^(BOOL finished) {
    }];
}

@end