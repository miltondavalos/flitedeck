//
//  NFDDatabaseBuilderValidation.h
//  FliteDeck
//
//  Created by Jeff Bailey on 12/26/13.
//
//

#import <Foundation/Foundation.h>

@interface NFDDatabaseBuilderValidation : NSObject

@property (nonatomic) NSInteger numWarnings;
@property (nonatomic) NSInteger numErrors;

- (void) validateFlightDeckDatabase;
- (void) validateMasterAircraftTypes;
- (void) validateMasterAircraftTypeGroups;

@end
