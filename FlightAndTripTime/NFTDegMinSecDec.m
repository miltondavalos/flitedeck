//
//  NFTDegMinSecDec.m
//  FlightAndTripTime
//
//  ported from com.netjets.common.latlong.DegMinSecDec found in FlightService.R1.
//
//  Created by Ken Gregory on 2/6/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFTDegMinSecDec.h"
#import "NFTMathUtil.h"


static double SECONDS_PER_MINUTE = (double)60.0;
static double MINUTES_PER_DEGREE = (double)60.0; 
static double SECONDS_PER_DEGREE = (double)60.0 * 60.0;
static double TOTAL_DEGREES = (double)360.0;

static char NFT_POSITIVE_DECLINATION = '+';
static char NFT_NEGATIVE_DECLINATION = '-';

@implementation NFTDegMinSecDec

@synthesize degrees=_degrees;
@synthesize minutes=_minutes;
@synthesize seconds=_seconds;
@synthesize declination=_declination;



#pragma mark initialization

- (id)init
{
    self = [super init];
    if (self) {
        self.declination=NFT_POSITIVE_DECLINATION;
    }
    
    return self;
}

- (id)initWithDegrees:(double)deg minutes:(double)min seconds:(double)secs declination:(char) dec
{
    self = [self init];
    if (self) {
        self.degrees=deg;
        self.minutes=min;
        self.seconds=secs;
        self.declination=dec;
    }
    return self;
}

- (id)initWithSeconds:(double) secs declination:(char) decl
{
    self = [super init];
    if (self) {
        if ((decl != NFT_POSITIVE_DECLINATION) && (decl != NFT_NEGATIVE_DECLINATION))
        {
           DLog(@"Declination was not '+' or '-'");
            return Nil;
        }
    
        if (secs < 0)
        {
            DLog(@"Seconds was less than zero.");
            return Nil;
        }
    
        secs = (int)secs;
        
        self.declination = decl;
        self.degrees = (int)(secs / SECONDS_PER_DEGREE);
        self.minutes = (int)((secs - (self.degrees * SECONDS_PER_DEGREE)) / MINUTES_PER_DEGREE);
        self.seconds = (secs - ((double)self.degrees * SECONDS_PER_DEGREE) - ((double)self.minutes * MINUTES_PER_DEGREE));
        
        self.degrees = (int)self.degrees % (int)TOTAL_DEGREES;
        
        self.minutes = ((int)self.minutes % (int)MINUTES_PER_DEGREE);

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
    double sign = (self.declination == [self getPositiveDeclination] ? 1 : -1);
   
    return (double)sign * (self.degrees + (self.minutes / MINUTES_PER_DEGREE) + (self.seconds / SECONDS_PER_DEGREE));
}


- (double) toMinutes
{
    int sign = (self.declination == [self getPositiveDeclination] ? 1.0 : -1.0);
    
    return sign * ((self.degrees * MINUTES_PER_DEGREE) + self.minutes + (self.seconds / SECONDS_PER_MINUTE));
}

- (double) toSeconds
{
    int sign = (self.declination == NFT_POSITIVE_DECLINATION ? 1.0 : -1.0);
    
    return sign * ((self.degrees * SECONDS_PER_DEGREE) + (self.minutes * MINUTES_PER_DEGREE) + self.seconds);
}

-(NSString *) description
{
    //(int)this.degrees + "d " + (int)this.minutes + "' " + MathUtil.roundDouble(this.seconds, 4) + " " + this.declination
    return [[NSString alloc] initWithFormat:@"%gd %g' %g %c",self.degrees,self.minutes,[NFTMathUtil roundDouble:self.seconds withFractionalDigits:4] ,self.declination];
}

@end
