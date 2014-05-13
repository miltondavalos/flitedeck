//
//  NFDImportService.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/10/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDImportService.h"
#import "NFDAircraftType.h"
#import "NFDContractRate.h"
#import "NCLFramework.h"
#import "ReaderThumbCache.h"

@implementation NFDImportService

- (void)importFromFiles
{
    [self importAirports];
    [self importFBO];
    [self importFBOPhone];
    [self importFBOAddress];
    [self importEventFile];
    [self importAircraftTypeRestrictionFile];
    [self importAircraftTypeGroupFile];
    [self importAircraftTypeFile];
    [self importPositioningMatrixFile];
    [self importCompanyFile];
}

-(void)importEntity:(NSString*)entityName fields:(NSArray*)fields downloadInfo:(NSString*)inputPath
{
    [NCLPersistenceUtil deleteAllObjectsForEntityName:entityName context:context error:nil];
    
    NSError *error = [[NSError alloc] init];
    DLog(@"Importing Entity %@ from: %@",entityName, inputPath);
    NSString *csvString = [NSString stringWithContentsOfFile:inputPath encoding:NSUTF8StringEncoding error:&error];
    
    if (!csvString)
    {
        printf("Couldn't read file at path %s\n. Error: %s",
               [inputPath UTF8String],
               [[error localizedDescription] ? [error localizedDescription] : [error description] UTF8String]);
        exit(1);
    }
    
    NSDate *startDate = [NSDate date];
    EntryReceiver *receiver =[[EntryReceiver alloc] initWithContext:context entityName:entityName] ;
    CSVParser *parser = [[CSVParser alloc] initWithString:csvString separator:@"," hasHeader:NO fieldNames: fields];
    [parser parseRowsForReceiver:receiver selector:@selector(receiveRecord:)];
    NSDate *endDate = [NSDate date];
    
    NSLog(@"%u %@ entries successfully imported in %f seconds.",
          [NCLPersistenceUtil countForFetchRequestForEntityName:entityName
                                                      predicate:nil
                                             includeSubEntities:NO
                                                        context:context
                                                          error:nil],
          entityName,
          [endDate timeIntervalSinceDate:startDate]);
    
    if (![context save:&error])
    {
        printf("Error while saving\n%s",
               [[error localizedDescription] ?
                [error localizedDescription] : [error description] UTF8String]);
        exit(1);
    }
}

// AIRPORT
- (void)importAirports
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Airport.csv"];
    
    if (path)
    {
        [self importEntity:@"Airport" fields:[NSArray arrayWithObjects:
                                                @"airportid",
                                                @"iata_cd",
                                                @"closest_airportid",
                                                @"airport_name",
                                                @"city_name",
                                                @"state_cd",
                                                @"country_cd",
                                                @"timezone_cd",
                                                @"elevation_qty",
                                                @"longest_runway_length_qty",
                                                @"latitude_qty",
                                                @"longitude_qty",
                                                @"instrument_approach_flag",
                                                @"fuel_available",
                                                @"customs_available",
                                                @"slots_required",
                                                nil] downloadInfo:path];
    }
}


// FBO
- (void)importFBO
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FBO.csv"];
    
    if (path)
    {
        [self importEntity:@"FBO" fields:[NSArray arrayWithObjects:
                                            @"fbo_id",
                                            @"vendor_name",
                                            @"airportid",
                                            @"fbo_ranking_qty",
                                            @"status",
                                            @"summer_operating_hour_desc",
                                            @"winter_operating_hour_desc",
                                            @"sys_last_changed_ts",
                                            nil] downloadInfo:path];
    }
}

// FBO PHONE
- (void)importFBOPhone
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FBO-Phone.csv"];
    
    if (path)
    {
        [self importEntity:@"FBOPhone" fields:[NSArray arrayWithObjects:
                                                 @"telephone_id",
                                                 @"fbo_id",
                                                 @"country_code_txt",
                                                 @"area_code_txt",
                                                 @"telephone_nbr_txt",
                                                 @"sys_last_changed_ts",nil] downloadInfo:path];
    }
}

// FBO ADDRESS
-(void) importFBOAddress
{

    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FBO-Address.csv"];
    
    if (path)
    {
        [self importEntity:@"FBOAddress" fields:[NSArray arrayWithObjects:
                                                   @"address_id",
                                                   @"fbo_id",
                                                   @"address_line1_txt",
                                                   @"address_line2_txt",
                                                   @"address_line3_txt",
                                                   @"address_line4_txt",
                                                   @"address_line5_txt",
                                                   @"city_name",
                                                   @"state_province_name",
                                                   @"postal_cd",
                                                   @"country_cd",
                                                   @"sys_last_changed_ts",nil] downloadInfo:path];
    }
}

// EVENT
-(void) importEventFile{
    [self importEvent: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Events.csv"]];
}

-(void) importEvent: (NSString *) inputPath {
    
    @try {
        [self  importEntity: @"EventInformation" fields:[NSArray arrayWithObjects:
                                                         @"event_id",
                                                         @"category",
                                                         @"start_date",
                                                         @"end_date",
                                                         @"name",
                                                         @"event_description",
                                                         @"location",nil] downloadInfo:inputPath];
        
#ifndef FLITEDECK_DATABASE_BUILDER
        // NOTE: The ifndef is here because we don't want to pull this class and all
        // it dependencies into the FliteDeckDataBuilder target.
        
        // Purge the Event cache when new events are loaded.
        [ReaderThumbCache purgeThumbCachesOlderThan:[[NSDate date] timeIntervalSinceNow]];
#endif
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    
}

// AIRCRAFT RESTRICTION
-(void) importAircraftTypeRestrictionFile{
    [self importAircraftTypeRestriction: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AircraftRestriction.csv"]];
}

-(void) importAircraftTypeRestriction: (NSString *) inputPath {
    
    @try {
        [self  importEntity: @"AircraftTypeRestriction" fields:[NSArray arrayWithObjects:
                                                                @"aircraftRestrictionID",
                                                                @"typeName",
                                                                @"airportID",
                                                                @"approvalStatusID",
                                                                @"restrictionType",
                                                                @"isForTakeoff",
                                                                @"isForLanding",
                                                                @"comments",
                                                                nil] downloadInfo:inputPath];
        
        
    }@catch(NSException *exception){
        DLog(@"%@",[exception reason]);
    }
    
}

// AIRCRAFT TYPE
- (void)importAircraftTypeFile
{
    [self importAircraftTypes:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AircraftType.csv"]];
}

- (void)importAircraftTypes:(NSString*)inputPath
{
    if (inputPath)
    {
        [self importEntity:@"MasterAircraftType" fields:[NSArray arrayWithObjects:
                                                         @"typeName",
                                                         @"typeFullName",
                                                         @"cabinSize",
                                                         @"numberOfPax",
                                                         @"minRunwayLength",
                                                         @"highCruiseSpeed",
                                                         @"maxFlyingTime",
                                                         @"lastChanged",
                                                         @"typeGroupNameForNJA",
                                                         @"typeGroupNameForNJE",
                                                         @"displayName",
                                                         @"displayOrder",
                                                         nil] downloadInfo:inputPath];
    }
}


// AIRCRAFT TYPE GROUP
- (void)importAircraftTypeGroupFile
{
    [self importAircraftTypeGroup:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AircraftTypeGroup.csv"]];
}

- (void)importAircraftTypeGroup:(NSString*)inputPath
{
    if (inputPath)
    {
        [self importEntity: @"MasterAircraftTypeGroup" fields:[NSArray arrayWithObjects:
                                                            @"typeGroupNameForNJA",
                                                            @"typeGroupNameForNJE",
                                                            @"displayOrder",
                                                            @"acPerformanceTypeName",
                                                            @"manufacturer",
                                                            @"numberOfPax",
                                                            @"range",
                                                            @"highCruiseSpeed",
                                                            @"cabinHeight",
                                                            @"cabinWidth",
                                                            @"baggageCapacity",
                                                            @"typeGroupName",
                                                            nil] downloadInfo:inputPath];
    }
}

// POSITIONING MATRIX
-(void) importPositioningMatrixFile{
    [self importPositioningMatrix: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PositioningMatrix.csv"]];
}

- (void)importPositioningMatrix:(NSString*)inputPath
{
    [self  importEntity: @"PositioningMatrix" fields:[NSArray arrayWithObjects:
                                                      @"fleetname",
                                                      @"cabintype",
                                                      @"acname",
                                                      @"comparableac",
                                                      @"acshortname",
                                                      @"acpassengers",
                                                      @"acrange",
                                                      @"acspeed",
                                                      @"accost",
                                                      @"detailslink",
                                                      @"typename",
                                                      nil] downloadInfo:inputPath];
}

// COMPANY
- (void)importCompanyFile
{
    [self importCompany:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Company.csv"]];
}

- (void)importCompany:(NSString*)inputPath
{
    [self  importEntity: @"Company" fields:[NSArray arrayWithObjects:
                                            @"company_id",
                                            @"name",
                                            @"type",
                                            @"competitive_analysis",
                                            @"general_info",
                                            nil] downloadInfo:inputPath];
}

@end
