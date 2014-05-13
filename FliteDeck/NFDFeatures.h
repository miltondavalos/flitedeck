//
//  NFDFeatures.h
//  FliteDeck
//
//  Created by Chad Predovich on 2/27/13.
//
//

#import <Foundation/Foundation.h>

@interface NFDFeatures : NSObject

@property (nonatomic, assign) BOOL shouldUseCrossCountry;
@property (nonatomic, strong) NSNumber * crossCountryPurchasePrice;

@property (nonatomic, assign) BOOL shouldUseNextYearPercentage;
@property (nonatomic, strong) NSNumber * nextYearPercentageOHF;
@property (nonatomic, strong) NSNumber * nextYearPercentageMMF;
@property (nonatomic, strong) NSNumber * nextYearPercentageCard;

@property (nonatomic, assign) BOOL shouldUseCard36MonthsIncentive;
@property (nonatomic, assign) BOOL shouldUseCardUpgradeIncentive;

@end
