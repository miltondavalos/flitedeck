//
//  NFDCaseSummaryCell.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/31/13.
//
//

#import <UIKit/UIKit.h>

@interface NFDCaseSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customerSinceValue;
@property (weak, nonatomic) IBOutlet UILabel *countValue;
@property (weak, nonatomic) IBOutlet UILabel *countDescriptor;

@end
