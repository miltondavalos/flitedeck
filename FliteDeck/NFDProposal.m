//
//  NFDProposal.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDProposal.h"

@implementation NFDProposal

@synthesize uniqueIdentifier;
@synthesize productCode;
@synthesize productType;
@synthesize title;
@synthesize subTitle;
@synthesize topLabel;
@synthesize bottomLabel;
@synthesize selected;
@synthesize calculated;

@synthesize productParameters = _productParameters;
@synthesize calculatedResults = _calculatedResults;
@synthesize relatedProposal = _relatedProposal;

-(id) init {
    self = [super init];
    if(self)
    {
        [self setProductParameters:[NSMutableDictionary dictionary]];
        self.calculatedResults = [[NSMutableDictionary alloc] init];
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        uniqueIdentifier = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Proposal> productCode:%@ | productType:%@ | title:%@ | subTitle:%@ | topLabel:%@ | bottomLabel:%@ | productParameters:%@ | calculatedResults:%@" , productCode, productType, title, subTitle, topLabel, bottomLabel, self.productParameters, self.calculatedResults];
}

- (NSDictionary *)unifiedDictionary
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict addEntriesFromDictionary:self.productParameters];
    [tempDict addEntriesFromDictionary:self.calculatedResults];
    if ([[self.productParameters allKeys] containsObject:@"AircraftInventory"])
    {
        NSArray *keys = [[[[self.productParameters objectForKey:@"AircraftInventory"] entity] attributesByName] allKeys];
        
        NSDictionary *cdDict = [NSDictionary dictionaryWithDictionary:[[self.productParameters objectForKey:@"AircraftInventory"] dictionaryWithValuesForKeys:keys]];
        [tempDict addEntriesFromDictionary:cdDict];
        
        [tempDict setObject:[cdDict objectForKey:@"anticipated_delivery_date"] forKey:@"DeliveryDate"];
        //[tempDict setObject:[cdDict objectForKey:@"contracts_until_date"] forKey:@"ContractsUntil"];
        [tempDict setObject:[cdDict objectForKey:@"legal_name"] forKey:@"LegalName"];
        [tempDict setObject:[cdDict objectForKey:@"sales_value"] forKey:@"SalesValue"];
        [tempDict setObject:[cdDict objectForKey:@"serial"] forKey:@"SerialNumber"];
//        [tempDict setObject:[cdDict objectForKey:@"share_immediately_available"] forKey:@"Available"];
        [tempDict setObject:[cdDict objectForKey:@"tail"] forKey:@"Tail"];
        [tempDict setObject:[cdDict objectForKey:@"year"] forKey:@"Year"];
        
//        NSDate *contractUntil = [cdDict objectForKey:@"contracts_until_date"];
//        NSTimeInterval secondsBetween = [contractUntil timeIntervalSinceDate:[NSDate date]];
//        int numberOfYears = ( ( secondsBetween / 86400 ) / 365 );
//        NSString *contractStringFromDate = [NSString stringWithFormat:@"%i Years",numberOfYears];
//        [tempDict setObject:contractStringFromDate forKey:@"ContractsUntil"];
        
        
        float avail = [[cdDict objectForKey:@"share_immediately_available"] floatValue];
        int hoursAvailable = 800 * avail;
        NSString *hoursAvailableString = [NSString stringWithFormat:@"%i hours", hoursAvailable];
        
        [tempDict setObject:hoursAvailableString forKey:@"Available"];
        
    }
    return [NSDictionary dictionaryWithDictionary:tempDict];
}

@end
