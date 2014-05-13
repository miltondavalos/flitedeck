#import "_NFDFuelRate.h"

@interface NFDFuelRate : _NFDFuelRate {}
// Custom logic goes here.

+(void) resetRelationshipsToAircraftTypes: (NSManagedObjectContext *) context error:(NSError **)error;

@end
