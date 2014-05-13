//
//  NSError+Utility.h
//  FliteDeck
//
//  Created by Chad Long on 5/23/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Utility)

+ (NSError*)errorWithDomain:(NSString*)domain code:(NSInteger)code description:(NSString*)description failureReason:(NSString*)failureReason;
+ (NSError*)errorWithDomain:(NSString*)domain code:(NSInteger)code description:(NSString*)description failureReason:(NSString*)failureReason recoverySuggestion:(NSString*)recoverySuggestion;

@end
