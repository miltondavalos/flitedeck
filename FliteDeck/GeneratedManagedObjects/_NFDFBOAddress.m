// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDFBOAddress.m instead.

#import "_NFDFBOAddress.h"

const struct NFDFBOAddressAttributes NFDFBOAddressAttributes = {
	.address_id = @"address_id",
	.address_line1_txt = @"address_line1_txt",
	.address_line2_txt = @"address_line2_txt",
	.address_line3_txt = @"address_line3_txt",
	.address_line4_txt = @"address_line4_txt",
	.address_line5_txt = @"address_line5_txt",
	.city_name = @"city_name",
	.country_cd = @"country_cd",
	.fbo_id = @"fbo_id",
	.postal_cd = @"postal_cd",
	.state_province_name = @"state_province_name",
	.sys_last_changed_ts = @"sys_last_changed_ts",
};

const struct NFDFBOAddressRelationships NFDFBOAddressRelationships = {
	.fboAddressParent = @"fboAddressParent",
};

const struct NFDFBOAddressFetchedProperties NFDFBOAddressFetchedProperties = {
};

@implementation NFDFBOAddressID
@end

@implementation _NFDFBOAddress

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FBOAddress" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FBOAddress";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FBOAddress" inManagedObjectContext:moc_];
}

- (NFDFBOAddressID*)objectID {
	return (NFDFBOAddressID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"address_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"address_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"fbo_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fbo_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic address_id;



- (int32_t)address_idValue {
	NSNumber *result = [self address_id];
	return [result intValue];
}

- (void)setAddress_idValue:(int32_t)value_ {
	[self setAddress_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveAddress_idValue {
	NSNumber *result = [self primitiveAddress_id];
	return [result intValue];
}

- (void)setPrimitiveAddress_idValue:(int32_t)value_ {
	[self setPrimitiveAddress_id:[NSNumber numberWithInt:value_]];
}





@dynamic address_line1_txt;






@dynamic address_line2_txt;






@dynamic address_line3_txt;






@dynamic address_line4_txt;






@dynamic address_line5_txt;






@dynamic city_name;






@dynamic country_cd;






@dynamic fbo_id;



- (int32_t)fbo_idValue {
	NSNumber *result = [self fbo_id];
	return [result intValue];
}

- (void)setFbo_idValue:(int32_t)value_ {
	[self setFbo_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFbo_idValue {
	NSNumber *result = [self primitiveFbo_id];
	return [result intValue];
}

- (void)setPrimitiveFbo_idValue:(int32_t)value_ {
	[self setPrimitiveFbo_id:[NSNumber numberWithInt:value_]];
}





@dynamic postal_cd;






@dynamic state_province_name;






@dynamic sys_last_changed_ts;






@dynamic fboAddressParent;

	






@end
