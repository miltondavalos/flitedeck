//
//  NFTFlightCalculator.m
//  FlightAndTripTime
//
//  Created by Chad Long on 2/17/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFTFlightCalculator.h"
#import "NFTPersistenceManager.h"
#import "NFTMathUtil.h"
#import "NFTWindCorrections.h"
#import "NFTStageDistAndSpeed.h"
#import "NFTAircraftTypeByProgram.h"
#import "NFTEnduranceEntry.h"
#import "NFDUserManager.h"

@implementation NFTFlightCalculator

+ (NSDecimalNumber*)tripTimeForAircraftType:(NSString*)aircraftType
                                 flightTime:(NSDecimalNumber*)flightTime
                                  techStops:(int)techStops
{
    static float TAXI_TIME = 0.2f;
    static int NJUS_PROGRAM_ID = 1000011;
    static int NJE_PROGRAM_ID = 1000021;
    int programIdForCompany;
    
    float turnTime = 0.5f;
    
    if ([[NFDUserManager sharedManager] companySetting] == NFDCompanySettingNJA) {
        programIdForCompany = NJUS_PROGRAM_ID;
    } else {
        programIdForCompany = NJE_PROGRAM_ID;
    }
    
    // get the turn time data for this aircraft from core data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NFTAircraftTypeByProgram"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"aircraftType == %@ AND programId == %i", aircraftType, programIdForCompany];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSManagedObjectContext *context = [[NFTPersistenceManager sharedInstance] mainMOC];
    NSArray *turnTimeData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error ||
        turnTimeData.count <= 0)
    {
        DLog(@"Unable to obtain turn time data for aircraft %@: error=%@", aircraftType, [error description]);
    }
    else
    {
        turnTime = [((NFTAircraftTypeByProgram*)[turnTimeData objectAtIndex:0]).techTurnTime floatValue];
    }
    
    // add it all up to get the trip time
    float tripTime = TAXI_TIME + [flightTime floatValue] + (techStops * turnTime);
    
//    DLog(@"Turn time is %f, Trip time is %f", turnTime, tripTime);

    
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.1f", tripTime]];
}

+ (NSDecimalNumber*)flightTimeForAircraftType:(NSString*)aircraftType
                      distanceInNauticalMiles:(double)distance
                               windCorrection:(int)windCorrection
                                        error:(NSError**)error
{
    return [NFTFlightCalculator flightTimeForAircraftType:aircraftType distanceInNauticalMiles:distance windCorrection:windCorrection highSpeedCruise:0 error:&*error];
}

+ (NSDecimalNumber*)flightTimeForAircraftType:(NSString*)aircraftType
                      distanceInNauticalMiles:(double)distance
                               windCorrection:(int)windCorrection
                              highSpeedCruise:(int)highSpeedCruise
                                        error:(NSError**)error
{
    // get the distance and speed data for this aircraft from core data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NFTStageDistAndSpeed"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"aircraftType == %@", aircraftType];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *coreDataError = nil;
    NSManagedObjectContext *context = [[NFTPersistenceManager sharedInstance] mainMOC];
    NSArray *stageDistAndSpeedData = [context executeFetchRequest:fetchRequest error:&coreDataError];
    
    if (coreDataError ||
        stageDistAndSpeedData.count <= 0)
    {
        // if stage and speed data is not available, use the high speed cruise if it is provided
        if (!coreDataError &&
            highSpeedCruise > 0)
        {
            return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.1f", (float)(distance / (highSpeedCruise + windCorrection))]];
        }
        else
        {
            if (error != 0)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Unable to calculate flight time.  Cruise speed may be required." forKey:NSLocalizedDescriptionKey];
                [details setValue:[coreDataError localizedDescription] forKey:NSLocalizedFailureReasonErrorKey];
                *error = [NSError errorWithDomain:@"FlightAndTripTime" code:101 userInfo:details];
            }

            DLog(@"Unable to obtain stage distance and speed data for aircraft %@: error=%@", aircraftType, [coreDataError localizedFailureReason]);
            
            return [NSDecimalNumber zero];
        }
    }
    
    // setup
    float windCalc[] = {
        (windCorrection * 0.20f),
        (windCorrection * 0.40f),
        (windCorrection * 0.60f),
        (windCorrection * 0.80f),
        (windCorrection * 0.95f),
        (windCorrection * 1.00f)
    };
    
    int stage = 0;
    double remaining = distance;
    float cumulativeMiles = 0.0f;
    float totalFlightTime = 0.0f;
    
    // calc flight time for ascent
    while (remaining >= [((NFTStageDistAndSpeed*)[stageDistAndSpeedData objectAtIndex:stage]).distance doubleValue] &&
           cumulativeMiles <= remaining)
    {
        NFTStageDistAndSpeed *stageDistAndSpeed = (NFTStageDistAndSpeed*)[stageDistAndSpeedData objectAtIndex:stage];
        int stageDist = [stageDistAndSpeed.distance intValue];
        int stageSpeed = [stageDistAndSpeed.averageSpeed intValue];
        
        totalFlightTime += stageDist / (stageSpeed + windCalc[stage]);                
        
        cumulativeMiles += stageDist;
        remaining -= stageDist;
        
        stage++;
        
        if (stage > 5)
            stage = 5;
    }
    
    // calc flight time for descent
    while (remaining > 0)
    {
        for (stage = 0; stage < 6 && [((NFTStageDistAndSpeed*)[stageDistAndSpeedData objectAtIndex:stage]).distance doubleValue] < remaining; stage++);
        
        if (stage > 0)
            stage--;
        
        NFTStageDistAndSpeed *stageDistAndSpeed = (NFTStageDistAndSpeed*)[stageDistAndSpeedData objectAtIndex:stage];
        int stageDist = [stageDistAndSpeed.distance intValue];
        int stageSpeed = [stageDistAndSpeed.averageSpeed intValue];
        
        if (stage == 0)
        {
            totalFlightTime += remaining / (stageSpeed + windCalc[stage]);
            remaining = 0;
        }            
        else
        {
            totalFlightTime += stageDist / (stageSpeed + windCalc[stage]);
            remaining -= stageDist;
        }
    }
    
    // 0.2 minimum
    if (totalFlightTime < 0.2f)
        totalFlightTime = 0.2f;
    
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.1f", totalFlightTime]];
}

+ (NFTEnduranceEntry*)enduranceForAircraftType:(NSString*)aircraftType
                                   numberOfPax:(int)numberOfPax
                                windCorrection:(int)headWind
{
    // round headwind to the nearest 5 interval
    int remainder = headWind % 5;
    
    if (headWind > 0 &&
        remainder != 0)
    {
        headWind += 5 - remainder;
    }
    else if (headWind < 0 &&
             remainder != 0)
    {
        headWind -= remainder;
    }
    
    // get the endurance data for this aircraft/pax load/headwind from core data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NFTEnduranceEntry"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"aircraftType == %@ AND numberOfPax == %i AND headwind == %i", aircraftType, numberOfPax, headWind];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSManagedObjectContext *context = [[NFTPersistenceManager sharedInstance] mainMOC];
    NSArray *enduranceData = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error ||
        enduranceData.count <= 0)
    {
        DLog(@"Unable to obtain endurance data for aircraft %@, pax load %i, & wind %i: error=%@", aircraftType, numberOfPax, headWind, [error description]);
        return nil;
    }
    
    return (NFTEnduranceEntry*)[enduranceData objectAtIndex:0];
}

+ (int)fuelStopsWithEndurance:(NSDecimalNumber*)endurance flightTime:(NSDecimalNumber*)flightTime
{
    // throw a red flag if bad data is provided
    if (endurance == nil ||
        [endurance floatValue] <= 0.0f ||
        flightTime == nil)
    {
        DLog(@"passed nil endurance or flightTime to fuelStopsWithEndurance");
        return -1;
    }
    
    return (int)([flightTime floatValue] / [endurance floatValue]);
}

+ (NFTEllipsoidalDistanceAndCourseInfo *)ellipsoidalDistanceAndCourse:(NFTLatLong*)station1  withDestination:(NFTLatLong*)station2
{
    
    if (( [station1 latitudeInDegrees] == [station2 latitudeInDegrees]) && ( [station1 longitudeInDegrees] == [station2 longitudeInDegrees]))
    {
        //double ret0[4] = { 0.0, 0.0, 0.0, 0.0 };
        return [[NFTEllipsoidalDistanceAndCourseInfo alloc] initWithDistanceKM:0.0 distanceSM:0.0 distanceNM:0.0 frontCourse:0.0];
        
    }
    
    double lat1 = NFTMathUtil.DEG_RAD * [station1.latitude toDegrees];
    double lat2 = NFTMathUtil.DEG_RAD * [station2.latitude toDegrees];    
    double long1 = NFTMathUtil.DEG_RAD * [station1.longitude toDegrees];    
    double long2 = NFTMathUtil.DEG_RAD * [station2.longitude toDegrees];
    
    double eps = 0.5E-13;
    
    double r = 1.0 - f_WGS84;
    
    double tu1 = (r * sin(lat1)) / cos(lat1);    
    double tu2 = (r * sin(lat2)) / cos(lat2);
    
    double cu1 = 1.0 / sqrt(tu1 * tu1 + 1.0);    
    double cu2 = 1.0 / sqrt(tu2 * tu2 + 1.0);
    
    double su1 = cu1 * tu1;    
    double s = cu1 * cu2;
    
    double backCourse = s * tu2;
    double frontCourse = backCourse * tu1;
    
    double x = long2 - long1;
    double c, d, e, c2a, cx, cy, cz, sa, sx, sy, y;
    
    c = 0.0;
    e = 0.0;
    c2a = 0.0;
    cx = 0.0;
    cy = 0.0;
    cz = 0.0;
    sa = 0.0;
    sx = 0.0;
    sy = 0.0;
    y = 0.0;
    d = 1;
    
    while (fabs(d - x) > eps)
    {
        sx = sin(x);
        cx = cos(x);
        tu1 = cu2 * sx;
        tu2 = backCourse - su1 * cu2 * cx;
        sy = sqrt(tu1 * tu1 + tu2 * tu2);
        cy = s * cx + frontCourse;
        y = atan2(sy, cy);
        sa = s * sx / y;
        c2a = -sa * sa + 1.0;
        cz = 2 * frontCourse;
        
        if (c2a > 0) {
            cz = -cz / c2a + cy;
        }
        
        e = 2 * cz * cz - 1.0;
        c = ((-3.0 * c2a + 4.0) * f_WGS84 + 4.0) * c2a * (f_WGS84) / 16.0;
        d = x;
        x = ((e * cy * c + cz) * sy * c + y) * sa;
        x = x * (1.0 - c) * f_WGS84 + long2 - long1;
        
    }
    
    frontCourse = atan2(tu1, tu2);
    
    if (frontCourse < 0){
        frontCourse = frontCourse + 2.0 * M_PI;
//        DLog(@"FronCourse.3: %g",frontCourse);
    }
    
    frontCourse = frontCourse * (180 / M_PI);
    
    backCourse = atan2(cu1 * sx, backCourse * cx - su1 * cu2) + M_PI;
    
    if (backCourse < 0) {
        backCourse = backCourse + 2.0 * M_PI;
    }
    
    backCourse = backCourse * (180 / M_PI);
    
    x = sqrt((1.0 / r / r - 1.0) * c2a + 1.0) + 1.0;
    x = (x - 2.0) / x;
    c = 1.0 - x;
    c = (x * x / 4.0 + 1.0) / c;
    d = (0.375 * x * x - 1.0) * x;
    x = e * cy;
    
    double distance = 1.0 - 2.0 * e;
    distance = ((((sy * sy * 4.0 - 3.0) * distance * cz * d / 6.0 - x) * d / 4.0 + cz) * sy * d + y) * c * a_WGS84 * r;
    
    // convert distance to various units
    double distanceKM = distance / 1000;
    double distanceSM = distanceKM / KILOMETERS_PER_STATUTE_MILE;
    double distanceNM = distanceSM * NAUTICAL_MILES_PER_STATUTE_MILE;
    
    return [[NFTEllipsoidalDistanceAndCourseInfo alloc]initWithDistanceKM:distanceKM distanceSM:distanceSM distanceNM:distanceNM frontCourse:frontCourse];
}

/**
 
 Based on an airport latitude, the season and the flight true course, return the wind correction.  
 Wind correction is a calculation on how much winds will increase or decrease the flight time.
 
 */
+ (int)getWindCorrection:(NFTLatLong *)airportLatLong 
                  season:(NFTSeason)seasonCode 
              trueCourse:(int)trueCourse {
    
    int windCorrection = 0;
    
    int latBand = airportLatLong.latitudeInDegrees;
//    DLog(@"latBand = %d", latBand);
    
    NFTLatitude *lat = [airportLatLong latitude];
    char latDir = [lat declination];
//    DLog(@"latDir = %c", latDir);
    
    latBand = [NFTAlgorithms convertLatBandByDirection:latBand latDir:latDir];
//    DLog(@"latBand = %d", latBand);
    
    
    // Queries for wind correction
    
    NSManagedObjectContext *context = [[NFTPersistenceManager sharedInstance] mainMOC];
    
    // Fetch the nearest wind correction based on latitude and greater than trueCourse
    int highCrs = [self findHighTrueCourse:trueCourse latBand:latBand context:context];
    
    // Fetch the nearest wind correction based on latitude and less than trueCourse
    int lowCrs = [self findLowTrueCourse:trueCourse latBand:latBand context:context];
    
    NSString *season = [NFTAlgorithms getSeasonByCode:seasonCode];
    
    int highVal = [self findSeasonCorrection:highCrs latBand:latBand season:season context:context];
    int lowVal =  [self findSeasonCorrection:lowCrs  latBand:latBand season:season context:context];

    windCorrection = [NFTAlgorithms interp_1d:lowCrs lowVal:lowVal highCrs:highCrs highVal:highVal trueCourse:trueCourse];
    
//    DLog(@"Wind correction = %d", windCorrection);
    
    return windCorrection;
}

/**
 
 Find the nearest wind correction based on latitude greater than trueCourse.
 
 */
+ (int)findHighTrueCourse:(int)trueCourse latBand:(int)latBand context:(NSManagedObjectContext *)context
{
    
    int highCrs = 0;
    
    //    List<WindCorrections> highCRS = WindCorrections.executeQuery(
    //        """select min(trueCourse) from WindCorrections where latitude=:theLatitude and trueCourse >= :theTrueCourse
    //        """,[theLatitude:latBand,theTrueCourse:trueCourse])
    
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] initWithEntityName:@"NFTWindCorrections"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(latitude == %@) AND (trueCourse >= %@)",
                 [NSNumber numberWithInt:latBand], 
                 [NSNumber numberWithInt:trueCourse]];
    
    [fetchReq setPredicate:predicate];
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NFTWindCorrections" inManagedObjectContext:context];
    [fetchReq setEntity:entity];
    
    // Specify that the request should return dictionaries.
    [fetchReq setResultType:NSDictionaryResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"trueCourse"];
    
    // Create an expression to represent the minimum value at the key path 'trueCourse'
    NSExpression *minExpression = [NSExpression expressionForFunction:@"min:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    
    // Create an expression description using the minExpression and returning a number.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"minTrueCourse"];
    [expressionDescription setExpression:minExpression];
    [expressionDescription setExpressionResultType:NSNumberFormatterNoStyle];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchReq setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    NSError *error = nil;
    
    NSArray *objects = [context executeFetchRequest:fetchReq error:&error];
    
    if (objects == nil) {
        // Handle the error.
    }
    else {
        if ([objects count] > 0) {
            highCrs = [[[objects objectAtIndex:0] valueForKey:@"minTrueCourse"] intValue];
//            DLog(@"********************* Nearest greater trueCourse: %d", highCrs);
        }
    }
    
    return highCrs;
}

/**
 
 Find the nearest wind correction based on latitude and less than trueCourse.
 
 */
+ (int)findLowTrueCourse:(int)trueCourse latBand:(int)latBand context:(NSManagedObjectContext *)context
{
    
    int lowCrs = 0;


    //    List<WindCorrections> lowCRS = WindCorrections.executeQuery(
    //     """select  max(trueCourse) from WindCorrections where latitude=:theLatitude and trueCourse <= :theTrueCourse
    //     """,[theLatitude:latBand,theTrueCourse:trueCourse])

    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] initWithEntityName:@"NFTWindCorrections"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(latitude == %@) AND (trueCourse <= %@)", 
                                [NSNumber numberWithInt:latBand], 
                              [NSNumber numberWithInt:trueCourse]];
    [fetchReq setPredicate:predicate];


    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NFTWindCorrections" inManagedObjectContext:context];
    [fetchReq setEntity:entity];

    // Specify that the request should return dictionaries.
    [fetchReq setResultType:NSDictionaryResultType];

    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"trueCourse"];

    // Create an expression to represent the minimum value at the key path 'trueCourse'
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];

    // Create an expression description using the maxExpression and returning a number.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];

    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"maxTrueCourse"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSNumberFormatterNoStyle];

    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchReq setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];

    NSError *error = nil;

    NSArray *objects = [context executeFetchRequest:fetchReq error:&error];

    if (objects == nil) {
        // Handle the error.
    }
    else {
        if ([objects count] > 0) {
            lowCrs = [[[objects objectAtIndex:0] valueForKey:@"maxTrueCourse"] intValue];
//            DLog(@"********************* Nearest least trueCourse: %d", lowCrs);
        }
    }

    return lowCrs;
}

/**
 
 Find the wind correction based on the latitude and the season.
 
 */
+ (int)findSeasonCorrection:(int)trueCourse latBand:(int)latBand season:(NSString *)season context:(NSManagedObjectContext *)context
{

    int seasonVal = 0;

    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"NFTWindCorrections"];

    NSPredicate   *pred = [NSPredicate predicateWithFormat:@"(latitude == %@) AND (trueCourse == %@)", 
                           [NSNumber numberWithInt:latBand], 
                           [NSNumber numberWithInt:trueCourse]];

    [fetch setPredicate:pred];


    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NFTWindCorrections" inManagedObjectContext:context];
    [fetch setEntity:entity];

    NSError *error = nil;

    NSArray *objs = [context executeFetchRequest:fetch error:&error];

    if (objs == nil) {
        // Handle the error.
    }
    else {
        if ([objs count] > 0) {
            
            NFTWindCorrections *windCorrections = (NFTWindCorrections *) [objs objectAtIndex:0];
            
            
            // No calculation for annual winds so we just average winter, spring, summer and fall
            
            if ([season isEqualToString:@"annualCorrection"]) {
                
                int winterVal = [[windCorrections valueForKey:@"winterCorrection"] intValue];
                int summerVal = [[windCorrections valueForKey:@"summerCorrection"] intValue];
                int springFallVal = [[windCorrections valueForKey:@"springFallCorrection"] intValue];
                
                seasonVal = [NFTAlgorithms annualWindCorrection:winterVal spring:springFallVal summer:summerVal fall:springFallVal];
                
            } else {
            
                seasonVal = [[windCorrections valueForKey:season] intValue];
            }
            
//            DLog(@"Seasonal correction = %d", seasonVal);
        }
    }
    
    return seasonVal;

}

    
@end
