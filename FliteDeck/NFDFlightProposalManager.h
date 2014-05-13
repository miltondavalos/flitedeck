//
//  NFDFlightProposalManager.h
//  ProposalCalculatorPrototype
//
//  Created by Geoffrey Goetz on 3/7/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDProposal.h"

//Triggered when adding or removing proposlas to master view...
#define PROPOSAL_LIST_UPDATED @"PROPOSAL_LIST_UPDATED"
#define PROPOSAL_SELECTION_UPDATED @"PROPOSAL_SELECTION_UPDATED"
#define PROPOSAL_SUBTITLE_UPDATED @"PROPOSAL_SUBTITLE_UPDATED"
#define PROPOSAL_RESULTS_UPDATED @"PROPOSAL_RESULTS_UPDATED"
#define PROPOSAL_PARAMETERS_UPDATED @"PROPOSAL_PARAMETERS_UPDATED"

//Used to identify the product selected...
#define SHARE_FINANCE_PRODUCT 1
#define SHARE_PURCHASE_PRODUCT 2
#define SHARE_LEASE_PRODUCT 3
#define CARD_PRODUCT 4
#define COMBO_CARD_PRODUCT 5
#define PHENOM_TRANSITION_LEASE_PRODUCT 6
#define PHENOM_TRANSITION_PURCHASE_PRODUCT 7

//Used to identify the product type selected...
#define SHARE_PRODUCT_TYPE 1
#define CARD_PRODUCT_TYPE 2
#define PHENOM_TRANSITION_PRODUCT_TYPE 3

#define MAX_SELECTED_PROPOSALS 4

@protocol NFDProposalParameterUpdater
- (void)updateProposalParameterData;
@end

@protocol NFDProposalResultUpdater
- (void)updateProposalResultData;
@end

@interface NFDFlightProposalManager : NSObject{
    NSMutableArray *proposals;
    NSMutableDictionary *selectedProposals;
}

@property(nonatomic, strong) NSMutableArray *proposals;
@property(nonatomic, strong) NSMutableDictionary *selectedProposals;
@property (readwrite, assign) BOOL aggregated;

+ (id)sharedInstance;

+ (NFDProposal*)createNewProposalForProduct:(int)productCode;

- (BOOL)hasProposals;
- (int)totalCountOfProposals;
- (NFDProposal*)retrieveProposalAtIndex:(int)index;

- (BOOL)includesPhenom;
- (BOOL)hasSelectedProposals;
- (int)totalCountOfSelectedProposals;
- (NFDProposal*)retrieveSelectedProposalForKey:(int)key;
- (NSArray*)retrieveAllSelectedProposals;
- (NFDProposal *)retrieveProposalWithId:(NSString *)identifier;

- (BOOL)canDispalyCompareView;
- (void)clearAllProposals;
- (void)performCalculationsForProposal:(NFDProposal*)proposal;

@end
