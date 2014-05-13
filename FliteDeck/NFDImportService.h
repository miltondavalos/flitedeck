//
//  NFDImportService.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/10/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDPersistenceService.h"
#import "NFDAirport.h"
#import "NFDAircraftType.h"
#import "NFDFileSystemHelper.h"

@interface NFDImportService : NFDPersistenceService

- (void)importEntity : (NSString *) entityName fields:(NSArray*) fields  downloadInfo : (NSString *) inputPath;
- (void)importFromFiles;

- (void)importAircraftTypeFile;
- (void)importAircraftTypeGroupFile;
- (void)importEventFile;
- (void)importAircraftTypeRestrictionFile;
- (void)importPositioningMatrixFile;
- (void)importCompanyFile;

- (void)importAirports;
- (void)importAircraftTypes:(NSString*)inputPath;
- (void)importFBO;
- (void)importFBOAddress;
- (void)importFBOPhone;
- (void)importEvent: (NSString *) inputPath;
- (void)importAircraftTypeRestriction: (NSString *) inputPath;
- (void)importAircraftTypeGroup:(NSString*)inputPath;
- (void)importPositioningMatrix: (NSString *) inputPath;
- (void)importCompany: (NSString *) inputPath;

@end