//
//  UIDevice+Utility.h
//  NCLFramework
//
//  Created by Chad Long on 1/4/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Utility)

+ (NSString*)identifier;
+ (NSNumber*)freeMemory;
+ (NSNumber*)freeDiskspace;
+ (NSString*)modelName;
+ (BOOL)isPhone;
+ (BOOL)isSimulator;
+ (BOOL)isSystemVersionAtLeastVersion:(NSInteger)version;

@end
