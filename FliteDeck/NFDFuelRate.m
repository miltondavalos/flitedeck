#import "NFDFuelRate.h"

#import "NFDPersistenceService.h"

@interface NFDFuelRate ()

// Private interface goes here.

@end


@implementation NFDFuelRate

// Custom logic goes here.

+(void) resetRelationshipsToAircraftTypes: (NSManagedObjectContext *) context error:(NSError **)error
{
    
    NSArray *allRates = [[NFDPersistenceService sharedInstance]  getAll: [NFDFuelRate entityName] sortedBy: nil];
    
    for (NFDFuelRate *fuelRate in allRates) {
        fuelRate.aircraftType = [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"AircraftType"
                                                                              predicateKey:@"typeName"
                                                                            predicateValue:fuelRate.typeName
                                                                        includeSubEntities:NO
                                                                                   context:context
                                                                                     error:error];
    }
}

@end
