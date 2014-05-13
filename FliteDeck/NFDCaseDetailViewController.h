//
//  NFDCaseDetailViewController.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/13/13.
//
//

#import <UIKit/UIKit.h>
#import "NFDCase.h"

#define CASE_DETAILS_DISMISSED_NOTIFICATION @"caseDetailsDismissed"

@interface NFDCaseDetailViewController : UIViewController

@property (strong, nonatomic) NFDCase *flightCase;
@property (strong, nonatomic) NSAttributedString *typeCategoryDetailsString;

@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UILabel *descriptionDescriptor;
@property (weak, nonatomic) IBOutlet UILabel *resolutionDescriptor;

@property (weak, nonatomic) IBOutlet UILabel *typeCategoryDetailsValue;
@property (weak, nonatomic) IBOutlet UILabel *requestNumberValue;
@property (weak, nonatomic) IBOutlet UILabel *statusValue;
@property (weak, nonatomic) IBOutlet UILabel *ownerImpactValue;
@property (weak, nonatomic) IBOutlet UIButton *ownerImpactButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionValue;
@property (weak, nonatomic) IBOutlet UITextView *resolutionValue;

- (IBAction)dismissModal:(id)sender;

@end
