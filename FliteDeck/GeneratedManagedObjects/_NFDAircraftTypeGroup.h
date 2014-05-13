// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAircraftTypeGroup.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDAircraftTypeGroupAttributes {
	__unsafe_unretained NSString *acPerformanceTypeName;
	__unsafe_unretained NSString *baggageCapacity;
	__unsafe_unretained NSString *cabinHeight;
	__unsafe_unretained NSString *cabinWidth;
	__unsafe_unretained NSString *displayOrder;
	__unsafe_unretained NSString *highCruiseSpeed;
	__unsafe_unretained NSString *manufacturer;
	__unsafe_unretained NSString *numberOfPax;
	__unsafe_unretained NSString *range;
	__unsafe_unretained NSString *typeGroupName;
	__unsafe_unretained NSString *warnings;
} NFDAircraftTypeGroupAttributes;

extern const struct NFDAircraftTypeGroupRelationships {
} NFDAircraftTypeGroupRelationships;

extern const struct NFDAircraftTypeGroupFetchedProperties {
} NFDAircraftTypeGroupFetchedProperties;












@class NSObject;

@interface NFDAircraftTypeGroupID : NSManagedObjectID {}
@end

@interface _NFDAircraftTypeGroup : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDAircraftTypeGroupID*)objectID;





@property (nonatomic, strong) NSString* acPerformanceTypeName;



//- (BOOL)validateAcPerformanceTypeName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* baggageCapacity;



//- (BOOL)validateBaggageCapacity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cabinHeight;



//- (BOOL)validateCabinHeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cabinWidth;



//- (BOOL)validateCabinWidth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* displayOrder;



@property int16_t displayOrderValue;
- (int16_t)displayOrderValue;
- (void)setDisplayOrderValue:(int16_t)value_;

//- (BOOL)validateDisplayOrder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* highCruiseSpeed;



//- (BOOL)validateHighCruiseSpeed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* manufacturer;



//- (BOOL)validateManufacturer:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* numberOfPax;



//- (BOOL)validateNumberOfPax:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* range;



//- (BOOL)validateRange:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeGroupName;



//- (BOOL)validateTypeGroupName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id warnings;



//- (BOOL)validateWarnings:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDAircraftTypeGroup (CoreDataGeneratedAccessors)

@end

@interface _NFDAircraftTypeGroup (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAcPerformanceTypeName;
- (void)setPrimitiveAcPerformanceTypeName:(NSString*)value;




- (NSString*)primitiveBaggageCapacity;
- (void)setPrimitiveBaggageCapacity:(NSString*)value;




- (NSString*)primitiveCabinHeight;
- (void)setPrimitiveCabinHeight:(NSString*)value;




- (NSString*)primitiveCabinWidth;
- (void)setPrimitiveCabinWidth:(NSString*)value;




- (NSNumber*)primitiveDisplayOrder;
- (void)setPrimitiveDisplayOrder:(NSNumber*)value;

- (int16_t)primitiveDisplayOrderValue;
- (void)setPrimitiveDisplayOrderValue:(int16_t)value_;




- (NSString*)primitiveHighCruiseSpeed;
- (void)setPrimitiveHighCruiseSpeed:(NSString*)value;




- (NSString*)primitiveManufacturer;
- (void)setPrimitiveManufacturer:(NSString*)value;




- (NSString*)primitiveNumberOfPax;
- (void)setPrimitiveNumberOfPax:(NSString*)value;




- (NSString*)primitiveRange;
- (void)setPrimitiveRange:(NSString*)value;




- (NSString*)primitiveTypeGroupName;
- (void)setPrimitiveTypeGroupName:(NSString*)value;




- (id)primitiveWarnings;
- (void)setPrimitiveWarnings:(id)value;




@end
