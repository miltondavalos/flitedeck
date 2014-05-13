//
//  AddressAnnotation.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/21/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

@synthesize coordinate,_title, _subtitle;

@synthesize airport;


- (NSString *)subtitle{
    return _subtitle;
}
- (NSString *)title{
    return _title;
}


-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end
