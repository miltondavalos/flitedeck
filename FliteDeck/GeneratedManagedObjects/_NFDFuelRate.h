// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDFuelRate.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDFuelRateAttributes {
	__unsafe_unretained NSString *nonQualified12MonthRate;
	__unsafe_unretained NSString *nonQualified1MonthRate;
	__unsafe_unretained NSString *nonQualified3MonthRate;
	__unsafe_unretained NSString *nonQualified6MonthRate;
	__unsafe_unretained NSString *qualified12MonthRate;
	__unsafe_unretained NSString *qualified1MonthRate;
	__unsafe_unretained NSString *qualified3MonthRate;
	__unsafe_unretained NSString *qualified6MonthRate;
	__unsafe_unretained NSString *typeName;
} NFDFuelRateAttributes;

extern const struct NFDFuelRateRelationships {
	__unsafe_unretained NSString *aircraftType;
} NFDFuelRateRelationships;

extern const struct NFDFuelRateFetchedProperties {
} NFDFuelRateFetchedProperties;

@class NFDAircraftType;











@interface NFDFuelRateID : NSManagedObjectID {}
@end

@interface _NFDFuelRate : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDFuelRateID*)objectID;





@property (nonatomic, strong) NSNumber* nonQualified12MonthRate;



@property int16_t nonQualified12MonthRateValue;
- (int16_t)nonQualified12MonthRateValue;
- (void)setNonQualified12MonthRateValue:(int16_t)value_;

//- (BOOL)validateNonQualified12MonthRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* nonQualified1MonthRate;



@property int16_t nonQualified1MonthRateValue;
- (int16_t)nonQualified1MonthRateValue;
- (void)setNonQualified1MonthRateValue:(int16_t)value_;

//- (BOOL)validateNonQualified1MonthRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* nonQualified3MonthRate;



@property int16_t nonQualified3MonthRateValue;
- (int16_t)nonQualified3MonthRateValue;
- (void)setNonQualified3MonthRateValue:(int16_t)value_;

//- (BOOL)validateNonQualified3MonthRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* nonQualified6MonthRate;



@property int16_t nonQualified6MonthRateValue;
- (int16_t)nonQualified6MonthRateValue;
- (void)setNonQualified6MonthRateValue:(int16_t)value_;

//- (BOOL)validateNonQualified6MonthRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* qualified12MonthRate;



@property int16_t qualified12MonthRateValue;
- (int16_t)qualified12MonthRateValue;
- (void)setQualified12MonthRateValue:(int16_t)value_;

//- (BOOL)validateQualified12MonthRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* qualified1MonthRate;



@property int16_t qualified1MonthRateValue;
- (int16_t)qualified1MonthRateValue;
- (void)setQualified1MonthRateValue:(int16_t)value_;

//- (BOOL)validateQualified1MonthRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* qualified3MonthRate;



@property int16_t qualified3MonthRateValue;
- (int16_t)qualified3MonthRateValue;
- (void)setQualified3MonthRateValue:(int16_t)value_;

//- (BOOL)validateQualified3MonthRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* qualified6MonthRate;



@property int16_t qualified6MonthRateValue;
- (int16_t)qualified6MonthRateValue;
- (void)setQualified6MonthRateValue:(int16_t)value_;

//- (BOOL)validateQualified6MonthRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeName;



//- (BOOL)validateTypeName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NFDAircraftType *aircraftType;

//- (BOOL)validateAircraftType:(id*)value_ error:(NSError**)error_;





@end

@interface _NFDFuelRate (CoreDataGeneratedAccessors)

@end

@interface _NFDFuelRate (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveNonQualified12MonthRate;
- (void)setPrimitiveNonQualified12MonthRate:(NSNumber*)value;

- (int16_t)primitiveNonQualified12MonthRateValue;
- (void)setPrimitiveNonQualified12MonthRateValue:(int16_t)value_;




- (NSNumber*)primitiveNonQualified1MonthRate;
- (void)setPrimitiveNonQualified1MonthRate:(NSNumber*)value;

- (int16_t)primitiveNonQualified1MonthRateValue;
- (void)setPrimitiveNonQualified1MonthRateValue:(int16_t)value_;




- (NSNumber*)primitiveNonQualified3MonthRate;
- (void)setPrimitiveNonQualified3MonthRate:(NSNumber*)value;

- (int16_t)primitiveNonQualified3MonthRateValue;
- (void)setPrimitiveNonQualified3MonthRateValue:(int16_t)value_;




- (NSNumber*)primitiveNonQualified6MonthRate;
- (void)setPrimitiveNonQualified6MonthRate:(NSNumber*)value;

- (int16_t)primitiveNonQualified6MonthRateValue;
- (void)setPrimitiveNonQualified6MonthRateValue:(int16_t)value_;




- (NSNumber*)primitiveQualified12MonthRate;
- (void)setPrimitiveQualified12MonthRate:(NSNumber*)value;

- (int16_t)primitiveQualified12MonthRateValue;
- (void)setPrimitiveQualified12MonthRateValue:(int16_t)value_;




- (NSNumber*)primitiveQualified1MonthRate;
- (void)setPrimitiveQualified1MonthRate:(NSNumber*)value;

- (int16_t)primitiveQualified1MonthRateValue;
- (void)setPrimitiveQualified1MonthRateValue:(int16_t)value_;




- (NSNumber*)primitiveQualified3MonthRate;
- (void)setPrimitiveQualified3MonthRate:(NSNumber*)value;

- (int16_t)primitiveQualified3MonthRateValue;
- (void)setPrimitiveQualified3MonthRateValue:(int16_t)value_;




- (NSNumber*)primitiveQualified6MonthRate;
- (void)setPrimitiveQualified6MonthRate:(NSNumber*)value;

- (int16_t)primitiveQualified6MonthRateValue;
- (void)setPrimitiveQualified6MonthRateValue:(int16_t)value_;




- (NSString*)primitiveTypeName;
- (void)setPrimitiveTypeName:(NSString*)value;





- (NFDAircraftType*)primitiveAircraftType;
- (void)setPrimitiveAircraftType:(NFDAircraftType*)value;


@end
