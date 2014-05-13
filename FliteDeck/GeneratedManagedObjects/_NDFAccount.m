// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NDFAccount.m instead.

#import "_NDFAccount.h"

const struct NDFAccountAttributes NDFAccountAttributes = {
	.account_id = @"account_id",
	.account_name = @"account_name",
};

const struct NDFAccountRelationships NDFAccountRelationships = {
};

const struct NDFAccountFetchedProperties NDFAccountFetchedProperties = {
};

@implementation NDFAccountID
@end

@implementation _NDFAccount

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Account";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Account" inManagedObjectContext:moc_];
}

- (NDFAccountID*)objectID {
	return (NDFAccountID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"account_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"account_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic account_id;



- (int32_t)account_idValue {
	NSNumber *result = [self account_id];
	return [result intValue];
}

- (void)setAccount_idValue:(int32_t)value_ {
	[self setAccount_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveAccount_idValue {
	NSNumber *result = [self primitiveAccount_id];
	return [result intValue];
}

- (void)setPrimitiveAccount_idValue:(int32_t)value_ {
	[self setPrimitiveAccount_id:[NSNumber numberWithInt:value_]];
}





@dynamic account_name;











@end
