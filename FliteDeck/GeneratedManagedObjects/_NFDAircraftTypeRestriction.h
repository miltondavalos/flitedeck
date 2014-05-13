// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAircraftTypeRestriction.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDAircraftTypeRestrictionAttributes {
	__unsafe_unretained NSString *aircraftRestrictionID;
	__unsafe_unretained NSString *airportID;
	__unsafe_unretained NSString *approvalStatusID;
	__unsafe_unretained NSString *comments;
	__unsafe_unretained NSString *isForLanding;
	__unsafe_unretained NSString *isForTakeoff;
	__unsafe_unretained NSString *restrictionType;
	__unsafe_unretained NSString *typeName;
} NFDAircraftTypeRestrictionAttributes;

extern const struct NFDAircraftTypeRestrictionRelationships {
} NFDAircraftTypeRestrictionRelationships;

extern const struct NFDAircraftTypeRestrictionFetchedProperties {
} NFDAircraftTypeRestrictionFetchedProperties;











@interface NFDAircraftTypeRestrictionID : NSManagedObjectID {}
@end

@interface _NFDAircraftTypeRestriction : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDAircraftTypeRestrictionID*)objectID;





@property (nonatomic, strong) NSNumber* aircraftRestrictionID;



@property int32_t aircraftRestrictionIDValue;
- (int32_t)aircraftRestrictionIDValue;
- (void)setAircraftRestrictionIDValue:(int32_t)value_;

//- (BOOL)validateAircraftRestrictionID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* airportID;



//- (BOOL)validateAirportID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* approvalStatusID;



@property int16_t approvalStatusIDValue;
- (int16_t)approvalStatusIDValue;
- (void)setApprovalStatusIDValue:(int16_t)value_;

//- (BOOL)validateApprovalStatusID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* comments;



//- (BOOL)validateComments:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isForLanding;



@property BOOL isForLandingValue;
- (BOOL)isForLandingValue;
- (void)setIsForLandingValue:(BOOL)value_;

//- (BOOL)validateIsForLanding:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isForTakeoff;



@property BOOL isForTakeoffValue;
- (BOOL)isForTakeoffValue;
- (void)setIsForTakeoffValue:(BOOL)value_;

//- (BOOL)validateIsForTakeoff:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* restrictionType;



//- (BOOL)validateRestrictionType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeName;



//- (BOOL)validateTypeName:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDAircraftTypeRestriction (CoreDataGeneratedAccessors)

@end

@interface _NFDAircraftTypeRestriction (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAircraftRestrictionID;
- (void)setPrimitiveAircraftRestrictionID:(NSNumber*)value;

- (int32_t)primitiveAircraftRestrictionIDValue;
- (void)setPrimitiveAircraftRestrictionIDValue:(int32_t)value_;




- (NSString*)primitiveAirportID;
- (void)setPrimitiveAirportID:(NSString*)value;




- (NSNumber*)primitiveApprovalStatusID;
- (void)setPrimitiveApprovalStatusID:(NSNumber*)value;

- (int16_t)primitiveApprovalStatusIDValue;
- (void)setPrimitiveApprovalStatusIDValue:(int16_t)value_;




- (NSString*)primitiveComments;
- (void)setPrimitiveComments:(NSString*)value;




- (NSNumber*)primitiveIsForLanding;
- (void)setPrimitiveIsForLanding:(NSNumber*)value;

- (BOOL)primitiveIsForLandingValue;
- (void)setPrimitiveIsForLandingValue:(BOOL)value_;




- (NSNumber*)primitiveIsForTakeoff;
- (void)setPrimitiveIsForTakeoff:(NSNumber*)value;

- (BOOL)primitiveIsForTakeoffValue;
- (void)setPrimitiveIsForTakeoffValue:(BOOL)value_;




- (NSString*)primitiveRestrictionType;
- (void)setPrimitiveRestrictionType:(NSString*)value;




- (NSString*)primitiveTypeName;
- (void)setPrimitiveTypeName:(NSString*)value;




@end
