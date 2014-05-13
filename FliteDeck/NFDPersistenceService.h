//
//  NFDPersistenceService.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/10/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDPersistenceManager.h"
#import "EntryReceiver.h"
#import "CSVParser.h"
#import "NCLFramework.h"
#import "NFDFBO.h"
#import "NFDFBOAddress.h"
#import "NFDFBOPhone.h"
#import "NFDAirport.h"
#import "NFDAircraftType.h"

@interface NFDPersistenceService : NSObject
{
    NFDPersistenceManager *pm;
    NSManagedObjectContext *context;
    //NSArray *recordsFound;
}

@property (strong,nonatomic) NFDPersistenceManager *pm;
@property (strong,nonatomic) NSManagedObjectContext *context;
//@property (nonatomic,retain) NSArray *recordsFound;

- (NSArray *) getAll : (NSString *) entityName sortedBy: (NSString*) fieldName;
- (NSArray*) queryEntity : (NSString *) criteria  entityName:(NSString *) entityName fieldName :(NSString *) fieldName;
- (NSArray*) queryEntityForUniqueValues : (NSString *) criteria  entityName:(NSString *) entityName fieldName :(NSString *) fieldName;
- (NSUInteger) getEntityCount: (NSString *) entityName;

+ (id) sharedInstance;
+ (void) copyManagedObjectAttributesFrom: (NSManagedObject *) source cloned:(NSManagedObject *)cloned entityName:(NSString *) entityName;

@end
