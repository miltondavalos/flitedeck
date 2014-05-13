// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDEventMedia.m instead.

#import "_NFDEventMedia.h"

const struct NFDEventMediaAttributes NFDEventMediaAttributes = {
	.event_id = @"event_id",
	.filename = @"filename",
	.groupSelector = @"groupSelector",
	.mimeType = @"mimeType",
	.typename = @"typename",
};

const struct NFDEventMediaRelationships NFDEventMediaRelationships = {
};

const struct NFDEventMediaFetchedProperties NFDEventMediaFetchedProperties = {
};

@implementation NFDEventMediaID
@end

@implementation _NFDEventMedia

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EventMedia" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EventMedia";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EventMedia" inManagedObjectContext:moc_];
}

- (NFDEventMediaID*)objectID {
	return (NFDEventMediaID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic event_id;






@dynamic filename;






@dynamic groupSelector;






@dynamic mimeType;






@dynamic typename;











@end
