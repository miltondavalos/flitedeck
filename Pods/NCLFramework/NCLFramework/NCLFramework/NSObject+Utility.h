//
//  NSObject+Utility.h
//  NCLFramework
//
//  Created by Chad Long on 9/5/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utility)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
