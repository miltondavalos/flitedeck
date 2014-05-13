// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDMasterAircraftType.m instead.

#import "_NFDMasterAircraftType.h"

const struct NFDMasterAircraftTypeAttributes NFDMasterAircraftTypeAttributes = {
	.typeGroupNameForNJA = @"typeGroupNameForNJA",
	.typeGroupNameForNJE = @"typeGroupNameForNJE",
};

const struct NFDMasterAircraftTypeRelationships NFDMasterAircraftTypeRelationships = {
};

const struct NFDMasterAircraftTypeFetchedProperties NFDMasterAircraftTypeFetchedProperties = {
};

@implementation NFDMasterAircraftTypeID
@end

@implementation _NFDMasterAircraftType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MasterAircraftType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MasterAircraftType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MasterAircraftType" inManagedObjectContext:moc_];
}

- (NFDMasterAircraftTypeID*)objectID {
	return (NFDMasterAircraftTypeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic typeGroupNameForNJA;






@dynamic typeGroupNameForNJE;











@end
