//
//  NFDFlightTrackerTailSearchViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/20/13.
//
//

#import "NFDFlightTrackerTailSearchViewController.h"

#import "UIColor+FliteDeckColors.h"

@interface NFDFlightTrackerTailSearchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *tailTextField;

@end

@implementation NFDFlightTrackerTailSearchViewController

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
    
    UIImage *disclosureImage = [UIImage imageNamed:@"disclosureArrow"];
    
    self.dateSelectorCell.accessoryView = [[UIImageView alloc] initWithImage:disclosureImage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tailTextField becomeFirstResponder];
}


- (IBAction)searchTapped:(id)sender {
    
    NSString *tailText = self.tailTextField.text;
    
    if (tailText && ![tailText isEmptyOrWhitespace]) {
    
        NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
        NSString *endDateText = [NSString stringFromDate:self.endDate formatType:NCLDateFormatDateOnly];
        
       [self.flightTrackerManager findFlightsByTailNumber:tailText startDate:startDateText endDate:endDateText];
    } else {
        self.errorLabel.text = @"Tail # required";
    }
    
}

@end
