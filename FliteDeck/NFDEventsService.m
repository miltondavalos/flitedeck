//
//  NFDEventsService.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDEventsService.h"

@implementation NFDEventsService

- (NSArray *) getEvents: (NSString *) criteria  {
    
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"EventInformation" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        if(![criteria isEqualToString:@""]){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(category CONTAINS [cd] %@) OR (name CONTAINS[cd] %@) OR (event_description CONTAINS[cd] %@) OR (location CONTAINS[cd] %@)", criteria, criteria, criteria, criteria];
            [fetchRequest setPredicate:predicate];
        }
        
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"start_date" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortByDate,nil]];
        
        
        NSError *error;
        NSArray *events = [context executeFetchRequest:fetchRequest error:&error];
        if([events count] > 0){
            return events;
        }
        return nil;
        DLog(@"%@",[error description]);
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    
    
}

- (NSArray *) getEventMedia: (NSString *) criteria  {
    
    @try{
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"EventMedia" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event_id = %@)", criteria];
            [fetchRequest setPredicate:predicate];
    
        
        
        //NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"start_date" ascending:YES];
        //[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortByDate,nil]];
        
        
        
        NSError *error;
        NSArray *events = [context executeFetchRequest:fetchRequest error:&error];
        if([events count] > 0){
            return events;
        }
        return nil;
        DLog(@"%@",[error description]);
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    
    
}
@end
