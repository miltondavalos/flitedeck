//
//  NFDFlightData.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFDFlightData : NSObject {
    NSString *Response;
    NSString *Status;
    NSString *Origin;
    NSString *Destination;
    NSString *Speed;
    NSString *Altitude;
    NSString *AircraftType;
    NSString *Lat;
    NSString *Lon;
    NSString *Distance;
    NSString *Bearing;
    NSString *EDT;
    NSString *ETA;
    NSString *PDT;
    NSString *PTA;
    NSString *AircraftName;
    NSString *AirlineName;
}

@property(nonatomic, strong) NSString *Response;
@property(nonatomic, strong) NSString *Status;
@property(nonatomic, strong) NSString *Origin;
@property(nonatomic, strong) NSString *Destination;
@property(nonatomic, strong) NSString *Speed;
@property(nonatomic, strong) NSString *Altitude;
@property(nonatomic, strong) NSString *AircraftType;
@property(nonatomic, strong) NSString *Lat;
@property(nonatomic, strong) NSString *Lon;
@property(nonatomic, strong) NSString *Distance;
@property(nonatomic, strong) NSString *Bearing;
@property(nonatomic, strong) NSString *EDT;
@property(nonatomic, strong) NSString *ETA;
@property(nonatomic, strong) NSString *PDT;
@property(nonatomic, strong) NSString *PTA;
@property(nonatomic, strong) NSString *AircraftName;
@property(nonatomic, strong) NSString *AirlineName;

@end
