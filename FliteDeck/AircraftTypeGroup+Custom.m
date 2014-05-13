//
//  AircraftTypeGroup+Custom.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AircraftTypeGroup+Custom.h"

@implementation NFDAircraftTypeGroup (Custom)
@dynamic warnings;

- (void) addWarning: (NSString *) warningMessage{
    if(self.warnings == nil){
         self.warnings = [[NSMutableArray alloc] init];
    }
    [self.warnings addObject: warningMessage];
}

- (void) clearWarnings{
    [self.warnings removeAllObjects];
}
/*-(void) dealloc {
    [self.warnings removeAllObjects];
    self.warnings = nil;
}*/
@end
