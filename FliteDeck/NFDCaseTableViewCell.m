//
//  NFDCaseTableViewCell.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/13/13.
//
//

#import "NFDCaseTableViewCell.h"
#import "UIColor+FliteDeckColors.h"
#import "NSMutableAttributedString+FliteDeck.h"

@interface NFDCaseTableViewCell ()
@property (nonatomic, strong) NSArray *descriptorLabels;
@property (nonatomic, strong) NSArray *valueLabels;
@end

@implementation NFDCaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.descriptorLabels = [NSArray arrayWithObjects:self.descriptionDescriptor, self.resolutionDescriptor, nil];
    self.valueLabels = [NSArray arrayWithObjects:self.typeCategoryDetailsValue, self.requestNumberValue,
                        self.statusValue, self.ownerImpactValue, self.descriptionValue,
                        self.resolutionValue, nil];
    
    [self setupDescriptorLabels];
    [self setupValueLabels];
    
    // border
    [self.container.layer setCornerRadius:7.0f];
    [self.container.layer setBorderColor:[UIColor flightDetailsBorderColor].CGColor];
    [self.container.layer setBorderWidth:1.0f];
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

- (void)setFlightCase:(NFDCase *)flightCase
{
    if (flightCase) {
        _flightCase = flightCase;
        
        self.typeCategoryDetailsValue.attributedText = [_flightCase caseTitleDisplayText];
        self.requestNumberValue.text = _flightCase.requestNumber;
//        self.minutesDelayedValue.text = [_flightCase minutesDelayedDisplayText];
        self.descriptionValue.text = _flightCase.description;
        self.resolutionValue.text = _flightCase.resolution;
        
        NSString *status = _flightCase.isOpen ? @"Open" : @"Closed";
        self.statusValue.text = status;
        
        NSString *firstOwnerImpact = [_flightCase.ownerImpacts firstObject];
        
        if (_flightCase.ownerImpacts.count > 1) {
            self.ownerImpactValue.text = [NSString stringWithFormat:@"%@ and %i more...", firstOwnerImpact, (_flightCase.ownerImpacts.count - 1)];
        } else {
            self.ownerImpactValue.text = firstOwnerImpact;
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.container.layer.borderColor = [UIColor caseBorderSelectedColor].CGColor;
        self.container.backgroundColor = [UIColor caseBorderSelectedColor];
    } else {
        self.container.layer.borderColor = [UIColor flightDetailsBorderColor].CGColor;
        self.container.backgroundColor = [UIColor flightDetailsBorderColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.container.layer.borderColor = [UIColor caseBorderSelectedColor].CGColor;
        self.container.backgroundColor = [UIColor caseBorderSelectedColor];
    } else {
        self.container.layer.borderColor = [UIColor flightDetailsBorderColor].CGColor;
        self.container.backgroundColor = [UIColor flightDetailsBorderColor];
    }
}

@end
