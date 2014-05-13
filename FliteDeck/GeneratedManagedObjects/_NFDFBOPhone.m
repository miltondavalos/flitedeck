// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDFBOPhone.m instead.

#import "_NFDFBOPhone.h"

const struct NFDFBOPhoneAttributes NFDFBOPhoneAttributes = {
	.area_code_txt = @"area_code_txt",
	.country_code_txt = @"country_code_txt",
	.fbo_id = @"fbo_id",
	.sys_last_changed_ts = @"sys_last_changed_ts",
	.telephone_id = @"telephone_id",
	.telephone_nbr_txt = @"telephone_nbr_txt",
};

const struct NFDFBOPhoneRelationships NFDFBOPhoneRelationships = {
	.fboPhoneParent = @"fboPhoneParent",
};

const struct NFDFBOPhoneFetchedProperties NFDFBOPhoneFetchedProperties = {
};

@implementation NFDFBOPhoneID
@end

@implementation _NFDFBOPhone

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FBOPhone" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FBOPhone";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FBOPhone" inManagedObjectContext:moc_];
}

- (NFDFBOPhoneID*)objectID {
	return (NFDFBOPhoneID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"fbo_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fbo_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"telephone_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"telephone_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic area_code_txt;






@dynamic country_code_txt;






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





@dynamic sys_last_changed_ts;






@dynamic telephone_id;



- (int32_t)telephone_idValue {
	NSNumber *result = [self telephone_id];
	return [result intValue];
}

- (void)setTelephone_idValue:(int32_t)value_ {
	[self setTelephone_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTelephone_idValue {
	NSNumber *result = [self primitiveTelephone_id];
	return [result intValue];
}

- (void)setPrimitiveTelephone_idValue:(int32_t)value_ {
	[self setPrimitiveTelephone_id:[NSNumber numberWithInt:value_]];
}





@dynamic telephone_nbr_txt;






@dynamic fboPhoneParent;

	






@end
