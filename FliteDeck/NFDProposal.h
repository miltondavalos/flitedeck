//
//  NFDProposal.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFDProposal : NSObject{

    NSString *uniqueIdentifier;
    
    NSNumber *productCode;
    NSNumber *productType;
    NSString *title;
    NSString *subTitle;
    NSString *topLabel;
    NSString *bottomLabel;
    BOOL selected;
    BOOL calculated;
}

@property (readonly, nonatomic, copy) NSString *uniqueIdentifier;

@property(nonatomic, strong) NSNumber *productCode;
@property(nonatomic, strong) NSNumber *productType;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *subTitle;
@property(nonatomic, strong) NSString *topLabel;
@property(nonatomic, strong) NSString *bottomLabel;
@property(nonatomic, assign, getter=isSelected) BOOL selected;
@property(nonatomic, assign, getter=hasBeenCalculated) BOOL calculated;

@property (nonatomic, strong) NSMutableDictionary *productParameters;
@property (nonatomic, strong) NSMutableDictionary *calculatedResults;

@property (nonatomic, strong) NFDProposal *relatedProposal;

- (NSString *)description;
- (NSDictionary *)unifiedDictionary;

@end
