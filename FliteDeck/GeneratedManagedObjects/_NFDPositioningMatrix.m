// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDPositioningMatrix.m instead.

#import "_NFDPositioningMatrix.h"

const struct NFDPositioningMatrixAttributes NFDPositioningMatrixAttributes = {
	.accost = @"accost",
	.acname = @"acname",
	.acpassengers = @"acpassengers",
	.acrange = @"acrange",
	.acshortname = @"acshortname",
	.acspeed = @"acspeed",
	.cabintype = @"cabintype",
	.comparableac = @"comparableac",
	.detailslink = @"detailslink",
	.fleetname = @"fleetname",
	.typename = @"typename",
};

const struct NFDPositioningMatrixRelationships NFDPositioningMatrixRelationships = {
};

const struct NFDPositioningMatrixFetchedProperties NFDPositioningMatrixFetchedProperties = {
};

@implementation NFDPositioningMatrixID
@end

@implementation _NFDPositioningMatrix

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PositioningMatrix" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PositioningMatrix";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PositioningMatrix" inManagedObjectContext:moc_];
}

- (NFDPositioningMatrixID*)objectID {
	return (NFDPositioningMatrixID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic accost;






@dynamic acname;






@dynamic acpassengers;






@dynamic acrange;






@dynamic acshortname;






@dynamic acspeed;






@dynamic cabintype;






@dynamic comparableac;






@dynamic detailslink;






@dynamic fleetname;






@dynamic typename;











@end
