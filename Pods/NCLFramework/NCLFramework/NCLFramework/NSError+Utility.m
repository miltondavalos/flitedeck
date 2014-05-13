//
//  NSError+Utility.m
//  FliteDeck
//
//  Created by Chad Long on 5/23/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NSError+Utility.h"

@implementation NSError (Utility)

// one-liner to construct an error object
+ (NSError*)errorWithDomain:(NSString*)domain code:(NSInteger)code description:(NSString*)description failureReason:(NSString*)failureReason
{    
    return [NSError errorWithDomain:domain code:code description:description failureReason:failureReason recoverySuggestion:nil];
}

+ (NSError*)errorWithDomain:(NSString*)domain code:(NSInteger)code description:(NSString*)description failureReason:(NSString*)failureReason recoverySuggestion:(NSString*)recoverySuggestion
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:description forKey:NSLocalizedDescriptionKey];
    [details setValue:failureReason forKey:NSLocalizedFailureReasonErrorKey];
    [details setValue:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
    
    return [NSError errorWithDomain:domain code:code userInfo:details];
}

// changes the error description to a {description OR failure reason} format
// error strings are truncated to 256 characters
- (NSString*)description
{
    NSString *result = nil;

    if (self.userInfo != nil)
    {
        NSString* desc = [self.userInfo objectForKey:NSLocalizedDescriptionKey];
        desc = [desc substringToIndex:MIN(256, [desc length])];

        NSString* reason = [self.userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
        reason = [reason substringToIndex:MIN(256, [reason length])];
        
        NSString* suggestion = [self.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
        suggestion = [suggestion substringToIndex:MIN(256, [suggestion length])];
        
        if (reason != nil)
            result = [NSString stringWithFormat:@"%@%@", reason, suggestion == nil ? @"": [NSString stringWithFormat:@"  %@", suggestion]];
        else
            result = desc;
    }

    return result;
}

@end