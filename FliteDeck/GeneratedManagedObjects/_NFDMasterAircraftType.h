// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDMasterAircraftType.h instead.

#import <CoreData/CoreData.h>
#import "NFDAircraftType.h"

extern const struct NFDMasterAircraftTypeAttributes {
	__unsafe_unretained NSString *typeGroupNameForNJA;
	__unsafe_unretained NSString *typeGroupNameForNJE;
} NFDMasterAircraftTypeAttributes;

extern const struct NFDMasterAircraftTypeRelationships {
} NFDMasterAircraftTypeRelationships;

extern const struct NFDMasterAircraftTypeFetchedProperties {
} NFDMasterAircraftTypeFetchedProperties;





@interface NFDMasterAircraftTypeID : NSManagedObjectID {}
@end

@interface _NFDMasterAircraftType : NFDAircraftType {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDMasterAircraftTypeID*)objectID;





@property (nonatomic, strong) NSString* typeGroupNameForNJA;



//- (BOOL)validateTypeGroupNameForNJA:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeGroupNameForNJE;



//- (BOOL)validateTypeGroupNameForNJE:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDMasterAircraftType (CoreDataGeneratedAccessors)

@end

@interface _NFDMasterAircraftType (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveTypeGroupNameForNJA;
- (void)setPrimitiveTypeGroupNameForNJA:(NSString*)value;




- (NSString*)primitiveTypeGroupNameForNJE;
- (void)setPrimitiveTypeGroupNameForNJE:(NSString*)value;




@end
