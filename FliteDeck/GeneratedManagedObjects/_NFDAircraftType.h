// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAircraftType.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDAircraftTypeAttributes {
	__unsafe_unretained NSString *cabinSize;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *displayOrder;
	__unsafe_unretained NSString *highCruiseSpeed;
	__unsafe_unretained NSString *lastChanged;
	__unsafe_unretained NSString *maxFlyingTime;
	__unsafe_unretained NSString *minRunwayLength;
	__unsafe_unretained NSString *numberOfPax;
	__unsafe_unretained NSString *typeFullName;
	__unsafe_unretained NSString *typeGroupName;
	__unsafe_unretained NSString *typeName;
} NFDAircraftTypeAttributes;

extern const struct NFDAircraftTypeRelationships {
	__unsafe_unretained NSString *contractRate;
	__unsafe_unretained NSString *fuelRate;
} NFDAircraftTypeRelationships;

extern const struct NFDAircraftTypeFetchedProperties {
} NFDAircraftTypeFetchedProperties;

@class NFDContractRate;
@class NFDFuelRate;













@interface NFDAircraftTypeID : NSManagedObjectID {}
@end

@interface _NFDAircraftType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDAircraftTypeID*)objectID;





@property (nonatomic, strong) NSString* cabinSize;



//- (BOOL)validateCabinSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* displayName;



//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* displayOrder;



//- (BOOL)validateDisplayOrder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* highCruiseSpeed;



//- (BOOL)validateHighCruiseSpeed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastChanged;



//- (BOOL)validateLastChanged:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* maxFlyingTime;



//- (BOOL)validateMaxFlyingTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* minRunwayLength;



//- (BOOL)validateMinRunwayLength:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* numberOfPax;



//- (BOOL)validateNumberOfPax:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeFullName;



//- (BOOL)validateTypeFullName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeGroupName;



//- (BOOL)validateTypeGroupName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeName;



//- (BOOL)validateTypeName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NFDContractRate *contractRate;

//- (BOOL)validateContractRate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NFDFuelRate *fuelRate;

//- (BOOL)validateFuelRate:(id*)value_ error:(NSError**)error_;





@end

@interface _NFDAircraftType (CoreDataGeneratedAccessors)

@end

@interface _NFDAircraftType (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCabinSize;
- (void)setPrimitiveCabinSize:(NSString*)value;




- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;




- (NSDecimalNumber*)primitiveDisplayOrder;
- (void)setPrimitiveDisplayOrder:(NSDecimalNumber*)value;




- (NSDecimalNumber*)primitiveHighCruiseSpeed;
- (void)setPrimitiveHighCruiseSpeed:(NSDecimalNumber*)value;




- (NSDate*)primitiveLastChanged;
- (void)setPrimitiveLastChanged:(NSDate*)value;




- (NSDecimalNumber*)primitiveMaxFlyingTime;
- (void)setPrimitiveMaxFlyingTime:(NSDecimalNumber*)value;




- (NSDecimalNumber*)primitiveMinRunwayLength;
- (void)setPrimitiveMinRunwayLength:(NSDecimalNumber*)value;




- (NSDecimalNumber*)primitiveNumberOfPax;
- (void)setPrimitiveNumberOfPax:(NSDecimalNumber*)value;




- (NSString*)primitiveTypeFullName;
- (void)setPrimitiveTypeFullName:(NSString*)value;




- (NSString*)primitiveTypeGroupName;
- (void)setPrimitiveTypeGroupName:(NSString*)value;




- (NSString*)primitiveTypeName;
- (void)setPrimitiveTypeName:(NSString*)value;





- (NFDContractRate*)primitiveContractRate;
- (void)setPrimitiveContractRate:(NFDContractRate*)value;



- (NFDFuelRate*)primitiveFuelRate;
- (void)setPrimitiveFuelRate:(NFDFuelRate*)value;


@end
