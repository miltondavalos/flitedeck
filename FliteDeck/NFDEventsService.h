//
//  NFDEventsService.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDPersistenceService.h"

@interface NFDEventsService : NFDPersistenceService
- (NSArray *) getEvents: (NSString *) criteria;
- (NSArray *) getEventMedia: (NSString *) criteria;

@end
