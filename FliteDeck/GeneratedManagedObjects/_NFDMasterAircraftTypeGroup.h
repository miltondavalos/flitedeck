// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDMasterAircraftTypeGroup.h instead.

#import <CoreData/CoreData.h>
#import "NFDAircraftTypeGroup.h"

extern const struct NFDMasterAircraftTypeGroupAttributes {
	__unsafe_unretained NSString *typeGroupNameForNJA;
	__unsafe_unretained NSString *typeGroupNameForNJE;
} NFDMasterAircraftTypeGroupAttributes;

extern const struct NFDMasterAircraftTypeGroupRelationships {
} NFDMasterAircraftTypeGroupRelationships;

extern const struct NFDMasterAircraftTypeGroupFetchedProperties {
} NFDMasterAircraftTypeGroupFetchedProperties;





@interface NFDMasterAircraftTypeGroupID : NSManagedObjectID {}
@end

@interface _NFDMasterAircraftTypeGroup : NFDAircraftTypeGroup {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDMasterAircraftTypeGroupID*)objectID;





@property (nonatomic, strong) NSString* typeGroupNameForNJA;



//- (BOOL)validateTypeGroupNameForNJA:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeGroupNameForNJE;



//- (BOOL)validateTypeGroupNameForNJE:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDMasterAircraftTypeGroup (CoreDataGeneratedAccessors)

@end

@interface _NFDMasterAircraftTypeGroup (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveTypeGroupNameForNJA;
- (void)setPrimitiveTypeGroupNameForNJA:(NSString*)value;




- (NSString*)primitiveTypeGroupNameForNJE;
- (void)setPrimitiveTypeGroupNameForNJE:(NSString*)value;




@end
