//
//  NCLPersistenceUtil.h
//  FliteDeck
//
//  Created by Chad Long on 4/9/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NCLPersistenceUtil : NSObject

+ (id)executeUniqueFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                          includeSubEntities:(BOOL)includeSubEntities
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error;

+ (id)executeUniqueFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error;

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     sortKey:(NSString*)sortKey
                          includeSubEntities:(BOOL)includeSubEntities
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error;

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     sortKey:(NSString*)sortKey
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error;

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                                     context:(NSManagedObjectContext*)context
                       returnObjectsAsFaults:(BOOL)returnObjectsAsFaults
                                       error:(NSError**)error;

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                          includeSubEntities:(BOOL)includeSubEntities
                                     context:(NSManagedObjectContext*)context
                       returnObjectsAsFaults:(BOOL)returnObjectsAsFaults
                                       error:(NSError**)error;

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                     sortKey:(NSString*)sortKey
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error;

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error;

+ (NSInteger)countForFetchRequestForEntityName:(NSString*)entityName
                                     predicate:(NSPredicate*)predicate
                            includeSubEntities:(BOOL)includeSubEntities
                                       context:(NSManagedObjectContext*)context
                                         error:(NSError**)error;

+ (NSInteger)countForFetchRequestForEntityName:(NSString*)entityName
                                     predicate:(NSPredicate*)predicate
                                       context:(NSManagedObjectContext*)context
                                         error:(NSError**)error;

+ (id)executeFetchRequestForEntityName:(NSString*)entityName
                    expressionFunction:(NSString*)expressionFunction
                         expressionKey:(NSString*)expressionKey
                  expressionResultType:(NSAttributeType)attributeType
                             predicate:(NSPredicate*)predicate
                               context:(NSManagedObjectContext*)context
                                 error:(NSError**)error;

+ (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                        includeSubEntities:(BOOL)includeSubEntities
                                   context:(NSManagedObjectContext*)context
                                     error:(NSError**)error;

+ (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                                   context:(NSManagedObjectContext*)context
                                     error:(NSError**)error;

+ (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                   context:(NSManagedObjectContext*)context
                                     error:(NSError**)error;

@end
