#import "NFDContractRate.h"
#import "NFDPersistenceService.h"


@interface NFDContractRate ()

// Private interface goes here.

@end


@implementation NFDContractRate

// Custom logic goes here.

+(void) resetRelationshipsToAircraftType:(NSManagedObjectContext *) context error:(NSError **)error
{
    
    NSArray *allRates = [[NFDPersistenceService sharedInstance]  getAll: [NFDContractRate entityName] sortedBy: nil];
    for (NFDContractRate *newContractRate in allRates) {
        NSArray *types = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                 predicateKey:@"typeGroupName"
                                                               predicateValue:newContractRate.typeGroupName
                                                                      sortKey:nil
                                                           includeSubEntities:NO
                                                                      context:context
                                                                        error:error];
        if (types != nil)
            newContractRate.aircraftTypes = [NSSet setWithArray:types];
        
    }
}

@end
