//
//  NFDFlightTrackingSabreXMLDelegate.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/17/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightTrackingSabreXMLDelegate.h"

@implementation NFDFlightTrackingSabreXMLDelegate

@synthesize flightData;

NSString *currentElement;
NSString *currentCharacters;

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    if (!flightData){
        flightData = [[NFDFlightData alloc] init];
    }
    currentElement = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    currentElement = elementName;
    currentCharacters = @"";
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    [currentCharacters stringByAppendingString:string];
    currentCharacters = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if (![currentElement isEqualToString:@"FlightData"]){
        [flightData setValue:currentCharacters forKey:currentElement];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    currentElement = nil;
    currentCharacters = nil;
}

@end
