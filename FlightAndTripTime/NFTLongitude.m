//
//  NFTLongitude.m
//  FlightAndTripTime
//
//  ported from com.netjets.common.latlong.Longitude.java found in Netjets-Common
//
//  Created by Ken Gregory on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFTLongitude.h"

@implementation NFTLongitude


static char NFT_POSITIVE_DECLINATION = 'E';
static char NFT_NEGATIVE_DECLINATION = 'W';
static char NFT_EAST_DECLINATION = 'E';
const char NFT_WEST_DECLINATION = 'W';

#pragma mark initialization
- (id)init
{
    self = [super init];
    if (self) {
        
        self.declination=NFT_POSITIVE_DECLINATION;
    }
    
    return self;
}

- (id) initWithSeconds:(double) secs 
{
    self=[super initWithSeconds:fabs(secs) declination:(secs < 0 ? [super getNegativeDeclination] : [super getPositiveDeclination])];
    if(self){
       [self setDeclination:(secs < 0 ? [self getNegativeDeclination] : [self getPositiveDeclination])];
    }
    return self;
}


- (id) initWithSeconds:(double)secs declination:(char)decl
{
    self=[super initWithSeconds:secs declination:(decl == NFT_EAST_DECLINATION ? [super getNegativeDeclination] : [super getPositiveDeclination])];
    if(self){
        [self setDeclination:(decl != NFT_EAST_DECLINATION ? [self getNegativeDeclination] : [self getPositiveDeclination])];  
    }
    return self;
}


//- (id) initWithLatitude(double degrees, double minutes, double seconds, char declination)
- (id)initWithDegrees:(double)deg 
           minutes:(double)min 
           seconds:(double)secs 
       declination:(char) dec
{
    self=[super initWithDegrees:(double)deg 
                     minutes:(double)min 
                     seconds:(double)secs 
                 declination:(char) dec];
    if(self){
        
    }
    return self;
}

- (double) toDegrees
{
    double baseDegrees = [super toDegrees];
    
    if ([self declination]==NFT_POSITIVE_DECLINATION &&
        baseDegrees < 0.0)
    {
        baseDegrees = baseDegrees * -1.0;
    }
    
    return baseDegrees;
}

- (double) toMinutes
{
    return ([self declination]==NFT_POSITIVE_DECLINATION ? 1.0 : -1.0)*abs([super toMinutes]);
}
- (double) toSeconds
{
 return ([self declination]==NFT_POSITIVE_DECLINATION ? 1.0 : -1.0)*abs([super toSeconds]);   
}



//
//This cannot be static because these methods are overridden in Lattitude and Longitude.
- (char) getPositiveDeclination
{
    return NFT_POSITIVE_DECLINATION;
}

//
//This cannot be static because these methods are overridden in Lattitude and Longitude.
- (char) getNegativeDeclination
{
    return NFT_NEGATIVE_DECLINATION;
}


@end
