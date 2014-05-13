//
//  NCLPersistenceUtil.m
//  FliteDeck
//
//  Created by Chad Long on 4/9/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NCLPersistenceUtil.h"
#import <CoreData/CoreData.h>
#import "NCLFramework.h"

@implementation NCLPersistenceUtil

#pragma mark - Key/value searches

+ (id)executeUniqueFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error
{
    return [self executeUniqueFetchRequestForEntityName:entityName predicateKey:key predicateValue:value includeSubEntities:YES context:context error:error];
}

+ (id)executeUniqueFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                          includeSubEntities:(BOOL)includeSubEntities
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error
{
    NSArray *results = [self executeFetchRequestForEntityName:entityName predicateKey:key predicateValue:value sortKey:nil  includeSubEntities:includeSubEntities context:context error:&*error];
    
    if (results &&
        [results count] > 0)
    {
        if ([results count] > 1)
            INFOLog(@"WARNING: Unique fetch returned more than one result!");

        return [results objectAtIndex:0];
    }
    
    return nil;
}

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     sortKey:(NSString*)sortKey
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error
{
    return [NCLPersistenceUtil executeFetchRequestForEntityName:entityName predicateKey:key predicateValue:value sortKey:sortKey includeSubEntities:YES context:context error:error];
}

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                predicateKey:(NSString*)key
                              predicateValue:(id)value
                                     sortKey:(NSString*)sortKey
                          includeSubEntities:(BOOL)includeSubEntities
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    
    NSArray *sortDescriptors = nil;
    
    if (sortKey)
    {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
        sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    }
    
    return [self executeFetchRequestForEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors includeSubEntities:includeSubEntities context:context returnObjectsAsFaults:NO error:&*error];
}

#pragma mark - Full predicate searches

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error
{
    return [self executeFetchRequestForEntityName:entityName predicate:predicate sortKey:nil context:context error:&*error];
}

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                     sortKey:(NSString*)sortKey
                                     context:(NSManagedObjectContext*)context
                                       error:(NSError**)error
{
    NSArray *sortDescriptors = nil;
    
    if (sortKey)
    {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
        sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    }
    
    return [self executeFetchRequestForEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors context:context returnObjectsAsFaults:YES error:&*error];
}

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                                     context:(NSManagedObjectContext*)context
                       returnObjectsAsFaults:(BOOL)returnObjectsAsFaults
                                       error:(NSError**)error
{
    return [self executeFetchRequestForEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors includeSubEntities:YES context:context returnObjectsAsFaults:returnObjectsAsFaults error:error];
}

#pragma mark - Base search

+ (NSArray*)executeFetchRequestForEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                             sortDescriptors:(NSArray*)sortDescriptors
                          includeSubEntities:(BOOL)includeSubEntities
                                     context:(NSManagedObjectContext*)context
                       returnObjectsAsFaults:(BOOL)returnObjectsAsFaults
                                       error:(NSError**)error
{
    // validate arguments
    if (context == 0)
    {
        @throw [NSException exceptionWithName:@"Invalid Context" reason:@"A valid managed object context is required" userInfo:nil];
    }
    
    // build the fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchRequest.includesSubentities=includeSubEntities;
    
    if (predicate)
        [fetchRequest setPredicate:predicate];
    
    if (sortDescriptors)
        [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setReturnsObjectsAsFaults:returnObjectsAsFaults];
    
    // execute
    NSError *fetchError = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError)
    {
        INFOLog(@"core data fetch error: %@", fetchError);
        
        if (error != 0)
        {
            *error = fetchError;
        }
        else
        {
            [NCLErrorPresenter presentError:fetchError];
        }
    }
    
    return result;
}

#pragma mark - Count search

+ (NSInteger)countForFetchRequestForEntityName:(NSString*)entityName
                                     predicate:(NSPredicate*)predicate
                                       context:(NSManagedObjectContext*)context
                                         error:(NSError**)error
{
    return [NCLPersistenceUtil countForFetchRequestForEntityName:entityName predicate:predicate includeSubEntities:YES context:context  error:error];
}

+ (NSInteger)countForFetchRequestForEntityName:(NSString*)entityName
                                     predicate:(NSPredicate*)predicate
                            includeSubEntities:(BOOL)includeSubEntities
                                       context:(NSManagedObjectContext*)context
                                         error:(NSError**)error
{
    // validate arguments
    if (context == 0)
    {
        @throw [NSException exceptionWithName:@"Invalid Context" reason:@"A valid managed object context is required" userInfo:nil];
    }
    
    // build the fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setIncludesSubentities:NO];
    [fetchRequest setIncludesSubentities:includeSubEntities];
    
    if (predicate)
        [fetchRequest setPredicate:predicate];

    // execute
    NSError *fetchError = nil;
    NSInteger count = [context countForFetchRequest:fetchRequest error:&fetchError];

    if (fetchError)
    {
        INFOLog(@"core data count error: %@", fetchError);
        
        if (error != 0)
        {
            *error = fetchError;
        }
        else
        {
            [NCLErrorPresenter presentError:fetchError];
        }
    }

    return (count == NSNotFound ? 0 : count);
}

#pragma mark - Function fetch (i.e. max | min | average | sum)

+ (id)executeFetchRequestForEntityName:(NSString*)entityName
                    expressionFunction:(NSString*)expressionFunction
                         expressionKey:(NSString*)expressionKey
                  expressionResultType:(NSAttributeType)attributeType
                             predicate:(NSPredicate*)predicate
                               context:(NSManagedObjectContext*)context
                                 error:(NSError**)error
{
    // validate arguments
    if (context == 0)
    {
        @throw [NSException exceptionWithName:@"Invalid Context" reason:@"A valid managed object context is required" userInfo:nil];
    }

    // build the fetch request
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:expressionKey];
    NSExpression *expression = [NSExpression expressionForFunction:expressionFunction arguments:[NSArray arrayWithObject:keyPathExpression]];

    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"resultKey"];
    [expressionDescription setExpression:expression];
    [expressionDescription setExpressionResultType:attributeType];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    if (predicate)
        [fetchRequest setPredicate:predicate];
    
    // execute
    NSError *fetchError = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError)
    {
        INFOLog(@"core data aggregate fetch error: %@", fetchError);
        
        if (error != 0)
        {
            *error = fetchError;
        }
        else
        {
            [NCLErrorPresenter presentError:fetchError];
        }
    }
    else if (result.count > 0)
    {
        return [[result objectAtIndex:0] valueForKey:@"resultKey"];
    }

    return nil;
}

#pragma mark - Entity truncate

+ (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                        includeSubEntities:(BOOL)includeSubEntities
                                   context:(NSManagedObjectContext*)context
                                     error:(NSError**)error
{
    NSInteger rowCount = 0;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setIncludesSubentities:includeSubEntities];
    if (predicate)
        [fetchRequest setPredicate:predicate];
    
    NSError *fetchError = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError)
    {
        INFOLog(@"core data fetch error on delete: %@", fetchError);
        
        if (error != 0)
        {
            *error = fetchError;
        }
        else
        {
            [NCLErrorPresenter presentError:fetchError];
        }
    }
    else
    {
        for (NSManagedObject *entity in result)
        {
            rowCount++;
            [context deleteObject:entity];
        }
    }
    
    return rowCount;
}

+ (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                                   context:(NSManagedObjectContext*)context
                                     error:(NSError**)error
{
    return [NCLPersistenceUtil deleteAllObjectsForEntityName:entityName predicate:predicate includeSubEntities:YES context:context error:error];
}

+ (NSInteger)deleteAllObjectsForEntityName:(NSString*)entityName context:(NSManagedObjectContext*)context error:(NSError**)error
{
    return [NCLPersistenceUtil deleteAllObjectsForEntityName:entityName predicate:nil context:context error:error];
}

@end
