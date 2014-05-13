#import "NFDFlight.h"

#import "UIColor+FliteDeckColors.h"

@implementation NFDFlight

- (BOOL)isUpgradedFlight
{
    if (self.aircraftTypeComparision == NFDAircraftTypeUpgrade && [self flightInAirOrFlown]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isDowngradedFlight
{
    if (self.aircraftTypeComparision == NFDAircraftTypeDowngrade && [self flightInAirOrFlown]) {
        return YES;
    }
    
    return NO;
}

- (BOOL) hasYellowAlert
{
    BOOL alerts = NO;
    if ([self allottedRemainingHoursAreNegative] || [self availableRemainingHoursAreNegative]){
        alerts = YES;
    } else {
        NFDAircraftTypeService *aircraftTypeService = [[NFDAircraftTypeService alloc] init];
        if ([aircraftTypeService isContractExpiringOrExpired:self.contractEndDate]) {
            alerts = YES;
        }
    }
    
    return alerts;
}

- (BOOL) hasGreenAlert
{
    BOOL positiveAlert = NO;
    
    // Business requirement to only check for flights in air or flown. (Future flights may change)
    if (self.aircraftTypeComparision == NFDAircraftTypeUpgrade && [self flightInAirOrFlown]) {
        positiveAlert = YES;
    }
    
    return positiveAlert;
}

- (NFDAircraftTypeComparisionResult)aircraftTypeComparision
{
    if (_aircraftTypeComparision == NFDAircraftTypeUnknown) {
        
        NFDAircraftTypeService *aircraftTypeService = [[NFDAircraftTypeService alloc] init];
        _aircraftTypeComparision = [aircraftTypeService compareAircraftTypes:self.aircraftTypeRequested actualType:self.aircraftTypeActual];
    }
    return _aircraftTypeComparision;
}

- (BOOL) flightInAirOrFlown
{
    BOOL inAirOrFlown = NO;
    if ([FLIGHT_STATUS_FLOWN isEqualToString:self.flightStatus] ||
        [FLIGHT_STATUS_IN_FLIGHT isEqualToString:self.flightStatus]) {
        inAirOrFlown = YES;
    }
    
    return inAirOrFlown;
}

- (BOOL) allottedRemainingHoursAreNegative
{
    return ([[NSNumber numberFromObject:self.allottedRemainingHours shouldUseZeroDefault:YES] intValue] < 0);
}

- (BOOL) availableRemainingHoursAreNegative
{
    return ([[NSNumber numberFromObject:self.availableRemainingHours shouldUseZeroDefault:YES] intValue] < 0);
}

- (BOOL) hasPassengers
{
    if (self.passengers.count) {
        return YES;
    }
    
    return NO;
}

- (BOOL) hasRecentAccountCases
{
    if ([self.accountControllableRecentCount isEqualToString:@"0"]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) hasLegCases
{
    if ([self.legTotalCount isEqualToString:@"0"]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) hasOpenLegCases
{
    if ([self.legOpenCount isEqualToString:@"0"]) {
        return NO;
    }
    
    return YES;
}

- (NSString *)legOpenCount
{
    return [self checkCaseCountStringForNull:_legOpenCount];
}

- (NSString *)legTotalCount
{
    return [self checkCaseCountStringForNull:_legTotalCount];
}

- (NSString *)accountTotalCount
{
    return [self checkCaseCountStringForNull:_accountTotalCount];
}

- (NSString *)accountOpenCount
{
    return [self checkCaseCountStringForNull:_accountOpenCount];
}

- (NSString *)accountControllableCount
{
    return [self checkCaseCountStringForNull:_accountControllableCount];
}

- (NSString *)accountControllableRecentCount
{
    return [self checkCaseCountStringForNull:_accountControllableRecentCount];
}

- (NSString *)checkCaseCountStringForNull:(NSString *)countString
{
    if ([countString isEqual:[NSNull null]] || [countString isEmptyOrWhitespace]) {
        return @"0";
    } else if (countString) {
        return countString;
    } else {
        return nil;
    }
}

@end