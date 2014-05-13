//
//  NFDCaseGroup.m
//  FliteDeck
//
//  Created by Chad Predovich on 12/17/13.
//
//

#import "NFDCaseGroup.h"

@implementation NFDCaseGroup

- (id)init
{
    self = [super init];
    if (self) {
        _cases = [NSMutableArray new];
    }
    return self;
}

- (NSString *)numberOfCasesAsString
{
    if (self.cases) {
        NSUInteger caseCount = self.cases.count;
    
        NSString *casesString = (caseCount == 1) ? @"Case" : @"Cases";
    
        return [NSString stringWithFormat:@"%i %@", self.cases.count, casesString];
    }
    
    return nil;
}



@end
