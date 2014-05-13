//
//  Event.h
//  NCLFramework
//
//  Created by Chad Long on 9/19/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventDetail;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSDate * createdTS;
@property (nonatomic, retain) NSNumber * elapsedTime;
@property (nonatomic, retain) NSNumber * errorCode;
@property (nonatomic, retain) NSString * transactionID;
@property (nonatomic, retain) NSString * component;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSSet *eventDetail;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addEventDetailObject:(EventDetail *)value;
- (void)removeEventDetailObject:(EventDetail *)value;
- (void)addEventDetail:(NSSet *)values;
- (void)removeEventDetail:(NSSet *)values;

@end
