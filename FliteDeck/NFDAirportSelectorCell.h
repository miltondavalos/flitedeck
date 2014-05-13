//
//  NFDAirportSelectorCell.h
//  FliteDeck
//
//  Created by Chad Predovich on 11/20/13.
//
//

#import <UIKit/UIKit.h>

@interface NFDAirportSelectorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *airportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *airportCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *airportCodeLabel;

@end
