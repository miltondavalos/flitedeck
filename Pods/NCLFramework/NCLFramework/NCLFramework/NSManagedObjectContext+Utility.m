//
//  NSManagedObjectContext+Utility.m
//  NCLFramework
//
//  Created by Chad Long on 5/21/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NSManagedObjectContext+Utility.h"
#import "NCLPersistenceUtil.h"

@implementation NSManagedObjectContext (Utility)

- (id)executeUniqueFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                          includeSubEntities:(BOOL)includeSubEntities
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:entityName predicateKey:key predicateValue:value includeSubEntities:includeSubEntities context:self error:error];
}

- (id)executeUniqueFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:entityName predicateKey:key predicateValue:value context:self error:error];
}

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     sortKey:(NSString*)sortKey
                          includeSubEntities:(BOOL)includeSubEntities
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeFetchRequestForEntityName:entityName predicateKey:key predicateValue:value sortKey:sortKey includeSubEntities:includeSubEntities context:self error:error];
}

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     sortKey:(NSString*)sortKey
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeFetchRequestForEntityName:entityName predicateKey:key predicateValue:value sortKey:sortKey context:self error:error];
}

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                       returnObjectsAsFaults:(BOOL)returnObjectsAsFaults
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeFetchRequestForEntityName:entityName
                                                      predicate:predicate
                                                sortDescriptors:sortDescriptors
                                                        context:self
                                          returnObjectsAsFaults:returnObjectsAsFaults
                                                          error:error];
}

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                          includeSubEntities:(BOOL)includeSubEntities
                       returnObjectsAsFaults:(BOOL)returnObjectsAsFaults
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeFetchRequestForEntityName:entityName
                                                      predicate:predicate
                                                sortDescriptors:sortDescriptors
                                             includeSubEntities:includeSubEntities 
                                                        context:self
                                          returnObjectsAsFaults:returnObjectsAsFaults
                                                          error:error];
}

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                     sortKey:(NSString*)sortKey
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeFetchRequestForEntityName:entityName predicate:predicate sortKey:sortKey context:self error:error];
}

- (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeFetchRequestForEntityName:entityName predicate:predicate context:self error:error];
}

- (NSInteger)countForFetchRequestForEntityName:(NSString*)entityName
                                     predicate:(NSPredicate*)predicate
                            includeSubEntities:(BOOL)includeSubEntities
                                         error:(NSError**)error
{
    return [NCLPersistenceUtil countForFetchRequestForEntityName:entityName predicate:predicate includeSubEntities:includeSubEntities context:self error:error];
}

- (NSInteger)countForFetchRequestForEntityName:(NSString*)entityName
                                     predicate:(NSPredicate*)predicate
                                         error:(NSError**)error
{
    return [NCLPersistenceUtil countForFetchRequestForEntityName:entityName predicate:predicate context:self error:error];
}

- (id)executeFetchRequestForEntityName:(NSString*)entityName
                    expressionFunction:(NSString*)expressionFunction
                         expressionKey:(NSString*)expressionKey
                  expressionResultType:(NSAttributeType)attributeType
                             predicate:(NSPredicate*)predicate
                                 error:(NSError**)error
{
    return [NCLPersistenceUtil executeFetchRequestForEntityName:entityName
                                             expressionFunction:expressionFunction
                                                  expressionKey:expressionKey
                                           expressionResultType:attributeType
                                                      predicate:predicate
                                                        context:self
                                                          error:error];
}

- (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                        includeSubEntities:(BOOL)includeSubEntities
                                     error:(NSError**)error
{
    return [NCLPersistenceUtil deleteAllObjectsForEntityName:entityName predicate:predicate includeSubEntities:includeSubEntities context:self error:error];
}

- (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                                     error:(NSError**)error
{
    return [NCLPersistenceUtil deleteAllObjectsForEntityName:entityName predicate:predicate context:self error:error];
}

- (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                     error:(NSError**)error
{
    return [NCLPersistenceUtil deleteAllObjectsForEntityName:entityName context:self error:error];
}

@end
