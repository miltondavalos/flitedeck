//
//  NFDCompareSharePurchaseView.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDProposal.h"
#import "NFDCompareView.h"

@interface NFDCompareSharePurchaseView : NFDCompareView
@property (nonatomic,weak) IBOutlet UILabel *title;
@property (nonatomic,weak) IBOutlet UILabel *subtitle;
@property (nonatomic,weak) IBOutlet UILabel *type;
@property (nonatomic,weak) IBOutlet UILabel *delivery;
@property (nonatomic,weak) IBOutlet UILabel *tailNumber;
@property (nonatomic,weak) IBOutlet UILabel *year;
@property (nonatomic,weak) IBOutlet UILabel *serial;
@property (nonatomic,weak) IBOutlet UILabel *available;
@property (nonatomic,weak) IBOutlet UILabel *value;
@property (nonatomic,weak) IBOutlet UILabel *contracts;
@property (nonatomic,weak) IBOutlet UILabel *mmfRate;
@property (nonatomic,weak) IBOutlet UILabel *mmfAnnual;
@property (nonatomic,weak) IBOutlet UILabel *ohfRate;
@property (nonatomic,weak) IBOutlet UILabel *ohfAnnual;
@property (nonatomic,weak) IBOutlet UILabel *fetRate;
@property (nonatomic,weak) IBOutlet UILabel *fetAnnual;
@property (nonatomic,weak) IBOutlet UILabel *fuelRate;
@property (nonatomic,weak) IBOutlet UILabel *fuelAnnual;
@property (nonatomic,weak) IBOutlet UILabel *prepaySavings;
@property (nonatomic,weak) IBOutlet UILabel *acquisitionCost;

-(void) setData : (NFDProposal*) proposal;
@end
