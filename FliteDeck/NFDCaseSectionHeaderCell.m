//
//  NFDCaseSectionHeaderCell.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/17/13.
//
//

#import "NFDCaseSectionHeaderCell.h"
#import "UIColor+FliteDeckColors.h"

@implementation NFDCaseSectionHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    [self.container.layer setCornerRadius:7.0f];
    self.container.backgroundColor = [UIColor caseSectionHeadingBackgroundColor];
    
    self.caseIcon.image = [[UIImage imageNamed:@"case.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.caseIcon.tintColor = [UIColor whiteColor];
}

@end
