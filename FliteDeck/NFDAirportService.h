//
//  NFDAirportService.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/13/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDPersistenceService.h"
#import "NFDFBOAddress.h"
#import "NFDFBOPhone.h"
#import "NCLFramework.h"

@interface NFDAirportService : NFDPersistenceService

- (NSArray *) getFBOs: (NSString *) airportCode;
- (NSSet *) getFBOAddress: (NSNumber *) fbo_id;
- (NSSet *) getFBOPhone: (NSNumber *) fbo_id;
- (NFDAirport *) findAirportWithCode: (NSString *) airportCode;
- (NSArray *) queryAirports : (NSString *) criteria;

@end
