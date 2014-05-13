//
//  NFDFlightTrackerManager.h
//  FliteDeck
//
//  Created by Jeff Bailey on 11/21/13.
//
//

#import <Foundation/Foundation.h>

#import "NFDFlight.h"
#import "NFDPassenger.h"
#import "NFDAirport.h"
#import "NFDFlightData.h"

#define DID_RECEIVE_ACCOUNT_CASES @"didReceiveAccountCases"
#define ERROR_FETCHING_ACCOUNT_CASES @"errorFetchingAccountCases"
#define ACCOUNT_CASES_KEY @"accountCases"
#define CONTROLLABLE_CASES_COUNT_KEY @"controllableCount"
#define OPEN_CASES_COUNT_KEY @"openCount"
#define TOTAL_CASES_COUNT_KEY @"totalCount"
#define TOTAL_RECENT_CASES_COUNT_KEY @"recentCount"
#define ACCOUNT_CASES_DETAIL_REF @"accountCasesDetailRef"

typedef NS_ENUM(NSInteger, NFDTrackerSortBy) {
    NFDTrackerSortByDepartureTime=0,
    NFDTrackerSortByArrivalTime,
    NFDTrackerSortByTail,
    NFDTrackerSortByAccount,
    NFDTrackerSortBySVP
};

typedef NS_ENUM(NSInteger, NFDTrackerSearchType) {
    NFDTrackerSearchTypeAccountSearch=0,
    NFDTrackerSearchTypeAirportSearch,
    NFDTrackerSearchTypeSVPSearch,
    NFDTrackerSearchTypeTailSearch
};

@interface NFDFlightTrackerManager: NSObject

@property (nonatomic, strong) NSArray *flights;
@property (nonatomic) NFDTrackerSortBy flightsSortedBy;
@property (nonatomic) NFDTrackerSearchType flightsSearchType;
@property (nonatomic, strong) NSDate *flightsLastUpdated;
@property (nonatomic, strong) NSString *flightsErrorMessage;
@property (nonatomic, strong) NSMutableDictionary *tails;
@property (nonatomic, strong) NSDate *tailsLastUpdated;
@property (nonatomic, strong) NSString *tailsErrorMessage;
@property (nonatomic, strong) NSSet *largeCabinGulfstream;
@property (nonatomic, assign) BOOL didSearchForFerryFlights;
@property (nonatomic, strong) NSString *searchDescription;
@property (nonatomic, strong) NSString *searchDetailDescription;
@property (nonatomic, strong) NSMutableDictionary *fetchedCases;


//Flights: iJet2 Service Methods
- (void)findFlightsByAccount:(NSString*)accountID accountName:(NSString *) accountName startDate:(NSString*)startDate endDate:(NSString *)endDate maxResults:(NSNumber *) maxResults;
- (void)findFlightsByTailNumber:(NSString*)tailNbr startDate:(NSString*)startDate endDate:(NSString *)endDate;
- (void)findFlightsByAirportId:(NSString*)airportId startDate:(NSString*)startDate endDate:(NSString *)endDate onlyFerryFlights:(BOOL)onlyFerryFlights;
- (void)findFlightsBySVP:(NSString*)svpEmail startDate:(NSString*)startDate endDate:(NSString *)endDate;
- (void)sortFlightsBy:(NFDTrackerSortBy)sortMethod;
- (BOOL)hasRetrievedFlights;
- (int)totalCountOfFlights;
- (NFDFlight*)retrieveFlightAtIndex:(int)index;

- (void)findCasesWithURL:(NSString *)path;

//Tracking: Sabre Service Methods
- (void)searchTrackingByTailNumber:(NSString *)tailNumber;
- (void)stopTrackingTimer;
- (BOOL)hasTrackedTails;
- (int)totalCountOfTails;
- (NFDFlightData*)retrieveTailWithKey:(NSString*)tailnumber;

//Core Data Airport Lookup
- (NFDAirport*)findAirportByAirportId:(NSString*)airportId context:(NSManagedObjectContext*)context;

//Utility Methods
- (NSString*)convertToHoursString:(NSString*)originalHoursString;
- (NSString*)checkStringForNull:(NSString*)theString;

//Rotate Aircraft Image by Degrees
- (UIImage*)rotatedImage:(UIImage*)sourceImage byDegreesFromNorth:(double)degrees color:(UIColor *)color;

//Are Flights filed by Tail Number for an aircraft type
- (BOOL)isLargeCabinGulfstream:(NSString*)aircraftType;

- (NSString *) flightsDidReceiveNewResultsNotificatioName;
- (NSString *) trackingDidReceiveNewResultsNotificatioName;
- (NSString *) searchingDidReceiveNewResultsNotificatioName;

@end
