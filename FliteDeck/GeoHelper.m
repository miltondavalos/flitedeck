//
//  GeoHelper.m
//  FlightProfile
//
//  Created by Evol Johnson on 1/11/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "GeoHelper.h"



//region Constants
//Equatorial radius of the earth from WGS 84 in meters, semi major axis = a
//static int a = 6378137;

//flattening = 1/298.257223563 = 0.0033528106647474805
//first eccentricity squared = e = (2-flattening)*flattening
//static double e = 0.0066943799901413165;


//Miles to Meters conversion factor (take inverse for opposite)
//static double milesToMeters = 1609.347;
//static double milesToKilometers = 1.609347;
//static double kilometersToMiles = (1.0/1.609347);
//Degrees to Radians converstion factor (take inverse for opposite)
static double degreesToRadians = M_PI/180.0;
static double milesToKilometers = 1.609344;

@implementation GeoHelper


+ (float)distanceBetweenLat1:(float)lat1 Long1:(float)lon1 Lat2:(float)lat2 Long2:(float)lon2 {
    float R = 6371.0; // earth’s radius (mean radius = 6,371km)
    float dLat = (lat2-lat1) * degreesToRadians;
    float dLon = (lon2-lon1) * degreesToRadians; 
    float a = sin(dLat/2.0) * sin(dLat/2.0) + cos(lat1*degreesToRadians) * cos(lat2*degreesToRadians) * sin(dLon/2.0) * sin(dLon/2.0); 
    float c = 2.0 * atan2(sqrt(a), sqrt(1-a)); 
    float d = (R * c)/milesToKilometers;
    return d;
}





+ (float)distanceBetweenAirports: (NFDAirport*) origin destination: (NFDAirport*) destination {
    float lat1 = [origin.latitude_qty floatValue]/3600;
    float long1 = [origin.longitude_qty floatValue]/3600;
    
    float lat2 = [destination.latitude_qty floatValue]/3600;
    float long2 = [destination.longitude_qty floatValue]/3600;
    
    return [GeoHelper distanceBetweenLat1: lat1 Long1:long1 Lat2: lat2 Long2:long2];
    
    
}


/*
 - (float)distanceToAirport:(Airport *)otherAirport inKilometers:(BOOL)useMetric {
    float lat1 = [self decimalLatitude];
    float lon1 = [self decimalLongitude];
    float lat2 = [otherAirport decimalLatitude];
    float lon2 = [otherAirport decimalLongitude];
    float distanceInKilometers = [Airport distanceBetweenLat1:lat1 Long1:lon1 Lat2:lat2 Long2:lon2];
    return (useMetric ? distanceInKilometers : distanceInKilometers * kilometersToMiles);
}

- (float)decimalLatitude {
    float latValue = 0.0;
    NSString *latString = self.latitude;
    if (latString != nil && [latString length] > 4) {
        int degreeLen = [latString length] - 3;
        NSString *degrees = [latString substringToIndex:degreeLen];
        NSString *minutes = [latString substringWithRange:NSMakeRange(degreeLen,2)];
        NSString *compass = [latString substringFromIndex:degreeLen+2];
        latValue = [degrees floatValue] + ([minutes floatValue]/60.0);
        if (compass != nil && [@"S" isEqualToString:[compass uppercaseString]]) {
            latValue = -1.0 * latValue;
        }
    }
    return latValue;
}

- (float)decimalLongitude {
    float lonValue = 0.0;
    NSString *lonString = self.longitude;
    if (lonString != nil && [lonString length] > 4) {
        int degreeLen = [lonString length] - 3;
        NSString *degrees = [lonString substringToIndex:degreeLen];
        NSString *minutes = [lonString substringWithRange:NSMakeRange(degreeLen,2)];
        NSString *compass = [lonString substringFromIndex:degreeLen+2];
        lonValue = [degrees floatValue] + ([minutes floatValue]/60.0);
        if (compass != nil && [@"S" isEqualToString:[compass uppercaseString]]) {
            lonValue = -1.0 * lonValue;
        }
    }
    return lonValue;
}
*/

@end
