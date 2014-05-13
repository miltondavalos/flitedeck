// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDContractRate.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDContractRateAttributes {
	__unsafe_unretained NSString *acquisitionCost;
	__unsafe_unretained NSString *californiaFee;
	__unsafe_unretained NSString *cardHalfPremium;
	__unsafe_unretained NSString *cardPurchase25Hour;
	__unsafe_unretained NSString *cardPurchase50Hour;
	__unsafe_unretained NSString *demoOccupiedHourlyFee;
	__unsafe_unretained NSString *lease12MonthFee;
	__unsafe_unretained NSString *lease24MonthFee;
	__unsafe_unretained NSString *lease36MonthFee;
	__unsafe_unretained NSString *lease48MonthFee;
	__unsafe_unretained NSString *lease60MonthFee;
	__unsafe_unretained NSString *leaseMonthlyMgmtFee;
	__unsafe_unretained NSString *leaseOccupiedHourlyFee;
	__unsafe_unretained NSString *shareMonthlyMgmtFee;
	__unsafe_unretained NSString *shareMonthlyMgmtFeeAccel1;
	__unsafe_unretained NSString *shareMonthlyMgmtFeePremium;
	__unsafe_unretained NSString *shareOccupiedHourlyFee;
	__unsafe_unretained NSString *shareOccupiedHourlyFeeAccel1;
	__unsafe_unretained NSString *shareOccupiedHourlyFeeAccel2;
	__unsafe_unretained NSString *shareOccupiedHourlyFeeAccel3;
	__unsafe_unretained NSString *typeGroupName;
} NFDContractRateAttributes;

extern const struct NFDContractRateRelationships {
	__unsafe_unretained NSString *aircraftTypes;
} NFDContractRateRelationships;

extern const struct NFDContractRateFetchedProperties {
} NFDContractRateFetchedProperties;

@class NFDAircraftType;























@interface NFDContractRateID : NSManagedObjectID {}
@end

@interface _NFDContractRate : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDContractRateID*)objectID;





@property (nonatomic, strong) NSNumber* acquisitionCost;



@property int32_t acquisitionCostValue;
- (int32_t)acquisitionCostValue;
- (void)setAcquisitionCostValue:(int32_t)value_;

//- (BOOL)validateAcquisitionCost:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* californiaFee;



@property int16_t californiaFeeValue;
- (int16_t)californiaFeeValue;
- (void)setCaliforniaFeeValue:(int16_t)value_;

//- (BOOL)validateCaliforniaFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* cardHalfPremium;



@property int16_t cardHalfPremiumValue;
- (int16_t)cardHalfPremiumValue;
- (void)setCardHalfPremiumValue:(int16_t)value_;

//- (BOOL)validateCardHalfPremium:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* cardPurchase25Hour;



@property int32_t cardPurchase25HourValue;
- (int32_t)cardPurchase25HourValue;
- (void)setCardPurchase25HourValue:(int32_t)value_;

//- (BOOL)validateCardPurchase25Hour:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* cardPurchase50Hour;



@property int32_t cardPurchase50HourValue;
- (int32_t)cardPurchase50HourValue;
- (void)setCardPurchase50HourValue:(int32_t)value_;

//- (BOOL)validateCardPurchase50Hour:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* demoOccupiedHourlyFee;



@property int16_t demoOccupiedHourlyFeeValue;
- (int16_t)demoOccupiedHourlyFeeValue;
- (void)setDemoOccupiedHourlyFeeValue:(int16_t)value_;

//- (BOOL)validateDemoOccupiedHourlyFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lease12MonthFee;



@property int32_t lease12MonthFeeValue;
- (int32_t)lease12MonthFeeValue;
- (void)setLease12MonthFeeValue:(int32_t)value_;

//- (BOOL)validateLease12MonthFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lease24MonthFee;



@property int32_t lease24MonthFeeValue;
- (int32_t)lease24MonthFeeValue;
- (void)setLease24MonthFeeValue:(int32_t)value_;

//- (BOOL)validateLease24MonthFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lease36MonthFee;



@property int32_t lease36MonthFeeValue;
- (int32_t)lease36MonthFeeValue;
- (void)setLease36MonthFeeValue:(int32_t)value_;

//- (BOOL)validateLease36MonthFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lease48MonthFee;



@property int32_t lease48MonthFeeValue;
- (int32_t)lease48MonthFeeValue;
- (void)setLease48MonthFeeValue:(int32_t)value_;

//- (BOOL)validateLease48MonthFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lease60MonthFee;



@property int32_t lease60MonthFeeValue;
- (int32_t)lease60MonthFeeValue;
- (void)setLease60MonthFeeValue:(int32_t)value_;

//- (BOOL)validateLease60MonthFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* leaseMonthlyMgmtFee;



@property int32_t leaseMonthlyMgmtFeeValue;
- (int32_t)leaseMonthlyMgmtFeeValue;
- (void)setLeaseMonthlyMgmtFeeValue:(int32_t)value_;

//- (BOOL)validateLeaseMonthlyMgmtFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* leaseOccupiedHourlyFee;



@property int16_t leaseOccupiedHourlyFeeValue;
- (int16_t)leaseOccupiedHourlyFeeValue;
- (void)setLeaseOccupiedHourlyFeeValue:(int16_t)value_;

//- (BOOL)validateLeaseOccupiedHourlyFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* shareMonthlyMgmtFee;



@property int32_t shareMonthlyMgmtFeeValue;
- (int32_t)shareMonthlyMgmtFeeValue;
- (void)setShareMonthlyMgmtFeeValue:(int32_t)value_;

//- (BOOL)validateShareMonthlyMgmtFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* shareMonthlyMgmtFeeAccel1;



@property int16_t shareMonthlyMgmtFeeAccel1Value;
- (int16_t)shareMonthlyMgmtFeeAccel1Value;
- (void)setShareMonthlyMgmtFeeAccel1Value:(int16_t)value_;

//- (BOOL)validateShareMonthlyMgmtFeeAccel1:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* shareMonthlyMgmtFeePremium;



@property int16_t shareMonthlyMgmtFeePremiumValue;
- (int16_t)shareMonthlyMgmtFeePremiumValue;
- (void)setShareMonthlyMgmtFeePremiumValue:(int16_t)value_;

//- (BOOL)validateShareMonthlyMgmtFeePremium:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* shareOccupiedHourlyFee;



@property int16_t shareOccupiedHourlyFeeValue;
- (int16_t)shareOccupiedHourlyFeeValue;
- (void)setShareOccupiedHourlyFeeValue:(int16_t)value_;

//- (BOOL)validateShareOccupiedHourlyFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* shareOccupiedHourlyFeeAccel1;



@property int16_t shareOccupiedHourlyFeeAccel1Value;
- (int16_t)shareOccupiedHourlyFeeAccel1Value;
- (void)setShareOccupiedHourlyFeeAccel1Value:(int16_t)value_;

//- (BOOL)validateShareOccupiedHourlyFeeAccel1:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* shareOccupiedHourlyFeeAccel2;



@property int16_t shareOccupiedHourlyFeeAccel2Value;
- (int16_t)shareOccupiedHourlyFeeAccel2Value;
- (void)setShareOccupiedHourlyFeeAccel2Value:(int16_t)value_;

//- (BOOL)validateShareOccupiedHourlyFeeAccel2:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* shareOccupiedHourlyFeeAccel3;



@property int16_t shareOccupiedHourlyFeeAccel3Value;
- (int16_t)shareOccupiedHourlyFeeAccel3Value;
- (void)setShareOccupiedHourlyFeeAccel3Value:(int16_t)value_;

//- (BOOL)validateShareOccupiedHourlyFeeAccel3:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typeGroupName;



//- (BOOL)validateTypeGroupName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *aircraftTypes;

- (NSMutableSet*)aircraftTypesSet;





@end

@interface _NFDContractRate (CoreDataGeneratedAccessors)

- (void)addAircraftTypes:(NSSet*)value_;
- (void)removeAircraftTypes:(NSSet*)value_;
- (void)addAircraftTypesObject:(NFDAircraftType*)value_;
- (void)removeAircraftTypesObject:(NFDAircraftType*)value_;

@end

@interface _NFDContractRate (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAcquisitionCost;
- (void)setPrimitiveAcquisitionCost:(NSNumber*)value;

- (int32_t)primitiveAcquisitionCostValue;
- (void)setPrimitiveAcquisitionCostValue:(int32_t)value_;




- (NSNumber*)primitiveCaliforniaFee;
- (void)setPrimitiveCaliforniaFee:(NSNumber*)value;

- (int16_t)primitiveCaliforniaFeeValue;
- (void)setPrimitiveCaliforniaFeeValue:(int16_t)value_;




- (NSNumber*)primitiveCardHalfPremium;
- (void)setPrimitiveCardHalfPremium:(NSNumber*)value;

- (int16_t)primitiveCardHalfPremiumValue;
- (void)setPrimitiveCardHalfPremiumValue:(int16_t)value_;




- (NSNumber*)primitiveCardPurchase25Hour;
- (void)setPrimitiveCardPurchase25Hour:(NSNumber*)value;

- (int32_t)primitiveCardPurchase25HourValue;
- (void)setPrimitiveCardPurchase25HourValue:(int32_t)value_;




- (NSNumber*)primitiveCardPurchase50Hour;
- (void)setPrimitiveCardPurchase50Hour:(NSNumber*)value;

- (int32_t)primitiveCardPurchase50HourValue;
- (void)setPrimitiveCardPurchase50HourValue:(int32_t)value_;




- (NSNumber*)primitiveDemoOccupiedHourlyFee;
- (void)setPrimitiveDemoOccupiedHourlyFee:(NSNumber*)value;

- (int16_t)primitiveDemoOccupiedHourlyFeeValue;
- (void)setPrimitiveDemoOccupiedHourlyFeeValue:(int16_t)value_;




- (NSNumber*)primitiveLease12MonthFee;
- (void)setPrimitiveLease12MonthFee:(NSNumber*)value;

- (int32_t)primitiveLease12MonthFeeValue;
- (void)setPrimitiveLease12MonthFeeValue:(int32_t)value_;




- (NSNumber*)primitiveLease24MonthFee;
- (void)setPrimitiveLease24MonthFee:(NSNumber*)value;

- (int32_t)primitiveLease24MonthFeeValue;
- (void)setPrimitiveLease24MonthFeeValue:(int32_t)value_;




- (NSNumber*)primitiveLease36MonthFee;
- (void)setPrimitiveLease36MonthFee:(NSNumber*)value;

- (int32_t)primitiveLease36MonthFeeValue;
- (void)setPrimitiveLease36MonthFeeValue:(int32_t)value_;




- (NSNumber*)primitiveLease48MonthFee;
- (void)setPrimitiveLease48MonthFee:(NSNumber*)value;

- (int32_t)primitiveLease48MonthFeeValue;
- (void)setPrimitiveLease48MonthFeeValue:(int32_t)value_;




- (NSNumber*)primitiveLease60MonthFee;
- (void)setPrimitiveLease60MonthFee:(NSNumber*)value;

- (int32_t)primitiveLease60MonthFeeValue;
- (void)setPrimitiveLease60MonthFeeValue:(int32_t)value_;




- (NSNumber*)primitiveLeaseMonthlyMgmtFee;
- (void)setPrimitiveLeaseMonthlyMgmtFee:(NSNumber*)value;

- (int32_t)primitiveLeaseMonthlyMgmtFeeValue;
- (void)setPrimitiveLeaseMonthlyMgmtFeeValue:(int32_t)value_;




- (NSNumber*)primitiveLeaseOccupiedHourlyFee;
- (void)setPrimitiveLeaseOccupiedHourlyFee:(NSNumber*)value;

- (int16_t)primitiveLeaseOccupiedHourlyFeeValue;
- (void)setPrimitiveLeaseOccupiedHourlyFeeValue:(int16_t)value_;




- (NSNumber*)primitiveShareMonthlyMgmtFee;
- (void)setPrimitiveShareMonthlyMgmtFee:(NSNumber*)value;

- (int32_t)primitiveShareMonthlyMgmtFeeValue;
- (void)setPrimitiveShareMonthlyMgmtFeeValue:(int32_t)value_;




- (NSNumber*)primitiveShareMonthlyMgmtFeeAccel1;
- (void)setPrimitiveShareMonthlyMgmtFeeAccel1:(NSNumber*)value;

- (int16_t)primitiveShareMonthlyMgmtFeeAccel1Value;
- (void)setPrimitiveShareMonthlyMgmtFeeAccel1Value:(int16_t)value_;




- (NSNumber*)primitiveShareMonthlyMgmtFeePremium;
- (void)setPrimitiveShareMonthlyMgmtFeePremium:(NSNumber*)value;

- (int16_t)primitiveShareMonthlyMgmtFeePremiumValue;
- (void)setPrimitiveShareMonthlyMgmtFeePremiumValue:(int16_t)value_;




- (NSNumber*)primitiveShareOccupiedHourlyFee;
- (void)setPrimitiveShareOccupiedHourlyFee:(NSNumber*)value;

- (int16_t)primitiveShareOccupiedHourlyFeeValue;
- (void)setPrimitiveShareOccupiedHourlyFeeValue:(int16_t)value_;




- (NSNumber*)primitiveShareOccupiedHourlyFeeAccel1;
- (void)setPrimitiveShareOccupiedHourlyFeeAccel1:(NSNumber*)value;

- (int16_t)primitiveShareOccupiedHourlyFeeAccel1Value;
- (void)setPrimitiveShareOccupiedHourlyFeeAccel1Value:(int16_t)value_;




- (NSNumber*)primitiveShareOccupiedHourlyFeeAccel2;
- (void)setPrimitiveShareOccupiedHourlyFeeAccel2:(NSNumber*)value;

- (int16_t)primitiveShareOccupiedHourlyFeeAccel2Value;
- (void)setPrimitiveShareOccupiedHourlyFeeAccel2Value:(int16_t)value_;




- (NSNumber*)primitiveShareOccupiedHourlyFeeAccel3;
- (void)setPrimitiveShareOccupiedHourlyFeeAccel3:(NSNumber*)value;

- (int16_t)primitiveShareOccupiedHourlyFeeAccel3Value;
- (void)setPrimitiveShareOccupiedHourlyFeeAccel3Value:(int16_t)value_;




- (NSString*)primitiveTypeGroupName;
- (void)setPrimitiveTypeGroupName:(NSString*)value;





- (NSMutableSet*)primitiveAircraftTypes;
- (void)setPrimitiveAircraftTypes:(NSMutableSet*)value;


@end
