//
//  NFDProposal+DictionaryAdapter.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDProposal.h"
#import "NFDAircraftInventory.h"
#import "NFDProposalProduct.h"
#import "NFDProposalResults.h"

@interface NFDProposalDictionaryAdapter : NFDProposal

@property (nonatomic,strong) NFDProposalProduct *product;
@property (nonatomic,strong) NFDProposalResults *results;

-(void) setData: (NFDProposal*) proposal;

@end
