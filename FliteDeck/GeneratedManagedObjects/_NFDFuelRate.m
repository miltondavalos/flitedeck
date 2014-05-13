// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDFuelRate.m instead.

#import "_NFDFuelRate.h"

const struct NFDFuelRateAttributes NFDFuelRateAttributes = {
	.nonQualified12MonthRate = @"nonQualified12MonthRate",
	.nonQualified1MonthRate = @"nonQualified1MonthRate",
	.nonQualified3MonthRate = @"nonQualified3MonthRate",
	.nonQualified6MonthRate = @"nonQualified6MonthRate",
	.qualified12MonthRate = @"qualified12MonthRate",
	.qualified1MonthRate = @"qualified1MonthRate",
	.qualified3MonthRate = @"qualified3MonthRate",
	.qualified6MonthRate = @"qualified6MonthRate",
	.typeName = @"typeName",
};

const struct NFDFuelRateRelationships NFDFuelRateRelationships = {
	.aircraftType = @"aircraftType",
};

const struct NFDFuelRateFetchedProperties NFDFuelRateFetchedProperties = {
};

@implementation NFDFuelRateID
@end

@implementation _NFDFuelRate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FuelRate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FuelRate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FuelRate" inManagedObjectContext:moc_];
}

- (NFDFuelRateID*)objectID {
	return (NFDFuelRateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"nonQualified12MonthRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"nonQualified12MonthRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"nonQualified1MonthRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"nonQualified1MonthRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"nonQualified3MonthRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"nonQualified3MonthRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"nonQualified6MonthRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"nonQualified6MonthRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"qualified12MonthRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"qualified12MonthRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"qualified1MonthRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"qualified1MonthRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"qualified3MonthRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"qualified3MonthRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"qualified6MonthRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"qualified6MonthRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic nonQualified12MonthRate;



- (int16_t)nonQualified12MonthRateValue {
	NSNumber *result = [self nonQualified12MonthRate];
	return [result shortValue];
}

- (void)setNonQualified12MonthRateValue:(int16_t)value_ {
	[self setNonQualified12MonthRate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNonQualified12MonthRateValue {
	NSNumber *result = [self primitiveNonQualified12MonthRate];
	return [result shortValue];
}

- (void)setPrimitiveNonQualified12MonthRateValue:(int16_t)value_ {
	[self setPrimitiveNonQualified12MonthRate:[NSNumber numberWithShort:value_]];
}





@dynamic nonQualified1MonthRate;



- (int16_t)nonQualified1MonthRateValue {
	NSNumber *result = [self nonQualified1MonthRate];
	return [result shortValue];
}

- (void)setNonQualified1MonthRateValue:(int16_t)value_ {
	[self setNonQualified1MonthRate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNonQualified1MonthRateValue {
	NSNumber *result = [self primitiveNonQualified1MonthRate];
	return [result shortValue];
}

- (void)setPrimitiveNonQualified1MonthRateValue:(int16_t)value_ {
	[self setPrimitiveNonQualified1MonthRate:[NSNumber numberWithShort:value_]];
}





@dynamic nonQualified3MonthRate;



- (int16_t)nonQualified3MonthRateValue {
	NSNumber *result = [self nonQualified3MonthRate];
	return [result shortValue];
}

- (void)setNonQualified3MonthRateValue:(int16_t)value_ {
	[self setNonQualified3MonthRate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNonQualified3MonthRateValue {
	NSNumber *result = [self primitiveNonQualified3MonthRate];
	return [result shortValue];
}

- (void)setPrimitiveNonQualified3MonthRateValue:(int16_t)value_ {
	[self setPrimitiveNonQualified3MonthRate:[NSNumber numberWithShort:value_]];
}





@dynamic nonQualified6MonthRate;



- (int16_t)nonQualified6MonthRateValue {
	NSNumber *result = [self nonQualified6MonthRate];
	return [result shortValue];
}

- (void)setNonQualified6MonthRateValue:(int16_t)value_ {
	[self setNonQualified6MonthRate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNonQualified6MonthRateValue {
	NSNumber *result = [self primitiveNonQualified6MonthRate];
	return [result shortValue];
}

- (void)setPrimitiveNonQualified6MonthRateValue:(int16_t)value_ {
	[self setPrimitiveNonQualified6MonthRate:[NSNumber numberWithShort:value_]];
}





@dynamic qualified12MonthRate;



- (int16_t)qualified12MonthRateValue {
	NSNumber *result = [self qualified12MonthRate];
	return [result shortValue];
}

- (void)setQualified12MonthRateValue:(int16_t)value_ {
	[self setQualified12MonthRate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveQualified12MonthRateValue {
	NSNumber *result = [self primitiveQualified12MonthRate];
	return [result shortValue];
}

- (void)setPrimitiveQualified12MonthRateValue:(int16_t)value_ {
	[self setPrimitiveQualified12MonthRate:[NSNumber numberWithShort:value_]];
}





@dynamic qualified1MonthRate;



- (int16_t)qualified1MonthRateValue {
	NSNumber *result = [self qualified1MonthRate];
	return [result shortValue];
}

- (void)setQualified1MonthRateValue:(int16_t)value_ {
	[self setQualified1MonthRate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveQualified1MonthRateValue {
	NSNumber *result = [self primitiveQualified1MonthRate];
	return [result shortValue];
}

- (void)setPrimitiveQualified1MonthRateValue:(int16_t)value_ {
	[self setPrimitiveQualified1MonthRate:[NSNumber numberWithShort:value_]];
}





@dynamic qualified3MonthRate;



- (int16_t)qualified3MonthRateValue {
	NSNumber *result = [self qualified3MonthRate];
	return [result shortValue];
}

- (void)setQualified3MonthRateValue:(int16_t)value_ {
	[self setQualified3MonthRate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveQualified3MonthRateValue {
	NSNumber *result = [self primitiveQualified3MonthRate];
	return [result shortValue];
}

- (void)setPrimitiveQualified3MonthRateValue:(int16_t)value_ {
	[self setPrimitiveQualified3MonthRate:[NSNumber numberWithShort:value_]];
}





@dynamic qualified6MonthRate;



- (int16_t)qualified6MonthRateValue {
	NSNumber *result = [self qualified6MonthRate];
	return [result shortValue];
}

- (void)setQualified6MonthRateValue:(int16_t)value_ {
	[self setQualified6MonthRate:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveQualified6MonthRateValue {
	NSNumber *result = [self primitiveQualified6MonthRate];
	return [result shortValue];
}

- (void)setPrimitiveQualified6MonthRateValue:(int16_t)value_ {
	[self setPrimitiveQualified6MonthRate:[NSNumber numberWithShort:value_]];
}





@dynamic typeName;






@dynamic aircraftType;

	






@end
