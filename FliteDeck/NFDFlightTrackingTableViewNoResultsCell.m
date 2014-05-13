//
//  NFDFlightTrackingTableViewNoResultsViewCell.m
//  FliteDeck
//
//  Created by Jeff Bailey on 10/30/13.
//
//

#import "NFDFlightTrackingTableViewNoResultsCell.h"

#import "UIColor+FliteDeckColors.h"

@implementation NFDFlightTrackingTableViewNoResultsCell

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
    self.contentView.backgroundColor = [UIColor tableViewBackgroundColor];
    self.noResultsView.backgroundColor = [UIColor tableViewBackgroundColor];
    self.noResultsLabel.textColor = [UIColor whiteColor];
}

@end
