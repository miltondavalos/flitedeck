//
//  NFDFlightTrackingSabreXMLDelegate.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/17/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDFlightData.h"

@interface NFDFlightTrackingSabreXMLDelegate : NSObject <NSXMLParserDelegate>{
    NFDFlightData *flightData;
}

@property(nonatomic, strong) NFDFlightData *flightData;

@end
