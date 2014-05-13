//
//  NFDAirportService.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/13/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDAirportService.h"

@implementation NFDAirportService


- (NSArray *) getFBOs: (NSString *) airportCode  {
    
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"FBO" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(airportid = %@) ", airportCode];
        
        NSSortDescriptor *sortByRanking = [[NSSortDescriptor alloc] initWithKey:@"fbo_ranking_qty" ascending:YES];
        
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"vendor_name" ascending:YES];
        
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortByRanking,sortByName,nil]];
        
        [fetchRequest setPredicate:predicate];
        
        [fetchRequest setFetchLimit:3];
        
        NSError *error;
        NSArray *fbos = [context executeFetchRequest:fetchRequest error:&error];
        if(error != nil){
            DLog(@"%@",[error description]);
        }else{
            if([fbos count] > 0){
                return fbos;
            }
        }
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
    
}

- (NSSet *) getFBOAddress: (NSNumber *) fbo_id  {
    
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"FBOAddress" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fbo_id = %@) ", fbo_id];
        
        /*NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fbo_ranking_qty" ascending:YES];
         [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];*/
        
        [fetchRequest setPredicate:predicate];
        
        [fetchRequest setFetchLimit:1];
        
        NSError *error;
        NSArray *fbos = [context executeFetchRequest:fetchRequest error:&error];
        if(error != nil){
            DLog(@"%@",[error description]);
        }else{
            if([fbos count] > 0){
                return [NSSet setWithArray:fbos];
            }
        }
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
    
}

- (NSSet *) getFBOPhone: (NSNumber *) fbo_id  {
    
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"FBOPhone" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fbo_id = %@)", fbo_id];
        
        /*NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fbo_ranking_qty" ascending:YES];
         [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];*/
        
        [fetchRequest setPredicate:predicate];
        
        [fetchRequest setFetchLimit:1];
        
        NSError *error;
        NSArray *fbos = [context executeFetchRequest:fetchRequest error:&error];
        if(error != nil){
            DLog(@"%@",[error description]);
        }else{
            if([fbos count] > 0){
                return [NSSet setWithArray:fbos];
            }
        }
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
    
}

- (NFDAirport *) findAirportWithCode: (NSString *) airportCode  {
    
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Airport" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(airportid = %@) ", airportCode];
        
        
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *airports = [context executeFetchRequest:fetchRequest error:&error];
        if(error != nil){
            DLog(@"%@",[error description]);
        }else{
            if([airports count] > 0){
                return [airports objectAtIndex:0];
            }
        }
        
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    return nil;
    
}

- (NSArray *) queryAirports : (NSString *) criteria {  
    @try{
        criteria = [criteria trimmed];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Airport" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(airport_name CONTAINS[cd] %@) OR (city_name CONTAINS[cd] %@) OR (airportid CONTAINS[cd] %@) or (iata_cd CONTAINS[cd] %@)", criteria, criteria, criteria, criteria];
        
        [fetchRequest setPredicate:predicate];
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"airport_name" ascending:YES];
        
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
