//
//  AddressAnnotation.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/21/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "NFDAirport.h"

@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
    NSString * _title;
    NSString * _subtitle;
    
    NFDAirport * airport;
}

@property(nonatomic,strong) NSString * _title;
@property(nonatomic,strong) NSString * _subtitle;

@property(nonatomic, strong) NFDAirport *airport;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

- (NSString *)subtitle;
- (NSString *)title;

@end
