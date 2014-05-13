//
//  NFDPositioningService.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDPositioningService.h"

@implementation NFDPositioningService

- (NSArray*) getPositioningEntity : (NSString *) criteria type:(NSString *) type {
    @try{
        criteria = [criteria trimmed];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Company" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        if(![criteria isEqualToString:@""]){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@) AND (type = %@)", criteria,type];
            [fetchRequest setPredicate:predicate];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(type = %@)",type];
            [fetchRequest setPredicate:predicate];
        }
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"name" ascending:YES];
        
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        
        
        NSError *error;
        NSArray *records = [context executeFetchRequest:fetchRequest error:&error];
        if(error != nil){
            DLog(@"%@",[error description]);
        }else{
            return records;
        }
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil; 
}
    
- (NSArray*) getCompetitorNames : (NSString *) criteria{
    return [self getPositioningEntity:criteria type:@"Competitor"];
}
- (NSArray*) getManufacturers : (NSString *) criteria{
    return [self getPositioningEntity:criteria type:@"Manufacturer"];
}
- (NSArray*) getAircraftForCompany : (NSString *) company size: (NSString *) size{
    @try{
        company = [company trimmed];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"PositioningMatrix" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fleetname = %@) AND (cabintype = %@)", company,size];
            [fetchRequest setPredicate:predicate];
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"acshortname" ascending:YES];
        
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        
        
        NSError *error;
        NSArray *records = [context executeFetchRequest:fetchRequest error:&error];
        if(error != nil){
            DLog(@"%@",[error description]);
        }else{
            return records;
        }
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
}
@end
