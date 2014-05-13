//
//  NFDAirportSearchManager.m
//  FliteDeck
//
//  Created by Chad Predovich on 11/21/13.
//
//

#import "NFDAirportSearchManager.h"
#import "NFDPersistenceManager.h"
#import "NFDAirportService.h"

#define MAX_RECENT_SEARCHES 20

@interface NFDAirportSearchManager () {
    dispatch_queue_t searchQueue;
}
@property (nonatomic, strong) NSString *path;
@property (readonly) NSArray *airportCodes;
@property (nonatomic, strong) NSMutableArray *recentAirportSearches;
@end

@implementation NFDAirportSearchManager

- (id)init
{
    self = [super init];
    if (self) {
        _path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _path = [_path stringByAppendingPathComponent:@"FliteDeck-AirportSearches.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:_path]) {
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"FliteDeck-AirportSearches" ofType:@"plist"];
            [fileManager copyItemAtPath:sourcePath toPath:_path error:nil];
        }
        
        searchQueue = dispatch_queue_create("com.netjets.airportsearch", 0);
    }
    
    return self;
}

- (NSArray *)airports
{
    if ((_airports.count > 0) ||
        (_airports.count == 0 && self.searchFieldText.length > 0))
    {
        return _airports;
    }
    
    return self.recentAirportSearches;
}

- (NSArray *)airportCodes
{
    return [[NSArray alloc] initWithContentsOfFile:self.path];
}

- (void)convertCodesToAirports
{
    NSMutableArray *newAirports = [NSMutableArray array];
    
    NFDAirportService *airportService = [NFDAirportService new];
    
    for (NSString *code in self.airportCodes) {
        NFDAirport *airport = [airportService findAirportWithCode:code];
        
        if (airport) {
            [newAirports addObject:airport];
        }
    }
    
    self.recentAirportSearches = newAirports;
}

- (void)addAirportCode:(NSString *)airportCode
{
    NSMutableArray *newAirports = [NSMutableArray arrayWithObject:airportCode];
    
    NSMutableArray *codes = [NSMutableArray arrayWithArray:self.airportCodes];
    
    [codes removeObject:airportCode];
    
    [newAirports addObjectsFromArray:codes];
    
    if (newAirports.count > MAX_RECENT_SEARCHES) {
        newAirports = [NSMutableArray arrayWithArray:[newAirports subarrayWithRange:NSMakeRange(0, MAX_RECENT_SEARCHES)]];
    }
    
    [newAirports writeToFile:self.path atomically:YES];
    
    [self convertCodesToAirports];
}

- (void)clearAirportCodes
{
    [[NSArray array] writeToFile:self.path atomically:YES];
}

- (void)findAirports:(NSString*)searchText
{
    dispatch_async(searchQueue, ^
       {
           NSArray *searchResults;
           
           // if no text exists, no need to search
           if (searchText.length <= 1)
           {
               searchResults = [[NSArray alloc] init];
           }
           
           // else... find the airports for the given search string
           else
           {
               NSString *partialPredicate = @"(airportid CONTAINS[cd] %@) OR (iata_cd CONTAINS[cd] %@)";
               NSString *fullPredicate = @"(airportid CONTAINS[cd] %@) OR (iata_cd CONTAINS[cd] %@) OR (airport_name CONTAINS[cd] %@) OR (city_name CONTAINS[cd] %@)";
               NSPredicate *predicate = nil;
               
               if (searchText.length > 2)
               {
                   predicate = [NSPredicate predicateWithFormat:fullPredicate, searchText, searchText, searchText, searchText];
               }
               else
               {
                   predicate = [NSPredicate predicateWithFormat:partialPredicate, searchText, searchText];
               }
               
               searchResults = [NCLPersistenceUtil executeFetchRequestForEntityName:@"Airport"
                                                                          predicate:predicate
                                                                            sortKey:@"airport_name"
                                                                            context:[[NFDPersistenceManager sharedInstance] mainMOC]
                                                                              error:nil];
           }
           
           // post a notification with appropriate search result data
           NSArray *keys = [NSArray arrayWithObjects:
                            AIRPORT_SEARCH_TEXT_NOTIFICATION_KEY,
                            AIRPORT_SEARCH_RESULTS_NOTIFICATION_KEY, nil];
           NSArray *objects = [NSArray arrayWithObjects:
                               searchText,
                               searchResults, nil];
           NSDictionary *notificationData = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
           
           dispatch_async(dispatch_get_main_queue(), ^
              {
                  [[NSNotificationCenter defaultCenter] postNotificationName:AIRPORT_SEARCH_DID_FINISH_NOTIFICATION object:self userInfo:notificationData];
              });
       });
}

- (void)updateAirports:(NSNotification*)notification
{
    NSString *searchText = [[[[notification userInfo] objectForKey:AIRPORT_SEARCH_TEXT_NOTIFICATION_KEY] stringByTrimmingWhiteSpaceAndNewLines] uppercaseString];
    
    if (![searchText isEqualToString:[[self.searchFieldText stringByRemovingExtraWhiteSpace] uppercaseString]])
    {
        // do nothing - the search text has changed since this process was initiated
    }
    
    else
    {
        // update the underlying data, and then the display
        self.airports = [[notification userInfo] objectForKey:AIRPORT_SEARCH_RESULTS_NOTIFICATION_KEY];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AIRPORTS_UPDATED_NOTIFICATION object:self];
    }
}

@end
