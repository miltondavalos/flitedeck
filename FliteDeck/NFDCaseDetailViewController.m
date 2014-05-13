//
//  NFDCaseDetailViewController.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/13/13.
//
//

#import "NFDCaseDetailViewController.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDOwnerImpactTableViewController.h"

@interface NFDCaseDetailViewController ()
@property (nonatomic, strong) NSArray *descriptorLabels;
@property (nonatomic, strong) NSArray *valueLabels;
@end

@implementation NFDCaseDetailViewController

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
    
    self.descriptorLabels = [NSArray arrayWithObjects:self.descriptionDescriptor, self.resolutionDescriptor, nil];
    self.valueLabels = [NSArray arrayWithObjects:self.typeCategoryDetailsValue, self.requestNumberValue,
                        self.statusValue, self.ownerImpactValue, self.descriptionValue,
                        self.resolutionValue, nil];
    
    [self setupDescriptorLabels];
    [self setupValueLabels];
    
    self.descriptionValue.contentInset = UIEdgeInsetsMake(0, -4, 0, -4);
    self.resolutionValue.contentInset = UIEdgeInsetsMake(0, -4, 0, -4);
    
    // border
    [self.container.layer setCornerRadius:7.0f];
    [self.container.layer setBorderColor:[UIColor flightDetailsBorderColor].CGColor];
    [self.container.layer setBorderWidth:1.0f];

    if (self.typeCategoryDetailsString) {
        self.typeCategoryDetailsValue.attributedText = self.typeCategoryDetailsString;
    } else {
        self.typeCategoryDetailsValue.attributedText = [self.flightCase caseTitleDisplayText];
    }
    
    if (self.flightCase) {
        self.requestNumberValue.text = self.flightCase.requestNumber;
        self.statusValue.text = self.flightCase.isOpen ? @"Open" : @"Closed";
        self.descriptionValue.text = self.flightCase.description;
        self.resolutionValue.text = self.flightCase.resolution;
        
        if (_flightCase.ownerImpacts.count > 1) {
            self.ownerImpactValue.hidden = YES;
            self.ownerImpactButton.hidden = NO;
            
            NSString *numberOfImpacts = [NSString stringWithFormat:@"%i Owner Impacts", _flightCase.ownerImpacts.count];
            
            [self.ownerImpactButton setTitleColor:[UIColor tintColorDefault] forState:UIControlStateNormal];
            [self.ownerImpactButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateHighlighted];
            [self.ownerImpactButton setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateSelected];
            [self.ownerImpactButton setTitleColor:[UIColor buttonTitleColorDisabled] forState:UIControlStateDisabled];
            
            [self.ownerImpactButton setTitle:numberOfImpacts forState:UIControlStateNormal];
            [self.ownerImpactButton setTitle:numberOfImpacts forState:UIControlStateHighlighted];
            [self.ownerImpactButton setTitle:numberOfImpacts forState:UIControlStateSelected];
            [self.ownerImpactButton setTitle:numberOfImpacts forState:UIControlStateDisabled];
        } else {
            self.ownerImpactValue.hidden = NO;
            self.ownerImpactButton.hidden = YES;
            
            self.ownerImpactValue.text = [_flightCase.ownerImpacts firstObject];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CASE_DETAILS_DISMISSED_NOTIFICATION object:nil];
}

- (void)setupDescriptorLabels
{
    for (UILabel *descriptorLabel in self.descriptorLabels) {
        descriptorLabel.textColor = [UIColor descriptorLabelTextColor];
    }
}

- (void)setupValueLabels
{
    for (UILabel *valueLabel in self.valueLabels) {
        if (valueLabel == self.requestNumberValue ||
            valueLabel == self.statusValue ||
            valueLabel == self.ownerImpactValue) {
            valueLabel.textColor = [UIColor colorWithRed:0.771 green:0.859 blue:0.936 alpha:1.000];
        } else {
            valueLabel.textColor = [UIColor valueLabelTextColor];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([@"ownerImpactSegue" isEqualToString:segue.identifier]) {
        NFDOwnerImpactTableViewController *ownerImpactController = segue.destinationViewController;
        ownerImpactController.ownerImpacts = [NSArray arrayWithArray:self.flightCase.ownerImpacts];
    }
}

@end
