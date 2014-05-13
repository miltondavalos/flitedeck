//
//  NSObject+Utility.m
//  NCLFramework
//
//  Created by Chad Long on 9/5/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NSObject+Utility.h"

@implementation NSObject (Utility)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}

@end