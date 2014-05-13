//
//  NCLPrivateMOC.h
//  NCLFramework
//
//  Created by Chad Long on 3/13/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NCLPrivateMOC : NSManagedObjectContext

- (id)initWithParentMOC:(NSManagedObjectContext*)parentContext;
- (BOOL)save:(NSError *__autoreleasing *)error shouldSaveParent:(BOOL)shouldSaveParent;

@end
