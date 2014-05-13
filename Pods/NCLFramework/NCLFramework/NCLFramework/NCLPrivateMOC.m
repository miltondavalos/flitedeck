//
//  NCLPrivateMOC.m
//  NCLFramework
//
//  Created by Chad Long on 3/13/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLPrivateMOC.h"
#import "NCLFramework.h"
#import "NCLAnalytics.h"
#import "NCLAnalyticsEvent.h"

@implementation NCLPrivateMOC

- (id)initWithParentMOC:(NSManagedObjectContext*)parentContext
{
    self = [super initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    if (self)
    {
        [self setUndoManager:nil];
        [self setMergePolicy:NSErrorMergePolicy];
        
        if (parentContext != nil)
        {
            [self setParentContext:parentContext];
        }
    }
    
    return self;
}

- (BOOL)save:(NSError *__autoreleasing *)error
{
    return [self save:&*error shouldSaveParent:YES];
}

- (BOOL)save:(NSError *__autoreleasing *)error shouldSaveParent:(BOOL)shouldSaveParent
{
    __block BOOL saveStatus = YES;
    
    [self performBlockAndWait:^
     {
         NSError *saveError = nil;
         
         if ([super save:&saveError])
         {
             if ([self parentContext] != nil)
             {
                 DEBUGLog(@"save of childMOC (--> parentMOC) completed");
             }
             else
             {
                 INFOLog(@"save of parentMOC (--> data store) completed");
             }
             
             if (shouldSaveParent &&
                 [self parentContext] != nil)
             {
                 [[self parentContext] performBlockAndWait:^
                 {
                     NSError *parentSaveError = nil;
                     
                     if ([[self parentContext] save:&parentSaveError])
                     {
                         INFOLog(@"save of parentMOC (--> data store) completed");
                     }
                     else
                     {
                         saveStatus = NO;
                         INFOLog(@"error saving to privateMOC: %@\n%@", [saveError localizedDescription], [saveError userInfo]);
                         [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"coreData" action:@"save" value:@"parentMOC" error:saveError]];
                         
                         if (error != 0)
                             *error = parentSaveError;
                         else
                             [NCLErrorPresenter presentError:parentSaveError];
                     }
                 }];
             }
         }
         else
         {
             saveStatus = NO;
             INFOLog(@"error saving to privateMOC: %@\n%@", [saveError localizedDescription], [saveError userInfo]);
             [NCLAnalytics addEvent:[NCLAnalyticsEvent eventForComponent:@"coreData" action:@"save" value:@"childMOC" error:saveError]];
             
             if (error != 0)
                 *error = saveError;
             else
                 [NCLErrorPresenter presentError:saveError];
         }
     }];
    
    return saveStatus;
}

@end
