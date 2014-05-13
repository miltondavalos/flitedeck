//
//  NFDFlightTrackerSVPSearchViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/20/13.
//
//

#import "NFDFlightTrackerSVPSearchViewController.h"

#import "NSString+FliteDeck.h"
#import "NFDUserManager.h"

@interface NFDFlightTrackerSVPSearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation NFDFlightTrackerSVPSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if (!self.usernameTextField.text || [self.usernameTextField.text isEmptyOrWhitespace]) {
        NSString *email = [[NFDUserManager sharedManager] username];
        
        if (email &&
            email.length > 0)
        {
            [self.usernameTextField setText:email];
        }
    }

    [self.usernameTextField becomeFirstResponder];

}


- (IBAction)searchTapped:(id)sender {
    
    self.errorLabel.text = @"";

    NSString *email = self.usernameTextField.text;
    
    if (![email isValidEmail]) {
        email = [email createNetJetsEmail];
    }
    
    if (email.length > 4) {
        
        NSString *startDateText = [NSString stringFromDate:self.startDate formatType:NCLDateFormatDateOnly];
        NSString *endDateText = [NSString stringFromDate:self.endDate formatType:NCLDateFormatDateOnly];
        
        [self.flightTrackerManager findFlightsBySVP:email startDate:startDateText endDate:endDateText];
    } else {
        self.errorLabel.text = @"SVP/AE Required";
    }

}

@end
