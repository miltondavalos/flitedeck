//
//  NFDCaseSummaryCell.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/31/13.
//
//

#import "NFDCaseSummaryCell.h"

@implementation NFDCaseSummaryCell

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
    [self.countValue.layer setCornerRadius:5.0f];
}

@end
