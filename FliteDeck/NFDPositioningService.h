//
//  NFDPositioningService.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDPersistenceService.h"

@interface NFDPositioningService : NFDPersistenceService
- (NSArray*) getCompetitorNames : (NSString *) criteria;
- (NSArray*) getManufacturers : (NSString *) criteria;
- (NSArray*) getPositioningEntity : (NSString *) criteria type:(NSString *) type;
- (NSArray*) getAircraftForCompany : (NSString *) company size: (NSString *) size;
@end
