//
//  NFTLongitude.h
//  FlightAndTripTime
//
//  Created by Ken Gregory on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFTDegMinSecDec.h"

@interface NFTLongitude : NFTDegMinSecDec


- (id) initWithSeconds:(double) secs;

- (id) initWithSeconds:(double)secs 
           declination:(char)decl;

- (id)initWithDegrees:(double)deg 
              minutes:(double)min 
              seconds:(double)secs 
          declination:(char) dec;

- (char) getPositiveDeclination;

- (char) getNegativeDeclination;

- (double) toDegrees;
- (double) toMinutes;
- (double) toSeconds;


@end
