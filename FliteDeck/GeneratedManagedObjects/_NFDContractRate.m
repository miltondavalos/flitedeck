// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDContractRate.m instead.

#import "_NFDContractRate.h"

const struct NFDContractRateAttributes NFDContractRateAttributes = {
	.acquisitionCost = @"acquisitionCost",
	.californiaFee = @"californiaFee",
	.cardHalfPremium = @"cardHalfPremium",
	.cardPurchase25Hour = @"cardPurchase25Hour",
	.cardPurchase50Hour = @"cardPurchase50Hour",
	.demoOccupiedHourlyFee = @"demoOccupiedHourlyFee",
	.lease12MonthFee = @"lease12MonthFee",
	.lease24MonthFee = @"lease24MonthFee",
	.lease36MonthFee = @"lease36MonthFee",
	.lease48MonthFee = @"lease48MonthFee",
	.lease60MonthFee = @"lease60MonthFee",
	.leaseMonthlyMgmtFee = @"leaseMonthlyMgmtFee",
	.leaseOccupiedHourlyFee = @"leaseOccupiedHourlyFee",
	.shareMonthlyMgmtFee = @"shareMonthlyMgmtFee",
	.shareMonthlyMgmtFeeAccel1 = @"shareMonthlyMgmtFeeAccel1",
	.shareMonthlyMgmtFeePremium = @"shareMonthlyMgmtFeePremium",
	.shareOccupiedHourlyFee = @"shareOccupiedHourlyFee",
	.shareOccupiedHourlyFeeAccel1 = @"shareOccupiedHourlyFeeAccel1",
	.shareOccupiedHourlyFeeAccel2 = @"shareOccupiedHourlyFeeAccel2",
	.shareOccupiedHourlyFeeAccel3 = @"shareOccupiedHourlyFeeAccel3",
	.typeGroupName = @"typeGroupName",
};

const struct NFDContractRateRelationships NFDContractRateRelationships = {
	.aircraftTypes = @"aircraftTypes",
};

const struct NFDContractRateFetchedProperties NFDContractRateFetchedProperties = {
};

@implementation NFDContractRateID
@end

@implementation _NFDContractRate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ContractRate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ContractRate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ContractRate" inManagedObjectContext:moc_];
}

- (NFDContractRateID*)objectID {
	return (NFDContractRateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"acquisitionCostValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"acquisitionCost"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"californiaFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"californiaFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"cardHalfPremiumValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"cardHalfPremium"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"cardPurchase25HourValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"cardPurchase25Hour"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"cardPurchase50HourValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"cardPurchase50Hour"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"demoOccupiedHourlyFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"demoOccupiedHourlyFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lease12MonthFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lease12MonthFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lease24MonthFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lease24MonthFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lease36MonthFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lease36MonthFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lease48MonthFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lease48MonthFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lease60MonthFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lease60MonthFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"leaseMonthlyMgmtFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"leaseMonthlyMgmtFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"leaseOccupiedHourlyFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"leaseOccupiedHourlyFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shareMonthlyMgmtFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shareMonthlyMgmtFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shareMonthlyMgmtFeeAccel1Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shareMonthlyMgmtFeeAccel1"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shareMonthlyMgmtFeePremiumValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shareMonthlyMgmtFeePremium"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shareOccupiedHourlyFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shareOccupiedHourlyFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shareOccupiedHourlyFeeAccel1Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shareOccupiedHourlyFeeAccel1"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shareOccupiedHourlyFeeAccel2Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shareOccupiedHourlyFeeAccel2"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shareOccupiedHourlyFeeAccel3Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shareOccupiedHourlyFeeAccel3"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic acquisitionCost;



- (int32_t)acquisitionCostValue {
	NSNumber *result = [self acquisitionCost];
	return [result intValue];
}

- (void)setAcquisitionCostValue:(int32_t)value_ {
	[self setAcquisitionCost:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveAcquisitionCostValue {
	NSNumber *result = [self primitiveAcquisitionCost];
	return [result intValue];
}

- (void)setPrimitiveAcquisitionCostValue:(int32_t)value_ {
	[self setPrimitiveAcquisitionCost:[NSNumber numberWithInt:value_]];
}





@dynamic californiaFee;



- (int16_t)californiaFeeValue {
	NSNumber *result = [self californiaFee];
	return [result shortValue];
}

- (void)setCaliforniaFeeValue:(int16_t)value_ {
	[self setCaliforniaFee:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCaliforniaFeeValue {
	NSNumber *result = [self primitiveCaliforniaFee];
	return [result shortValue];
}

- (void)setPrimitiveCaliforniaFeeValue:(int16_t)value_ {
	[self setPrimitiveCaliforniaFee:[NSNumber numberWithShort:value_]];
}





@dynamic cardHalfPremium;



- (int16_t)cardHalfPremiumValue {
	NSNumber *result = [self cardHalfPremium];
	return [result shortValue];
}

- (void)setCardHalfPremiumValue:(int16_t)value_ {
	[self setCardHalfPremium:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCardHalfPremiumValue {
	NSNumber *result = [self primitiveCardHalfPremium];
	return [result shortValue];
}

- (void)setPrimitiveCardHalfPremiumValue:(int16_t)value_ {
	[self setPrimitiveCardHalfPremium:[NSNumber numberWithShort:value_]];
}





@dynamic cardPurchase25Hour;



- (int32_t)cardPurchase25HourValue {
	NSNumber *result = [self cardPurchase25Hour];
	return [result intValue];
}

- (void)setCardPurchase25HourValue:(int32_t)value_ {
	[self setCardPurchase25Hour:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCardPurchase25HourValue {
	NSNumber *result = [self primitiveCardPurchase25Hour];
	return [result intValue];
}

- (void)setPrimitiveCardPurchase25HourValue:(int32_t)value_ {
	[self setPrimitiveCardPurchase25Hour:[NSNumber numberWithInt:value_]];
}





@dynamic cardPurchase50Hour;



- (int32_t)cardPurchase50HourValue {
	NSNumber *result = [self cardPurchase50Hour];
	return [result intValue];
}

- (void)setCardPurchase50HourValue:(int32_t)value_ {
	[self setCardPurchase50Hour:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCardPurchase50HourValue {
	NSNumber *result = [self primitiveCardPurchase50Hour];
	return [result intValue];
}

- (void)setPrimitiveCardPurchase50HourValue:(int32_t)value_ {
	[self setPrimitiveCardPurchase50Hour:[NSNumber numberWithInt:value_]];
}





@dynamic demoOccupiedHourlyFee;



- (int16_t)demoOccupiedHourlyFeeValue {
	NSNumber *result = [self demoOccupiedHourlyFee];
	return [result shortValue];
}

- (void)setDemoOccupiedHourlyFeeValue:(int16_t)value_ {
	[self setDemoOccupiedHourlyFee:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveDemoOccupiedHourlyFeeValue {
	NSNumber *result = [self primitiveDemoOccupiedHourlyFee];
	return [result shortValue];
}

- (void)setPrimitiveDemoOccupiedHourlyFeeValue:(int16_t)value_ {
	[self setPrimitiveDemoOccupiedHourlyFee:[NSNumber numberWithShort:value_]];
}





@dynamic lease12MonthFee;



- (int32_t)lease12MonthFeeValue {
	NSNumber *result = [self lease12MonthFee];
	return [result intValue];
}

- (void)setLease12MonthFeeValue:(int32_t)value_ {
	[self setLease12MonthFee:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLease12MonthFeeValue {
	NSNumber *result = [self primitiveLease12MonthFee];
	return [result intValue];
}

- (void)setPrimitiveLease12MonthFeeValue:(int32_t)value_ {
	[self setPrimitiveLease12MonthFee:[NSNumber numberWithInt:value_]];
}





@dynamic lease24MonthFee;



- (int32_t)lease24MonthFeeValue {
	NSNumber *result = [self lease24MonthFee];
	return [result intValue];
}

- (void)setLease24MonthFeeValue:(int32_t)value_ {
	[self setLease24MonthFee:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLease24MonthFeeValue {
	NSNumber *result = [self primitiveLease24MonthFee];
	return [result intValue];
}

- (void)setPrimitiveLease24MonthFeeValue:(int32_t)value_ {
	[self setPrimitiveLease24MonthFee:[NSNumber numberWithInt:value_]];
}





@dynamic lease36MonthFee;



- (int32_t)lease36MonthFeeValue {
	NSNumber *result = [self lease36MonthFee];
	return [result intValue];
}

- (void)setLease36MonthFeeValue:(int32_t)value_ {
	[self setLease36MonthFee:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLease36MonthFeeValue {
	NSNumber *result = [self primitiveLease36MonthFee];
	return [result intValue];
}

- (void)setPrimitiveLease36MonthFeeValue:(int32_t)value_ {
	[self setPrimitiveLease36MonthFee:[NSNumber numberWithInt:value_]];
}





@dynamic lease48MonthFee;



- (int32_t)lease48MonthFeeValue {
	NSNumber *result = [self lease48MonthFee];
	return [result intValue];
}

- (void)setLease48MonthFeeValue:(int32_t)value_ {
	[self setLease48MonthFee:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLease48MonthFeeValue {
	NSNumber *result = [self primitiveLease48MonthFee];
	return [result intValue];
}

- (void)setPrimitiveLease48MonthFeeValue:(int32_t)value_ {
	[self setPrimitiveLease48MonthFee:[NSNumber numberWithInt:value_]];
}





@dynamic lease60MonthFee;



- (int32_t)lease60MonthFeeValue {
	NSNumber *result = [self lease60MonthFee];
	return [result intValue];
}

- (void)setLease60MonthFeeValue:(int32_t)value_ {
	[self setLease60MonthFee:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLease60MonthFeeValue {
	NSNumber *result = [self primitiveLease60MonthFee];
	return [result intValue];
}

- (void)setPrimitiveLease60MonthFeeValue:(int32_t)value_ {
	[self setPrimitiveLease60MonthFee:[NSNumber numberWithInt:value_]];
}





@dynamic leaseMonthlyMgmtFee;



- (int32_t)leaseMonthlyMgmtFeeValue {
	NSNumber *result = [self leaseMonthlyMgmtFee];
	return [result intValue];
}

- (void)setLeaseMonthlyMgmtFeeValue:(int32_t)value_ {
	[self setLeaseMonthlyMgmtFee:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLeaseMonthlyMgmtFeeValue {
	NSNumber *result = [self primitiveLeaseMonthlyMgmtFee];
	return [result intValue];
}

- (void)setPrimitiveLeaseMonthlyMgmtFeeValue:(int32_t)value_ {
	[self setPrimitiveLeaseMonthlyMgmtFee:[NSNumber numberWithInt:value_]];
}





@dynamic leaseOccupiedHourlyFee;



- (int16_t)leaseOccupiedHourlyFeeValue {
	NSNumber *result = [self leaseOccupiedHourlyFee];
	return [result shortValue];
}

- (void)setLeaseOccupiedHourlyFeeValue:(int16_t)value_ {
	[self setLeaseOccupiedHourlyFee:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLeaseOccupiedHourlyFeeValue {
	NSNumber *result = [self primitiveLeaseOccupiedHourlyFee];
	return [result shortValue];
}

- (void)setPrimitiveLeaseOccupiedHourlyFeeValue:(int16_t)value_ {
	[self setPrimitiveLeaseOccupiedHourlyFee:[NSNumber numberWithShort:value_]];
}





@dynamic shareMonthlyMgmtFee;



- (int32_t)shareMonthlyMgmtFeeValue {
	NSNumber *result = [self shareMonthlyMgmtFee];
	return [result intValue];
}

- (void)setShareMonthlyMgmtFeeValue:(int32_t)value_ {
	[self setShareMonthlyMgmtFee:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveShareMonthlyMgmtFeeValue {
	NSNumber *result = [self primitiveShareMonthlyMgmtFee];
	return [result intValue];
}

- (void)setPrimitiveShareMonthlyMgmtFeeValue:(int32_t)value_ {
	[self setPrimitiveShareMonthlyMgmtFee:[NSNumber numberWithInt:value_]];
}





@dynamic shareMonthlyMgmtFeeAccel1;



- (int16_t)shareMonthlyMgmtFeeAccel1Value {
	NSNumber *result = [self shareMonthlyMgmtFeeAccel1];
	return [result shortValue];
}

- (void)setShareMonthlyMgmtFeeAccel1Value:(int16_t)value_ {
	[self setShareMonthlyMgmtFeeAccel1:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveShareMonthlyMgmtFeeAccel1Value {
	NSNumber *result = [self primitiveShareMonthlyMgmtFeeAccel1];
	return [result shortValue];
}

- (void)setPrimitiveShareMonthlyMgmtFeeAccel1Value:(int16_t)value_ {
	[self setPrimitiveShareMonthlyMgmtFeeAccel1:[NSNumber numberWithShort:value_]];
}





@dynamic shareMonthlyMgmtFeePremium;



- (int16_t)shareMonthlyMgmtFeePremiumValue {
	NSNumber *result = [self shareMonthlyMgmtFeePremium];
	return [result shortValue];
}

- (void)setShareMonthlyMgmtFeePremiumValue:(int16_t)value_ {
	[self setShareMonthlyMgmtFeePremium:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveShareMonthlyMgmtFeePremiumValue {
	NSNumber *result = [self primitiveShareMonthlyMgmtFeePremium];
	return [result shortValue];
}

- (void)setPrimitiveShareMonthlyMgmtFeePremiumValue:(int16_t)value_ {
	[self setPrimitiveShareMonthlyMgmtFeePremium:[NSNumber numberWithShort:value_]];
}





@dynamic shareOccupiedHourlyFee;



- (int16_t)shareOccupiedHourlyFeeValue {
	NSNumber *result = [self shareOccupiedHourlyFee];
	return [result shortValue];
}

- (void)setShareOccupiedHourlyFeeValue:(int16_t)value_ {
	[self setShareOccupiedHourlyFee:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveShareOccupiedHourlyFeeValue {
	NSNumber *result = [self primitiveShareOccupiedHourlyFee];
	return [result shortValue];
}

- (void)setPrimitiveShareOccupiedHourlyFeeValue:(int16_t)value_ {
	[self setPrimitiveShareOccupiedHourlyFee:[NSNumber numberWithShort:value_]];
}





@dynamic shareOccupiedHourlyFeeAccel1;



- (int16_t)shareOccupiedHourlyFeeAccel1Value {
	NSNumber *result = [self shareOccupiedHourlyFeeAccel1];
	return [result shortValue];
}

- (void)setShareOccupiedHourlyFeeAccel1Value:(int16_t)value_ {
	[self setShareOccupiedHourlyFeeAccel1:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveShareOccupiedHourlyFeeAccel1Value {
	NSNumber *result = [self primitiveShareOccupiedHourlyFeeAccel1];
	return [result shortValue];
}

- (void)setPrimitiveShareOccupiedHourlyFeeAccel1Value:(int16_t)value_ {
	[self setPrimitiveShareOccupiedHourlyFeeAccel1:[NSNumber numberWithShort:value_]];
}





@dynamic shareOccupiedHourlyFeeAccel2;



- (int16_t)shareOccupiedHourlyFeeAccel2Value {
	NSNumber *result = [self shareOccupiedHourlyFeeAccel2];
	return [result shortValue];
}

- (void)setShareOccupiedHourlyFeeAccel2Value:(int16_t)value_ {
	[self setShareOccupiedHourlyFeeAccel2:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveShareOccupiedHourlyFeeAccel2Value {
	NSNumber *result = [self primitiveShareOccupiedHourlyFeeAccel2];
	return [result shortValue];
}

- (void)setPrimitiveShareOccupiedHourlyFeeAccel2Value:(int16_t)value_ {
	[self setPrimitiveShareOccupiedHourlyFeeAccel2:[NSNumber numberWithShort:value_]];
}





@dynamic shareOccupiedHourlyFeeAccel3;



- (int16_t)shareOccupiedHourlyFeeAccel3Value {
	NSNumber *result = [self shareOccupiedHourlyFeeAccel3];
	return [result shortValue];
}

- (void)setShareOccupiedHourlyFeeAccel3Value:(int16_t)value_ {
	[self setShareOccupiedHourlyFeeAccel3:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveShareOccupiedHourlyFeeAccel3Value {
	NSNumber *result = [self primitiveShareOccupiedHourlyFeeAccel3];
	return [result shortValue];
}

- (void)setPrimitiveShareOccupiedHourlyFeeAccel3Value:(int16_t)value_ {
	[self setPrimitiveShareOccupiedHourlyFeeAccel3:[NSNumber numberWithShort:value_]];
}





@dynamic typeGroupName;






@dynamic aircraftTypes;

	
- (NSMutableSet*)aircraftTypesSet {
	[self willAccessValueForKey:@"aircraftTypes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"aircraftTypes"];
  
	[self didAccessValueForKey:@"aircraftTypes"];
	return result;
}
	






@end
