//
//  NDFDataBuilderRootViewController.m
//  FliteDeck
//
//  Created by Jeff Bailey on 12/30/13.
//
//

#import "NDFDataBuilderRootViewController.h"

#import "NFDImportService.h"
#import "NFTDataImportManager.h"
#import "NFDPersistenceManager.h"
#import "NFDDatabaseBuilderValidation.h"

@interface NDFDataBuilderRootViewController ()

#define db_name_0 @"FliteDeck.sqlite"
#define db_name_1 @"FlightAndTripTime.sqlite"

@property (weak, nonatomic) IBOutlet UILabel *numErrorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numWarningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dbNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *numWarningsActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *numErrorsActivityIndicator;

- (IBAction)switchDb:(id)sender;
- (IBAction)startImport:(id)sender;

@end

@implementation NDFDataBuilderRootViewController

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
	// Do any additional setup after loading the view.
    
    self.numWarningsLabel.text = nil;
    self.numErrorsLabel.text = nil;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startActivityIndicators {
    self.numWarningsLabel.text = nil;
    self.numWarningsLabel.hidden = YES;
    
    self.numErrorsLabel.text = nil;
    self.numErrorsLabel.hidden = YES;
    
    [self.numWarningsActivityIndicator startAnimating];
    self.numWarningsActivityIndicator.hidden = NO;

    [self.numErrorsActivityIndicator startAnimating];
    self.numErrorsActivityIndicator.hidden = NO;
}

- (void)stopActivityIndicators {
    [self.numWarningsActivityIndicator stopAnimating];
    self.numWarningsActivityIndicator.hidden = YES;
    
    [self.numErrorsActivityIndicator stopAnimating];
    self.numErrorsActivityIndicator.hidden = YES;

    self.numWarningsLabel.hidden = NO;
    self.numErrorsLabel.hidden = NO;
}

- (IBAction)switchDb:(id)sender {
    
    UISegmentedControl *selectedDb = (UISegmentedControl *) sender;
    NSInteger selIdx = selectedDb.selectedSegmentIndex;
    
    if(selIdx == 0) {
        self.dbNameLabel.text = db_name_0;
    } else if(selIdx == 1) {
        self.dbNameLabel.text = db_name_1;
    } else {
        DLog(@"Invalid index selected.");
    }
    
}
- (IBAction)startActivityIndicators:(id)sender {
    [self startActivityIndicators];
}

- (IBAction)startImport:(id)sender {
    
    if([self.dbNameLabel.text isEqual:db_name_0]) {
    
        NFDImportService *importService = [[NFDImportService alloc] init];
        [importService importFromFiles];
        
        NFDDatabaseBuilderValidation *validator = [[NFDDatabaseBuilderValidation alloc] init];
        [validator validateFlightDeckDatabase];
        
        self.numErrorsLabel.text = [NSString stringWithFormat:@"%d", validator.numErrors];
        self.numWarningsLabel.text = [NSString stringWithFormat:@"%d", validator.numWarnings];

    } else if([self.dbNameLabel.text isEqual:db_name_1]) {

        [NFTDataImportManager importAll];
        self.numErrorsLabel.text = @"N/A";
        self.numWarningsLabel.text = @"N/A";
        
    }
    
    [self stopActivityIndicators];
}

@end
