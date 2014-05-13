//
//  NCLSimpleKeychain.h
//  FliteDeck
//
//  Created by Chad Long on 4/13/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCLUserPassword : NSObject

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, readonly, strong) NSString* host;

- (id)initWithUsername:(NSString*)username password:(NSString*)password host:(NSString*)host;

@end