//
//  NFDDatabaseBuilderValidation.m
//  FliteDeck
//
//  Created by Jeff Bailey on 12/26/13.
//
//

#import "NFDDatabaseBuilderValidation.h"

#import "NFDPersistenceManager.h"
#import "NFDMasterAircraftType.h"
#import "NFDMasterAircraftTypeGroup.h"
#import "NFDAircraftTypeService.h"
#import "NSManagedObjectContext+Utility.h"


@implementation NFDDatabaseBuilderValidation


- (void) validateFlightDeckDatabase
{
    [self validateMasterAircraftTypes];
    [self validateMasterAircraftTypeGroups];
}

- (void) validateMasterAircraftTypes
{
    
    NSManagedObjectContext *context = [[NFDPersistenceManager sharedInstance] mainMOC];
    
    NSArray *acTypeArray = [context executeFetchRequestForEntityName:[NFDMasterAircraftType entityName] predicate:nil error:nil];
    
    for (NFDMasterAircraftType *acType in acTypeArray) {
        if (![acType.typeGroupNameForNJA isEmptyOrWhitespace]) {
            if (![self foundMasterAircraftTypeGroupForTypeGroupColumnName:@"typeGroupNameForNJA" context:context]) {
                self.numErrors++;
                NSLog(@"ERROR: Aircraft type %@ has a bad typeGroupNameForNJA %@", acType.typeName, acType.typeGroupNameForNJA);
            }
        }
        
        if (![acType.typeGroupNameForNJE isEmptyOrWhitespace]) {
            if (![self foundMasterAircraftTypeGroupForTypeGroupColumnName:@"typeGroupNameForNJE" context:context]) {
                self.numErrors++;
                NSLog(@"ERROR: Aircraft type %@ has a bad typeGroupNameForNJE %@", acType.typeName, acType.typeGroupNameForNJE);
            }
        }
        
        if ([acType.typeGroupNameForNJE isEmptyOrWhitespace] && [acType.typeGroupNameForNJA isEmptyOrWhitespace]){
            self.numWarnings++;
            NSLog(@"WARNING: Aircraft type has no NJE or NJA typeGroupName: %@", acType.typeName);
        }
    }
}

- (void) validateMasterAircraftTypeGroups
{
    NSManagedObjectContext *context = [[NFDPersistenceManager sharedInstance] mainMOC];
    NFDAircraftTypeService *service = [[NFDAircraftTypeService alloc] init];

    NSArray *acGroupArray = [context executeFetchRequestForEntityName:[NFDMasterAircraftTypeGroup entityName] predicate:nil error:nil];
    
    for (NFDMasterAircraftTypeGroup *acGroup in acGroupArray) {
        
        if ([acGroup.typeGroupNameForNJE isEmptyOrWhitespace] && [acGroup.typeGroupNameForNJA isEmptyOrWhitespace]){
            self.numWarnings++;
            NSLog(@"WARNING: Aircraft Group has no NJE or NJA typeGroupName: %@", acGroup.acPerformanceTypeName);
        }
        
        NFDMasterAircraftType *acType = [service queryMasterAircraftTypesByTypeName:acGroup.acPerformanceTypeName];
        if (acType == nil) {
            NSLog(@"ERROR: Aircraft Group NJA: <%@> NJA: <%@> has a bad acPerformanceTypeName of <%@>", acGroup.typeGroupNameForNJA, acGroup.typeGroupNameForNJE, acGroup.acPerformanceTypeName);
            self.numErrors++;
        }
    }
    
}

- (BOOL) foundMasterAircraftTypeGroupForTypeGroupColumnName:(NSString *) typeGroupColumnName context:(NSManagedObjectContext *)context
{
    NSError *error;
    BOOL found = NO;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K != nil) AND %K.length > 0", typeGroupColumnName, typeGroupColumnName];
    
    
   NSInteger count = [context countForFetchRequestForEntityName:[NFDMasterAircraftTypeGroup entityName] predicate:predicate error:&error];
    if (error) {
        DLog(@"%@",[error description]);
    }
    
    if (count > 0) {
        found = YES;
    }
    return found;
}

@end
