// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAircraftInventory.m instead.

#import "_NFDAircraftInventory.h"

const struct NFDAircraftInventoryAttributes NFDAircraftInventoryAttributes = {
	.anticipated_delivery_date = @"anticipated_delivery_date",
	.contracts_until_date = @"contracts_until_date",
	.legal_name = @"legal_name",
	.sales_value = @"sales_value",
	.serial = @"serial",
	.share_immediately_available = @"share_immediately_available",
	.tail = @"tail",
	.type = @"type",
	.year = @"year",
};

const struct NFDAircraftInventoryRelationships NFDAircraftInventoryRelationships = {
};

const struct NFDAircraftInventoryFetchedProperties NFDAircraftInventoryFetchedProperties = {
};

@implementation NFDAircraftInventoryID
@end

@implementation _NFDAircraftInventory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AircraftInventory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AircraftInventory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AircraftInventory" inManagedObjectContext:moc_];
}

- (NFDAircraftInventoryID*)objectID {
	return (NFDAircraftInventoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic anticipated_delivery_date;






@dynamic contracts_until_date;






@dynamic legal_name;






@dynamic sales_value;






@dynamic serial;






@dynamic share_immediately_available;






@dynamic tail;






@dynamic type;






@dynamic year;











@end
