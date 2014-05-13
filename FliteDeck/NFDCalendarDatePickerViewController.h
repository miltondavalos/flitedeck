//
//  NFDCalendarDatePickerViewController.h
//  TimesSquareTestApp
//
//  Created by Jeff Bailey on 10/14/13.
//
//

#import <UIKit/UIKit.h>
#import <TimesSquare/TimesSquare.h>

@interface NFDCalendarDatePickerViewController : UIViewController

@property (nonatomic, strong) NSCalendar *calendar;

@property (weak, nonatomic) IBOutlet TSQCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UINavigationBar *calendarNavBar;

@property (nonatomic, copy) void(^configureBlock)(void);
@property (nonatomic, copy) void(^doneBlock)(void);

- (id)initWithConfigureBlock: (void (^)(void))configureBlock andDoneBlock: (void (^)(void)) doneBlock;

@end
