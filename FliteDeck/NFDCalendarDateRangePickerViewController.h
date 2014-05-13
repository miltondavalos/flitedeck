//
//  NFDCalendarDateRangePickerViewController.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/22/13.
//
//

#import <UIKit/UIKit.h>

#import <TimesSquare/TimesSquare.h>

@protocol NFDDataRangeSelectedDelegate;

@interface NFDCalendarDateRangePickerViewController : UIViewController

@property (nonatomic, strong) NSCalendar *calendar;

@property (weak, nonatomic) IBOutlet TSQCalendarView *calendarView;

@property (nonatomic, copy) void(^configureBlock)(void);
@property (nonatomic, copy) void(^doneBlock)(void);

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (assign, nonatomic) id <NFDDataRangeSelectedDelegate> delegate;

- (id)initWithConfigureBlock: (void (^)(void))configureBlock andDoneBlock: (void (^)(void)) doneBlock;

@end

@protocol NFDDataRangeSelectedDelegate <NSObject>

-(void) dateRangeChangedWithStartDate:(NSDate *) startDate endDate:(NSDate *) endDate;

@end
