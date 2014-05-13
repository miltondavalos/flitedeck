// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDEventInformation.m instead.

#import "_NFDEventInformation.h"

const struct NFDEventInformationAttributes NFDEventInformationAttributes = {
	.category = @"category",
	.end_date = @"end_date",
	.event_description = @"event_description",
	.event_id = @"event_id",
	.location = @"location",
	.media = @"media",
	.name = @"name",
	.start_date = @"start_date",
};

const struct NFDEventInformationRelationships NFDEventInformationRelationships = {
};

const struct NFDEventInformationFetchedProperties NFDEventInformationFetchedProperties = {
};

@implementation NFDEventInformationID
@end

@implementation _NFDEventInformation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EventInformation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EventInformation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EventInformation" inManagedObjectContext:moc_];
}

- (NFDEventInformationID*)objectID {
	return (NFDEventInformationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic category;






@dynamic end_date;






@dynamic event_description;






@dynamic event_id;






@dynamic location;






@dynamic media;






@dynamic name;






@dynamic start_date;











@end
