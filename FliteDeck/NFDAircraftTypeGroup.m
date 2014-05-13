#import "NFDAircraftTypeGroup.h"
#import "NFDFuelRate.h"
#import "NFDPersistenceManager.h"

@interface NFDAircraftTypeGroup ()

// Private interface goes here.

@end


@implementation NFDAircraftTypeGroup

// Custom logic goes here.

- (NFDFuelRate *)fuelRate
{
    NSError *error;
    NSArray *fuelRates = [NCLPersistenceUtil executeFetchRequestForEntityName:@"FuelRate"
                                                                 predicateKey:@"typeName"
                                                               predicateValue:self.acPerformanceTypeName
                                                                      sortKey:nil
                                                           includeSubEntities:NO
                                                                      context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                        error:&error];
    if (fuelRates && fuelRates.count > 0)
    {
        return fuelRates[0];
    }
    
    return nil;
}

@end
