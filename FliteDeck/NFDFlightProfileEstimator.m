//
//  FlightProfileEstimator.m
//  FlightProfile
//
//  Created by Evol Johnson on 1/11/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProfileEstimator.h"
#import "NSNumber+Utilities.h"
#import "AircraftTypeResults.h"
#import "NFTFlightAndTripTime.h"
#import "NFDPersistenceService.h"
#import "Leg.h"
#import "NFDContractRate.h"
#import "NFDFuelRate.h"
#import "FuelRate+Utility.h"
#import "AircraftTypeGroup+Custom.h"
#import "ContractRate+Utility.h"
#import "NCLFramework.h"
#import "NFDUserManager.h"

@implementation NFDFlightProfileEstimator
@synthesize valid;
-(id) init {
    self = [super init];
    if(self){
        
    }
    return self;
}

- (NFDAircraftType*)aircraftTypeForTypeName:(NSString*)typeName
{
    NSError *error = nil;
    NSArray *aircraftTypeData = [NCLPersistenceUtil executeFetchRequestForEntityName:@"AircraftType"
                                                                        predicateKey:@"typeName"
                                                                      predicateValue:typeName
                                                                             sortKey:nil
                                                                  includeSubEntities: NO
                                                                             context:[[NFDPersistenceService sharedInstance] context]
                                                                               error:&error];
    
    if (error ||
        aircraftTypeData.count <= 0)
    {
        return nil;
    }
    
    return [aircraftTypeData objectAtIndex:0];
}

- (NFDContractRate*)contractRateInfoForAircraftTypeGroup:(NSString*)typeGroupName
{
    NSError *error = nil;
    NSArray *contractRateData = [NCLPersistenceUtil executeFetchRequestForEntityName:@"ContractRate"
                                                                        predicateKey:@"typeGroupName"
                                                                      predicateValue:[typeGroupName trimmed]
                                                                             sortKey:nil
                                                                  includeSubEntities: NO
                                                                             context:[[NFDPersistenceService sharedInstance] context]
                                                                               error:&error];
    
    if (error ||
        contractRateData.count <= 0)
    {
        NSLog(@"Error getting contract rates for aircraft type group %@: error=%@", typeGroupName, [error localizedDescription]);
        return nil;
    }
    
    NFDContractRate *rate = [contractRateData objectAtIndex:0];
    
    return rate;
}

- (BOOL)tripAndRateInfo:(FlightEstimatorData*)parameters
{
    NFDUserManager *userManager = [NFDUserManager sharedManager];
    
    // validation and setup
    valid = TRUE;
    if ([parameters.airports count] < 2 || [parameters.aircrafts count] < 1 || parameters.season == nil || parameters.product == nil)
    {
        for (NFDAircraftTypeGroup *typeGroup in parameters.aircrafts){
            [typeGroup clearWarnings];
        }
        valid = NO;
        return valid;
    }
    
    NSString static *fuelWarning = @"Fuel Stop Required";
    parameters.results = [[NSMutableArray alloc] init];
    //NFDAirportService *airportService = [[NFDAirportService alloc] init];

    //[parameters retrieveAirportsFromIds];
    // iterate through each selected aircraft type group
    for (NFDAircraftTypeGroup *typeGroup in parameters.aircrafts)
    {
        AircraftTypeResults *acResult = [[AircraftTypeResults alloc] init];
        NFDAircraftType *ac = [self aircraftTypeForTypeName:typeGroup.acPerformanceTypeName];
        NFDContractRate *rate = nil;
        
        if ([userManager profileShowMoney]) {
            rate = [self contractRateInfoForAircraftTypeGroup:typeGroup.typeGroupName];
        }
        
        acResult.aircraft = ac;
        acResult.rates = rate;
        //NSLog(@"%@ -> %@",ac.typeName,[rate description]);
        acResult.name = [NSString stringWithFormat:@"%@", typeGroup.typeGroupName];
        acResult.asapStop = @"";
        [typeGroup clearWarnings];
        
        // get trip time info for each aircraft/airport pair... including return trips
        NFTSeason season = ANNUAL;
        
        if ([[parameters season] isEqualToString:@"Spring"])
            season = SPRING;
        else if ([[parameters season] isEqualToString:@"Summer"])
            season = SUMMER;
        else if ([[parameters season] isEqualToString:@"Fall"])
            season = FALL;
        else if ([[parameters season] isEqualToString:@"Winter"])
            season = WINTER;
        
        float totalOutTripTime = 0.0f;
        float totalReturnTripTime = 0.0f;
        float totalOutFlightTime = 0.0f;
        float totalReturnFlightTime = 0.0f;
        int totalDistance = 0;
        NFTLatLong *prevLocationLatLong = nil;
        NFDAirport *previousAirport = nil;
        int position = 0;
        for (NFDAirport *airport in parameters.airports)
        {
            //Airport *airport = [airportService findAirportWithCode:airportid];
            NFTLatLong *currentLatLong = [[NFTLatLong alloc] initWithSecondsLatitude:[airport.latitude_qty doubleValue] secondsLongitude:[airport.longitude_qty doubleValue]];
            
            if (prevLocationLatLong)
            {
                NFTTripInfo* outTripInfo = [NFTFlightAndTripTime tripInfoForAircraftType:ac.typeName
                                                           latitudeAndLongitudeForOrigin:prevLocationLatLong
                                                      latitudeAndLongitudeForDestination:currentLatLong
                                                                                  season:season
                                                                      numberOfPassengers:[parameters passengers]
                                                                         highSpeedCruise:[[ac highCruiseSpeed] intValue]
                                                                         maxRangeInHours:[ac maxFlyingTime]
                                                                                   error:nil];
                
                totalOutTripTime += [outTripInfo.tripTime doubleValue];
                totalOutFlightTime += [outTripInfo.flightTime doubleValue];
                totalDistance += [outTripInfo.distanceInNauticalMiles intValue];
                
                Leg *leg = [[Leg alloc] init];
                leg.origin = previousAirport;
                leg.destination = airport;
                leg.position = position;
                //leg.originId = previousAirport.airportid;
                //leg.destinationId = airport.airportid;
                leg.distance = [outTripInfo.distanceInNauticalMiles floatValue];
                //NSLog(@"%f",leg.distance);
                leg.blockTime = [outTripInfo.tripTime floatValue];

                //NSLog(@"%@-%@",leg.origin.airport_name,leg.destination.airport_name);
                //leg.destinationForPDF = [NSString stringWithFormat:@"%@ - %@ (%@)",leg.destination.airport_name,leg.destination.city_name, leg.destination.airportid];
                //NSLog(@"%@ %@",leg.origin.airportid,leg.destination.airportid);
                //NSNumber *occupiedHourlyRate = [rate estimatedHourlyFeeForProduct:parameters.product fuelIncluded:NO taxIncluded:NO];

                leg.fuelStops = outTripInfo.fuelStops;
                //NSLog(@"%@-%@",leg.origin.airport_name,leg.destination.airport_name);
                //leg.destinationForPDF = [NSString stringWithFormat:@"%@ - %@ (%@)",leg.destination.airport_name,leg.destination.city_name, leg.destination.airportid];
                //NSLog(@"%@ %@",leg.origin.airportid,leg.destination.airportid);
                NSNumber *occupiedHourlyRate = [rate estimatedHourlyFeeForProduct:parameters.product];

                if (occupiedHourlyRate && ![[NSDecimalNumber notANumber] isEqualToNumber:occupiedHourlyRate])
                {
                    float flightTime = [outTripInfo.flightTime floatValue];
                    float flightTimeWithTaxi = (flightTime == 0.0f) ? 0.0f : flightTime + 0.2f;
                    float taxRate = [rate isTaxable:parameters.product] == YES ? 1.075f : 1.0f;
                    int fuelRate = (taxRate == 1.0f) ? ac.fuelRate.qualifiedDefaultRate : ac.fuelRate.nonQualifiedDefaultRate;
                    
                    leg.hourlyCost = roundf([occupiedHourlyRate floatValue] * flightTimeWithTaxi);
                    leg.fuelCost = roundf(fuelRate * flightTimeWithTaxi * taxRate);
                    leg.californiaFee = [rate californiaFeesForDeparture:previousAirport arrival:airport];
                    leg.totalCost = leg.hourlyCost + leg.fuelCost + leg.californiaFee;
                    
                    // if we can't determine the block time, let's just show the hourly fee (1 hour of flight time)
                    if (leg.hourlyCost == 0.0f)
                    {
                        leg.hourlyCost = [occupiedHourlyRate floatValue];
                        leg.totalCost = 0.0f;
                    }
                    
                    if (leg.fuelCost == 0.0f)
                        leg.fuelCost = ac.fuelRate.qualifiedDefaultRate;
                }

                [acResult.outLegs addObject: leg];
                
                NFTTripInfo* returnTripInfo = nil;
                
                if (parameters.roundTrip == YES)
                {
                    returnTripInfo = [NFTFlightAndTripTime tripInfoForAircraftType:ac.typeName
                                                     latitudeAndLongitudeForOrigin:currentLatLong
                                                latitudeAndLongitudeForDestination:prevLocationLatLong
                                                                            season:season
                                                                numberOfPassengers:[parameters passengers]
                                                                   highSpeedCruise:[[ac highCruiseSpeed] intValue]
                                                                   maxRangeInHours:[ac maxFlyingTime]
                                                                             error:nil];
                    
                    totalReturnTripTime += [returnTripInfo.tripTime doubleValue];
                    totalReturnFlightTime += [returnTripInfo.flightTime doubleValue];
                    
                    Leg *leg = [[Leg alloc] init];
                    leg.origin = airport;
                    leg.position = position;
                    leg.destination = previousAirport;
                    leg.distance = [returnTripInfo.distanceInNauticalMiles floatValue];
                    leg.blockTime = [returnTripInfo.tripTime floatValue];
                    leg.fuelStops = returnTripInfo.fuelStops;

                    //NSLog(@"%@ %@",leg.origin.airportid,leg.destination.airportid);
                    
                    if (![[NSDecimalNumber notANumber] isEqualToNumber:occupiedHourlyRate])
                    {
                        float flightTime = [returnTripInfo.flightTime floatValue];
                        float flightTimeWithTaxi = (flightTime == 0.0f) ? 0.0f : flightTime + 0.2f;
                        float taxRate = [rate isTaxable:parameters.product] == YES ? 1.075f : 1.0f;
                        int fuelRate = (taxRate == 1.0f) ? ac.fuelRate.qualifiedDefaultRate : ac.fuelRate.nonQualifiedDefaultRate;
                        
                        leg.hourlyCost = roundf([occupiedHourlyRate floatValue] * flightTimeWithTaxi);
                        leg.fuelCost = roundf(fuelRate * flightTimeWithTaxi * taxRate);
                        leg.californiaFee = [rate californiaFeesForDeparture:previousAirport arrival:airport];
                        leg.totalCost = leg.hourlyCost + leg.fuelCost + leg.californiaFee;
                        
                        // if we can't determine the block time, let's just show the hourly fee (1 hour of flight time)
                        if (leg.hourlyCost == 0.0f)
                        {
                            leg.hourlyCost = [occupiedHourlyRate floatValue];
                            leg.totalCost = 0.0f;
                        }
                        
                        if (leg.fuelCost == 0.0f)
                            leg.fuelCost = ac.fuelRate.qualifiedDefaultRate;
                    }

                    [acResult.retLegs addObject: leg];
                }
                
                if (outTripInfo.fuelStops > 0 || returnTripInfo.fuelStops > 0 )
                {
                    acResult.asapStop = fuelWarning;
                    [typeGroup addWarning:fuelWarning];
                }
            }
            
            prevLocationLatLong = currentLatLong;
            previousAirport = airport;
            position++;
        }
        
        parameters.totalDistance = [NSNumber numberWithInt:totalDistance];
        
        if ([userManager profileShowMoney]) {
            // set the contract rate info
            NSNumber *OHF = [rate estimatedHourlyFeeForProduct:parameters.product];

            // validate product type
            if (rate == nil ||
                [[NSDecimalNumber notANumber] isEqualToNumber:OHF])
            {
                [typeGroup addWarning:@"Aircraft Not Available"];
                valid = NO;
            }
        }
        // validate pax
        if ([ac.numberOfPax intValue] < parameters.passengers)
        {   
            [typeGroup addWarning:@"Exceeds Aircraft Capacity"];
            valid = NO;
        }
        
        // validate runway length
        int cont = 0;
        NSString *airportsWarning = @"";
        
        for (NFDAirport *airport in parameters.airports)
        {
            //NSLog(@" AC %d %@  %d",[ac.minRunwayLength intValue], airport.airportid,[airport.longest_runway_length_qty intValue]);
            if ([ac.minRunwayLength intValue] > [airport.longest_runway_length_qty intValue])
            {
                if (cont > 0){
                    airportsWarning = [airportsWarning stringByAppendingFormat:@", "];
                }else{
                    airportsWarning = @"Restricted: Runway Length ("; 
                }
                airportsWarning = [airportsWarning stringByAppendingFormat:@"%@",airport.airportid];
                cont++;
                valid = NO;
            }
        }
        
        if (![airportsWarning isEqualToString:@""])
        {
            airportsWarning = [airportsWarning stringByAppendingFormat:@")"];
            [typeGroup addWarning:airportsWarning];
        }

        // set final results
        [parameters.results addObject:acResult];
    }
    
    return valid;
}

-(BOOL) validateAircraft : (NFDAircraftTypeGroup *) typeGroup {
    return NO; 
}

@end
