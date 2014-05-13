//
//  NFTDegMinSecDec.h
//  FlightAndTripTime
//
//  Created by Ken Gregory on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NFTDegMinSecDec : NSObject

@property (nonatomic) double degrees;
@property (nonatomic) double minutes;
@property (nonatomic) double seconds;
@property (nonatomic) char declination;


- (id)initWithDegrees:(double)deg 
              minutes:(double)min 
              seconds:(double)secs 
          declination:(char) dec;

- (id)initWithSeconds:(double) secs 
          declination:(char) decl;

- (double) toDegrees;
- (double) toMinutes;
- (double) toSeconds;
- (char) getPositiveDeclination;
- (char) getNegativeDeclination;
@end
