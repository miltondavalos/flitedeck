// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAirport.m instead.

#import "_NFDAirport.h"

const struct NFDAirportAttributes NFDAirportAttributes = {
	.airport_name = @"airport_name",
	.airportid = @"airportid",
	.city_name = @"city_name",
	.closest_airportid = @"closest_airportid",
	.country_cd = @"country_cd",
	.customs_available = @"customs_available",
	.elevation_qty = @"elevation_qty",
	.fuel_available = @"fuel_available",
	.iata_cd = @"iata_cd",
	.instrument_approach_flag = @"instrument_approach_flag",
	.latitude_qty = @"latitude_qty",
	.longest_runway_length_qty = @"longest_runway_length_qty",
	.longitude_qty = @"longitude_qty",
	.slots_required = @"slots_required",
	.state_cd = @"state_cd",
	.timezone_cd = @"timezone_cd",
};

const struct NFDAirportRelationships NFDAirportRelationships = {
};

const struct NFDAirportFetchedProperties NFDAirportFetchedProperties = {
};

@implementation NFDAirportID
@end

@implementation _NFDAirport

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Airport" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Airport";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Airport" inManagedObjectContext:moc_];
}

- (NFDAirportID*)objectID {
	return (NFDAirportID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"customs_availableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"customs_available"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"elevation_qtyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"elevation_qty"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"fuel_availableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fuel_available"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"instrument_approach_flagValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"instrument_approach_flag"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longest_runway_length_qtyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longest_runway_length_qty"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"slots_requiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"slots_required"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic airport_name;






@dynamic airportid;






@dynamic city_name;






@dynamic closest_airportid;






@dynamic country_cd;






@dynamic customs_available;



- (BOOL)customs_availableValue {
	NSNumber *result = [self customs_available];
	return [result boolValue];
}

- (void)setCustoms_availableValue:(BOOL)value_ {
	[self setCustoms_available:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveCustoms_availableValue {
	NSNumber *result = [self primitiveCustoms_available];
	return [result boolValue];
}

- (void)setPrimitiveCustoms_availableValue:(BOOL)value_ {
	[self setPrimitiveCustoms_available:[NSNumber numberWithBool:value_]];
}





@dynamic elevation_qty;



- (int16_t)elevation_qtyValue {
	NSNumber *result = [self elevation_qty];
	return [result shortValue];
}

- (void)setElevation_qtyValue:(int16_t)value_ {
	[self setElevation_qty:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveElevation_qtyValue {
	NSNumber *result = [self primitiveElevation_qty];
	return [result shortValue];
}

- (void)setPrimitiveElevation_qtyValue:(int16_t)value_ {
	[self setPrimitiveElevation_qty:[NSNumber numberWithShort:value_]];
}





@dynamic fuel_available;



- (BOOL)fuel_availableValue {
	NSNumber *result = [self fuel_available];
	return [result boolValue];
}

- (void)setFuel_availableValue:(BOOL)value_ {
	[self setFuel_available:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFuel_availableValue {
	NSNumber *result = [self primitiveFuel_available];
	return [result boolValue];
}

- (void)setPrimitiveFuel_availableValue:(BOOL)value_ {
	[self setPrimitiveFuel_available:[NSNumber numberWithBool:value_]];
}





@dynamic iata_cd;






@dynamic instrument_approach_flag;



- (BOOL)instrument_approach_flagValue {
	NSNumber *result = [self instrument_approach_flag];
	return [result boolValue];
}

- (void)setInstrument_approach_flagValue:(BOOL)value_ {
	[self setInstrument_approach_flag:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveInstrument_approach_flagValue {
	NSNumber *result = [self primitiveInstrument_approach_flag];
	return [result boolValue];
}

- (void)setPrimitiveInstrument_approach_flagValue:(BOOL)value_ {
	[self setPrimitiveInstrument_approach_flag:[NSNumber numberWithBool:value_]];
}





@dynamic latitude_qty;






@dynamic longest_runway_length_qty;



- (int16_t)longest_runway_length_qtyValue {
	NSNumber *result = [self longest_runway_length_qty];
	return [result shortValue];
}

- (void)setLongest_runway_length_qtyValue:(int16_t)value_ {
	[self setLongest_runway_length_qty:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLongest_runway_length_qtyValue {
	NSNumber *result = [self primitiveLongest_runway_length_qty];
	return [result shortValue];
}

- (void)setPrimitiveLongest_runway_length_qtyValue:(int16_t)value_ {
	[self setPrimitiveLongest_runway_length_qty:[NSNumber numberWithShort:value_]];
}





@dynamic longitude_qty;






@dynamic slots_required;



- (BOOL)slots_requiredValue {
	NSNumber *result = [self slots_required];
	return [result boolValue];
}

- (void)setSlots_requiredValue:(BOOL)value_ {
	[self setSlots_required:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSlots_requiredValue {
	NSNumber *result = [self primitiveSlots_required];
	return [result boolValue];
}

- (void)setPrimitiveSlots_requiredValue:(BOOL)value_ {
	[self setPrimitiveSlots_required:[NSNumber numberWithBool:value_]];
}





@dynamic state_cd;






@dynamic timezone_cd;











@end
