//
//  NFDFlightTrackerAirportSearchViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/21/13.
//
//

#import "NFDFlightTrackerAirportSearchViewController.h"

#import "NFDCalendarDateRangePickerViewController.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAirportSelectorViewController.h"
#import "UIView+FrameUtilities.h"
#import "NFDAirportService.h"

#define TRACKER_LAST_AIRPORT_SEARCH_CODE_KEY @"TrackerLastAirportSearchCode"

@interface NFDFlightTrackerAirportSearchViewController () <NFDDataRangeSelectedDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *flightTypeSegmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *airportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *airportCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *airportCodeLabel;

@property (strong, nonatomic) NFDAirport *selectedAirport;

@end

@implementation NFDFlightTrackerAirportSearchViewController

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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastTrackerAirportSearchCode = [userDefaults stringForKey:TRACKER_LAST_AIRPORT_SEARCH_CODE_KEY];
    if (!lastTrackerAirportSearchCode) {
        lastTrackerAirportSearchCode = @"KTEB";
    }
    
    NFDAirportService *airportService = [NFDAirportService new];
    self.selectedAirport = [airportService findAirportWithCode:lastTrackerAirportSearchCode];
    
    UIImage *disclosureImage = [UIImage imageNamed:@"disclosureArrow"];
    self.airportSelectorCell.accessoryView = [[UIImageView alloc] initWithImage:disclosureImage];
    self.dateSelectorCell.accessoryView = [[UIImageView alloc] initWithImage:disclosureImage];

    [self updateViewWithSelectedAirport];
}

- (IBAction)searchTapped:(id)sender {
    
    NSString *airportCode = self.airportCodeLabel.text;
    if (airportCode != nil) {
    
        BOOL onlySearchFerryFlights = [self.flightTypeSegmentedControl selectedSegmentIndex] == 1;
        NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
        NSString *endDateText = [NSString stringFromDate:self.endDate formatType:NCLDateFormatDateOnly];
        
        [self.flightTrackerManager findFlightsByAirportId:airportCode startDate:startDateText endDate:endDateText onlyFerryFlights:onlySearchFerryFlights];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:airportCode forKey:TRACKER_LAST_AIRPORT_SEARCH_CODE_KEY];
        [userDefaults synchronize];
    }

}

- (void)updateViewWithSelectedAirport {
    if (self.selectedAirport) {
        self.airportCityLabel.text = self.selectedAirport.city_name;
        self.airportNameLabel.text = self.selectedAirport.airport_name;
        self.airportCodeLabel.text = self.selectedAirport.airportid;
    }
}

- (IBAction)airportSelectedUnwindSegue:(UIStoryboardSegue *)segue {
    NFDAirportSelectorViewController *airportSelectorViewController = segue.sourceViewController;
    self.selectedAirport = airportSelectorViewController.selectedAirport;
    
    [self updateViewWithSelectedAirport];
}

@end
