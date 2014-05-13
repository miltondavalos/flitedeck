//
//  NFDLegViewContainer.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDLegViewContainer : UIView
@property (nonatomic,strong) NSMutableArray *legs;
@property BOOL returnTrip;
-(void) setData : (NSMutableArray*) legs_;
@end
