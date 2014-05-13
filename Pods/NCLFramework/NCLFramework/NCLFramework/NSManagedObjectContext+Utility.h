//
//  NSManagedObjectContext+Utility.h
//  NCLFramework
//
//  Created by Chad Long on 5/21/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Utility)

- (id)executeUniqueFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                          includeSubEntities:(BOOL)includeSubEntities
                                       error:(NSError**)error;

- (id)executeUniqueFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                       error:(NSError**)error;

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     sortKey:(NSString*)sortKey
                          includeSubEntities:(BOOL)includeSubEntities
                                       error:(NSError**)error;

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     sortKey:(NSString*)sortKey
                                       error:(NSError**)error;

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                       returnObjectsAsFaults:(BOOL)returnObjectsAsFaults
                                       error:(NSError**)error;

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                          includeSubEntities:(BOOL)includeSubEntities
                       returnObjectsAsFaults:(BOOL)returnObjectsAsFaults
                                       error:(NSError**)error;

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                     sortKey:(NSString*)sortKey
                                       error:(NSError**)error;

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                       error:(NSError**)error;

- (NSInteger)countForFetchRequestForEntityName:(NSString*)entityName
                                     predicate:(NSPredicate*)predicate
                            includeSubEntities:(BOOL)includeSubEntities
                                         error:(NSError**)error;

- (NSInteger)countForFetchRequestForEntityName:(NSString*)entityName
                                     predicate:(NSPredicate*)predicate
                                         error:(NSError**)error;

- (id)executeFetchRequestForEntityName:(NSString*)entityName
                    expressionFunction:(NSString*)expressionFunction
                         expressionKey:(NSString*)expressionKey
                  expressionResultType:(NSAttributeType)attributeType
                             predicate:(NSPredicate*)predicate
                                 error:(NSError**)error;

- (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                        includeSubEntities:(BOOL)includeSubEntities
                                     error:(NSError**)error;

- (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                                     error:(NSError**)error;

- (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                     error:(NSError**)error;

@end
