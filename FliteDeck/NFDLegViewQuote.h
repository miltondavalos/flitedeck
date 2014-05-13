//
//  NFDLegViewQuote.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Leg.h"

@interface NFDLegViewQuote : UIView {
    UILabel *title;
    UILabel *airportName;
    UILabel *distance;
    UIButton *showInfo;
    NFDAirport *airport;
}

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *airportName;
@property (nonatomic, strong) IBOutlet UILabel *distance;
@property (nonatomic, strong) IBOutlet UIButton *showInfo;
@property (nonatomic, strong) NFDAirport *airport;
-(void) setData: (Leg*) leg  type : (int) type;
-(IBAction) viewAirportDetail: (id) sender;
@end
