
#import <Foundation/Foundation.h>
#import "NFDAircraftTypeService.h"

#define FLIGHT_STATUS_NOT_FLOWN @"Not Flown"
#define FLIGHT_STATUS_IN_FLIGHT @"In Flight"
#define FLIGHT_STATUS_FLOWN @"Flown"

@interface NFDFlight : NSObject

@property(nonatomic, strong) NSString *tailNumber;
@property(nonatomic, strong) NSString *flightStatus;
@property(nonatomic, strong) NSString *flightTimeEstimated;
@property(nonatomic, strong) NSString *flightTimeActual;
@property(nonatomic, strong) NSMutableArray *passengers;
@property(nonatomic, strong) NSString *departureICAO;
@property(nonatomic, strong) NSString *departureFBO;
@property(nonatomic, strong) NSTimeZone *departureTZ;
@property(nonatomic, strong) NSDate *departureTimeEstimated;
@property(nonatomic, strong) NSDate *departureTimeActual;
@property(nonatomic, strong) NSString *arrivalICAO;
@property(nonatomic, strong) NSString *arrivalFBO;
@property(nonatomic, strong) NSTimeZone *arrivalTZ;
@property(nonatomic, strong) NSDate *arrivalTimeEstimated;
@property(nonatomic, strong) NSDate *arrivalTimeActual;
@property(nonatomic, strong) NSString *accountName;
@property(nonatomic, strong) NSString *companyName;
@property(nonatomic, strong) NSString *contractType;
@property(nonatomic, strong) NSString *contractStatus;
@property(nonatomic, strong) NSString *contractShareSize;
@property(nonatomic, strong) NSString *contractCardHours;
@property(nonatomic, strong) NSString *contractFlightRule;
@property(nonatomic, strong) NSDate *customerSinceDate;
@property(nonatomic, strong) NSDate *contractStartDate;
@property(nonatomic, strong) NSDate *contractEndDate;
@property(nonatomic, strong) NSDate *contractCurrentYearStartDate;
@property(nonatomic, strong) NSDate *contractCurrentYearEndDate;
@property(nonatomic, strong) NSString *allottedRemainingHours;
@property(nonatomic, strong) NSString *availableRemainingHours;
@property(nonatomic, strong) NSString *svpName;
@property(nonatomic, strong) NSString *aircraftTypeGuaranteed;
@property(nonatomic, strong) NSString *aircraftDisplayNameGuaranteed;
@property(nonatomic, strong) NSString *aircraftTypeContract;
@property(nonatomic, strong) NSString *aircraftTypeRequested;
@property(nonatomic, strong) NSString *aircraftTypeActual;
@property(nonatomic, strong) NSString *aircraftTypeDisplayNameRequested;
@property(nonatomic, strong) NSString *aircraftTypeDisplayNameActual;
@property(nonatomic, strong) NSString *tollFreeNumber;
@property(nonatomic, strong) NSString *productDeliveryTeamName;
@property(nonatomic, strong) NSNumber *ferryFlight;
@property(nonatomic, strong) NSNumber *flightTypeCode;

//Cases
@property(nonatomic) BOOL showLegCaseCount;
@property(nonatomic, strong) NSString *legOpenCount;
@property(nonatomic, strong) NSString *legTotalCount;

@property(nonatomic, strong) NSString *accountTotalCount;
@property(nonatomic, strong) NSString *accountOpenCount;
@property(nonatomic, strong) NSString *accountControllableCount;
@property(nonatomic, strong) NSString *accountControllableRecentCount;

@property(nonatomic, strong) NSString *accountCaseDetailsRef;

@property(nonatomic, strong) NSArray *accountCaseGroups;
@property(nonatomic, strong) NSArray *flightCaseGroups;

@property(nonatomic) NFDAircraftTypeComparisionResult aircraftTypeComparision;

- (BOOL) isUpgradedFlight;
- (BOOL) isDowngradedFlight;

- (BOOL) hasYellowAlert;
- (BOOL) hasGreenAlert;

- (BOOL) allottedRemainingHoursAreNegative;
- (BOOL) availableRemainingHoursAreNegative;

- (BOOL) flightInAirOrFlown;

- (BOOL) hasPassengers;

- (BOOL) hasRecentAccountCases;
- (BOOL) hasLegCases;
- (BOOL) hasOpenLegCases;

@end
