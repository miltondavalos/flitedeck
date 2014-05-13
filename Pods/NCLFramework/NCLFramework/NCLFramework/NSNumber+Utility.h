//
//  NSNumber+Utility.h
//  FliteDeck
//
//  Created by Chad Long on 5/25/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Utility)

+ (NSNumber*)numberFromObject:(id)object;
+ (NSNumber*)numberFromObject:(id)object shouldUseZeroDefault:(BOOL)shouldUseZeroDefault;
+ (NSNumber*)numberFromObject:(id)object shouldUseZeroDefault:(BOOL)shouldUseZeroDefault decimalPlaces:(NSInteger)decimalPlaces;

@end
