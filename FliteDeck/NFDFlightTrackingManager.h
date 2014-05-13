//
//  NFDFlightTrackingManager.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDFlight.h"
#import "NFDPassenger.h"
#import "NFDAirport.h"
#import "NFDFlightData.h"

#define TRACKER_SORTBYACCOUNT 0
#define TRACKER_SORTBYTAIL 1
#define TRACKER_SORTBYDEPARTURETIME 2
#define TRACKER_SORTBYARRIVALTIME 3
#define TRACKER_SORTBYSVP 4

#define FLIGHTS_DID_RECEIVE_NEW_RESULTS @"FLIGHTS_DID_RECEIVE_NEW_RESULTS"
#define TRACKING_DID_RECEIVE_NEW_RESULTS @"TRACKING_DID_RECEIVE_NEW_RESULTS"
#define SEARCHING_FOR_RESULTS @"SEARCHING_FOR_RESULTS"

#define SEARCH_BY_SVPAE 0
#define SEARCH_BY_AIRPORT 1
#define SEARCH_BY_AIRCRAFT 2

@interface NFDFlightTrackingManager : NSObject {

    NSDate *flightsLastUpdated;
    NSString *flightsErrorMessage;
    NSMutableDictionary *tails;
    NSDate *tailsLastUpdated;
    NSString *tailsErrorMessage;

    NSDateFormatter *shortDateFormatter;
}

@property(nonatomic, strong) NSArray *flights;
@property(nonatomic, strong) NSDate *flightsLastUpdated;
@property(nonatomic, strong) NSString *flightsErrorMessage;
@property(nonatomic, strong) NSMutableDictionary *tails;
@property(nonatomic, strong) NSDate *tailsLastUpdated;
@property(nonatomic, strong) NSString *tailsErrorMessage;
@property(nonatomic, strong) NSSet *largeCabinGulfstream;

+ (id)sharedInstance;

//Flights: iJet2 Service Methods
- (NSDictionary *)searchFlightsByChoices;
- (void)findFlightsByTailNumber:(NSString*)tailNbr startDate:(NSString*)startDate endDate:(NSString *)endDate;
- (void)findFlightsByAirportId:(NSString*)airportId startDate:(NSString*)startDate endDate:(NSString *)endDate onlyFerryFlights:(BOOL)onlyFerryFlights;
- (void)findFlightsBySVP:(NSString*)svpEmail startDate:(NSString*)startDate endDate:(NSString *)endDate;
- (void)sortFlightsBy:(int)sortMethod;
- (BOOL)hasRetrievedFlights;
- (int)totalCountOfFlights;
- (NFDFlight*)retrieveFlightAtIndex:(int)index;

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


@end
