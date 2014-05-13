//
//  NFDFlightTrackerManager.m
//  FliteDeck
//
//  Created by Jeff Bailey on 11/21/13.
//
//

#import "NFDFlightTrackerManager.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "NFDFlightTrackingManager.h"
#import "NFDPersistenceManager.h"
#import "NCLFramework.h"
#import "NFDFlightTrackingSabreXMLDelegate.h"
#import "NFDUserManager.h"
#import "NFDNetJetsRemoteService.h"
#import "UIColor+FliteDeckColors.h"
#import "NFDAircraftTypeService.h"
#import "NFDCaseGroup.h"
#import "NFDCase.h"

#define FLIGHTS_DID_RECEIVE_NEW_RESULTS @"FLIGHTS_DID_RECEIVE_NEW_RESULTS"
#define TRACKING_DID_RECEIVE_NEW_RESULTS @"TRACKING_DID_RECEIVE_NEW_RESULTS"
#define SEARCHING_FOR_RESULTS @"SEARCHING_FOR_RESULTS"

@interface NFDFlightTrackerManager () 

@property (nonatomic, strong) NSDateFormatter *shortDateFormatter;

@end

@implementation NFDFlightTrackerManager

@synthesize flights = _flights;
@synthesize flightsLastUpdated;
@synthesize flightsErrorMessage;
@synthesize tails;
@synthesize tailsLastUpdated;
@synthesize tailsErrorMessage;
@synthesize largeCabinGulfstream;

NSTimer *trackingTimer;

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _shortDateFormatter = [[NSDateFormatter alloc] init];
        [_shortDateFormatter setDateStyle:NSDateFormatterShortStyle];
        
        [self setTails:[NSMutableDictionary dictionary]];
        [self setFlightsErrorMessage:@"Welcome to Flight Tracking."];
        [self setTailsErrorMessage:@"Welcome to Flight Tracking."];
        [self setLargeCabinGulfstream:
         [NSSet setWithObjects:@"GIV-SP", @"G-400", @"G-450", @"G-550", @"GV", nil]];
        
        _didSearchForFerryFlights = NO;
        _fetchedCases = [NSMutableDictionary new];
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

#pragma mark - Flights: IJet2 Service Calls

- (void)addQueryDates:(NSMutableDictionary *)queryParams startDate:(NSString *)startDate endDate:(NSString *)endDate
{
    if (startDate &&
        (!endDate || [endDate isEmptyOrWhitespace] || [startDate isEqualToString:endDate])) {
        [queryParams setObject:[self.shortDateFormatter dateFromString:startDate] forKey:@"date"];
    } else if (startDate && endDate) {
        [queryParams setObject:[self.shortDateFormatter dateFromString:startDate] forKey:@"startDate"];
        [queryParams setObject:[self.shortDateFormatter dateFromString:endDate] forKey:@"endDate"];
    }
}

- (void)findFlightsByAccount:(NSString*)accountID accountName:(NSString *) accountName startDate:(NSString*)startDate endDate:(NSString *)endDate maxResults:(NSNumber *) maxResults
{
    self.flightsSearchType = NFDTrackerSearchTypeAccountSearch;
    self.searchDescription = accountName;
    
    if (startDate) {
        self.searchDetailDescription = [self formatDatesForStartDate:startDate andEndDate:endDate];
    } else {
        self.searchDetailDescription = [NSString stringWithFormat:@"Last %@ flights", maxResults];
    }

    // setup the query parameters
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] initWithCapacity:3];
    [queryParams setObject:accountID forKey:@"account"];
    
    [self addQueryDates:queryParams startDate:startDate endDate: endDate];
    
    if (maxResults) {
        [queryParams setObject:[maxResults stringValue] forKey:@"resultCnt"];
    }
    
    // execute search
    [self findFlightsWithQueryParams:queryParams];
}

- (void)findFlightsBySVP:(NSString*)svpEmail startDate:(NSString*)startDate endDate:(NSString *)endDate
{
    self.flightsSearchType = NFDTrackerSearchTypeSVPSearch;

    self.searchDescription = svpEmail;
    self.searchDetailDescription = [self formatDatesForStartDate:startDate andEndDate:endDate];

    // setup the query parameters
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] initWithCapacity:2];
    [queryParams setObject:svpEmail forKey:@"emailAddress"];
    
    [self addQueryDates:queryParams startDate:startDate endDate: endDate];
    
    // execute search
    [self findFlightsWithQueryParams:queryParams];
}

- (void)findFlightsByAirportId:(NSString*)airportId startDate:(NSString*)startDate endDate:(NSString *)endDate onlyFerryFlights:(BOOL)onlyFerryFlights
{
    self.flightsSearchType = NFDTrackerSearchTypeAirportSearch;
    self.searchDescription = airportId;
    self.searchDetailDescription = [self formatDatesForStartDate:startDate andEndDate:endDate];
    
    // setup the query parameters
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] initWithCapacity:3];
    [queryParams setObject:airportId forKey:@"location"];
    
    [self addQueryDates:queryParams startDate:startDate endDate: endDate];
    
    if (onlyFerryFlights) {
        self.didSearchForFerryFlights = YES;
        [queryParams setObject:@"3" forKey:@"flightTypeCd"];
    } else {
        self.didSearchForFerryFlights = NO;
    }
    
    // execute search
    [self findFlightsWithQueryParams:queryParams];
}

- (void)findFlightsByTailNumber:(NSString*)tailNbr startDate:(NSString*)startDate endDate:(NSString *)endDate
{
    self.flightsSearchType = NFDTrackerSearchTypeTailSearch;

    self.searchDescription = tailNbr;
    self.searchDetailDescription = [self formatDatesForStartDate:startDate andEndDate:endDate];

    // setup the query parameters
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] initWithCapacity:2];
    [queryParams setObject:tailNbr forKey:@"tailNumber"];
    
    [self addQueryDates:queryParams startDate:startDate endDate: endDate];
    
    // execute search
    [self findFlightsWithQueryParams:queryParams];
}

- (void)findCasesWithURL:(NSString *)path
{
    NCLURLRequest *request = [[NCLURLRequest alloc] initWithURL:[NSURL URLWithString:path]];

    request.shouldPresentAlertOnError = NO;
    request.timeoutInterval = 45.0;
    request.user = [[NFDNetJetsRemoteService sharedInstance] user];
    
    [[NFDNetJetsRemoteService sharedInstance] sendHttpRequest:request
                                withBackgroundProcessingBlock:^(NSData *data, NSError *error)
     {
         NSString *originalPath = path;
         
         if (error)
         {
             if (error.code == NSURLErrorTimedOut) {
                 [self setFlightsErrorMessage:@"Search Time Exceeded"];
             } else {
                 [self setFlightsErrorMessage:@"Service Not Available"];
             }
             
            [self performSelectorOnMainThread:@selector(postErrorFetchingCasesNotification) withObject:nil waitUntilDone:NO];
         }
         else
         {
             NSError *jsonError = nil;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
             
             NSDictionary *jsonDict = [json objectForKey:@"cases"];
             
             NSArray *cases = [jsonDict objectForKey:@"recentControllableCases"];
             NSDictionary *caseSummary = [jsonDict objectForKey:@"caseSummary"];
             NSNumber *controllableCountTemp = [caseSummary objectForKey:CONTROLLABLE_CASES_COUNT_KEY];
             NSNumber *openCountTemp = [caseSummary objectForKey:OPEN_CASES_COUNT_KEY];
             NSNumber *totalCountTemp = [caseSummary objectForKey:TOTAL_CASES_COUNT_KEY];
             
             NSString *controllableCount = controllableCountTemp.stringValue;
             NSString *openCount = openCountTemp.stringValue;
             NSString *totalCount = totalCountTemp.stringValue;
             NSString *totalRecentCasesCount = [NSString stringWithFormat:@"%i", cases.count];
             
             NSMutableArray *caseGroups = [NSMutableArray new];
             NSMutableArray *caseOrder = [NSMutableArray new];
             
             if (([cases isKindOfClass:[NSArray class]]) && ([cases count] > 0)) {
                 
                 NSMutableDictionary *caseGroupDict = [NSMutableDictionary new];
                 
                 for (NSDictionary *caseDictionary in cases) {
                     NSNumber *legIDTemp = [caseDictionary objectForKey:@"legId"];
                     NSString *legID = [self checkStringForNull:[legIDTemp stringValue]];
                     
                     NFDCaseGroup *caseGroup;
                     
                     if ([caseGroupDict objectForKey:legID]) {
                         caseGroup = [caseGroupDict objectForKey:legID];
                     } else {
                         caseGroup = [self caseGroupForDictionary:caseDictionary];
                         caseGroup.legID = legID;
                         
                         // Newest cases first
                         [caseOrder insertObject:legID atIndex:0];
                     }
                     
                     NFDCase *newCase = [self caseForDictionary:caseDictionary];
                     
                     [caseGroup.cases addObject:newCase];
                     
                     [caseGroupDict setObject:caseGroup forKey:legID];
                 }
                 
                 for (NSString *caseKey in caseOrder) {
                     NFDCaseGroup *cg = [caseGroupDict objectForKey:caseKey];
                     [caseGroups addObject:cg];
                 }
             }
             
             NSDictionary *userInfo = @{ACCOUNT_CASES_KEY:caseGroups, CONTROLLABLE_CASES_COUNT_KEY:controllableCount, OPEN_CASES_COUNT_KEY:openCount, TOTAL_CASES_COUNT_KEY:totalCount, TOTAL_RECENT_CASES_COUNT_KEY:totalRecentCasesCount, ACCOUNT_CASES_DETAIL_REF:originalPath};
             
             [self.fetchedCases setObject:userInfo forKey:originalPath];
             
             [self performSelectorOnMainThread:@selector(postDidReceiveAccountCasesNotification:) withObject:userInfo waitUntilDone:NO];
         }
     }];
}

- (NFDCaseGroup *)caseGroupForDictionary:(NSDictionary *)caseDictionary
{
    NFDCaseGroup *caseGroup = [NFDCaseGroup new];
    caseGroup.leadPax = [self checkStringForNull:[caseDictionary objectForKey:@"leadPax"]];
    caseGroup.tail = [self checkStringForNull:[caseDictionary objectForKey:@"tailNumber"]];
    caseGroup.departureFBO = [self checkStringForNull:[caseDictionary objectForKey:@"departureAirport"]];
    caseGroup.departureDate = [NSDate dateFromISOString:[caseDictionary objectForKey:@"departureDate"]];
    caseGroup.arrivalFBO = [self checkStringForNull:[caseDictionary objectForKey:@"arrivalAirport"]];
    caseGroup.arrivalDate = [NSDate dateFromISOString:[caseDictionary objectForKey:@"arrivalDate"]];
    caseGroup.tail = [self checkStringForNull:[caseDictionary objectForKey:@"tailNumber"]];

    return caseGroup;
}

- (NFDCase *)caseForDictionary:(NSDictionary *)caseDictionary
{
    NFDCase *newCase = [NFDCase new];
    newCase.type = [self checkStringForNull:[caseDictionary objectForKey:@"type"]];
    newCase.category = [self checkStringForNull:[caseDictionary objectForKey:@"category"]];
    newCase.details = [self checkStringForNull:[caseDictionary objectForKey:@"details"]];
    newCase.description = [self checkStringForNull:[caseDictionary objectForKey:@"caseDescription"]];
    newCase.resolution = [self checkStringForNull:[caseDictionary objectForKey:@"caseResolution"]];
    newCase.ownerImpacts = [caseDictionary objectForKey:@"ownerImpacts"];
    NSNumber *requestNumberTemp = [caseDictionary objectForKey:@"requestNumber"];
    newCase.requestNumber = [self checkStringForNull:[requestNumberTemp stringValue]];
    newCase.status = [NSNumber numberFromObject:[caseDictionary objectForKey:@"open"]];
    
    return newCase;
}

- (void)removeFetchedCasesForURL:(NSString *)url
{
    [self.fetchedCases removeObjectForKey:url];
}

- (void)postDidReceiveAccountCasesNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_RECEIVE_ACCOUNT_CASES object:self userInfo:userInfo];
}

- (void)postErrorFetchingCasesNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_FETCHING_ACCOUNT_CASES object:self];
}

- (void)findFlightsWithQueryParams:(NSDictionary*)queryParams
{    
    // clean results array and notify app of pending search
    self.flights = [[NSArray alloc] init];
    self.fetchedCases = [NSMutableDictionary new];
    [[NSNotificationCenter defaultCenter] postNotificationName:[self searchingDidReceiveNewResultsNotificatioName] object:nil];
    
    // process remote http request in background
    NSString *path = [[NFDNetJetsRemoteService sharedInstance] buildPath:TRACKER_LEGS_URL];
    NCLURLRequest *request = [[NFDNetJetsRemoteService sharedInstance] urlRequestWithPath: path queryParams:queryParams];
    request.notificationName = [self flightsDidReceiveNewResultsNotificatioName];
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
                             flight.companyName = [self checkStringForNull:[leg objectForKey:@"company-name"]];
                             flight.contractType = [self checkStringForNull:[leg objectForKey:@"contract-type"]];
                             flight.contractStatus = [self checkStringForNull:[leg objectForKey:@"contract-status"]];
                             NSNumber *tempShareSize = [leg objectForKey:@"share-size"];
                             flight.contractShareSize = [self checkStringForNull:[tempShareSize stringValue]];
                             NSNumber *tempCardHours = [leg objectForKey:@"card-hours"];
                             flight.contractCardHours = [self checkStringForNull:[tempCardHours stringValue]];
                             flight.contractFlightRule = [self checkStringForNull:[leg objectForKey:@"flight-rule"]];
                             flight.customerSinceDate = [NSDate dateFromISOString:[leg objectForKey:@"customer-since-date"]];
                             flight.contractStartDate = [NSDate dateFromISOString:[leg objectForKey:@"contract-start-date"]];
                             flight.contractEndDate = [NSDate dateFromISOString:[leg objectForKey:@"contract-end-date"]];
                             flight.contractCurrentYearStartDate = [NSDate dateFromISOString:[leg objectForKey:@"contract-current-year-start-date"]];
                             flight.contractCurrentYearEndDate = [NSDate dateFromISOString:[leg objectForKey:@"contract-current-year-end-date"]];
                             flight.allottedRemainingHours = [NSString stringFromObject:[leg objectForKey: @"allotted-remaining-hours"]];
                             flight.availableRemainingHours = [NSString stringFromObject:[leg objectForKey:@"available-remaining-hours"]];
                             flight.tollFreeNumber = [self checkStringForNull:[leg objectForKey:@"toll-free-number"]];
                             flight.productDeliveryTeamName = [self checkStringForNull:[leg objectForKey:@"product-delivery-team-name"]];
                             
                             // Cases
                             NSDictionary *caseDetails = [leg objectForKey:@"case-details"];
                             
                             if (caseDetails) {
                                 flight.showLegCaseCount = YES;
                             } else {
                                 flight.showLegCaseCount = NO;
                             }
                             
                             flight.accountCaseDetailsRef = [caseDetails objectForKey:@"account-case-details-ref"];
                             
                             NSNumber *tempLegTotalCount = [caseDetails objectForKey:@"leg-total"];
                             flight.legTotalCount = [self checkStringForNull:[tempLegTotalCount stringValue]];
                             
                             NSNumber *tempLegOpenCount = [caseDetails objectForKey:@"leg-open"];
                             flight.legOpenCount = [self checkStringForNull:[tempLegOpenCount stringValue]];
                             
                             if ([tempLegTotalCount integerValue] > 0) {
                                 NSArray *legCases = [caseDetails objectForKey:@"leg-cases"];
                                 NSDictionary *firstCase = [legCases objectAtIndex:0];
                                 
                                 NFDCaseGroup *caseGroup = [self caseGroupForDictionary:firstCase];
                                 caseGroup.accountName = flight.accountName;
                                 
                                 for (NSDictionary *caseDictionary in legCases) {
                                     NFDCase *newCase = [self caseForDictionary:caseDictionary];
                                     
                                     [caseGroup.cases addObject:newCase];
                                 }
                                 
                                 flight.flightCaseGroups = [NSArray arrayWithObject:caseGroup];
                             }
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
                             
                             NSManagedObjectContext *privateMOC = [[NFDPersistenceManager sharedInstance] privateMOC];
                             NFDAircraftTypeService *aircraftTypeService = [NFDAircraftTypeService new];
                             
                             flight.aircraftDisplayNameGuaranteed = [aircraftTypeService displayNameForTypeName:flight.aircraftTypeGuaranteed moc: privateMOC];
                             
                             flight.aircraftTypeDisplayNameRequested = [aircraftTypeService displayNameForTypeName:flight.aircraftTypeRequested moc: privateMOC];
                             
                             flight.aircraftTypeDisplayNameActual = [aircraftTypeService displayNameForTypeName:flight.aircraftTypeActual moc: privateMOC];
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
                 [self sortFlightsBy:NFDTrackerSortByDepartureTime];
                 self.flightsLastUpdated = [NSDate date];
             }else{
                 [self setFlightsErrorMessage:@"No results available."];
             }
         }
     }];
}

#pragma mark - Flights: Manage Array of Flights returned by iJet2 Service Call

- (void)sortFlightsBy:(NFDTrackerSortBy)sortMethod{
    NSArray *sortedArray;
    switch (sortMethod) {
        case NFDTrackerSortByAccount:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSString *first = [(NFDFlight*)a accountName];
                NSString *second = [(NFDFlight*)b accountName];
                return [first compare:second];
            }];
            break;
        }
        case NFDTrackerSortByTail:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSString *first = [(NFDFlight*)a tailNumber];
                NSString *second = [(NFDFlight*)b tailNumber];
                return [first compare:second];
            }];
            break;
        }
        case NFDTrackerSortByArrivalTime:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSNumber *first = [NSNumber numberWithDouble:[[(NFDFlight*)a arrivalTimeEstimated] timeIntervalSince1970]];
                NSNumber *second = [NSNumber numberWithDouble:[[(NFDFlight*)b arrivalTimeEstimated] timeIntervalSince1970]];
                return [first compare:second];
            }];
            break;
        }
        case NFDTrackerSortByDepartureTime:{
            sortedArray = [self.flights sortedArrayUsingComparator:^(id a, id b) {
                NSNumber *first = [NSNumber numberWithDouble:[[(NFDFlight*)a departureTimeEstimated] timeIntervalSince1970]];
                NSNumber *second = [NSNumber numberWithDouble:[[(NFDFlight*)b departureTimeEstimated] timeIntervalSince1970]];
                return [first compare:second];
            }];
            break;
        }
        case NFDTrackerSortBySVP:{
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
    self.flightsSortedBy = sortMethod;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:[self trackingDidReceiveNewResultsNotificatioName] object:nil];
    }else{
        [self errorSabreData];
    }
}

-(void)errorSabreData{
    self.tailsLastUpdated = nil;
    [self setTailsErrorMessage:@"No results available."];
    [[NSNotificationCenter defaultCenter] postNotificationName:[self trackingDidReceiveNewResultsNotificatioName] object:nil];
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

- (NSString *) formatDatesForStartDate:(NSString *) startDate andEndDate:(NSString *)endDate
{
    NSString *result = nil;
    
    if (endDate && ![endDate isEmptyOrWhitespace]) {
        result = [NSString stringWithFormat:@"%@-%@", startDate, endDate];
    } else {
        result = startDate;
    }
    
    return result;
}

- (NSString *) flightsDidReceiveNewResultsNotificatioName
{
    return  [NSString stringWithFormat:@"%@_SEARCHTYPE_%d", FLIGHTS_DID_RECEIVE_NEW_RESULTS, self.flightsSearchType];
}

- (NSString *) trackingDidReceiveNewResultsNotificatioName
{
    return  [NSString stringWithFormat:@"%@_SEARCHTYPE_%d", TRACKING_DID_RECEIVE_NEW_RESULTS, self.flightsSearchType];
}

- (NSString *) searchingDidReceiveNewResultsNotificatioName
{
    return  [NSString stringWithFormat:@"%@_SEARCHTYPE_%d", SEARCHING_FOR_RESULTS, self.flightsSearchType];
}

@end
