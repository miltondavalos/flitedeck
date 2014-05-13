//
//  NFTLatitude.m
//  FlightAndTripTime
//
//  ported from com.netjets.common.latlong.Latitude.java found in Netjets-Common
//
//  Created by Ken Gregory on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFTLatitude.h"



@implementation NFTLatitude

static char NFT_POSITIVE_DECLINATION = 'N';
static char NFT_NEGATIVE_DECLINATION = 'S';
static char NFT_NORTH_DECLINATION = 'N';
//static char NFT_SOUTH_DECLINATION = 'S';

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
    self=[super initWithSeconds:secs declination:(decl == NFT_NORTH_DECLINATION ? [super getNegativeDeclination] : [super getPositiveDeclination])];
    if(self){
      [self setDeclination:(decl != NFT_NORTH_DECLINATION ? [self getNegativeDeclination] : [self getPositiveDeclination])];  
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


@end
