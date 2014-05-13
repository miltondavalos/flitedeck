//
//  NFDProposal+DictionaryAdapter.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDProposalDictionaryAdapter.h"

@implementation NFDProposalDictionaryAdapter
@synthesize product,results;

-(void) setData: (NFDProposal*) proposal{
    
    uniqueIdentifier = proposal.uniqueIdentifier;
    
    productCode=proposal.productCode;;
    productType=proposal.productType;
    title=proposal.title;
    subTitle=proposal.subTitle;
    topLabel=proposal.topLabel;
    bottomLabel=proposal.bottomLabel;
    selected=proposal.selected;
    calculated =proposal.calculated;
    
    product = [[NFDProposalProduct alloc] init];
    [product setData:proposal.productParameters];
    
    results = [[NFDProposalResults alloc] init];
    [results setData:proposal.calculatedResults];
}

@end
