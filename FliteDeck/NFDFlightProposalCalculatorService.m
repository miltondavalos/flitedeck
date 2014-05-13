 //
//  NFDFlightProposalCalculatorService.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 4/4/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalCalculatorService.h"
#import "NFDPersistenceManager.h"
#import "NFDContractRate.h"
#import "NFDFuelRate.h"
#import "NFDAircraftType.h"
#import "NFDAircraftTypeGroup.h"
#import "NFDFlightProposalManager.h"
#import "NCLFramework.h"

#define FET_TAX_RATE 0.075f

@implementation NFDFlightProposalCalculatorService

#pragma mark - Lookup Values

+ (NSArray*)inventoryForAircraftType:(NSString*)aircraftType
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ AND share_immediately_available != %@ AND share_immediately_available != %@", aircraftType, @"0", @"null"];
    return [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftInventory" predicate:predicate context:[[NFDPersistenceManager sharedInstance] mainMOC] error:nil];
}

+ (NSArray *)inventoryForAircraftType:(NSString *)aircraftType yearsOfServiceRemaining:(int)yearsOfServiceRemaining
{
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:yearsOfServiceRemaining];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *fiveYearsFromNow = [gregorian dateByAddingComponents:dateComponents toDate:now options:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ AND ((contracts_until_date >= %@) OR (contracts_until_date == null)) AND share_immediately_available != %@ AND share_immediately_available != %@ AND sales_value > 0", aircraftType, fiveYearsFromNow, @"0", @"null"];
    return [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftInventory" predicate:predicate context:[[NFDPersistenceManager sharedInstance] mainMOC] error:nil];
}

+ (NSArray *)annualHourAllotmentChoicesForGeneralProductType:(kGeneralProductType)gpt maxHoursAvailable:(NSNumber *)maxHoursAvailable
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    switch (gpt) 
    {
        case kGeneralProductTypeShare:
        {
            //NOTE: TO BE HANDLED IN THE AGGREGATE VIEW
            //            [tempArray addObject:@"25 Multi"];
            //            [tempArray addObject:@"50 Multi"];
            
            if (maxHoursAvailable == nil || [maxHoursAvailable intValue] == 0) {
                maxHoursAvailable = [NSNumber numberWithInt:800];
            }
            
            int numberOfOptions = ([maxHoursAvailable intValue] / 25);
            
            for (int i = 1; i <= numberOfOptions; i++) 
            {
                [tempArray addObject:[NSString stringWithFormat:@"%i", (i*25)]];
                if (i < 3)
                {
                    [tempArray addObject:[NSString stringWithFormat:@"%i Multi", i*25]];
                }
            }
            
            return [NSArray arrayWithArray:tempArray];
            break;
        }
        case kGeneralProductTypeCard:
        {
            NSArray *tempArray = [NSArray arrayWithObjects:@"25 Hour Card", @"50 Hour Card", @"Half Card", CROSS_COUNTRY_CARD_TYPE_LABEL, nil];
            return tempArray;
            break;
        }
        case kGeneralProductTypePhenomTransistion:
        {
            for (int i = 50; i < 801; i = i + 25) 
            {
                [tempArray addObject:[NSString stringWithFormat:@"%i",i]];
                if (i == 50)
                {
                    [tempArray addObject:@"50 Multi"];
                }
            }
            return [NSArray arrayWithArray:tempArray];
            break;
        }
        default:
        {
            return nil;
            break;
        }
    }
}

+ (NSArray *)numberOfAnnualCardsChoices
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 1; i < 11; i++) 
    {
        [tempArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
    return [NSArray arrayWithArray:tempArray];
}

+ (NSArray *)aircraftComboChoices
{
    NSArray *tempArray = [NSArray arrayWithObjects:
                          @"Hawker 400XP | Hawker 900XP",
                          @"Citation V Ultra | Citation X",
                          @"Citation Encore/+ | G200",
                          @"Phenom 300 | Global 5000",nil];
    return tempArray;
    
}

+ (NSArray *)aircraftChoicesForCard
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cardPurchase25Hour != 0"];
    NSError *error;
    NSArray *rates = [NCLPersistenceUtil executeFetchRequestForEntityName:@"ContractRate" predicate:pred sortDescriptors:nil includeSubEntities:NO context:[[NFDPersistenceManager sharedInstance] mainMOC] returnObjectsAsFaults:NO error:&error];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    
    NSArray *aircraftTypeGroups = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftTypeGroup" predicate:nil sortDescriptors: sortDescriptors includeSubEntities:NO context:[[NFDPersistenceManager sharedInstance] mainMOC] returnObjectsAsFaults:NO error:&error];
    
    
    NSMutableArray *groupNames = [[NSMutableArray alloc] init];
    for (NFDAircraftTypeGroup *typeGroup in aircraftTypeGroups)
    {
        [groupNames addObject:typeGroup.typeGroupName];
    }
        
    NSMutableArray *rateGroupNames = [[NSMutableArray alloc] init];
    if (rates && ( [rates count] > 0 ) )
    {
        for (NFDContractRate *rate in rates)
        {
            [rateGroupNames addObject:rate.typeGroupName];
        }
    }
        
    for (NSString *name in groupNames)
    {
        if ([rateGroupNames containsObject:name])
        {
            [array addObject:name];
        }
    }
    return array;
}


+ (NSArray *)aircraftChoicesForLease
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"leaseOccupiedHourlyFee != 0"];
    NSError *error;
    NSArray *rates = [NCLPersistenceUtil executeFetchRequestForEntityName:@"ContractRate"
                                                                predicate:pred
                                                          sortDescriptors:nil
                                                        includeSubEntities:NO
                                                                  context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                    returnObjectsAsFaults:NO
                                                                    error:&error];
    
    NSMutableArray *rateGroupNames = [[NSMutableArray alloc] init];
    if (rates && ( [rates count] > 0 ) )
    {
        for (NFDContractRate *rate in rates)
        {
            [rateGroupNames addObject:rate.typeGroupName];
        }
    }

    
    NSArray *aircraftTypes = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                        predicate:nil
                                                                  sortDescriptors:[NFDFlightProposalCalculatorService createDisplayOrderSortDescriptor]
                                                               includeSubEntities: NO
                                                                          context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                            returnObjectsAsFaults: NO
                                                                    error:&error];
    for (NFDAircraftType *aircraftType in aircraftTypes)
    {
        if ([rateGroupNames containsObject:aircraftType.typeGroupName])
        {
            [array addObject:aircraftType.displayName];
        }
    }
    
    return array;
}

+ (NSArray *) createDisplayOrderSortDescriptor
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    return [[NSArray alloc] initWithObjects:sort, nil];
}

+ (NSString *)aircraftTypeNameFromDisplayName:(NSString *)displayName
{
    NSString *typeName = @"";
    if (displayName)
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"displayName = %@", displayName];
        NSError *error;
        NSArray *aircraftTypes = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                            predicate:pred
                                                                      sortDescriptors:nil
                                                                   includeSubEntities: NO
                                                                              context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                returnObjectsAsFaults:NO
                                                                                error:&error];
        typeName = [(NFDAircraftType *)[aircraftTypes objectAtIndex:0] typeName];
    }
    return typeName;
}

+ (NSString *)aircraftDisplayNameFromTypeName:(NSString *)typeName
{
    NSString *displayName = @"";
    if (typeName)
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"typeName = %@", typeName];
        NSError *error;
        NSArray *aircraftTypes = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                            predicate:pred
                                                                      sortDescriptors:nil
                                                                   includeSubEntities: NO
                                                                              context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                returnObjectsAsFaults:NO
                                                                                error:&error];
        displayName = [(NFDAircraftType *)[aircraftTypes objectAtIndex:0] displayName];
    }
    return displayName;
}

//TODO: Update based off of values in rate table
+ (NSArray *)prepayEstimateChoices
{
    return [NSArray arrayWithObjects:@"None", @"MMF", @"OHF & Fuel", @"MMF & OHF & Fuel", @"Lease", @"Lease & MMF", @"Lease & MMF & OHF & Fuel", nil];
}

+ (NSArray *)prepayEstimateChoicesForProductCode:(int)productCode
{
    NSMutableArray *choices = [[NSMutableArray alloc] init];
    
    [choices addObject:@"None"];
    [choices addObject:@"MMF"];
    [choices addObject:@"OHF & Fuel"];
    [choices addObject:@"MMF, OHF & Fuel"];
    
    if (productCode == SHARE_LEASE_PRODUCT)
    {
        [choices addObject:@"Lease"];
        [choices addObject:@"Lease & MMF"];
        [choices addObject:@"Lease, MMF, OHF & Fuel"];
    }
    
    return [NSArray arrayWithArray:choices];

}

+ (NSArray *)leaseTermChoicesForAircraftType:(NSString *)aircraftType
{
    NSMutableArray *leaseTermDisplayNames = [NSMutableArray array];
    
    if (aircraftType == nil) {
        leaseTermDisplayNames = [NSMutableArray arrayWithObjects:LEASE_TERM_24_MONTHS, LEASE_TERM_36_MONTHS, LEASE_TERM_48_MONTHS, LEASE_TERM_60_MONTHS, nil];
    }
    
    NFDContractRate *contractRate = [NFDFlightProposalCalculatorService contractRateInfoForAircraftType:aircraftType];

    if ([[contractRate lease12MonthFee] intValue] > 0) {
        [leaseTermDisplayNames addObject:LEASE_TERM_12_MONTHS];
    }
    if ([[contractRate lease24MonthFee] intValue] > 0) {
        [leaseTermDisplayNames addObject:LEASE_TERM_24_MONTHS];
    }
    if ([[contractRate lease36MonthFee] intValue] > 0) {
        [leaseTermDisplayNames addObject:LEASE_TERM_36_MONTHS];
    }
    if ([[contractRate lease48MonthFee] intValue] > 0) {
        [leaseTermDisplayNames addObject:LEASE_TERM_48_MONTHS];
    }
    if ([[contractRate lease60MonthFee] intValue] > 0) {
        [leaseTermDisplayNames addObject:LEASE_TERM_60_MONTHS];
    }
    
    return [NSArray arrayWithArray:leaseTermDisplayNames];
}

+ (NSArray *)fuelPeriodChoicesForAircraftChoices:(NSArray *)aircraftChoices isQualified:(BOOL)isQualified
{
    NSMutableArray *fuelMonthData = [[NSMutableArray alloc] init];
    for (NSString *aircraftChoice in aircraftChoices)
    {
        NFDFuelRate *fuelRate = [NFDFlightProposalCalculatorService fuelRateInfoForAircraftGroupName:aircraftChoice];
        NSString *aircraftType = [fuelRate typeName];
        NSArray *tempArray = [NFDFlightProposalCalculatorService fuelPeriodChoicesForAircraftType:aircraftType isQualified:YES];
        if (((fuelMonthData.count > 0) && ([[fuelMonthData objectAtIndex:0] count] > [[tempArray objectAtIndex:0] count])) || (fuelMonthData.count == 0))
        {
            fuelMonthData = [NSMutableArray arrayWithArray:tempArray];
        }
    }
    return fuelMonthData;
}

+ (NSArray *)fuelPeriodChoicesForAircraftType:(NSString *)aircraftType isQualified:(bool)isQualified
{
    NSMutableArray *fuelDisplayNames = [NSMutableArray array];
    NSMutableArray *fuelRateValues = [NSMutableArray array];
    
    NSNumber *zero = [NSNumber numberWithInt:0];
    
    if (aircraftType == nil) {
        fuelDisplayNames = [NSMutableArray arrayWithObjects:MONTH_RATE_LAST, MONTH_RATE_3_MONTHS, MONTH_RATE_6_MONTHS, MONTH_RATE_12_MONTHS, nil];
        fuelRateValues = [NSMutableArray arrayWithObjects:zero, zero, zero, zero, nil];
        return [NSArray arrayWithObjects:fuelDisplayNames, fuelRateValues, nil];
    }
    
    NFDFuelRate *fuelRate = [NFDFlightProposalCalculatorService fuelRateInfoForAircraftType:aircraftType];

    if (isQualified) {
        if ([[fuelRate qualified1MonthRate] intValue] > 0) {
            [fuelDisplayNames addObject:MONTH_RATE_LAST];
            [fuelRateValues addObject:[fuelRate qualified1MonthRate]];
        }
        if ([[fuelRate qualified3MonthRate] intValue] > 0) {
            [fuelDisplayNames addObject:MONTH_RATE_3_MONTHS];
            [fuelRateValues addObject:[fuelRate qualified3MonthRate]];
        }
        if ([[fuelRate qualified6MonthRate] intValue] > 0) {
            [fuelDisplayNames addObject:MONTH_RATE_6_MONTHS];
            [fuelRateValues addObject:[fuelRate qualified6MonthRate]];
        }
        if ([[fuelRate qualified12MonthRate] intValue] > 0) {
            [fuelDisplayNames addObject:MONTH_RATE_12_MONTHS];
            [fuelRateValues addObject:[fuelRate qualified12MonthRate]];
        }
    } else {
        if ([[fuelRate nonQualified1MonthRate] intValue] > 0) {
            [fuelDisplayNames addObject:MONTH_RATE_LAST];
            [fuelRateValues addObject:[fuelRate nonQualified1MonthRate]];
        }
        if ([[fuelRate nonQualified3MonthRate] intValue] > 0) {
            [fuelDisplayNames addObject:MONTH_RATE_3_MONTHS];
            [fuelRateValues addObject:[fuelRate nonQualified3MonthRate]];
        }
        if ([[fuelRate nonQualified6MonthRate] intValue] > 0) {
            [fuelDisplayNames addObject:MONTH_RATE_6_MONTHS];
            [fuelRateValues addObject:[fuelRate nonQualified6MonthRate]];
        }
        if ([[fuelRate nonQualified12MonthRate] intValue] > 0) {
            [fuelDisplayNames addObject:MONTH_RATE_12_MONTHS];
            [fuelRateValues addObject:[fuelRate nonQualified12MonthRate]];
        }
    }
    NSArray *choices = [NSArray arrayWithObjects:fuelDisplayNames, fuelRateValues, nil];

    return choices; 
}

+ (NSNumber *)acquisitionCostForAircraftTypeGroup:(NSString *)aircraftTypeGroup
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typeGroupName = %@", aircraftTypeGroup];
    NSArray *returnedContractRates = [NCLPersistenceUtil executeFetchRequestForEntityName:@"ContractRate"
                                                                                predicate:predicate
                                                                          sortDescriptors:nil
                                                                       includeSubEntities: NO
                                                                                  context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                    returnObjectsAsFaults:NO
                                                                                    error:nil];
    NFDContractRate *contractRate = [returnedContractRates objectAtIndex:0];
    NSNumber *acquisitionCost = [contractRate acquisitionCost];
    if (acquisitionCost != nil) {
        return acquisitionCost;
    }
    
    return [NSNumber numberWithInt:0];
}


#pragma mark - Contract Rates by Airctaft Type

+ (NFDFuelRate*)fuelRateInfoForAircraftType:(NSString*)aircraftType
{
    NSError *error = nil;
    NSArray *fuelRates = [NCLPersistenceUtil executeFetchRequestForEntityName:@"FuelRate"
                                                                predicateKey:@"typeName"
                                                              predicateValue:aircraftType
                                                                      sortKey:nil
                                                           includeSubEntities:NO
                                                                     context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                       error:&error];
    
    if (error ||
        fuelRates.count <= 0)
    {
        NSLog(@"Error getting fuel rates for aircraft type %@: error=%@", aircraftType, [error localizedDescription]);
        return nil;
    }
    
    NFDFuelRate *rate = ((NFDFuelRate*)[fuelRates objectAtIndex:0]);
    
    return rate;
}

+ (NFDFuelRate*)fuelRateInfoForAircraftGroupName:(NSString*)aircraftGroupName
{
    NSError *error = nil;
    NSArray *aircraft = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftTypeGroup"
                                                                predicateKey:@"typeGroupName"
                                                              predicateValue:aircraftGroupName
                                                                     sortKey:nil
                                                          includeSubEntities:NO
                                                                     context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                       error:&error];
    
    if (error ||
        aircraft.count <= 0)
    {
        NSLog(@"Error getting fuel rates for aircraft type %@: error=%@", aircraftGroupName, [error localizedDescription]);
        return nil;
    }
    
    NFDFuelRate *rate = [((NFDAircraftTypeGroup*)[aircraft objectAtIndex:0]) fuelRate];
    
    return rate;
}

+ (NFDContractRate*)contractRateInfoForAircraftType:(NSString*)aircraftType
{
    NSError *error = nil;
    NSArray *aircraft = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                predicateKey:@"typeName"
                                                              predicateValue:aircraftType
                                                                     sortKey:nil
                                                          includeSubEntities:NO
                                                                     context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                       error:&error];
    
    if (error ||
        aircraft.count <= 0)
    {
        NSLog(@"Error getting contract rates for aircraft type %@: error=%@", aircraftType, [error localizedDescription]);
        return nil;
    }
    
    NFDContractRate *rate = ((NFDAircraftType*)[aircraft objectAtIndex:0]).contractRate;

    return rate;
}


+ (NFDContractRate*)contractRateInfoForAircraftGroupName:(NSString*)aircraftGroupName
{
    NSError *error = nil;
    NSArray *aircraft = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                predicateKey:@"typeGroupName"
                                                              predicateValue:aircraftGroupName
                                                                     sortKey:nil
                                                          includeSubEntities:NO
                                                                     context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                       error:&error];
    
    if (error ||
        aircraft.count <= 0)
    {
        NSLog(@"Error getting contract rates for aircraft type %@: error=%@", aircraftGroupName, [error localizedDescription]);
        return nil;
    }
    
    NFDContractRate *rate = ((NFDAircraftType*)[aircraft objectAtIndex:0]).contractRate;
    
    return rate;
}

#pragma mark - Rounding Calculated Results

+(NSNumber *)applyRoundingTo:(NSNumber*)value{
    if ( value && ( [value intValue] > 0 ) ){
        @try {
            NSDecimalNumber *originalValue = [NSDecimalNumber 
                decimalNumberWithDecimal:[[NSNumber numberWithDouble:[value doubleValue]] decimalValue]];
            //First round up to the nearest penny...
            NSDecimalNumberHandler *decimalHandler = [NSDecimalNumberHandler 
                decimalNumberHandlerWithRoundingMode:NSRoundPlain
                    scale:2
                    raiseOnExactness:NO
                    raiseOnOverflow:NO
                    raiseOnUnderflow:NO
                    raiseOnDivideByZero:NO];
            NSDecimalNumber *nearestPenny = [originalValue 
                decimalNumberByRoundingAccordingToBehavior:decimalHandler];
            //Then round up to the nearest dollar...
            decimalHandler = [NSDecimalNumberHandler 
                decimalNumberHandlerWithRoundingMode:NSRoundPlain
                    scale:0
                    raiseOnExactness:NO
                    raiseOnOverflow:NO
                    raiseOnUnderflow:NO
                    raiseOnDivideByZero:NO];
            NSDecimalNumber *nearestDollar = [nearestPenny 
                decimalNumberByRoundingAccordingToBehavior:decimalHandler];
            
            return [NSNumber numberWithInt:[nearestDollar intValue]];
            
        }
        @catch (NSException *exception) {
            return [NSNumber numberWithInt:0];
        }
    }else{
        return [NSNumber numberWithInt:0];
    }
}

#pragma mark - Share - Purchase - Deposit

+ (NSNumber *)calculateDepositFromAcquisitionCost:(NSNumber *)acquisitionCost qualified:(BOOL)qualified
{
    double deposit = qualified ? acquisitionCost.doubleValue * 0.2 : acquisitionCost.doubleValue * 0.2 * 1.075;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:deposit]];
}


#pragma mark - Share Products - Monthly Lease Fee

// lease fee using type instead of group
+(NSNumber*)calculateMonthlyLeaseFeeForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm
{
    NSNumber *leaseFee = [NSNumber numberWithInt:0];
    NFDContractRate *contractRate = [NFDFlightProposalCalculatorService contractRateInfoForAircraftType:aircraftType];
    
    if ([leaseTerm  isEqual: LEASE_TERM_12_MONTHS]) {
        leaseFee = [contractRate lease12MonthFee];
    } else if ([leaseTerm  isEqual: LEASE_TERM_24_MONTHS]) { 
        leaseFee = [contractRate lease24MonthFee];
    } else if ([leaseTerm  isEqual: LEASE_TERM_36_MONTHS]) {
        leaseFee = [contractRate lease36MonthFee];
    } else if ([leaseTerm  isEqual: LEASE_TERM_48_MONTHS]) {
        leaseFee = [contractRate lease48MonthFee];
    } else if ([leaseTerm  isEqual: LEASE_TERM_60_MONTHS]) {
        leaseFee = [contractRate lease60MonthFee];
    }
    
    float fullLeaseShare = ([leaseFee floatValue] * 16);
    
    float monthlyLeaseFee = (fullLeaseShare * ([annualHours floatValue] / 800));
    
    NSNumber *roundedFee = [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:monthlyLeaseFee]];
    
    return roundedFee;
}

+(NSNumber*)calculateMonthlyLeaseFeeFETForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm isQualified:(BOOL)qualified
{
    NSNumber *leaseFee = [NSNumber numberWithInt:0];
    
    if (!qualified)
    {
        NFDContractRate *contractRate = [NFDFlightProposalCalculatorService contractRateInfoForAircraftType:aircraftType];
        
        if ([leaseTerm  isEqual: LEASE_TERM_12_MONTHS]) {
            leaseFee = [contractRate lease12MonthFee];
        } else if ([leaseTerm  isEqual: LEASE_TERM_24_MONTHS]) { 
            leaseFee = [contractRate lease24MonthFee];
        } else if ([leaseTerm  isEqual: LEASE_TERM_36_MONTHS]) {
            leaseFee = [contractRate lease36MonthFee];
        } else if ([leaseTerm  isEqual: LEASE_TERM_48_MONTHS]) {
            leaseFee = [contractRate lease48MonthFee];
        } else if ([leaseTerm  isEqual: LEASE_TERM_60_MONTHS]) {
            leaseFee = [contractRate lease60MonthFee];
        }
    }    
    float fullLeaseShare = ([leaseFee floatValue] * 16);
    
    float monthlyLeaseFee = (fullLeaseShare * ([annualHours floatValue] / 800));
    
    float monthlyLeaseFeeFET = monthlyLeaseFee * 0.075;
    
    
    NSNumber *roundedFee = [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:monthlyLeaseFeeFET]];

    return roundedFee;
}


+ (NSNumber *)calculateAnnualLeaseFeeForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm
{
    NSNumber *monthlyLeaseFee = [NFDFlightProposalCalculatorService calculateMonthlyLeaseFeeForAircraftType:aircraftType annualHours:annualHours leaseTerm:leaseTerm];
    double annualLeaseFee = ([monthlyLeaseFee doubleValue] * 12);
    return [NSNumber numberWithDouble:annualLeaseFee];
}

+ (NSNumber *)calculateAnnualLeaseFETForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm isQualified:(BOOL)qualified
{
    NSNumber *annualLeaseFee = [NFDFlightProposalCalculatorService calculateAnnualLeaseFeeForAircraftType:aircraftType annualHours:annualHours leaseTerm:leaseTerm];
    double annualLeaseFET = qualified ? 0 : ([annualLeaseFee doubleValue] * FET_TAX_RATE);
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:annualLeaseFET]];
}

+ (NSNumber*)calculateMonthlyLeaseDepositForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm isQualified:(BOOL)qualified
{
    double monthlyLeaseFee = [[NFDFlightProposalCalculatorService calculateMonthlyLeaseFeeForAircraftType:aircraftType annualHours:annualHours leaseTerm:leaseTerm] doubleValue];
    
    double leaseDeposit = qualified ? monthlyLeaseFee * 3.0 : monthlyLeaseFee * 3.0 * 1.075;
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:leaseDeposit]];
}


#pragma mark - Share Products - MMF

//Internal calculation, no rounding applied...
+(NSNumber*)calculateMonthlyManagementFeeRateForAircraftVintage:(NSString*)vintage andShareSize:(NSString*)hours withRates:(NFDContractRate*)contractRate isMultiShare:(BOOL)isMultiShare
{
    float numberOfHours = [hours floatValue];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    int yearNow = [components year];
    int yearVintage = [vintage intValue];
    
    NSNumber *rate = [contractRate shareMonthlyMgmtFee];
    NSNumber *premium = isMultiShare ? [NSNumber numberWithInt:0] : [contractRate shareMonthlyMgmtFeePremium];
    NSNumber *accelerator = [contractRate shareMonthlyMgmtFeeAccel1];

    
    
    float result = 0;
    if ( rate && ( rate > 0 ) ){
        result = result + ( [rate floatValue] * ( numberOfHours / 50.0f ) );
        if ( premium && ( premium > 0 ) ){
            if ( numberOfHours < 75 ){
                result = result + ( [premium floatValue] * ( numberOfHours / 50.0f ) );
            }
        }
        if ( accelerator && ( accelerator > 0 ) ){
            if (yearNow >= yearVintage + 5){
                result = result + ( [accelerator floatValue] * ( numberOfHours / 50.0f ) );
            }
        }
    }
    return [NSNumber numberWithFloat:result];
}

//Uses Aircraft Type for Rates
+(NSNumber*)calculateShareMonthlyManagementFeeRateForAircraftType:(NSString*)aircraftType andAircraftVintage:(NSString*)vintage andShareSize:(NSString*)hours isMultiShare:(BOOL)isMultiShare
{
    NFDContractRate *contractRate = [NFDFlightProposalCalculatorService contractRateInfoForAircraftType:aircraftType];
    NSNumber *mgtFeeRate = [NFDFlightProposalCalculatorService calculateMonthlyManagementFeeRateForAircraftVintage:vintage andShareSize:hours withRates:contractRate isMultiShare:isMultiShare];
    return [NFDFlightProposalCalculatorService applyRoundingTo:mgtFeeRate];
}

+(NSNumber*)calculateLeaseMonthlyManagementFeeRateForAircraftType:(NSString*)aircraftType andShareSize:(NSString*)hours isMultiShare:(BOOL)isMultiShare
{
    NFDContractRate *contractRate = [NFDFlightProposalCalculatorService contractRateInfoForAircraftType:aircraftType];
    NSNumber *rate = [contractRate shareMonthlyMgmtFee];
    NSNumber *premium = isMultiShare ? [NSNumber numberWithInt:0] : [contractRate shareMonthlyMgmtFeePremium];
    NSNumber *accelerator = [contractRate shareMonthlyMgmtFeeAccel1];
    
    float numberOfHours = [hours floatValue];
        
    float result = 0;
    if ( rate && ( rate > 0 ) )
    {
        
        result = result + (([accelerator floatValue] + [rate floatValue]) * ( numberOfHours / 50.0f ) );
        if ( premium && ( premium > 0 ) ){
            if ( numberOfHours < 75 ){
                result = result + ( [premium floatValue] * ( numberOfHours / 50.0f ) );
            }
        }
    }
    //float numberOfHours = [hours floatValue];

    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:result]];
}
//Uses Aircraft Type for Annual
+(NSNumber*)calculateShareMonthlyManagementFeeAnnualForAircraftType:(NSString*)aircraftType andAircraftVintage:(NSString*)vintage andShareSize:(NSString*)hours isMultiShare:(BOOL)isMultiShare
{
    NSNumber *mgtFeeRate = [NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeRateForAircraftType:aircraftType andAircraftVintage:vintage andShareSize:hours isMultiShare:isMultiShare];
    NSNumber *mgtFeeAnnual = [NSNumber numberWithFloat:( [mgtFeeRate floatValue] * 12.0f )];
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:mgtFeeAnnual];
}
+(NSNumber*)calculateLeaseMonthlyManagementFeeAnnualForAircraftType:(NSString*)aircraftType andShareSize:(NSString*)hours isMultiShare:(BOOL)isMultiShare
{
    float result = 12.0 * [[NFDFlightProposalCalculatorService calculateLeaseMonthlyManagementFeeRateForAircraftType:aircraftType andShareSize:hours isMultiShare:isMultiShare] floatValue];
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:result]];
}

#pragma mark - Share Products - OHF

+ (NSNumber *)calculateShareOccupiedHourlyFeeRateForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage  usingProposalYear:(NSString *)proposalYear
{
    NFDContractRate *contractRate = [NFDFlightProposalCalculatorService contractRateInfoForAircraftType:aircraftType];
    
    int rate = [[contractRate shareOccupiedHourlyFee] intValue];
    
    int ohfAccel1 = [[contractRate shareOccupiedHourlyFeeAccel1] intValue];
    int ohfAccel2 = [[contractRate shareOccupiedHourlyFeeAccel2] intValue];
    int ohfAccel3 = [[contractRate shareOccupiedHourlyFeeAccel3] intValue];
        
    int yearNow = [proposalYear intValue];
    
    int yearVintage = [vintage intValue];

    if (yearNow >= yearVintage + 2)
    {
        rate += ohfAccel1;
    }
    if (yearNow >= yearVintage + 5)
    {
        rate += ohfAccel2;
    }
    if (yearNow >= yearVintage + 10)
    {
        rate += ohfAccel3;
    }
    
    if (rate > 0)
    {
        return [NSNumber numberWithInt:rate];
    }
    
    return [NSNumber numberWithInt:0];
}

+ (NSNumber *)calculateShareOccupiedHourlyFeeRateForAircraftType:(NSString *)aircraftType andVintage:(NSString *)vintage
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    int yearNow = [components year];
    NSString *proposalYear = [NSString stringWithFormat:@"%i", yearNow];
    
    return [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
}

+ (NSNumber *)calculateShareOccupiedHourlyFeeAnnualForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage andShareSize:(NSString *)hours
{
    NSNumber *ohfRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType andVintage:vintage];
    
    return [NSNumber numberWithInt:([hours intValue] * [ohfRate intValue])];
}

+ (NSNumber *)calculateShareOccupiedHourlyFeeAnnualForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage andShareSize:(NSString *)hours usingProposalYear:(NSString *)proposalYear
{
    NSNumber *ohfRate = [NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeRateForAircraftType:aircraftType vintage:vintage usingProposalYear:proposalYear];
    
    return [NSNumber numberWithInt:([hours intValue] * [ohfRate intValue])];
}

+ (NSNumber *)calculateLeaseOccupiedHourlyFeeRateForAircraftType:(NSString *)aircraftType
{
    NFDContractRate *contractRate = [NFDFlightProposalCalculatorService contractRateInfoForAircraftType:aircraftType];
    
    return [contractRate leaseOccupiedHourlyFee];
}

+ (NSNumber *)calculateLeaseOccupiedHourlyFeeAnnualForAircraftType:(NSString *)aircraftType andShareSize:(NSString *)hours
{
    return [NSNumber numberWithInt:([[NFDFlightProposalCalculatorService calculateLeaseOccupiedHourlyFeeRateForAircraftType:aircraftType] intValue] * [hours intValue])];
}

#pragma mark - Share Products - Federal Excise Tax Calculations

+ (NSNumber *)calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:(NSNumber *)occupiedHourlyFeeRate
{
    float newOccupiedHourlyFeeRate = ([occupiedHourlyFeeRate floatValue] * FET_TAX_RATE);
    return [NSNumber numberWithFloat:newOccupiedHourlyFeeRate];
}

+ (NSNumber *)calculateShareFederalExciseTaxForOccupiedHourlyFeeAnnual:(NSNumber *)occupiedHourlyFeeAnnual
{
    float newOccupiedHourlyFeeAnnual = ([occupiedHourlyFeeAnnual floatValue] * FET_TAX_RATE);
    return [NSNumber numberWithFloat:newOccupiedHourlyFeeAnnual];
}

+ (NSNumber *)calculateShareFederalExciseTaxForAcquisitionCost:(NSNumber *)acquisitionCost
{
    double fetAcquisitionCost = ([acquisitionCost doubleValue] * FET_TAX_RATE);
    return [NSNumber numberWithDouble:fetAcquisitionCost];
}

+ (NSNumber *)calculateShareOperationalFederalExciseTaxForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare
{
    
    float ohfAnnual = [[NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:hours] floatValue];
    
    float mgtFeeAnnual = [[NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:vintage andShareSize:hours isMultiShare:isMultiShare] floatValue];
    
    float fuelAnnual = [[NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:aircraftType andFuelPeriod:fuelPeriod forNumberOfHours:hours isQualified:qualified] floatValue];
    
    float fetRate = (float)FETRATE;
    
    return [NSNumber numberWithFloat:(ohfAnnual + mgtFeeAnnual + fuelAnnual) * fetRate];
}

+ (NSNumber *)calculateLeaseOperationalFederalExciseTaxForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare
{
    
    float ohfAnnual = [[NFDFlightProposalCalculatorService calculateLeaseOccupiedHourlyFeeAnnualForAircraftType:aircraftType andShareSize:hours] floatValue];
    
    float mgtFeeAnnual = [[NFDFlightProposalCalculatorService calculateLeaseMonthlyManagementFeeAnnualForAircraftType:aircraftType andShareSize:hours isMultiShare:isMultiShare] floatValue];
    
    float fuelAnnual = [[NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:aircraftType andFuelPeriod:fuelPeriod forNumberOfHours:hours isQualified:qualified] floatValue];
    
    float fetRate = (float)FETRATE;
    
    return [NSNumber numberWithFloat:(ohfAnnual + mgtFeeAnnual + fuelAnnual) * fetRate];
}

#pragma mark - Card Products - Purchase Price

+ (NSNumber *)calculateCardPurchasePriceForAircraftGroupName:(NSString *)aircraftGroupName andCardType:(NSString *)cardType
{
    NFDContractRate *contractRate = [NFDFlightProposalCalculatorService contractRateInfoForAircraftGroupName:aircraftGroupName];
    NSNumber *cardPurchasePrice = [NSNumber numberWithInt:0];
    int cardTypeIndex = 0;
    if (cardType)
    {
        cardTypeIndex = [[NFDFlightProposalCalculatorService annualHourAllotmentChoicesForGeneralProductType:kGeneralProductTypeCard maxHoursAvailable:nil] indexOfObject:cardType];
    }
    
    switch (cardTypeIndex) {
        case 0:
            cardPurchasePrice = [contractRate cardPurchase25Hour];
            break;
        case 1:
            cardPurchasePrice = [contractRate cardPurchase50Hour];
            break;
        case 2:
            cardPurchasePrice = [NSNumber numberWithInt:(0.5*[[contractRate cardPurchase25Hour] intValue]) + [[contractRate cardHalfPremium] intValue]];
            break;
        case 3:
            cardPurchasePrice = [contractRate cardPurchase25Hour];
            break;
        default:
            break;
    }
    return cardPurchasePrice;
}

+ (NSNumber *)calculateCardPurchasePriceForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType andNumberOfCards:(int)numberOfCards
{
    return [NSNumber numberWithInt:(numberOfCards * [[NFDFlightProposalCalculatorService calculateCardPurchasePriceForAircraftGroupName:aircraftGroupName andCardType:cardType] intValue])];
}

+ (NSNumber *)calculateComboCardPurchasePriceForAircraftGroupNames:(NSArray *)aircraftGroupNames andNumberOfCards:(int)numberOfCards
{
    int cabinSize = 0;
    float tempPurchasePrice = 0;
    for (NSString *aircraftChoice in aircraftGroupNames)
    {        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"typeGroupName = %@", aircraftChoice]; 
        NSArray *aircraftTypes = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                            predicate:pred
                                                                      sortDescriptors:nil
                                                                   includeSubEntities:NO
                                                                              context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                returnObjectsAsFaults:NO
                                                                                error:nil];
        
        NFDAircraftType *aircraftType = [aircraftTypes objectAtIndex:0];

        if ([[NSString stringWithFormat:@"%@", aircraftType.cabinSize] isEqualToString:@"S"])
        {
            cabinSize += 1;
        }
        if ([[NSString stringWithFormat:@"%@", aircraftType.cabinSize] isEqualToString:@"M"])
        {
            cabinSize += 2;
        }
        if ([[NSString stringWithFormat:@"%@", aircraftType.cabinSize] isEqualToString:@"L"])
        {
            cabinSize += 4;
        }
        tempPurchasePrice += [[NFDFlightProposalCalculatorService calculateCardPurchasePriceForAircraftGroupName:aircraftChoice cardType:nil andNumberOfCards:numberOfCards] floatValue] / aircraftGroupNames.count;
    }
        
    int premium = 0;
    
    if (cabinSize < 3) {
        premium = 5000;         // combo of 2 Light Cabins
    } else if (cabinSize == 3) {
        premium = 6250;         // combo of Light cabin and Mid cabin
    } else if (cabinSize > 3) {
        premium = 7500;         // combo anything with a Large cabin or 2 Mid cabins
    }
    
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:tempPurchasePrice + (numberOfCards*premium)]];
}

#pragma mark - Card Products - Purchase FET

+ (NSNumber *)calculateCardPurchaseFETForAircraftGroupName:(NSString *)aircraftGroupName andCardType:(NSString *)cardType
{
    float rateFET = (float)FETRATE;
    float cardPurchasePrice = [[NFDFlightProposalCalculatorService calculateCardPurchasePriceForAircraftGroupName:aircraftGroupName andCardType:cardType] floatValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:rateFET * cardPurchasePrice]];
}

+ (NSNumber *)calculateCardPurchaseFETForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType andNumberOfCards:(int)numberOfCards
{
    float rateFET = (float)FETRATE;
    float cardPurchasePriceTotal = [[NFDFlightProposalCalculatorService calculateCardPurchasePriceForAircraftGroupName:aircraftGroupName cardType:cardType andNumberOfCards:numberOfCards] floatValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:rateFET * cardPurchasePriceTotal]];
}


+ (NSNumber *)calculateComboCardPurchaseFETForAircraftGroupNames:(NSArray *)aircraftGroupNames andNumberOfCards:(int)numberOfCards
{
    float rateFET = (float)FETRATE;
    float cardPurchasePrice = [[NFDFlightProposalCalculatorService calculateComboCardPurchasePriceForAircraftGroupNames:aircraftGroupNames andNumberOfCards:numberOfCards] floatValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:rateFET * cardPurchasePrice]];
}

+ (NSNumber *)calculateCardPurchaseFETForPurchasePrice:(NSNumber *)purchasePrice
{
    float rateFET = (float)FETRATE;
    float cardPurchasePriceTotal = [purchasePrice floatValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:rateFET * cardPurchasePriceTotal]];
}



#pragma mark - Card Products - Hours

+ (NSNumber *)hoursForCardType:(NSString *)cardType
{
    if ([cardType isEqualToString:@"25 Hour Combo Card"])
    {
        return [NSNumber numberWithInt:25];
    }
    int cardTypeIndex = [[NFDFlightProposalCalculatorService annualHourAllotmentChoicesForGeneralProductType:kGeneralProductTypeCard maxHoursAvailable:nil] indexOfObject:cardType];
    
    switch (cardTypeIndex) {
        case kCardType25Hours:
            return [NSNumber numberWithInt:25];
            break;
        case kCardType50Hours:
            return [NSNumber numberWithInt:50];
            break;
        case kCardTypeHalf:
            return [NSNumber numberWithFloat:12.5];
            break;
        case kCardTypeCrossCountry:
            return [NSNumber numberWithInt:25];
            break;
        default:
            return [NSNumber numberWithInt:0];
            break;
    }
}

+ (NSNumber *)contractMonthsForCardType:(NSString *)cardType
{
    int cardTypeIndex = [[NFDFlightProposalCalculatorService annualHourAllotmentChoicesForGeneralProductType:kGeneralProductTypeCard maxHoursAvailable:nil] indexOfObject:cardType];
    
    switch (cardTypeIndex) {
        case kCardType25Hours:
            return [NSNumber numberWithInt:12];
            break;
        case kCardType50Hours:
            return [NSNumber numberWithInt:24];
            break;
        case kCardTypeHalf:
            return [NSNumber numberWithInt:12];
            break;
        default:
            return [NSNumber numberWithInt:0];
            break;
    }
}

#pragma mark - Phenom


+ (NSNumber *)calculateAnnualLeaseFeeForMonthlyLeaseFee:(NSNumber *)monthlyLeaseFee
{
    double annualLeaseFee = ([monthlyLeaseFee doubleValue] * 12);
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:annualLeaseFee]];
}

+ (NSNumber *)calculateAnnualLeaseFETForAnnualLeaseFee:(NSNumber *)annualLeaseFee isQualified:(BOOL)qualified
{
    float fetRate = qualified ? 0 : (float)FET_TAX_RATE;
    double annualLeaseFET = ([annualLeaseFee doubleValue] * fetRate);
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:annualLeaseFET]];
}

+ (NSNumber *)calculateTermFETForAcquisitionCost:(NSNumber *)acquisitionCost isQualified:(BOOL)qualified
{
    float fetRate = qualified ? 0 : (float)FET_TAX_RATE;
    double termFET = ([acquisitionCost doubleValue] * fetRate);
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:termFET]];
}

+ (NSNumber *)calculateDepositForAnnualHours:(NSString *)annualHours
{
    double deposit = (100000 * ([annualHours doubleValue] / 50));
    return [NSNumber numberWithDouble:deposit];
}

+ (NSNumber *)calculateProgressPaymentForAcquisitionCost:(NSNumber *)acquisitionCost
{
    //.25 X Acquisition Cost
    double progressPayment = (.25 * [acquisitionCost doubleValue]);
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:progressPayment]];
}

+ (NSNumber *)calculateCashDueAtClosingForAcquisitionCost:(NSNumber *)acquisitionCost fet:(NSNumber *)fet deposit:(NSNumber *)deposit progressPayment:(NSNumber *)progressPayment
{
    //Acquisition + FET - Deposit - Progress Pmt
    double cashDue = ([acquisitionCost doubleValue] + [fet doubleValue] - [deposit doubleValue] - [progressPayment doubleValue]);
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:cashDue]];
}

+ (NSNumber *)calculateAnnualOperationalCostForAnnualMonthlyManagementFee:(NSNumber *)annualMMF annualOperationHourlyFee:(NSNumber *)annualOHF annualFuel:(NSNumber *)annualFuel annualFET:(NSNumber *)annualFET annualLeaseFee:(NSNumber *)annualLeaseFee annualLeaseFET:(NSNumber *)annualLeaseFET
{
    //Ann Lease Fee + Ann Lease FET + Ann MMF + Ann OHF + Ann Fuel + Ann FET
    double annualOperationalCost = ([annualMMF doubleValue] + [annualOHF doubleValue] + [annualFuel doubleValue] + [annualFET doubleValue] + [annualLeaseFee doubleValue] + [annualLeaseFET doubleValue]);
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:annualOperationalCost]];
}

+ (NSNumber *)calculateAverageHourlyOperationalCostForAnnualMonthlyManagementFee:(NSNumber *)annualMMF annualOperationHourlyFee:(NSNumber *)annualOHF annualFuel:(NSNumber *)annualFuel annualFET:(NSNumber *)annualFET annualLeaseFee:(NSNumber *)annualLeaseFee annualLeaseFET:(NSNumber *)annualLeaseFET andShareSize:(NSString *)hours
{
    //Ann Lease Fee + Ann Lease FET + Ann MMF + Ann OHF + Ann Fuel + Ann FET
    double annualOperationalCost = ([annualMMF doubleValue] + [annualOHF doubleValue] + [annualFuel doubleValue] + [annualFET doubleValue] + [annualLeaseFee doubleValue] + [annualLeaseFET doubleValue]);
    double averageHourlyCost = annualOperationalCost/[hours floatValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:averageHourlyCost]];
}

+ (NSNumber *)calculateTotalFETForMonthlyManagementFee:(NSNumber *)mmf occupiedHourlyFee:(NSNumber *)ohf fuel:(NSNumber *)fuel isQualified:(BOOL)qualified
{
    // Generic total FET calculator. Can calculate Rate or Annual.    
    float fetRate = qualified ? 0 : (float)FET_TAX_RATE;
    double totalFET = (([mmf doubleValue] + [ohf doubleValue] + [fuel doubleValue]) * fetRate);
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:totalFET]];
}

#pragma mark - Fuel Variable

// return the fuel variable rate for Share Purchase and Share Finance
+ (NSNumber *)fuelVariableRateForAircraftType:(NSString *)aircraftType andFuelPeriod:(NSString *)fuelPeriod isQualified:(BOOL)qualified
{
    NFDFuelRate *fuelRate = [NFDFlightProposalCalculatorService fuelRateInfoForAircraftType:aircraftType];
    if (fuelRate)
    {
        return [NFDFlightProposalCalculatorService fuelVariableRateFromContractRate:fuelRate andFuelPeriod:fuelPeriod forAircraftType:aircraftType isQualified:qualified];
    }
    return [NSNumber numberWithInt:0];
}

// return the fuel variable rate for Card
+ (NSNumber *)fuelVariableRateForAircraftGroupName:(NSString *)aircraftGroupName andFuelPeriod:(NSString *)fuelPeriod isQualified:(BOOL)qualified
{
    NFDFuelRate *fuelRate = [NFDFlightProposalCalculatorService fuelRateInfoForAircraftGroupName:aircraftGroupName];
    NSString *aircraftType = [fuelRate typeName];
    if (fuelRate)
    {
        return [NFDFlightProposalCalculatorService fuelVariableRateFromContractRate:fuelRate andFuelPeriod:fuelPeriod forAircraftType:aircraftType isQualified:qualified];
    }
    return [NSNumber numberWithInt:0];
}

// return the fuel variable total for Card Purchase, Share Purchase, Share Finance
+ (NSNumber *)fuelVariableTotalForAircraftType:(NSString *)aircraftType andFuelPeriod:(NSString *)fuelPeriod forNumberOfHours:(id)numberOfHours isQualified:(BOOL)qualified
{
    float hours = [numberOfHours floatValue];
    float fuelVariable = [[NFDFlightProposalCalculatorService fuelVariableRateForAircraftType:aircraftType andFuelPeriod:fuelPeriod isQualified:qualified] intValue];
    return [NSNumber numberWithFloat:(hours * fuelVariable)];
}

// return the fuel variable total for Card
+ (NSNumber *)fuelVariableTotalForAircraftGroupName:(NSString *)aircraftGroupName andFuelPeriod:(NSString *)fuelPeriod forCardType:(NSString *)cardType andNumberOfCards:(int)numberOfCards
{
    float hours = numberOfCards * [[NFDFlightProposalCalculatorService hoursForCardType:cardType] floatValue];
    return [NFDFlightProposalCalculatorService fuelVariableTotalForAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriod forNumberOfHours:[NSNumber numberWithFloat:hours] isQualified:NO];
}


+ (NSNumber *)comboCardFuelVariableTotalForAircraftGroupNames:(NSArray *)aircraftGroupNames andFuelPeriod:(NSString *)fuelPeriod andNumberOfCards:(int)numberOfCards
{
    float fuelRate = [[NFDFlightProposalCalculatorService comboCardFuelVariableRateForAircraftGroupNames:aircraftGroupNames andFuelPeriod:fuelPeriod] floatValue];
    float fuelTotal = fuelRate * 25 * numberOfCards;
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:fuelTotal]];
}

+ (NSNumber *)comboCardFuelVariableRateForAircraftGroupNames:(NSArray *)aircraftGroupNames andFuelPeriod:(NSString *)fuelPeriod
{
    float tempFuelRate = 0;
    for (NSString *aircraftChoice in aircraftGroupNames)
    {        
        tempFuelRate += [[NFDFlightProposalCalculatorService fuelVariableRateForAircraftGroupName:aircraftChoice andFuelPeriod:fuelPeriod isQualified:NO] floatValue] / aircraftGroupNames.count;
    }
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:tempFuelRate]];
}


// return the fuel variable total for Share Lease (also called by totaler for Card)
+ (NSNumber *)fuelVariableTotalForAircraftGroupName:(NSString *)aircraftGroupName andFuelPeriod:(NSString *)fuelPeriod forNumberOfHours:(id)numberOfHours isQualified:(BOOL)qualified
{
    float hours = [numberOfHours floatValue];
    int fuelVariable = [[NFDFlightProposalCalculatorService fuelVariableRateForAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriod isQualified:qualified] intValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:(hours * fuelVariable)]];
}

// return the fuel variable rate from a contract rate object
+ (NSNumber *)fuelVariableRateFromContractRate:(NFDFuelRate *)fuelRate andFuelPeriod:(NSString *)fuelPeriod forAircraftType:(NSString *)aircraftType isQualified:(BOOL)qualified
{
    NSArray *fuelPeriodChoicesArray = [NFDFlightProposalCalculatorService fuelPeriodChoicesForAircraftType:aircraftType isQualified:qualified];
    NSArray *fuelMonthRatesDisplayNames = [fuelPeriodChoicesArray objectAtIndex:0];
    NSArray *fuelMonthRates = [fuelPeriodChoicesArray objectAtIndex:1];
    
    NSUInteger indexForFuelPeriod = [fuelMonthRatesDisplayNames indexOfObject:fuelPeriod];
    
    if (indexForFuelPeriod != NSNotFound) {
        return [fuelMonthRates objectAtIndex:indexForFuelPeriod];
    }
    return [NSNumber numberWithInt:0];
}

#pragma mark - Card fuel FET

//+ (NSNumber *)calculateCardFuelFETRateforAircraftGroupName:(NSString *)aircraftGroupName andFuelPeriod:(NSString *)fuelPeriod
//{
//    float rateFET = (float)FETRATE;
//    float fuelRate = [[NFDFlightProposalCalculatorService fuelVariableRateForAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriod isQualified:NO] floatValue];
//    
//    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:rateFET*fuelRate]];
//}

+ (NSNumber *)calculateCardFuelFETAnnualforAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod
{    
    float fuelAnnual = [[NFDFlightProposalCalculatorService fuelVariableTotalForAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriod forCardType:cardType andNumberOfCards:numberOfCards] floatValue];
    
    float fuelFETAnnual = fuelAnnual * (float)FETRATE;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:fuelFETAnnual]];
}


+ (NSNumber *)comboCardFuelFETTotalForAircraftGroupNames:(NSArray *)aircraftGroupNames andFuelPeriod:(NSString *)fuelPeriod andNumberOfCards:(int)numberOfCards
{
    float fuelRate = [[NFDFlightProposalCalculatorService comboCardFuelVariableRateForAircraftGroupNames:aircraftGroupNames andFuelPeriod:fuelPeriod] floatValue];
    float hours = 25.0;
    float fuelFETAnnual = fuelRate * hours * numberOfCards * (float)FETRATE;
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:fuelFETAnnual]];
}

//+ (NSNumber *)comboCardFuelFETRateForAircraftGroupNames:(NSArray *)aircraftGroupNames andFuelPeriod:(NSString *)fuelPeriod
//{
//    float fuelRate = [[NFDFlightProposalCalculatorService comboCardFuelVariableRateForAircraftGroupNames:aircraftGroupNames andFuelPeriod:fuelPeriod] floatValue];
//    
//    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:fuelRate * (float)FETRATE]];
//}

#pragma mark - Card totals

+ (NSNumber *)calculateCardTotalCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod
{
    //float rateFET = (float)FETRATE;
    float totalPurchasePrice = [[NFDFlightProposalCalculatorService calculateCardPurchasePriceForAircraftGroupName:aircraftGroupName cardType:cardType andNumberOfCards:numberOfCards] floatValue];
    float purchaseFET = [[NFDFlightProposalCalculatorService calculateCardPurchaseFETForAircraftGroupName:aircraftGroupName cardType:cardType andNumberOfCards:numberOfCards] floatValue];
    float totalFuelVariable = [[NFDFlightProposalCalculatorService fuelVariableTotalForAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriod forCardType:cardType andNumberOfCards:numberOfCards] floatValue];
    float totalFuelFET = [[NFDFlightProposalCalculatorService calculateCardFuelFETAnnualforAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards andFuelPeriod:fuelPeriod] floatValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:totalPurchasePrice + purchaseFET + totalFuelVariable + totalFuelFET]];
}

+ (NSNumber *)calculateCardAverageHourlyCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod 
{
    float totalCost = [[NFDFlightProposalCalculatorService calculateCardTotalCostForAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards andFuelPeriod:fuelPeriod] floatValue];
    
    float hours = numberOfCards * [[NFDFlightProposalCalculatorService hoursForCardType:cardType] floatValue];
    float average = totalCost/hours;
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:average]];
}

+ (NSNumber *)calculateCardTotalCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards fuelPeriod:(NSString *)fuelPeriod andPurchasePrice:(NSNumber *)purchasePrice
{
    //float rateFET = (float)FETRATE;
    float totalPurchasePrice = [purchasePrice floatValue];
    float purchaseFET = [[NFDFlightProposalCalculatorService calculateCardPurchaseFETForPurchasePrice:purchasePrice] floatValue];
    float totalFuelVariable = [[NFDFlightProposalCalculatorService fuelVariableTotalForAircraftGroupName:aircraftGroupName andFuelPeriod:fuelPeriod forCardType:cardType andNumberOfCards:numberOfCards] floatValue];
    float totalFuelFET = [[NFDFlightProposalCalculatorService calculateCardFuelFETAnnualforAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards andFuelPeriod:fuelPeriod] floatValue];
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:totalPurchasePrice + purchaseFET + totalFuelVariable + totalFuelFET]];
}

+ (NSNumber *)calculateCardAverageHourlyCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards fuelPeriod:(NSString *)fuelPeriod andPurchasePrice:(NSNumber *)purchasePrice
{
    float totalCost = [[NFDFlightProposalCalculatorService calculateCardTotalCostForAircraftGroupName:aircraftGroupName cardType:cardType numberOfCards:numberOfCards fuelPeriod:fuelPeriod andPurchasePrice:purchasePrice] floatValue];
    
    float hours = numberOfCards * [[NFDFlightProposalCalculatorService hoursForCardType:cardType] floatValue];
    float average = totalCost/hours;
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:average]];
}

+ (NSNumber *)calculateCostWithNextYearPercentage:(NSNumber *)percentage andInitialCost:(NSNumber *)initialCost
{
    float initialCostFloat = [initialCost floatValue];
    float calculatedFloat = ((initialCostFloat * ([percentage floatValue] / 100)) + initialCostFloat);
    return [NSNumber numberWithFloat:calculatedFloat];
}

+ (NSNumber *)calculateComboCardTotalCostForAircraftGroupNames:(NSArray *)aircraftGroupNames numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod
{
    float totalPurchasePrice = [[NFDFlightProposalCalculatorService calculateComboCardPurchasePriceForAircraftGroupNames:aircraftGroupNames andNumberOfCards:numberOfCards] floatValue];
    float totalPurchaseFET = [[NFDFlightProposalCalculatorService calculateComboCardPurchaseFETForAircraftGroupNames:aircraftGroupNames andNumberOfCards:numberOfCards] floatValue];
    float totalFuelVariable = [[NFDFlightProposalCalculatorService comboCardFuelVariableTotalForAircraftGroupNames:aircraftGroupNames andFuelPeriod:fuelPeriod andNumberOfCards:numberOfCards] floatValue];
    float totalFuelFET = [[NFDFlightProposalCalculatorService comboCardFuelFETTotalForAircraftGroupNames:aircraftGroupNames andFuelPeriod:fuelPeriod andNumberOfCards:numberOfCards] floatValue];
    
    float total = totalPurchasePrice + totalPurchaseFET + totalFuelVariable + totalFuelFET;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:total]];
}

+ (NSNumber *)calculateComboCardTotalCostForAircraftGroupNames:(NSArray *)aircraftGroupNames purchasePrice:(NSNumber *)purchasePrice purchaseFET:(NSNumber *)purchaseFET numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod
{
    float totalFuelVariable = [[NFDFlightProposalCalculatorService comboCardFuelVariableTotalForAircraftGroupNames:aircraftGroupNames andFuelPeriod:fuelPeriod andNumberOfCards:numberOfCards] floatValue];
    float totalFuelFET = [[NFDFlightProposalCalculatorService comboCardFuelFETTotalForAircraftGroupNames:aircraftGroupNames andFuelPeriod:fuelPeriod andNumberOfCards:numberOfCards] floatValue];
    
    float total = [purchasePrice floatValue] + [purchaseFET floatValue] + totalFuelVariable + totalFuelFET;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:total]];
}

+ (NSNumber *)calculateComboCardAverageHourlyCostForAircraftGroupNames:(NSArray *)aircraftGroupNames numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod
{
    float total = [[NFDFlightProposalCalculatorService calculateComboCardTotalCostForAircraftGroupNames:aircraftGroupNames numberOfCards:numberOfCards andFuelPeriod:fuelPeriod] floatValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:total/(numberOfCards * 25)]];
}

+ (NSNumber *)calculateComboCardAverageHourlyCostForTotalCost:(NSNumber *)totalCost andNumberOfCards:(int)numberOfCards
{
    float total = [totalCost floatValue];
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:total/(numberOfCards * 25)]];
}

#pragma mark - Prepayment Savings

+ (NSNumber *)calculatePrepaymentSavingsForMMF:(NSNumber *)mmfRate
{
    double annualMmf = [mmfRate doubleValue] * 12.0f;
    NSNumber *presentValueOfDiscountedPayments = 
    [NFDFlightProposalCalculatorService calcualtePV:[NSNumber numberWithDouble:DISCOUNT_RATE_FOR_PREPAYMENTS/12.0f] 
                                         havingTerm:[NSNumber numberWithInt:NUMBER_OF_PAYMENTS_TO_DISCOUNT] 
                                 withMonthlyPayment:mmfRate 
                                  havingFutureValue:[NSNumber numberWithInt:0] 
                                    withPaymentType:[NSNumber numberWithInt:0] ];
    
    double pv = [presentValueOfDiscountedPayments doubleValue];
    double paymentsNotDiscounted = [mmfRate doubleValue] * ( 12 - NUMBER_OF_PAYMENTS_TO_DISCOUNT );
    double savings = annualMmf + pv - paymentsNotDiscounted;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:savings]];   
}

+ (NSNumber *)calculatePrepaymentSavingsForOHF:(NSNumber *)ohfRate havingAnnualHoursOf:(NSNumber *)annualHours
{
    
    double Ohf = [ohfRate doubleValue];
    double hours = [annualHours doubleValue];
    double monthlyOhf = Ohf * hours / 12.0f;
    double annualOhf = monthlyOhf * 12.0f;
    
    NSNumber *presentValueOfDiscountedPayments = 
    [NFDFlightProposalCalculatorService calcualtePV:[NSNumber numberWithDouble:DISCOUNT_RATE_FOR_PREPAYMENTS/12.0f] 
                                         havingTerm:[NSNumber numberWithInt:NUMBER_OF_PAYMENTS_TO_DISCOUNT] 
                                 withMonthlyPayment:[NSNumber numberWithDouble:monthlyOhf] 
                                  havingFutureValue:[NSNumber numberWithInt:0] 
                                    withPaymentType:[NSNumber numberWithInt:0] ];
    
    double pv = [presentValueOfDiscountedPayments doubleValue];
    double paymentsNotDiscounted = monthlyOhf * ( 12 - NUMBER_OF_PAYMENTS_TO_DISCOUNT );
    double savings = annualOhf + pv - paymentsNotDiscounted;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:savings]];   
}

+ (NSNumber *)calculatePrepaymentSavingsForFuel:(NSNumber *)fuelRate havingAnnualHoursOf:(NSNumber *)annualHours
{
    
    double fulePerHour = [fuelRate doubleValue];
    double hours = [annualHours doubleValue];
    double monthlyFule = fulePerHour * hours / 12.0f;
    double annualFuel = monthlyFule * 12.0f;
    
    NSNumber *presentValueOfDiscountedPayments = 
    [NFDFlightProposalCalculatorService calcualtePV:[NSNumber numberWithDouble:DISCOUNT_RATE_FOR_PREPAYMENTS/12.0f] 
                                         havingTerm:[NSNumber numberWithInt:NUMBER_OF_PAYMENTS_TO_DISCOUNT] 
                                 withMonthlyPayment:[NSNumber numberWithDouble:monthlyFule] 
                                  havingFutureValue:[NSNumber numberWithInt:0] 
                                    withPaymentType:[NSNumber numberWithInt:0] ];
    
    double pv = [presentValueOfDiscountedPayments doubleValue];
    double paymentsNotDiscounted = monthlyFule * ( 12 - NUMBER_OF_PAYMENTS_TO_DISCOUNT );
    double savings = annualFuel + pv - paymentsNotDiscounted;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:savings]];   
}

+ (NSNumber *)calculatePrepaymentSavingsForLease:(NSNumber *)leasePayment{
    
    double monthlyLease = [leasePayment doubleValue];
    double annualLease = monthlyLease * 12.0f;
    
    NSNumber *presentValueOfDiscountedPayments = 
    [NFDFlightProposalCalculatorService calcualtePV:[NSNumber numberWithDouble:DISCOUNT_RATE_FOR_PREPAYMENTS/12.0f] 
                                         havingTerm:[NSNumber numberWithInt:NUMBER_OF_PAYMENTS_TO_DISCOUNT] 
                                 withMonthlyPayment:[NSNumber numberWithDouble:monthlyLease] 
                                  havingFutureValue:[NSNumber numberWithInt:0] 
                                    withPaymentType:[NSNumber numberWithInt:0] ];
    
    double pv = [presentValueOfDiscountedPayments doubleValue];
    double paymentsNotDiscounted = monthlyLease * ( 12 - NUMBER_OF_PAYMENTS_TO_DISCOUNT );
    double savings = annualLease + pv - paymentsNotDiscounted;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithDouble:savings]];   
}

+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)ohfRate andFuel:(NSNumber *)fuelRate havingAnnualHoursOf:(NSNumber *)annualHours{
    
    NSNumber *ohfSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForOHF:ohfRate havingAnnualHoursOf:(NSNumber *)annualHours];
    NSNumber *fuelSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForOHF:fuelRate havingAnnualHoursOf:(NSNumber *)annualHours];
    return [NSNumber numberWithDouble: ([ohfSavings doubleValue] + [fuelSavings doubleValue])];   
}

+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)mmfRate andOHF:(NSNumber *)ohfRate andFuel:(NSNumber *)fuelRate havingAnnualHoursOf:(NSNumber *)annualHours{
    
    NSNumber *mmfSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForMMF:mmfRate ];
    NSNumber *ohfSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForOHF:ohfRate havingAnnualHoursOf:(NSNumber *)annualHours];
    NSNumber *fuelSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForFuel:fuelRate havingAnnualHoursOf:(NSNumber *)annualHours];
    return [NSNumber numberWithDouble: ([mmfSavings doubleValue] + [ohfSavings doubleValue] + [fuelSavings doubleValue])];   
}

+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)mmfRate andLease:(NSNumber *)leasePayment havingAnnualHoursOf:(NSNumber *)annualHours{
    
    NSNumber *mmfSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForMMF:mmfRate];
    NSNumber *leaseSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForLease:leasePayment];
    return [NSNumber numberWithDouble:([mmfSavings doubleValue] + [leaseSavings doubleValue])];   
}

+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)mmfRate andOHF:(NSNumber *)ohfRate andLease:(NSNumber *)leasePayment havingAnnualHoursOf:(NSNumber *)annualHours{
    
    NSNumber *mmfSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForMMF:mmfRate];
    NSNumber *ohfSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForOHF:ohfRate havingAnnualHoursOf:(NSNumber *)annualHours];
    NSNumber *leaseSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForLease:leasePayment];
    return [NSNumber numberWithDouble:([mmfSavings doubleValue] + [ohfSavings doubleValue] + [leaseSavings doubleValue])];   
}

+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)mmfRate andOHF:(NSNumber *)ohfRate andFuel:(NSNumber *)fuelRate andLease:(NSNumber *)leasePayment havingAnnualHoursOf:(NSNumber *)annualHours{
    
    NSNumber *mmfSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForMMF:mmfRate];
    NSNumber *ohfSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForOHF:ohfRate havingAnnualHoursOf:(NSNumber *)annualHours];
    NSNumber *leaseSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForLease:leasePayment];
    NSNumber *fuelSavings = [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForFuel:fuelRate havingAnnualHoursOf:(NSNumber *)annualHours];
    
    return [NSNumber numberWithDouble:([mmfSavings doubleValue] + [ohfSavings doubleValue] + [fuelSavings doubleValue] + [leaseSavings doubleValue])];   
}

+ (NSNumber *)calculatePrepaymentSavingsForSelection:(NSString *)prepaymentSelection usingMMF:(NSNumber *)mmfRate andOHF:(NSNumber *)ohfRate andFuel:(NSNumber *)fuelRate andLease:(NSNumber *)leasePayment havingAnnualHoursOf:(NSNumber *)annualHours isQualified:(BOOL)qualified
{
    
    double fetRate = qualified ? 1 : 1+(double)FETRATE;
    
    if ([prepaymentSelection isEqualToString:@"MMF"])
    {
        return [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForMMF:[NSNumber numberWithDouble:(fetRate * [mmfRate doubleValue])]];
    }
    else if ([prepaymentSelection isEqualToString:@"OHF & Fuel"])
    {
        return [NFDFlightProposalCalculatorService calculatePrepaymentSavingsCombination:[NSNumber numberWithDouble:(fetRate * [ohfRate doubleValue])] andFuel:[NSNumber numberWithDouble:( fetRate * [fuelRate doubleValue])] havingAnnualHoursOf:(NSNumber *)annualHours];
    }
    else if ([prepaymentSelection isEqualToString:@"MMF, OHF & Fuel"])
    {
        return [NFDFlightProposalCalculatorService calculatePrepaymentSavingsCombination:[NSNumber numberWithDouble:(fetRate * [mmfRate doubleValue])] andOHF:[NSNumber numberWithDouble:(fetRate * [ohfRate doubleValue])] andFuel:[NSNumber numberWithDouble:( fetRate * [fuelRate doubleValue])] havingAnnualHoursOf:(NSNumber *)annualHours];
    }
    else if ([prepaymentSelection isEqualToString:@"Lease"])
    {
        return [NFDFlightProposalCalculatorService calculatePrepaymentSavingsForLease:[NSNumber numberWithDouble:(fetRate * [leasePayment doubleValue])]];
    }
    else if ([prepaymentSelection isEqualToString:@"Lease, MMF, OHF & Fuel"])
    {
        return [NFDFlightProposalCalculatorService calculatePrepaymentSavingsCombination:[NSNumber numberWithDouble:(fetRate * [mmfRate doubleValue])] andOHF:[NSNumber numberWithDouble:(fetRate * [ohfRate doubleValue])] andFuel:[NSNumber numberWithDouble:( fetRate * [fuelRate doubleValue])] andLease:[NSNumber numberWithDouble:(fetRate * [leasePayment doubleValue])] havingAnnualHoursOf:(NSNumber *)annualHours];
    }
    else if ([prepaymentSelection isEqualToString:@"Lease & MMF"])
    {
        return [NFDFlightProposalCalculatorService calculatePrepaymentSavingsCombination:[NSNumber numberWithDouble:(fetRate * [mmfRate doubleValue])] andLease:[NSNumber numberWithDouble:(fetRate * [leasePayment doubleValue])] havingAnnualHoursOf:(NSNumber *)annualHours];
    }
    else
    {
        return [NSNumber numberWithInt:0];
    }
}

#pragma mark - Financial Calculations

+ (NSNumber *)calculateAcquisitionCostFromAircraftValue:(NSNumber *)aircraftValue andAnnualHours:(NSNumber *)annualHours{

    double acquisitionCost = round ( ( ( round ( [aircraftValue doubleValue] ) ) * [annualHours floatValue] ) / 800 );
    return [NSNumber numberWithDouble:acquisitionCost];
}

+ (NSNumber *)calculateDownPaymmentFromAcquisitionCost:(NSNumber *)acquisitionCost{

    double downPayment = round ( [acquisitionCost doubleValue] * 0.2f );
    return [NSNumber numberWithDouble:downPayment];
}

+ (NSNumber *)calculateFinancedAmountFromAcquisitionCost:(NSNumber *)acquisitionCost{

    double downPayment = [[NFDFlightProposalCalculatorService calculateDownPaymmentFromAcquisitionCost:acquisitionCost] doubleValue];
    double financedAmount = round ( [acquisitionCost doubleValue] - downPayment );    
    return [NSNumber numberWithDouble:financedAmount];
}

+ (NSNumber *)calculatePaymentPlusInterestFromAcquisitionCost:(NSNumber *)acquisitionCost forVintage:(NSNumber *)vintage{
    
    float annualRate = LOAN_INTEREST_RATE;
    float monthlyRate = ( annualRate / 12.0f );
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSNumber *currentYear = [NSNumber numberWithInteger:[components year]];
    float ageOfAircraft = ([currentYear floatValue] - [vintage floatValue]);
    float numberOfPayments = ( 20.0f - ageOfAircraft ) * 12.0f;
    double futureValue = 0.0;
    double presentValue = [[NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost] doubleValue] * -1.0f;
    
    
    NSNumber *payment = [NFDFlightProposalCalculatorService calcualtePMT:[NSNumber numberWithDouble:monthlyRate]
                                                              havingTerm:[NSNumber numberWithDouble:numberOfPayments]
                                                        withPresentValue:[NSNumber numberWithDouble:presentValue]
                                                          andFutureValue:[NSNumber numberWithDouble:futureValue]
                                                          andPaymentType:[NSNumber numberWithInt:0]];
    return payment;
    
    
}

+ (NSNumber *)calculatePaymentPlusInterestFromAcquisitionCost:(NSNumber *)acquisitionCost forVintage:(NSNumber *)vintage forDisplay:(BOOL)forDisplay 
{
    NSNumber *payment = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage];
    
    if (forDisplay)
    {
        return [NFDFlightProposalCalculatorService applyRoundingTo:payment];
    }
    return payment;
}
    


+ (NSNumber *)calculateBalloonPaymentFromAcquisitionCost:(NSNumber *)acquisitionCost forVintage:(NSNumber *)vintage{
    
    float annualRate = LOAN_INTEREST_RATE;
    float monthlyRate = ( annualRate / 12.0f );

    float numberOfPayments = LOAN_TERM_IN_MONTHS;
    double presentValue = [[NFDFlightProposalCalculatorService calculateFinancedAmountFromAcquisitionCost:acquisitionCost] doubleValue] * -1.0f;
    double payment = [[NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:acquisitionCost forVintage:vintage] doubleValue];
    
    NSNumber *futureValue = [NFDFlightProposalCalculatorService calcualteFV:[NSNumber numberWithDouble:monthlyRate]
                                                                 havingTerm:[NSNumber numberWithDouble:numberOfPayments]
                                                         withMonthlyPayment:[NSNumber numberWithDouble:payment]
                                                            andPresentValue:[NSNumber numberWithDouble:presentValue]
                                                             andPaymentType:[NSNumber numberWithInt:0]];    
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:futureValue];   
}


#pragma mark - Share Operational Annual Cost

+ (NSNumber *)calculateShareOperationalAnnualCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare
{
    
    float ohfAnnual = [[NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:hours] floatValue];
    
    float mgtFeeAnnual = [[NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:vintage andShareSize:hours isMultiShare:isMultiShare] floatValue];
    
    if (nextYearPercentageForOHF != nil) {
        ohfAnnual = [[NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForOHF andInitialCost:[NSNumber numberWithFloat:ohfAnnual]] floatValue];
    }
    
    if (nextYearPercentageForMMF != nil) {
        mgtFeeAnnual = [[NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForMMF andInitialCost:[NSNumber numberWithFloat:mgtFeeAnnual]] floatValue];
    }
    
    float fuelAnnual = [[NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:aircraftType andFuelPeriod:fuelPeriod forNumberOfHours:hours isQualified:qualified] floatValue];
    
    float fetAnnual = [[NFDFlightProposalCalculatorService calculateShareOperationalFederalExciseTaxForAircraftType:aircraftType vintage:vintage shareSize:hours andFuelPeriod:fuelPeriod isQualified:qualified isMultiShare:isMultiShare] floatValue];
    
    float total = qualified ? ohfAnnual + mgtFeeAnnual + fuelAnnual : ohfAnnual + mgtFeeAnnual + fuelAnnual + fetAnnual;

    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:total]];
}


+ (NSNumber *)calculateFinanceOperationalAnnualCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified withAcquisitionCost:(NSNumber *)acqCost isMultiShare:(BOOL)isMultiShare
{    
    NSNumber *calcCost = acqCost;
    
    if (!qualified)
    {
        calcCost = [NSNumber numberWithFloat:(acqCost.floatValue * 1.075)];
    }
    
    NSNumber *paymentRaw = [NFDFlightProposalCalculatorService calculatePaymentPlusInterestFromAcquisitionCost:calcCost forVintage:[NSNumber numberWithInt:[vintage intValue]]];
    
    NSNumber *payment = [NFDFlightProposalCalculatorService applyRoundingTo:paymentRaw];
    
    float annualPayments = [payment floatValue] * 12;
    
    float ohfAnnual = [[NFDFlightProposalCalculatorService calculateShareOccupiedHourlyFeeAnnualForAircraftType:aircraftType vintage:vintage andShareSize:hours] floatValue];
    
    float mgtFeeAnnual = [[NFDFlightProposalCalculatorService calculateShareMonthlyManagementFeeAnnualForAircraftType:aircraftType andAircraftVintage:vintage andShareSize:hours isMultiShare:isMultiShare] floatValue];
    
    if (nextYearPercentageForOHF != nil) {
        ohfAnnual = [[NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForOHF andInitialCost:[NSNumber numberWithFloat:ohfAnnual]] floatValue];
    }
    
    if (nextYearPercentageForMMF != nil) {
        mgtFeeAnnual = [[NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForMMF andInitialCost:[NSNumber numberWithFloat:mgtFeeAnnual]] floatValue];
    }
    
    float fuelAnnual = [[NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:aircraftType andFuelPeriod:fuelPeriod forNumberOfHours:hours isQualified:qualified] floatValue];
    
    float fetAnnual = [[NFDFlightProposalCalculatorService calculateShareOperationalFederalExciseTaxForAircraftType:aircraftType vintage:vintage shareSize:hours andFuelPeriod:fuelPeriod isQualified:qualified isMultiShare:isMultiShare] floatValue];
    
    float total = qualified ? ohfAnnual + mgtFeeAnnual + fuelAnnual + annualPayments : ohfAnnual + mgtFeeAnnual + fuelAnnual + fetAnnual + annualPayments;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:total]];
}

+ (NSNumber *)calculateLeaseOperationalAnnualCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours leaseTerm:(NSString *)leaseTerm andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare
{
    float monthlyLeaseFee = [[NFDFlightProposalCalculatorService calculateMonthlyLeaseFeeForAircraftType:aircraftType annualHours:hours leaseTerm:leaseTerm] floatValue] * 12;
    
    float monthlyLeaseFeeFET = [[NFDFlightProposalCalculatorService calculateMonthlyLeaseFeeFETForAircraftType:aircraftType annualHours:hours leaseTerm:leaseTerm isQualified:qualified] floatValue] * 12;
    
    float ohfAnnual = [[NFDFlightProposalCalculatorService calculateLeaseOccupiedHourlyFeeAnnualForAircraftType:aircraftType andShareSize:hours] floatValue];
    
    float mgtFeeAnnual = [[NFDFlightProposalCalculatorService calculateLeaseMonthlyManagementFeeAnnualForAircraftType:aircraftType andShareSize:hours isMultiShare:isMultiShare] floatValue];
    
    if (nextYearPercentageForOHF != nil) {
        ohfAnnual = [[NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForOHF andInitialCost:[NSNumber numberWithFloat:ohfAnnual]] floatValue];
    }
    
    if (nextYearPercentageForMMF != nil) {
        mgtFeeAnnual = [[NFDFlightProposalCalculatorService calculateCostWithNextYearPercentage:nextYearPercentageForMMF andInitialCost:[NSNumber numberWithFloat:mgtFeeAnnual]] floatValue];
    }
    
    float fuelAnnual = [[NFDFlightProposalCalculatorService fuelVariableTotalForAircraftType:aircraftType andFuelPeriod:fuelPeriod forNumberOfHours:hours isQualified:qualified] floatValue];
    
    float fetAnnual = [[NFDFlightProposalCalculatorService calculateLeaseOperationalFederalExciseTaxForAircraftType:aircraftType vintage:vintage shareSize:hours andFuelPeriod:fuelPeriod isQualified:qualified isMultiShare:isMultiShare] floatValue];
    
    float total = qualified ? (ohfAnnual + mgtFeeAnnual + fuelAnnual + monthlyLeaseFee) : (ohfAnnual + mgtFeeAnnual + fuelAnnual + fetAnnual + monthlyLeaseFee + monthlyLeaseFeeFET);

    //float fetRate = qualified ? 1 : 1+(float)FETRATE;
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:total]];
}

#pragma mark - Share Operational Average Hourly Cost

+ (NSNumber *)calculateShareOperationalAverageHourlyCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare
{
    
    float annualCost = [[NFDFlightProposalCalculatorService calculateShareOperationalAnnualCostForAircraftType:aircraftType vintage:vintage shareSize:hours andFuelPeriod:fuelPeriod nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:qualified isMultiShare:isMultiShare] floatValue];
    float numHours = [hours floatValue];

    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:annualCost/numHours]];
}

+ (NSNumber *)calculateFinanceOperationalAverageHourlyCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified withAcquisitionCost:(NSNumber *)acqCost isMultiShare:(BOOL)isMultiShare
{
    
    float annualCost = [[NFDFlightProposalCalculatorService calculateFinanceOperationalAnnualCostForAircraftType:aircraftType vintage:vintage shareSize:hours andFuelPeriod:fuelPeriod nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:qualified withAcquisitionCost:acqCost isMultiShare:isMultiShare] floatValue];
    float numHours = [hours floatValue];
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:annualCost/numHours]];
}

+ (NSNumber *)calculateLeaseOperationalAverageHourlyCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours leaseTerm:(NSString *)leaseTerm andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare
{
    float annualCost = [[NFDFlightProposalCalculatorService calculateLeaseOperationalAnnualCostForAircraftType:aircraftType vintage:vintage shareSize:hours leaseTerm:leaseTerm andFuelPeriod:fuelPeriod nextYearPercentageForOHF:nextYearPercentageForOHF nextYearPercentageForMMF:nextYearPercentageForMMF isQualified:qualified isMultiShare:isMultiShare] floatValue];
    float numHours = [hours floatValue];
    
    return [NFDFlightProposalCalculatorService applyRoundingTo:[NSNumber numberWithFloat:annualCost/numHours]];
}


#pragma mark - Excel Financial Functions

+ (NSNumber *)calcualtePV:(NSNumber *) monthlyRate 
               havingTerm:(NSNumber *) numberOfMonths
       withMonthlyPayment:(NSNumber *) monthlyPayment
        havingFutureValue:(NSNumber *) futureValue
          withPaymentType:(NSNumber *) paymentType
{  
    
    double rate = [monthlyRate doubleValue];
    double nPer = [numberOfMonths doubleValue];
    double fv = [futureValue doubleValue];   
    double pmt = [monthlyPayment doubleValue];    
    double type = [paymentType doubleValue];
    
    //A = ( 1 + monthlyRate ) ^ nper
    double A = pow ( ( 1.0f + rate), nPer );
    
    //B = pmt * (1 + rate * type)
    double B = pmt * ( 1.0f + rate * type );
    
    //C =  (  ((1 + rate) ^ nper   - 1 ) / rate ) )
    double C = ( ( pow ( ( 1.0f + rate ), nPer ) ) - 1.0f ) / rate;
    
    //PV() = - ( B * C + FV ) / A
    double presentValue = - 1.0f * ( ( B * C + fv ) / A ); 
    
    return [NSNumber numberWithDouble:presentValue];   
}

+ (NSNumber *)calcualteFV:(NSNumber *) monthlyRate 
               havingTerm:(NSNumber *) numberOfMonths
       withMonthlyPayment:(NSNumber *) monthlyPayment
          andPresentValue:(NSNumber *) presentValue
           andPaymentType:(NSNumber *) paymentType
{  
    
    double rate = [monthlyRate doubleValue];
    double nPer = [numberOfMonths doubleValue];
    double pv = [presentValue doubleValue];   
    double pmt = [monthlyPayment doubleValue];    
    double type = [paymentType doubleValue];
    
    
    //A = presentValue * ( 1 + monthlyRate ) ^ numberOfPayments
    double A = pv * ( pow ( ( 1 + rate ), nPer ) );
    
    //B = payment * (1 + ( monthlyRate * 0 ) )
    double B = pmt * ( 1.0f + ( rate * type) );
    
    //C =  ( ( (1 + monthlyRate ) ^ numberOfPayments   - 1 ) / monthlyRate ) )
    double C = ( ( pow ( ( 1.0f + rate ), nPer ) ) - 1.0f ) / rate;
    
    //FV() = - A - ( B * C )
    double futureValue = (-1.0f *  A) - ( B * C ) ;
    
    return [NSNumber numberWithDouble:futureValue];   
    
}

+ (NSNumber *)calcualtePMT:(NSNumber *) monthlyRate 
                havingTerm:(NSNumber *) numberOfMonths
          withPresentValue:(NSNumber *) presentValue
            andFutureValue:(NSNumber *) futureValue
            andPaymentType:(NSNumber *) paymentType
{  
    
    double rate = [monthlyRate doubleValue];
    double nPer = [numberOfMonths doubleValue];
    double pv = [presentValue doubleValue];   
    double fv = [futureValue doubleValue];    
    double type = [paymentType doubleValue];
    
    //A = presentValue * ( 1 + monthlyRate ) ^ numberOfPayments
    double A = ( pv * ( pow ( ( 1 + rate ), nPer ) ) );
    
    //B = ( 1 + ( rate * type ) )
    double B = 1.0f + ( rate * type );
    
    //C =  (  ( (1 + rate) ^ nper   - 1 ) / rate ) )
    double C =  ( ( pow ( ( 1.0f + rate ) , ( nPer ) ) - 1 ) / rate );
    
    //PMT() = - ( FV + A ) / ( B * C )
    double pmt = -1.0f * ( ( fv + A ) / ( B * C ) );
    
    return [NSNumber numberWithDouble:pmt];
    
}

@end
