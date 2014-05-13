// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAircraftTypeRestriction.m instead.

#import "_NFDAircraftTypeRestriction.h"

const struct NFDAircraftTypeRestrictionAttributes NFDAircraftTypeRestrictionAttributes = {
	.aircraftRestrictionID = @"aircraftRestrictionID",
	.airportID = @"airportID",
	.approvalStatusID = @"approvalStatusID",
	.comments = @"comments",
	.isForLanding = @"isForLanding",
	.isForTakeoff = @"isForTakeoff",
	.restrictionType = @"restrictionType",
	.typeName = @"typeName",
};

const struct NFDAircraftTypeRestrictionRelationships NFDAircraftTypeRestrictionRelationships = {
};

const struct NFDAircraftTypeRestrictionFetchedProperties NFDAircraftTypeRestrictionFetchedProperties = {
};

@implementation NFDAircraftTypeRestrictionID
@end

@implementation _NFDAircraftTypeRestriction

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AircraftTypeRestriction" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AircraftTypeRestriction";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AircraftTypeRestriction" inManagedObjectContext:moc_];
}

- (NFDAircraftTypeRestrictionID*)objectID {
	return (NFDAircraftTypeRestrictionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"aircraftRestrictionIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"aircraftRestrictionID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"approvalStatusIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"approvalStatusID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isForLandingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isForLanding"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isForTakeoffValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isForTakeoff"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic aircraftRestrictionID;



- (int32_t)aircraftRestrictionIDValue {
	NSNumber *result = [self aircraftRestrictionID];
	return [result intValue];
}

- (void)setAircraftRestrictionIDValue:(int32_t)value_ {
	[self setAircraftRestrictionID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveAircraftRestrictionIDValue {
	NSNumber *result = [self primitiveAircraftRestrictionID];
	return [result intValue];
}

- (void)setPrimitiveAircraftRestrictionIDValue:(int32_t)value_ {
	[self setPrimitiveAircraftRestrictionID:[NSNumber numberWithInt:value_]];
}





@dynamic airportID;






@dynamic approvalStatusID;



- (int16_t)approvalStatusIDValue {
	NSNumber *result = [self approvalStatusID];
	return [result shortValue];
}

- (void)setApprovalStatusIDValue:(int16_t)value_ {
	[self setApprovalStatusID:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveApprovalStatusIDValue {
	NSNumber *result = [self primitiveApprovalStatusID];
	return [result shortValue];
}

- (void)setPrimitiveApprovalStatusIDValue:(int16_t)value_ {
	[self setPrimitiveApprovalStatusID:[NSNumber numberWithShort:value_]];
}





@dynamic comments;






@dynamic isForLanding;



- (BOOL)isForLandingValue {
	NSNumber *result = [self isForLanding];
	return [result boolValue];
}

- (void)setIsForLandingValue:(BOOL)value_ {
	[self setIsForLanding:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsForLandingValue {
	NSNumber *result = [self primitiveIsForLanding];
	return [result boolValue];
}

- (void)setPrimitiveIsForLandingValue:(BOOL)value_ {
	[self setPrimitiveIsForLanding:[NSNumber numberWithBool:value_]];
}





@dynamic isForTakeoff;



- (BOOL)isForTakeoffValue {
	NSNumber *result = [self isForTakeoff];
	return [result boolValue];
}

- (void)setIsForTakeoffValue:(BOOL)value_ {
	[self setIsForTakeoff:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsForTakeoffValue {
	NSNumber *result = [self primitiveIsForTakeoff];
	return [result boolValue];
}

- (void)setPrimitiveIsForTakeoffValue:(BOOL)value_ {
	[self setPrimitiveIsForTakeoff:[NSNumber numberWithBool:value_]];
}





@dynamic restrictionType;






@dynamic typeName;











@end
