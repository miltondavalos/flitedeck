// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAircraftType.m instead.

#import "_NFDAircraftType.h"

const struct NFDAircraftTypeAttributes NFDAircraftTypeAttributes = {
	.cabinSize = @"cabinSize",
	.displayName = @"displayName",
	.displayOrder = @"displayOrder",
	.highCruiseSpeed = @"highCruiseSpeed",
	.lastChanged = @"lastChanged",
	.maxFlyingTime = @"maxFlyingTime",
	.minRunwayLength = @"minRunwayLength",
	.numberOfPax = @"numberOfPax",
	.typeFullName = @"typeFullName",
	.typeGroupName = @"typeGroupName",
	.typeName = @"typeName",
};

const struct NFDAircraftTypeRelationships NFDAircraftTypeRelationships = {
	.contractRate = @"contractRate",
	.fuelRate = @"fuelRate",
};

const struct NFDAircraftTypeFetchedProperties NFDAircraftTypeFetchedProperties = {
};

@implementation NFDAircraftTypeID
@end

@implementation _NFDAircraftType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AircraftType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AircraftType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AircraftType" inManagedObjectContext:moc_];
}

- (NFDAircraftTypeID*)objectID {
	return (NFDAircraftTypeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic cabinSize;






@dynamic displayName;






@dynamic displayOrder;






@dynamic highCruiseSpeed;






@dynamic lastChanged;






@dynamic maxFlyingTime;






@dynamic minRunwayLength;






@dynamic numberOfPax;






@dynamic typeFullName;






@dynamic typeGroupName;






@dynamic typeName;






@dynamic contractRate;

	

@dynamic fuelRate;

	






@end
