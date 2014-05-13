//
//  NFDMasterSynchService.m
//  FliteDeck
//
//  Created by Jeff Bailey on 12/19/13.
//
//

#import "NFDMasterSynchService.h"

#import "NFDPersistenceManager.h"
#import "NFDAircraftTypeGroup.h"
#import "NFDAircraftType.h"
#import "NFDFuelRate.h"
#import "NFDContractRate.h"
#import "NFDMasterAircraftTypeGroup.h"
#import "NFDMasterAircraftType.h"
#import "NFDPersistenceService.h"
#import "NSManagedObjectContext+Utility.h"


@implementation NFDMasterSynchService


-(BOOL) isSyncFromMasterNeeded
{
    NSManagedObjectContext *context = [[NFDPersistenceManager sharedInstance] mainMOC];
    
    NSInteger groupCount = [context countForFetchRequestForEntityName:[NFDAircraftTypeGroup entityName] predicate:nil includeSubEntities:NO error:nil];
    if (groupCount == 0) {
        return YES;
    }
    
    NSInteger typeCount = [context countForFetchRequestForEntityName:[NFDAircraftType entityName] predicate:nil includeSubEntities:NO error:nil];
    if (typeCount == 0) {
        return YES;
    }
    
    NFDCompanySetting companySetting = [[NFDUserManager sharedManager] companySetting];
    NSPredicate *predicate = [self createPredicateForTypeGroupName:companySetting];
    
    NSInteger masterGroupCount = [context countForFetchRequestForEntityName:[NFDMasterAircraftTypeGroup entityName] predicate:predicate includeSubEntities:NO error:nil];

    if (groupCount != masterGroupCount) {
        NSLog(@"***WARNING - Unexpected Master sync of aircraft group table needed.***");
        return YES;
    }
    
    NSInteger masterTypeCount = [context countForFetchRequestForEntityName:[NFDMasterAircraftType entityName] predicate:predicate includeSubEntities:NO error:nil];
    
    if (typeCount != masterTypeCount) {
        NSLog(@"***WARNING - Unexpected Master sync of aircraft table needed.***");
        return YES;
    }
    
    return NO;
}

-(void) syncFromMasterForCompany:(NFDCompanySetting) companySetting
{
    
    NSManagedObjectContext *context = [[NFDPersistenceManager sharedInstance] mainMOC];
    
    [self syncAircraftTableFromMaster:companySetting entityName:[NFDAircraftTypeGroup entityName] context:context];
    [self syncAircraftTableFromMaster:companySetting entityName:[NFDAircraftType entityName] context:context];
    
    [NFDFuelRate resetRelationshipsToAircraftTypes:context error:nil];
    [NFDContractRate resetRelationshipsToAircraftType:context error:nil];
    
    [context save:nil];
}


-(void) syncAircraftTableFromMaster:(NFDCompanySetting) companySetting entityName: (NSString *)entityName context:(NSManagedObjectContext *) context
{
    NSString *masterEntityName = [NSString stringWithFormat:@"Master%@", entityName];
    
    NSError *error;
    NSInteger deleteCount = [context deleteAllObjectsForEntityName:entityName predicate:nil includeSubEntities:NO error:&error];
    
    DLog(@"Deleted %d entities of type %@", deleteCount, entityName);
    
    NSArray *masterArray = [self fetchByTypeGroupNameForCompany:companySetting entityName:masterEntityName context:context];
    
    for (NSManagedObject *masterEntity in masterArray) {
        
        NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        
        [self copyManagedObjectAttributesFrom:masterEntity cloned:entity entityName:entityName];
        [NFDPersistenceService copyManagedObjectAttributesFrom: masterEntity cloned:entity entityName:entityName];
        
        NSString *masterTypeGroupName = nil;
        switch (companySetting) {
            case NFDCompanySettingNJA:
                masterTypeGroupName = @"typeGroupNameForNJA";
                break;
            case NFDCompanySettingNJE:
                masterTypeGroupName = @"typeGroupNameForNJE";
                break;
            default:
                break;
        }
        
        [entity setValue:[masterEntity valueForKey:masterTypeGroupName] forKey:@"typeGroupName"];

    }
    DLog(@"Added %d entities of type %@ from Master", masterArray.count, entityName);

}

-(void) copyManagedObjectAttributesFrom: (NSManagedObject *) source cloned:(NSManagedObject *)cloned entityName:(NSString *) entityName
{
    
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:source.managedObjectContext] attributesByName];
    
    for (NSString *attr in attributes) {
        [cloned setValue:[source valueForKey:attr] forKey:attr];
    }
}

-(NSArray *) fetchByTypeGroupNameForCompany: (NFDCompanySetting) companySetting entityName:(NSString *) entityName context:(NSManagedObjectContext *) context
{
    NSArray *entityArray = nil;
    
    NSPredicate *predicate = [self createPredicateForTypeGroupName:companySetting];
    if (predicate) {
        NSError *error;
        entityArray = [context executeFetchRequestForEntityName:entityName predicate:predicate error:&error];
    }

    return entityArray;
}

-(NSPredicate *) createPredicateForTypeGroupName:(NFDCompanySetting) companySetting
{
    NSPredicate *predicate = nil;
    
    NSString *typeGroupColumnName = nil;
    switch (companySetting) {
        case NFDCompanySettingNJA:
            typeGroupColumnName = @"typeGroupNameForNJA";
            break;
        case NFDCompanySettingNJE:
            typeGroupColumnName = @"typeGroupNameForNJE";
            break;
        default:
            break;
    }
    
    if (typeGroupColumnName != nil) {
        predicate = [NSPredicate predicateWithFormat:@"(%K != nil) AND %K.length > 0", typeGroupColumnName, typeGroupColumnName];
    }
    
    return predicate;
}


@end
