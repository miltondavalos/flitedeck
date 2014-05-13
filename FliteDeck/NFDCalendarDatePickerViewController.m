//
//  NFDCalendarDatePickerViewController.m
//  TimesSquareTestApp
//
//  Created by Jeff Bailey on 10/14/13.
//
//

#import "NFDCalendarDatePickerViewController.h"

#import "NFDCalendarRowCell.h"
#import "NFDCalenderMonthHeaderCell.h"

#import <TimesSquare/TimesSquare.h>

@interface NFDCalendarDatePickerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;


@end

@implementation NFDCalendarDatePickerViewController

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
    
    if (self.configureBlock) {
        self.configureBlock();
    }
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

@end
