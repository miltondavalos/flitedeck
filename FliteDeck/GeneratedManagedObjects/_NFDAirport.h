// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAirport.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDAirportAttributes {
	__unsafe_unretained NSString *airport_name;
	__unsafe_unretained NSString *airportid;
	__unsafe_unretained NSString *city_name;
	__unsafe_unretained NSString *closest_airportid;
	__unsafe_unretained NSString *country_cd;
	__unsafe_unretained NSString *customs_available;
	__unsafe_unretained NSString *elevation_qty;
	__unsafe_unretained NSString *fuel_available;
	__unsafe_unretained NSString *iata_cd;
	__unsafe_unretained NSString *instrument_approach_flag;
	__unsafe_unretained NSString *latitude_qty;
	__unsafe_unretained NSString *longest_runway_length_qty;
	__unsafe_unretained NSString *longitude_qty;
	__unsafe_unretained NSString *slots_required;
	__unsafe_unretained NSString *state_cd;
	__unsafe_unretained NSString *timezone_cd;
} NFDAirportAttributes;

extern const struct NFDAirportRelationships {
} NFDAirportRelationships;

extern const struct NFDAirportFetchedProperties {
} NFDAirportFetchedProperties;



















@interface NFDAirportID : NSManagedObjectID {}
@end

@interface _NFDAirport : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDAirportID*)objectID;





@property (nonatomic, strong) NSString* airport_name;



//- (BOOL)validateAirport_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* airportid;



//- (BOOL)validateAirportid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* city_name;



//- (BOOL)validateCity_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* closest_airportid;



//- (BOOL)validateClosest_airportid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country_cd;



//- (BOOL)validateCountry_cd:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* customs_available;



@property BOOL customs_availableValue;
- (BOOL)customs_availableValue;
- (void)setCustoms_availableValue:(BOOL)value_;

//- (BOOL)validateCustoms_available:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* elevation_qty;



@property int16_t elevation_qtyValue;
- (int16_t)elevation_qtyValue;
- (void)setElevation_qtyValue:(int16_t)value_;

//- (BOOL)validateElevation_qty:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fuel_available;



@property BOOL fuel_availableValue;
- (BOOL)fuel_availableValue;
- (void)setFuel_availableValue:(BOOL)value_;

//- (BOOL)validateFuel_available:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* iata_cd;



//- (BOOL)validateIata_cd:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* instrument_approach_flag;



@property BOOL instrument_approach_flagValue;
- (BOOL)instrument_approach_flagValue;
- (void)setInstrument_approach_flagValue:(BOOL)value_;

//- (BOOL)validateInstrument_approach_flag:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* latitude_qty;



//- (BOOL)validateLatitude_qty:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longest_runway_length_qty;



@property int16_t longest_runway_length_qtyValue;
- (int16_t)longest_runway_length_qtyValue;
- (void)setLongest_runway_length_qtyValue:(int16_t)value_;

//- (BOOL)validateLongest_runway_length_qty:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* longitude_qty;



//- (BOOL)validateLongitude_qty:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* slots_required;



@property BOOL slots_requiredValue;
- (BOOL)slots_requiredValue;
- (void)setSlots_requiredValue:(BOOL)value_;

//- (BOOL)validateSlots_required:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* state_cd;



//- (BOOL)validateState_cd:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* timezone_cd;



//- (BOOL)validateTimezone_cd:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDAirport (CoreDataGeneratedAccessors)

@end

@interface _NFDAirport (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAirport_name;
- (void)setPrimitiveAirport_name:(NSString*)value;




- (NSString*)primitiveAirportid;
- (void)setPrimitiveAirportid:(NSString*)value;




- (NSString*)primitiveCity_name;
- (void)setPrimitiveCity_name:(NSString*)value;




- (NSString*)primitiveClosest_airportid;
- (void)setPrimitiveClosest_airportid:(NSString*)value;




- (NSString*)primitiveCountry_cd;
- (void)setPrimitiveCountry_cd:(NSString*)value;




- (NSNumber*)primitiveCustoms_available;
- (void)setPrimitiveCustoms_available:(NSNumber*)value;

- (BOOL)primitiveCustoms_availableValue;
- (void)setPrimitiveCustoms_availableValue:(BOOL)value_;




- (NSNumber*)primitiveElevation_qty;
- (void)setPrimitiveElevation_qty:(NSNumber*)value;

- (int16_t)primitiveElevation_qtyValue;
- (void)setPrimitiveElevation_qtyValue:(int16_t)value_;




- (NSNumber*)primitiveFuel_available;
- (void)setPrimitiveFuel_available:(NSNumber*)value;

- (BOOL)primitiveFuel_availableValue;
- (void)setPrimitiveFuel_availableValue:(BOOL)value_;




- (NSString*)primitiveIata_cd;
- (void)setPrimitiveIata_cd:(NSString*)value;




- (NSNumber*)primitiveInstrument_approach_flag;
- (void)setPrimitiveInstrument_approach_flag:(NSNumber*)value;

- (BOOL)primitiveInstrument_approach_flagValue;
- (void)setPrimitiveInstrument_approach_flagValue:(BOOL)value_;




- (NSDecimalNumber*)primitiveLatitude_qty;
- (void)setPrimitiveLatitude_qty:(NSDecimalNumber*)value;




- (NSNumber*)primitiveLongest_runway_length_qty;
- (void)setPrimitiveLongest_runway_length_qty:(NSNumber*)value;

- (int16_t)primitiveLongest_runway_length_qtyValue;
- (void)setPrimitiveLongest_runway_length_qtyValue:(int16_t)value_;




- (NSDecimalNumber*)primitiveLongitude_qty;
- (void)setPrimitiveLongitude_qty:(NSDecimalNumber*)value;




- (NSNumber*)primitiveSlots_required;
- (void)setPrimitiveSlots_required:(NSNumber*)value;

- (BOOL)primitiveSlots_requiredValue;
- (void)setPrimitiveSlots_requiredValue:(BOOL)value_;




- (NSString*)primitiveState_cd;
- (void)setPrimitiveState_cd:(NSString*)value;




- (NSString*)primitiveTimezone_cd;
- (void)setPrimitiveTimezone_cd:(NSString*)value;




@end
