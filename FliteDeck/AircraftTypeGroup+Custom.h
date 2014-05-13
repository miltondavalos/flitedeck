//
//  AircraftTypeGroup+Custom.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDAircraftTypeGroup.h"

@interface NFDAircraftTypeGroup (Custom)
@property (nonatomic, retain) NSMutableArray *warnings;
- (void) clearWarnings;
-(void) addWarning: (NSString *) warningMessage;
@end
