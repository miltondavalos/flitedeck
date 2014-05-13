//
//  NFDFlightProposalPDFBlueprintManager.h
//  FliteDeck
//
//  Created by Ryan Smith on 5/3/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFDFlightProposalPDFBlueprintManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *blueprint;

+ (NFDFlightProposalPDFBlueprintManager *)sharedInstance;


@end
