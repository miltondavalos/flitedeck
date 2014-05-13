#import "_NFDContractRate.h"

@interface NFDContractRate : _NFDContractRate {}
// Custom logic goes here.

+(void) resetRelationshipsToAircraftType:(NSManagedObjectContext *) context error:(NSError **)error;

@end
