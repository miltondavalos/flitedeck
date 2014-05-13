//
//  NFDCaseSectionHeaderCell.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/17/13.
//
//

#import <UIKit/UIKit.h>

@interface NFDCaseSectionHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIImageView *caseIcon;
@property (weak, nonatomic) IBOutlet UILabel *accountNameValue;
@property (weak, nonatomic) IBOutlet UILabel *subHeadingValue;
@property (weak, nonatomic) IBOutlet UILabel *controllableCasesHeadingValue;
@property (weak, nonatomic) IBOutlet UILabel *departureAirportValue;
@property (weak, nonatomic) IBOutlet UILabel *arrivalAirportValue;
@property (weak, nonatomic) IBOutlet UILabel *departureDateValue;
@property (weak, nonatomic) IBOutlet UILabel *arrivalDateValue;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingCasesActivityIndicator;

@end
