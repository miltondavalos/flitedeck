//
//  Prospect.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Prospect.h"

@implementation Prospect
@synthesize first_name,last_name,title,email,entity;

-(id) init {
    self = [super init];
    if(self){
        [self reset];
        
    }
    return self;
}
-(void) reset {
    title = @"";
    first_name = @"";
    last_name = @"";
    email = @"";
    entity = @"";
}
@end
