// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDCompany.m instead.

#import "_NFDCompany.h"

const struct NFDCompanyAttributes NFDCompanyAttributes = {
	.company_id = @"company_id",
	.competitive_analysis = @"competitive_analysis",
	.general_info = @"general_info",
	.name = @"name",
	.type = @"type",
};

const struct NFDCompanyRelationships NFDCompanyRelationships = {
};

const struct NFDCompanyFetchedProperties NFDCompanyFetchedProperties = {
};

@implementation NFDCompanyID
@end

@implementation _NFDCompany

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Company";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Company" inManagedObjectContext:moc_];
}

- (NFDCompanyID*)objectID {
	return (NFDCompanyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic company_id;






@dynamic competitive_analysis;






@dynamic general_info;






@dynamic name;






@dynamic type;











@end
