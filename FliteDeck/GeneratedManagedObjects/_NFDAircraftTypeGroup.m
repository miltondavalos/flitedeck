// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAircraftTypeGroup.m instead.

#import "_NFDAircraftTypeGroup.h"

const struct NFDAircraftTypeGroupAttributes NFDAircraftTypeGroupAttributes = {
	.acPerformanceTypeName = @"acPerformanceTypeName",
	.baggageCapacity = @"baggageCapacity",
	.cabinHeight = @"cabinHeight",
	.cabinWidth = @"cabinWidth",
	.displayOrder = @"displayOrder",
	.highCruiseSpeed = @"highCruiseSpeed",
	.manufacturer = @"manufacturer",
	.numberOfPax = @"numberOfPax",
	.range = @"range",
	.typeGroupName = @"typeGroupName",
	.warnings = @"warnings",
};

const struct NFDAircraftTypeGroupRelationships NFDAircraftTypeGroupRelationships = {
};

const struct NFDAircraftTypeGroupFetchedProperties NFDAircraftTypeGroupFetchedProperties = {
};

@implementation NFDAircraftTypeGroupID
@end

@implementation _NFDAircraftTypeGroup

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AircraftTypeGroup" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AircraftTypeGroup";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AircraftTypeGroup" inManagedObjectContext:moc_];
}

- (NFDAircraftTypeGroupID*)objectID {
	return (NFDAircraftTypeGroupID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"displayOrderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"displayOrder"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic acPerformanceTypeName;






@dynamic baggageCapacity;






@dynamic cabinHeight;






@dynamic cabinWidth;






@dynamic displayOrder;



- (int16_t)displayOrderValue {
	NSNumber *result = [self displayOrder];
	return [result shortValue];
}

- (void)setDisplayOrderValue:(int16_t)value_ {
	[self setDisplayOrder:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveDisplayOrderValue {
	NSNumber *result = [self primitiveDisplayOrder];
	return [result shortValue];
}

- (void)setPrimitiveDisplayOrderValue:(int16_t)value_ {
	[self setPrimitiveDisplayOrder:[NSNumber numberWithShort:value_]];
}





@dynamic highCruiseSpeed;






@dynamic manufacturer;






@dynamic numberOfPax;






@dynamic range;






@dynamic typeGroupName;






@dynamic warnings;











@end
