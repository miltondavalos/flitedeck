//
//  NFDFlightProposalCalculatorService.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 4/4/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NFDContractRate.h"
#import "NFDFuelRate.h"

#define FETRATE 0.075

#define DISCOUNT_RATE_FOR_PREPAYMENTS 0.0396f
#define NUMBER_OF_PAYMENTS_TO_DISCOUNT 11
#define LOAN_INTEREST_RATE 0.06f
#define LOAN_TERM_IN_MONTHS 60

#define MONTH_RATE_LAST @"Last"
#define MONTH_RATE_3_MONTHS @"3 Month"
#define MONTH_RATE_6_MONTHS @"6 Month"
#define MONTH_RATE_12_MONTHS @"12 Month"

#define LEASE_TERM_12_MONTHS @"12 Month"
#define LEASE_TERM_24_MONTHS @"24 Month"
#define LEASE_TERM_36_MONTHS @"36 Month"
#define LEASE_TERM_48_MONTHS @"48 Month"
#define LEASE_TERM_60_MONTHS @"60 Month"

#define CROSS_COUNTRY_CARD_TYPE_LABEL @"Marquis Jet X-Country Card"

@class NFDContractRate;

typedef enum {
    kGeneralProductTypeShare = 0,
    kGeneralProductTypeCard,
    kGeneralProductTypePhenomTransistion,
} kGeneralProductType;

typedef enum 
{
    kFuelPeriodLastMonth = 0,
    kFuelPeriod3Months,
    kFuelPeriod6Months,
    kFuelPeriod12Months,
} kFuelPeriod;

typedef enum
{
    kCardType25Hours = 0,
    kCardType50Hours,
    kCardTypeHalf,
    kCardTypeCrossCountry,
} kCardType;

@interface NFDFlightProposalCalculatorService : NSObject

+ (NSArray *)inventoryForAircraftType:(NSString*)aircraftType;
+ (NSArray *)inventoryForAircraftType:(NSString *)aircraftType yearsOfServiceRemaining:(int)yearsOfServiceRemaining;
+ (NSArray *)annualHourAllotmentChoicesForGeneralProductType:(kGeneralProductType)gpt maxHoursAvailable:(NSNumber *)maxHoursAvailable;
+ (NSArray *)numberOfAnnualCardsChoices;
+ (NSArray *)aircraftComboChoices;
+ (NSArray *)aircraftChoicesForCard;
+ (NSArray *)aircraftChoicesForLease;
+ (NSString *)aircraftTypeNameFromDisplayName:(NSString *)displayName;
+ (NSString *)aircraftDisplayNameFromTypeName:(NSString *)typeName;
+ (NSArray *)prepayEstimateChoices;
+ (NSArray *)prepayEstimateChoicesForProductCode:(int)productCode;
+ (NSArray *)leaseTermChoicesForAircraftType:(NSString *)aircraftType;
+ (NSArray *)fuelPeriodChoicesForAircraftType:(NSString *)aircraftType isQualified:(bool)isQualified;
+ (NSNumber *)acquisitionCostForAircraftTypeGroup:(NSString *)aircraftTypeGroup;

//Contract Rates by Airctaft Type
+ (NFDFuelRate*)fuelRateInfoForAircraftType:(NSString*)aircraftType;
+ (NFDFuelRate*)fuelRateInfoForAircraftGroupName:(NSString*)aircraftGroupName;
+ (NFDContractRate*)contractRateInfoForAircraftType:(NSString*)aircraftType;
+ (NFDContractRate*)contractRateInfoForAircraftGroupName:(NSString*)aircraftGroupName;

//Monthly Lease Fee
+(NSNumber*)calculateMonthlyLeaseFeeForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm;
+(NSNumber*)calculateMonthlyLeaseFeeFETForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm isQualified:(BOOL)qualified;
//Annual Lease Fee
+ (NSNumber *)calculateAnnualLeaseFeeForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm;
+ (NSNumber *)calculateAnnualLeaseFETForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm isQualified:(BOOL)qualified;

//Monthly Management Fee Calculations
+(NSNumber*)calculateShareMonthlyManagementFeeRateForAircraftType:(NSString*)aircraftType andAircraftVintage:(NSString*)vintage andShareSize:(NSString*)hours isMultiShare:(BOOL)isMultiShare;
+(NSNumber*)calculateLeaseMonthlyManagementFeeRateForAircraftType:(NSString*)aircraftType andShareSize:(NSString*)hours isMultiShare:(BOOL)isMultiShare;
+(NSNumber*)calculateShareMonthlyManagementFeeAnnualForAircraftType:(NSString*)aircraftType andAircraftVintage:(NSString*)vintage andShareSize:(NSString*)hours isMultiShare:(BOOL)isMultiShare;
+(NSNumber*)calculateLeaseMonthlyManagementFeeAnnualForAircraftType:(NSString*)aircraftType andShareSize:(NSString*)hours isMultiShare:(BOOL)isMultiShare;

//Occupied Hourly Fee Calculations
+ (NSNumber *)calculateShareOccupiedHourlyFeeRateForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage  usingProposalYear:(NSString *)proposalYear;
+ (NSNumber *)calculateShareOccupiedHourlyFeeRateForAircraftType:(NSString *)aircraftType andVintage:(NSString *)vintage;
+ (NSNumber *)calculateShareOccupiedHourlyFeeAnnualForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage andShareSize:(NSString *)hours usingProposalYear:(NSString *)proposalYear;
+ (NSNumber *)calculateShareOccupiedHourlyFeeAnnualForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage andShareSize:(NSString *)hours;

+ (NSNumber *)calculateLeaseOccupiedHourlyFeeRateForAircraftType:(NSString *)aircraftType;
+ (NSNumber *)calculateLeaseOccupiedHourlyFeeAnnualForAircraftType:(NSString *)aircraftType andShareSize:(NSString *)hours;

//Federal Excise Tax Calculations
+ (NSNumber *)calculateShareFederalExciseTaxForOccupiedHourlyFeeRate:(NSNumber *)occupiedHourlyFeeRate;
+ (NSNumber *)calculateShareFederalExciseTaxForOccupiedHourlyFeeAnnual:(NSNumber *)occupiedHourlyFeeAnnual;
+ (NSNumber *)calculateShareFederalExciseTaxForAcquisitionCost:(NSNumber *)acquisitionCost;
+ (NSNumber *)calculateShareOperationalFederalExciseTaxForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare;
+ (NSNumber *)calculateLeaseOperationalFederalExciseTaxForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare;
//Card Calculations
+ (NSNumber *)calculateCardPurchasePriceForAircraftGroupName:(NSString *)aircraftGroupName andCardType:(NSString *)cardType;
+ (NSNumber *)calculateCardPurchasePriceForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType andNumberOfCards:(int)numberOfCards;
+ (NSNumber *)calculateCardPurchaseFETForAircraftGroupName:(NSString *)aircraftGroupName andCardType:(NSString *)cardType;
+ (NSNumber *)calculateCardPurchaseFETForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType andNumberOfCards:(int)numberOfCards;
+ (NSNumber *)calculateCardPurchaseFETForPurchasePrice:(NSNumber *)purchasePrice;
+ (NSNumber *)hoursForCardType:(NSString *)cardType;
+ (NSNumber *)contractMonthsForCardType:(NSString *)cardType;
//+ (NSNumber *)calculateCardFuelFETRateforAircraftGroupName:(NSString *)aircraftGroupName andFuelPeriod:(NSString *)fuelPeriod;
+ (NSNumber *)calculateCardFuelFETAnnualforAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod;
+ (NSNumber *)calculateCardTotalCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod;
//+ (NSNumber *)calculateCardAnnualCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod includingFuelFET:(BOOL)includeFuelFET;
+ (NSNumber *)calculateCardAverageHourlyCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod;
+ (NSNumber *)calculateCardTotalCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards fuelPeriod:(NSString *)fuelPeriod andPurchasePrice:(NSNumber *)purchasePrice;
+ (NSNumber *)calculateCardAverageHourlyCostForAircraftGroupName:(NSString *)aircraftGroupName cardType:(NSString *)cardType numberOfCards:(int)numberOfCards fuelPeriod:(NSString *)fuelPeriod andPurchasePrice:(NSNumber *)purchasePrice;

+ (NSNumber *)calculateCostWithNextYearPercentage:(NSNumber *)percentage andInitialCost:(NSNumber *)initialCost;

+ (NSNumber *)calculateComboCardTotalCostForAircraftGroupNames:(NSArray *)aircraftGroupNames  numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod;
+ (NSNumber *)calculateComboCardAverageHourlyCostForAircraftGroupNames:(NSArray *)aircraftGroupNames numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod;
+ (NSNumber *)calculateComboCardAverageHourlyCostForTotalCost:(NSNumber *)totalCost andNumberOfCards:(int)numberOfCards;

+ (NSNumber *)calculateComboCardPurchasePriceForAircraftGroupNames:(NSArray *)aircraftGroupNames andNumberOfCards:(int)numberOfCards;
+ (NSNumber *)calculateComboCardPurchaseFETForAircraftGroupNames:(NSArray *)aircraftGroupNames andNumberOfCards:(int)numberOfCards;
+ (NSNumber *)comboCardFuelVariableRateForAircraftGroupNames:(NSArray *)aircraftGroupNames andFuelPeriod:(NSString *)fuelPeriod;
+ (NSNumber *)comboCardFuelVariableTotalForAircraftGroupNames:(NSArray *)aircraftGroupNames andFuelPeriod:(NSString *)fuelPeriod andNumberOfCards:(int)numberOfCards;
+ (NSNumber *)calculateComboCardTotalCostForAircraftGroupNames:(NSArray *)aircraftGroupNames purchasePrice:(NSNumber *)purchasePrice purchaseFET:(NSNumber *)purchaseFET numberOfCards:(int)numberOfCards andFuelPeriod:(NSString *)fuelPeriod;
//+ (NSNumber *)comboCardFuelFETRateForAircraftGroupNames:(NSArray *)aircraftGroupNames andFuelPeriod:(NSString *)fuelPeriod;
+ (NSNumber *)comboCardFuelFETTotalForAircraftGroupNames:(NSArray *)aircraftGroupNames andFuelPeriod:(NSString *)fuelPeriod andNumberOfCards:(int)numberOfCards;

//Phenom Calculations
+ (NSNumber *)calculateAnnualLeaseFeeForMonthlyLeaseFee:(NSNumber *)monthlyLeaseFee;
+ (NSNumber *)calculateAnnualLeaseFETForAnnualLeaseFee:(NSNumber *)annualLeaseFee isQualified:(BOOL)qualified;
+ (NSNumber *)calculateTermFETForAcquisitionCost:(NSNumber *)acquisitionCost isQualified:(BOOL)qualified;
+ (NSNumber *)calculateDepositForAnnualHours:(NSString *)annualHours;
+ (NSNumber *)calculateProgressPaymentForAcquisitionCost:(NSNumber *)acquisitionCost;
+ (NSNumber *)calculateCashDueAtClosingForAcquisitionCost:(NSNumber *)acquisitionCost fet:(NSNumber *)fet deposit:(NSNumber *)deposit progressPayment:(NSNumber *)progressPayment;
+ (NSNumber *)calculateAnnualOperationalCostForAnnualMonthlyManagementFee:(NSNumber *)annualMMF annualOperationHourlyFee:(NSNumber *)annualOHF annualFuel:(NSNumber *)annualFuel annualFET:(NSNumber *)annualFET annualLeaseFee:(NSNumber *)annualLeaseFee annualLeaseFET:(NSNumber *)annualLeaseFET;
+ (NSNumber *)calculateAverageHourlyOperationalCostForAnnualMonthlyManagementFee:(NSNumber *)annualMMF annualOperationHourlyFee:(NSNumber *)annualOHF annualFuel:(NSNumber *)annualFuel annualFET:(NSNumber *)annualFET annualLeaseFee:(NSNumber *)annualLeaseFee annualLeaseFET:(NSNumber *)annualLeaseFET andShareSize:(NSString *)hours;
+ (NSNumber *)calculateTotalFETForMonthlyManagementFee:(NSNumber *)mmf occupiedHourlyFee:(NSNumber *)ohf fuel:(NSNumber *)fuel isQualified:(BOOL)qualified;

//Fuel Calculations
+ (NSNumber *)fuelVariableRateForAircraftType:(NSString *)aircraftType andFuelPeriod:(NSString *)fuelPeriod isQualified:(BOOL)qualified;

+ (NSNumber *)fuelVariableRateForAircraftGroupName:(NSString *)aircraftGroupName andFuelPeriod:(NSString *)fuelPeriod isQualified:(BOOL)qualified;

+ (NSNumber *)fuelVariableRateFromContractRate:(NFDFuelRate *)fuelRate andFuelPeriod:(NSString *)fuelPeriod forAircraftType:(NSString *)aircraftType isQualified:(BOOL)qualified;

+ (NSNumber *)fuelVariableTotalForAircraftType:(NSString *)aircraftType andFuelPeriod:(NSString *)fuelPeriod forNumberOfHours:(id)numberOfHours isQualified:(BOOL)qualified;

+ (NSNumber *)fuelVariableTotalForAircraftGroupName:(NSString *)aircraftGroupName andFuelPeriod:(NSString *)fuelPeriod forNumberOfHours:(id)numberOfHours isQualified:(BOOL)qualified;

+ (NSNumber *)fuelVariableTotalForAircraftGroupName:(NSString *)aircraftGroupName andFuelPeriod:(NSString *)fuelPeriod forCardType:(NSString *)cardType andNumberOfCards:(int)numberOfCards;
+ (NSArray *)fuelPeriodChoicesForAircraftChoices:(NSArray *)aircraftChoices isQualified:(BOOL)isQualified;

//Prepayment Savings
+ (NSNumber *)calculatePrepaymentSavingsForMMF:(NSNumber *)mmfRate;
+ (NSNumber *)calculatePrepaymentSavingsForOHF:(NSNumber *)ohfRate havingAnnualHoursOf:(NSNumber *)annualHours;
+ (NSNumber *)calculatePrepaymentSavingsForFuel:(NSNumber *)fuelRate havingAnnualHoursOf:(NSNumber *)annualHours;
+ (NSNumber *)calculatePrepaymentSavingsForLease:(NSNumber *)leasePayment;
+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)ohfRate andFuel:(NSNumber *)fuelRate havingAnnualHoursOf:(NSNumber *)annualHours;
+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)mmfRate andOHF:(NSNumber *)ohfRate andFuel:(NSNumber *)fuelRate havingAnnualHoursOf:(NSNumber *)annualHours;
+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)mmfRate andLease:(NSNumber *)leasePayment havingAnnualHoursOf:(NSNumber *)annualHours;
+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)mmfRate andOHF:(NSNumber *)ohfRate andLease:(NSNumber *)leasePayment havingAnnualHoursOf:(NSNumber *)annualHours;
+ (NSNumber *)calculatePrepaymentSavingsCombination:(NSNumber *)mmfRate andOHF:(NSNumber *)ohfRate andFuel:(NSNumber *)fuelRate andLease:(NSNumber *)leasePayment havingAnnualHoursOf:(NSNumber *)annualHours;
+ (NSNumber *)calculatePrepaymentSavingsForSelection:(NSString *)prepaymentSelection usingMMF:(NSNumber *)mmfRate andOHF:(NSNumber *)ohfRate andFuel:(NSNumber *)fuelRate andLease:(NSNumber *)leasePayment havingAnnualHoursOf:(NSNumber *)annualHours isQualified:(BOOL)qualified;


//Financial Calculations
+ (NSNumber *)calculateAcquisitionCostFromAircraftValue:(NSNumber *)aircraftValue andAnnualHours:(NSNumber *)annualHours;
+ (NSNumber *)calculateDownPaymmentFromAcquisitionCost:(NSNumber *)acquisitionCost;
+ (NSNumber *)calculateFinancedAmountFromAcquisitionCost:(NSNumber *)acquisitionCost;
+ (NSNumber *)calculatePaymentPlusInterestFromAcquisitionCost:(NSNumber *)acquisitionCost forVintage:(NSNumber *)vintage;
+ (NSNumber *)calculatePaymentPlusInterestFromAcquisitionCost:(NSNumber *)acquisitionCost forVintage:(NSNumber *)vintage forDisplay:(BOOL)forDisplay;
+ (NSNumber *)calculateBalloonPaymentFromAcquisitionCost:(NSNumber *)acquisitionCost forVintage:(NSNumber *)vintage;

+ (NSNumber *)calculateShareOperationalAnnualCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare;

+ (NSNumber *)calculateFinanceOperationalAnnualCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified withAcquisitionCost:(NSNumber *)acqCost isMultiShare:(BOOL)isMultiShare;
+ (NSNumber *)calculateLeaseOperationalAnnualCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours leaseTerm:(NSString *)leaseTerm andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare;

+ (NSNumber *)calculateShareOperationalAverageHourlyCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare;
+ (NSNumber *)calculateFinanceOperationalAverageHourlyCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified withAcquisitionCost:(NSNumber *)acqCost isMultiShare:(BOOL)isMultiShare;
+ (NSNumber *)calculateLeaseOperationalAverageHourlyCostForAircraftType:(NSString *)aircraftType vintage:(NSString *)vintage shareSize:(NSString *)hours leaseTerm:(NSString *)leaseTerm andFuelPeriod:(NSString *)fuelPeriod nextYearPercentageForOHF:(NSNumber *)nextYearPercentageForOHF nextYearPercentageForMMF:(NSNumber *)nextYearPercentageForMMF isQualified:(BOOL)qualified isMultiShare:(BOOL)isMultiShare;

+ (NSNumber *)calculateDepositFromAcquisitionCost:(NSNumber *)acquisitionCost qualified:(BOOL)qualified;
+ (NSNumber*)calculateMonthlyLeaseDepositForAircraftType:(NSString*)aircraftType annualHours:(NSString*)annualHours leaseTerm:(NSString*)leaseTerm isQualified:(BOOL)qualified;

@end
