// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDMasterFuelRate.m instead.

#import "_NFDMasterFuelRate.h"

const struct NFDMasterFuelRateAttributes NFDMasterFuelRateAttributes = {
	.companyID = @"companyID",
};

const struct NFDMasterFuelRateRelationships NFDMasterFuelRateRelationships = {
};

const struct NFDMasterFuelRateFetchedProperties NFDMasterFuelRateFetchedProperties = {
};

@implementation NFDMasterFuelRateID
@end

@implementation _NFDMasterFuelRate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MasterFuelRate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MasterFuelRate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MasterFuelRate" inManagedObjectContext:moc_];
}

- (NFDMasterFuelRateID*)objectID {
	return (NFDMasterFuelRateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic companyID;











@end
