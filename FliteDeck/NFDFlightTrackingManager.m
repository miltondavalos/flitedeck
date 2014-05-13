//
//  NFDFlightTrackingManager.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "NFDFlightTrackingManager.h"
#import "NFDPersistenceManager.h"
#import "NCLFramework.h"
#import "NFDFlightTrackingSabreXMLDelegate.h"
#import "NFDUserManager.h"
#import "NFDNetJetsRemoteService.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAircraftTypeService.h"



@implementation NFDFlightTrackingManager

@synthesize flights = _flights;
@synthesize flightsLastUpdated;
@synthesize flightsErrorMessage;
@synthesize tails;
@synthesize tailsLastUpdated;
@synthesize tailsErrorMessage;
@synthesize largeCabinGulfstream;

NSTimer *trackingTimer;

#pragma mark - Initialization

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject setTails:[NSMutableDictionary dictionary]];
        [_sharedObject setFlightsErrorMessage:@"Welcome to Flight Tracking."];
        [_sharedObject setTailsErrorMessage:@"Welcome to Flight Tracking."];
        [_sharedObject setLargeCabinGulfstream:
         [NSSet setWithObjects:@"GIV-SP", @"G-400", @"G-450", @"G-550", @"GV", nil]];            
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        shortDateFormatter = [[NSDateFormatter alloc] init];
        [shortDateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    
    return self;
}

#pragma mark - Synchronized flight array access for thread safety

- (NSArray*)flights
{
    NSArray *result = nil;
    
    @synchronized(_flights)
    {
        result = _flights;
    }
    
    return result;
}

- (void)setFlights:(NSArray*)flights
{
    @synchronized(_flights)
    {
        _flights = flights;
    }
}

#pragma mark - Flights: Supported Searches

- (NSDictionary *)searchFlightsByChoices
{
    NSArray *tempObjectsArray = [NSArray arrayWithObjects:
                          @"Flights by SVP/AE", 
                          @"Flights by Airport", 
                          @"Flights by Tail", 
                          nil];
    NSArray *tempKeysArray = [NSArray arrayWithObjects:
                              [NSNumber numberWithInt:SEARCH_BY_SVPAE], 
                              [NSNumber numberWithInt:SEARCH_BY_AIRPORT], 
                              [NSNumber numberWithInt:SEARCH_BY_AIRCRAFT],
                              nil];
    NSDictionary *tempDictionary = [NSDictionary dictionaryWithObjects:tempObjectsArray forKeys:tempKeysArray];
    return tempDictionary;
}

#pragma mark - Flights: IJet2 Service Calls

- (void)addQueryDates:(NSMutableDictionary *)queryParams startDate:(NSString *)startDate endDate:(NSString *)endDate
{
    if ([startDate isEqualToString:endDate]) {
        [queryParams setObject:[shortDateFormatter dateFromString:startDate] forKey:@"date"];
    } else {
        [queryParams setObject:[shortDateFormatter dateFromString:startDate] forKey:@"startDate"];
        [queryParams setObject:[shortDateFormatter dateFromString:endDate] forKey:@"endDate"];
    }
}

- (void)findFlightsBySVP:(NSString*)svpEmail startDate:(NSString*)startDate endDate:(NSString *)endDate
{
    // setup the query parameters
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] initWithCapacity:2];
    [queryParams setObject:svpEmail forKey:@"emailAddress"];
    
    [self addQueryDates:queryParams startDate:startDate endDate: endDate];

    // execute search
    [self findFlightsWithQueryParams:queryParams];
}

- (void)findFlightsByAirportId:(NSString*)airportId startDate:(NSString*)startDate endDate:(NSString *)endDate onlyFerryFlights:(BOOL)onlyFerryFlights
{
    // setup the query parameters
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] initWithCapacity:3];
    [queryParams setObject:airportId forKey:@"location"];
    
    [self addQueryDates:queryParams startDate:startDate endDate: endDate];
    
    if (onlyFerryFlights) {
        [queryParams setObject:@"3" forKey:@"flightTypeCd"];
    }
    
    // execute search
    [self findFlightsWithQueryParams:queryParams];
}

- (void)findFlightsByTailNumber:(NSString*)tailNbr startDate:(NSString*)startDate endDate:(NSString *)endDate
{
    // setup the query parameters
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] initWithCapacity:2];
    [queryParams setObject:tailNbr forKey:@"tailNumber"];
    
    [self addQueryDates:queryParams startDate:startDate endDate: endDate];

    // execute search
    [self findFlightsWithQueryParams:queryParams];
}

- (void)findFlightsWithQueryParams:(NSDictionary*)queryParams
{
    // clean results array and notify app of pending search
    self.flights = [[NSArray alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCHING_FOR_RESULTS object:nil];
    
    // process remote http request in background
    NSString *path = [[NFDNetJetsRemoteService sharedInstance] buildPath:TRACKER_LEGS_URL];
    NCLURLRequest *request = [[NFDNetJetsRemoteService sharedInstance] urlRequestWithPath: path queryParams:queryParams];
    request.notificationName = FLIGHTS_DID_RECEIVE_NEW_RESULTS;
    request.shouldPresentAlertOnError = YES;
    request.timeoutInterval = 45.0;
    
    [[NFDNetJetsRemoteService sharedInstance] sendHttpRequest:request
                                withBackgroundProcessingBlock:^(NSData *data, NSError *error)
     {       
         if (error)
         {             
             if (error.code == NSURLErrorTimedOut) {
                 [self setFlightsErrorMessage:@"Search Time Exceeded"];
             } else {
                 [self setFlightsErrorMessage:@"Service Not Available"];
             }
             
             self.flightsLastUpdated = nil;
         }
         else
         {
             NSError *jsonError = nil;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
             
             NSArray *legs = [json objectForKey:@"legs"];
             
             if (([legs isKindOfClass:[NSArray class]]) && ([legs count] > 0))
             {
                 NSMutableArray *flightArray = [[NSMutableArray alloc] init];
                 
                 for (int i=0; i < legs.count; i++)
                 {
                     NSDictionary *leg = [legs objectAtIndex:i];
                     
                     if ([leg isKindOfClass:[NSDictionary class]])
                     {
                         //Create new Flight object...
                         NFDFlight *flight = [NFDFlight alloc];
                         
                         //SVP Name
                         @try {
                             NSString *firstName = [self checkStringForNull:[leg objectForKey:@"sales-first-name"]];
                             NSString *lastName = [self checkStringForNull:[leg objectForKey:@"sales-last-name"]];
                             flight.svpName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
                         }
                         @catch (NSException *exception) {
                         }
                         
                         //Account Information
                         @try {
                             flight.accountName = [self checkStringForNull:[leg objectForKey:@"account-name"]];
                             flight.contractType = [self checkStringForNull:[leg objectForKey:@"contract-type"]];
                             flight.contractStatus = [self checkStringForNull:[leg objectForKey:@"contract-status"]];
                             NSNumber *tempShareSize = [leg objectForKey:@"share-size"];
                             flight.contractShareSize = [self checkStringForNull:[tempShareSize stringValue]];
                             NSNumber *tempCardHours = [leg objectForKey:@"card-hours"];
                             flight.contractCardHours = [self checkStringForNull:[tempCardHours stringValue]];
                             flight.contractFlightRule = [self checkStringForNull:[leg objectForKey:@"flight-rule"]];
                             flight.contractStartDate = [NSDate dateFromISOString:[leg objectForKey:@"contract-start-date"]];
                             flight.contractEndDate = [NSDate dateFromISOString:[leg objectForKey:@"contract-end-date"]];
                             flight.contractCurrentYearStartDate = [NSDate dateFromISOString:[leg objectForKey:@"contract-current-year-start-date"]];
                             flight.contractCurrentYearEndDate = [NSDate dateFromISOString:[leg objectForKey:@"contract-current-year-end-date"]];
                             flight.allottedRemainingHours = [self checkStringForNull:[leg objectForKey: @"allotted-remaining-hours"]];
                             flight.availableRemainingHours = [self checkStringForNull:[leg objectForKey: @"available-remaining-hours"]];
                             flight.tollFreeNumber = [self checkStringForNull:[leg objectForKey:@"toll-free-number"]];
                             flight.productDeliveryTeamName = [self checkStringForNull:[leg objectForKey:@"product-delivery-team-name"]];
                         }
                         @catch (NSException *exception) {
                         }
                         
                         //Flight Information
                         @try {
                             flight.flightStatus = [self checkStringForNull:[leg objectForKey:@"flight-status"]];
                             flight.flightTimeEstimated = [self checkStringForNull:[self convertToHoursString:[leg objectForKey:@"flight-time-est"]]];
                             flight.flightTimeActual = [self checkStringForNull:[leg objectForKey:@"flight-time-act"]];
                             if (![flight.flightTimeActual isEqualToString:@""])
                             {
                                 NSArray *timeComponents = [flight.flightTimeActual componentsSeparatedByString:@", "];
                                 NSMutableArray *numbersAndUnits = [[NSMutableArray alloc] init];
                                 for (NSString *comp in timeComponents)
                                 {
                                     [numbersAndUnits addObjectsFromArray:[comp componentsSeparatedByString:@" "]];
                                 }
                                 if (([[numbersAndUnits objectAtIndex:0] isEqualToString:@"1"]) && ([[numbersAndUnits objectAtIndex:1] isEqualToString:@"hours"]))
                                 {
                                     [numbersAndUnits replaceObjectAtIndex:1 withObject:@"hour"];
                                 }
                                 if (numbersAndUnits.count == 4)
                                 {
                                     flight.flightTimeActual = [NSString stringWithFormat:@"%@ %@, %@ %@",
                                                                [numbersAndUnits objectAtIndex:0],
                                                                [numbersAndUnits objectAtIndex:1],
                                                                [numbersAndUnits objectAtIndex:2],
                                                                [numbersAndUnits objectAtIndex:3]];
                                 }
                                 else if (numbersAndUnits.count == 2)
                                 {
                                     flight.flightTimeActual = [NSString stringWithFormat:@"%@ %@",
                                                                [numbersAndUnits objectAtIndex:0],
                                                                [numbersAndUnits objectAtIndex:1]];
                                 }
                             }

                             flight.flightTypeCode = [NSNumber numberFromObject:[leg objectForKey:@"flight-type-code"] shouldUseZeroDefault:NO];
                             flight.ferryFlight = [NSNumber numberFromObject:[leg objectForKey:@"ferry-flight"] shouldUseZeroDefault:YES];
                         }
                         @catch (NSException *exception) {
                         }
                         
                         //Aircraft Information
                         @try {
                             flight.tailNumber = [self checkStringForNull:[leg objectForKey:@"tail-number"]];
                             flight.aircraftTypeGuaranteed = [self checkStringForNull:[leg objectForKey:@"aircraft-type-guarantee"]];
                             flight.aircraftTypeContract = [self checkStringForNull:[leg objectForKey:@"aircraft-type-contract"]];
                             flight.aircraftTypeRequested = [self checkStringForNull:[leg objectForKey:@"aircraft-type-requested"]];
                             flight.aircraftTypeActual = [self checkStringForNull:[leg objectForKey:@"aircraft-type-actual"]];
                             
                             NFDAircraftTypeService *aircraftTypeService = [NFDAircraftTypeService new];
                             
                             NSManagedObjectContext *moc = [[NFDPersistenceManager sharedInstance] privateMOC];
                             
                             NSString *aircraftDisplayNameGuaranteed = [aircraftTypeService displayNameForTypeName:flight.aircraftTypeGuaranteed moc: moc];
                             if (aircraftDisplayNameGuaranteed) {
                                 flight.aircraftDisplayNameGuaranteed = aircraftDisplayNameGuaranteed;
                             }
                             
                             NSString *requestedDisplayName = [aircraftTypeService displayNameForTypeName:flight.aircraftTypeRequested moc: moc];
                             if (requestedDisplayName) {
                                 flight.aircraftTypeDisplayNameRequested = requestedDisplayName;
                             }
                             
                             NSString *actualDisplayName = [aircraftTypeService displayNameForTypeName:flight.aircraftTypeActual moc: moc];
                             if (actualDisplayName) {
                                 flight.aircraftTypeDisplayNameActual = actualDisplayName;
                             }
                         }
                         @catch (NSException *exception) {
                         }
                         
                         //Departure Information
                         NSDictionary *departureDict = [leg objectForKey:@"departure"];
                         if ( ( [departureDict isKindOfClass:[NSDictionary class]] ) && ( [departureDict count] ) > 0 ){
                             @try {
                                 flight.departureICAO = [self checkStringForNull:[departureDict objectForKey:@"icao"]];
                                 flight.departureFBO = [self checkStringForNull:[departureDict objectForKey:@"fbo"]];
                                 flight.departureTimeEstimated = [NSDate dateFromISOString:[departureDict objectForKey:@"time-est"]];
                                 flight.departureTimeActual = [NSDate dateFromISOString:[departureDict objectForKey:@"time-act"]];
                                 
                                 NSManagedObjectContext *context = [[NFDPersistenceManager sharedInstance] privateMOC];
                                 NFDAirport *airport = [self findAirportByAirportId:flight.departureICAO context:context];
                                 
                                 if (airport &&
                                     airport.timezone_cd != nil)
                                 {
                                     flight.departureTZ = [NSTimeZone timeZoneWithName:airport.timezone_cd];
                                 }
                             }
                             @catch (NSException *exception) {
                             }
                         }
                         
                         //Arrival Information
                         NSDictionary *arrivalDict = [leg objectForKey:@"arrival"];
                         if ( ( [arrivalDict isKindOfClass:[NSDictionary class]] ) && ( [arrivalDict count] ) > 0 ){
                             @try {
                                 flight.arrivalICAO = [self checkStringForNull:[arrivalDict objectForKey:@"icao"]];
                                 flight.arrivalFBO = [self checkStringForNull:[arrivalDict objectForKey:@"fbo"]];
                                 flight.arrivalTimeEstimated = [NSDate dateFromISOString:[arrivalDict objectForKey:@"time-est"]];
                                 flight.arrivalTimeActual = [NSDate dateFromISOString:[arrivalDict objectForKey:@"time-act"]];
                                 
                                 NSManagedObjectContext *context = [[NFDPersistenceManager sharedInstance] privateMOC];
                                 NFDAirport *airport = [self findAirportByAirportId:flight.arrivalICAO context:context];
                                 
                                 if (airport &&
                                     airport.timezone_cd != nil)
                                 {
                                     flight.arrivalTZ = [NSTimeZone timeZoneWithName:airport.timezone_cd];
                                 }
                             }
                             @catch (NSException *exception) {
                             }
                         }
                         
                         //Passenger Information
                         NSArray *passengersArray = [leg objectForKey:@"passengers"];
                         if (([passengersArray isKindOfClass:[NSArray class]]) && ([passengersArray count] > 0)) {
                             flight.passengers = [NSMutableArray array];
                             
                             for (int i=0; i < [passengersArray count]; i++) {
                                 NSDictionary *passengerDict = [passengersArray objectAtIndex:i];
                                 NFDPassenger *passenger = [NFDPassenger alloc];
                                 @try {
                                     passenger.firstName = [self checkStringForNull:[passengerDict objectForKey:@"first-name"]];
                                     passenger.lastName = [self checkStringForNull:[passengerDict objectForKey:@"last-name"]];
                                     NSString *lead = [self checkStringForNull:[passengerDict objectForKey:@"lead-passenger"]];
                                     if ([lead isEqualToString:@"T"]) {
                                         passenger.isLeadPassenger = YES;
                                     } else {
                                         passenger.isLeadPassenger = NO;
                                     }
                                     [flight.passengers addObject:passenger];
                                 }
                                 @catch (NSException *exception) {
                                 }
                             }
                             
                             //Sort passenger list by lead passenger...
                             NSArray *sortedArray = [flight.passengers sortedArrayUsingComparator:^(id a, id b) {
                                 NSNumber *first = [NSNumber numberWithBool:[(NFDPassenger*)a isLeadPassenger]];
                                 NSNumber *second = [NSNumber numberWithBool:[(NFDPassenger*)b isLeadPassenger]];
                                 return [second compare:first];
                             }];
                             flight.passengers = nil;
                             flight.passengers = [NSMutableArray arrayWithArray:sortedArray];
                             
                         }
                         
                         //Add new Flight Object to Flights Array...
                         [flightArray addObject:flight];
                     }
                 }
                 
                 self.flights = [[NSArray alloc] initWithArray:flightArray];
                 [self sortFlightsBy:TRACKER_SORTBYDEPARTURETIME];
                 self.flightsLastUpdated = [NSDate date];
             }else{
                 [self setFlightsErrorMessage:@"No results available."];
             }
         }
     }];
}

#pragma mark - Flights: Manage Array of Flights returned by iJet2 Service Call

- (void)sortFlightsBy:(int)sortMethod{
    NSArray *sortedArray;
    switch (sortMethod) {
        case TRACKER_SORTBYACCOUNT:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSString *first = [(NFDFlight*)a accountName];
                NSString *second = [(NFDFlight*)b accountName];
                return [first compare:second];
            }];
            break;
        }
        case TRACKER_SORTBYTAIL:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSString *first = [(NFDFlight*)a tailNumber];
                NSString *second = [(NFDFlight*)b tailNumber];
                return [first compare:second];
            }];
            break;
        }
        case TRACKER_SORTBYARRIVALTIME:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSNumber *first = [NSNumber numberWithDouble:[[(NFDFlight*)a arrivalTimeEstimated] timeIntervalSince1970]];
                NSNumber *second = [NSNumber numberWithDouble:[[(NFDFlight*)b arrivalTimeEstimated] timeIntervalSince1970]];
                return [first compare:second];
            }];
            break;
        }
        case TRACKER_SORTBYDEPARTURETIME:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSNumber *first = [NSNumber numberWithDouble:[[(NFDFlight*)a departureTimeEstimated] timeIntervalSince1970]];
                NSNumber *second = [NSNumber numberWithDouble:[[(NFDFlight*)b departureTimeEstimated] timeIntervalSince1970]];
                return [first compare:second];
            }];
            break;
        }
        case TRACKER_SORTBYSVP:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSString *first = [(NFDFlight*)a svpName];
                NSString *second = [(NFDFlight*)b svpName];
                return [first compare:second];
            }];
            break;
        }
        default:
            break;
    }
    
    self.flights = nil;
    self.flights = sortedArray;
}

- (BOOL)hasRetrievedFlights{
    if ( (self.flights) && ([self.flights count] > 0) ) {
        return YES;
    } else {
        return NO;
    }
}

- (int)totalCountOfFlights{
    if (self.flights == nil) {
        return 0;
    } else {
        return [self.flights count];
    }
}

- (NFDFlight*)retrieveFlightAtIndex:(int)index{
    if ([self hasRetrievedFlights]){
        NFDFlight *retrievedFlight = [self.flights objectAtIndex:index];
        if (retrievedFlight == nil) {
            return nil;
        } else {
            return retrievedFlight;
        }
    }else {
        return nil;
    }
}

#pragma mark - Tracking: Supported Searches

- (void)searchTrackingByTailNumber:(NSString *)tailNumber {
    [self retrieveTrackingForTailNumber:tailNumber];
}

- (void)updateTrackingForAllSearchedTails{
    if ([self hasTrackedTails]){
        for (NSString *tailNumber in [self.tails allKeys]) {
            [self retrieveTrackingForTailNumber:tailNumber];
        }
    }
}

#pragma mark - Tracking: Five Minute Update Timer

-(void)startTrackingTimer{
    if ( ([self hasTrackedTails]) && ( !(trackingTimer) || !([trackingTimer isValid]) ) ){
        trackingTimer = [NSTimer scheduledTimerWithTimeInterval:300.0
                                                         target:self
                                                       selector:@selector(updateTrackingForAllSearchedTails)
                                                       userInfo:nil
                                                        repeats:YES];
    }
}

-(void)stopTrackingTimer{
    [self removeAllTails];
    if (trackingTimer){
        [trackingTimer invalidate];
        trackingTimer = nil;
    }
}

#pragma mark - Tracking: Sabre Service Call

- (void)retrieveTrackingForTailNumber:(NSString*)tailNumber{
    dispatch_async(kBgQueue, ^{
        NSString *url;
        @try {
            url = [NSString stringWithFormat:@"%@?Userid=%@&Password=%@&ACID=%@",SABRE_TRACKING_API_URL,SABRE_USER_ID,SABRE_USER_PASSWORD,tailNumber];
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (data){
                [self performSelectorOnMainThread:@selector(fetchedSabreData:) withObject:[NSArray arrayWithObjects:data,tailNumber,nil] waitUntilDone:YES];
            }else{
                [self performSelectorOnMainThread:@selector(errorSabreData) withObject:nil waitUntilDone:YES];
            }
        }@catch (NSException *exception) {
            [self performSelectorOnMainThread:@selector(errorSabreData) withObject:nil waitUntilDone:YES];
        }
    });
}

#pragma mark - Tracking: XML Parsing of Sabre Data

- (void)fetchedSabreData:(NSArray *)fetchArray {
    
    NSData *responseData = [fetchArray objectAtIndex:0];
    NSString *tailNumber = [fetchArray objectAtIndex:1];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
    NFDFlightTrackingSabreXMLDelegate *parserDelegate = [[NFDFlightTrackingSabreXMLDelegate alloc] init];
    [parser setDelegate:parserDelegate];
    [parser parse];
    
    NFDFlightData *flightData = [parserDelegate flightData];
    [self.tails removeObjectForKey:tailNumber];
    
    if (![[flightData Response] isEqualToString:@"3"]){
        [self.tails setObject:flightData forKey:tailNumber];
        [self setTailsLastUpdated:[NSDate date]];
        [self startTrackingTimer];
        [[NSNotificationCenter defaultCenter] postNotificationName:TRACKING_DID_RECEIVE_NEW_RESULTS object:nil];
    }else{
        [self errorSabreData];
    }
}

-(void)errorSabreData{
    self.tailsLastUpdated = nil;
    [self setTailsErrorMessage:@"No results available."];
    [[NSNotificationCenter defaultCenter] postNotificationName:TRACKING_DID_RECEIVE_NEW_RESULTS object:nil];
}

#pragma mark - Tracking: Manage List of Aircraft returned by Sabre Service Call

- (BOOL)hasTrackedTails{
    if ( (self.tails) && ([self.tails count] > 0) ) {
        return YES;
    } else {
        return NO;
    }
}

- (int)totalCountOfTails{
    if (self.tails == nil) {
        return 0;
    } else {
        return [self.tails count];
    }
}

- (NFDFlightData*)retrieveTailWithKey:(NSString*)tailnumber{
    NFDFlightData *retrievedTail = [self.tails objectForKey:tailnumber];
    if (retrievedTail == nil) {
        return nil;
    } else {
        return retrievedTail;
    }
}

- (void)removeAllTails{
    if (self.tails){
        [self.tails removeAllObjects];
    }else{
        self.tails = [NSMutableDictionary dictionary];
    }
}

#pragma mark - Airport: CoreData Search

- (NFDAirport*)findAirportByAirportId:(NSString*)airportId context:(NSManagedObjectContext*)context
{
    return [NCLPersistenceUtil executeUniqueFetchRequestForEntityName:@"Airport"
                                                         predicateKey:@"airportid"
                                                       predicateValue:airportId
                                                              context:context
                                                                error:nil];
}

#pragma mark - Date/Time Helper Methods

- (NSString*)convertToHoursString:(NSString*)originalHoursString {
    float hoursFloat = [originalHoursString floatValue];
    if (hoursFloat == 1.0)
    {
        return [NSString stringWithFormat:@"%.01f hour", hoursFloat];
    }
    
    return [NSString stringWithFormat:@"%.01f hours", hoursFloat];
}

#pragma mark - Null String Helper Methods

- (NSString*)checkStringForNull:(NSString*)theString{
    if ((theString) && ([theString isKindOfClass:[NSString class]]) &&([theString length] > 0) && ![@"null" isEqualToString:theString] && ![@"<null>" isEqualToString:theString]){
        return theString;
    }else {
        return @"";
    }
}

#pragma mark - Rotation of Aircraft Image

- (UIImage*)rotatedImage:(UIImage*)sourceImage byDegreesFromNorth:(double)degrees color:(UIColor *)color
{

    CGSize rotateSize =  sourceImage.size;
    UIGraphicsBeginImageContext(rotateSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotateSize.width/2, rotateSize.height/2);
    CGContextRotateCTM(context, ( degrees * M_PI/180.0f ) );
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(-rotateSize.width/2,-rotateSize.height/2,rotateSize.width, rotateSize.height),
                       sourceImage.CGImage);
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGRect rect = CGRectZero;
    CGSize tintSize =  rotatedImage.size;
    rect.size = tintSize;
    UIGraphicsBeginImageContext(tintSize);
    [color set];
    UIRectFill(rect);
    [rotatedImage drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    [rotatedImage drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:0.0f];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

#pragma mark - Misc Utility methods

- (BOOL)isLargeCabinGulfstream:(NSString*)aircraftType {
    
    if ((self.largeCabinGulfstream) && 
        ([self.largeCabinGulfstream containsObject:aircraftType]) ) {
        return YES;
    } else {
        return NO;
    }
}

@end
