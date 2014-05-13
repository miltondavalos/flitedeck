// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDMasterContractRate.m instead.

#import "_NFDMasterContractRate.h"

const struct NFDMasterContractRateAttributes NFDMasterContractRateAttributes = {
	.companyID = @"companyID",
};

const struct NFDMasterContractRateRelationships NFDMasterContractRateRelationships = {
};

const struct NFDMasterContractRateFetchedProperties NFDMasterContractRateFetchedProperties = {
};

@implementation NFDMasterContractRateID
@end

@implementation _NFDMasterContractRate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MasterContractRate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MasterContractRate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MasterContractRate" inManagedObjectContext:moc_];
}

- (NFDMasterContractRateID*)objectID {
	return (NFDMasterContractRateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic companyID;











@end
