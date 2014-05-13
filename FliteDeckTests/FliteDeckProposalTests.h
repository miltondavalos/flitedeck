//
//  FliteDeckProposalTests.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.


#import <SenTestingKit/SenTestingKit.h>
#import "NFDProposalCalculatorService.h"
#import "NFDAircraftTypeProposalService.h"

@interface FliteDeckProposalTests : SenTestCase
@property (nonatomic, strong) NFDProposalCalculatorService *serviceProposal;
@property (nonatomic, strong) NFDAircraftTypeProposalService *serviceAircraft;
@end
