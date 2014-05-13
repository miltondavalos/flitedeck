//
//  NFDAirportSearchManager.h
//  FliteDeck
//
//  Created by Chad Predovich on 11/21/13.
//
//

#import <Foundation/Foundation.h>

#define AIRPORT_SEARCH_DID_FINISH_NOTIFICATION @"AirportSearchDidCompleteNotification"
#define AIRPORT_SEARCH_TEXT_NOTIFICATION_KEY @"AirportSearchTextNotificationKey"
#define AIRPORT_SEARCH_RESULTS_NOTIFICATION_KEY @"AirportSearchResultsNotificationKey"
#define AIRPORTS_UPDATED_NOTIFICATION @"AirportsUpdatedNotification"

@interface NFDAirportSearchManager : NSObject

@property (nonatomic, strong) NSArray *airports;
@property (nonatomic, strong) NSString *searchFieldText;

- (void)convertCodesToAirports;
- (void)clearAirportCodes;
- (void)addAirportCode:(NSString *)airportCode;
- (void)findAirports:(NSString*)searchText;

@end
