//
//  NCLSimpleKeychain.m
//  FliteDeck
//
//  Created by Chad Long on 4/13/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLUserPassword.h"
#import "NSString+Utility.h"

@implementation NCLUserPassword

- (id)initWithUsername:(NSString*)username password:(NSString*)password host:(NSString*)host
{
    self = [super init];
    
    if (self)
    {
        _username = username;
        _password = password;
        _host = host;
    }
    
    return self;
}

@end