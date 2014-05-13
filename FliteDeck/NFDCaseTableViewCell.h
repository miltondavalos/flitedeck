//
//  NFDCaseTableViewCell.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/13/13.
//
//

#import <UIKit/UIKit.h>
#import "NFDCase.h"

@interface NFDCaseTableViewCell : UITableViewCell

@property (strong, nonatomic) NFDCase *flightCase;

@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UILabel *descriptionDescriptor;
@property (weak, nonatomic) IBOutlet UILabel *resolutionDescriptor;

@property (weak, nonatomic) IBOutlet UILabel *typeCategoryDetailsValue;
@property (weak, nonatomic) IBOutlet UILabel *requestNumberValue;
@property (weak, nonatomic) IBOutlet UILabel *statusValue;
@property (weak, nonatomic) IBOutlet UILabel *ownerImpactValue;
@property (weak, nonatomic) IBOutlet UILabel *descriptionValue;
@property (weak, nonatomic) IBOutlet UILabel *resolutionValue;

@end
