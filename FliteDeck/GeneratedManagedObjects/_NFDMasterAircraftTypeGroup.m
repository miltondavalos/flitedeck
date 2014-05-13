// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDMasterAircraftTypeGroup.m instead.

#import "_NFDMasterAircraftTypeGroup.h"

const struct NFDMasterAircraftTypeGroupAttributes NFDMasterAircraftTypeGroupAttributes = {
	.typeGroupNameForNJA = @"typeGroupNameForNJA",
	.typeGroupNameForNJE = @"typeGroupNameForNJE",
};

const struct NFDMasterAircraftTypeGroupRelationships NFDMasterAircraftTypeGroupRelationships = {
};

const struct NFDMasterAircraftTypeGroupFetchedProperties NFDMasterAircraftTypeGroupFetchedProperties = {
};

@implementation NFDMasterAircraftTypeGroupID
@end

@implementation _NFDMasterAircraftTypeGroup

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MasterAircraftTypeGroup" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MasterAircraftTypeGroup";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MasterAircraftTypeGroup" inManagedObjectContext:moc_];
}

- (NFDMasterAircraftTypeGroupID*)objectID {
	return (NFDMasterAircraftTypeGroupID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic typeGroupNameForNJA;






@dynamic typeGroupNameForNJE;











@end
