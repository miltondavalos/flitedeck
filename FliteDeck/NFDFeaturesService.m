//
//  NFDFeaturesService.m
//  FliteDeck
//
//  Created by Chad Predovich on 2/27/13.
//
//

#import "NFDFeaturesService.h"

@implementation NFDFeaturesService

#define FEATURE_KEY_SHOULD_USE_CROSS_COUNTRY @"ShouldUseCrossCountry"
#define FEATURE_KEY_CROSS_COUNTRY_PURCHASE_PRICE @"CrossCountryPurchasePrice"
#define FEATURE_KEY_SHOULD_USE_NEXT_YEAR_PERCENTAGE @"ShouldUseNextYearPercentage"
#define FEATURE_KEY_NEXT_YEAR_PERCENTAGE_OHF @"NextYearPercentageOHF"
#define FEATURE_KEY_NEXT_YEAR_PERCENTAGE_MMF @"NextYearPercentageMMF"
#define FEATURE_KEY_NEXT_YEAR_PERCENTAGE_CARD @"NextYearPercentageCard"
#define FEATURE_KEY_SHOULD_USE_CARD_36_MONTHS_INCENTIVE @"ShouldUseCard36MonthsIncentive"
#define FEATURE_KEY_SHOULD_USE_CARD_UPGRADE_INCENTIVE @"ShouldUseCardUpgradeIncentive"

@synthesize path, currentFeaturesDictionary;

- (id)init
{
    self = [super init];
    if (self) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"FliteDeck-Features.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path]) {
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"FliteDeck-Features" ofType:@"plist"];
            [fileManager copyItemAtPath:sourcePath toPath:path error:nil];
        }
        
        currentFeaturesDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}

+ (NFDFeatures *)currentFeatures
{
    NFDFeaturesService *featureService = [[self alloc] init];
    
    NFDFeatures *features = [[NFDFeatures alloc] init];
    features.shouldUseCrossCountry = [[featureService.currentFeaturesDictionary valueForKey:FEATURE_KEY_SHOULD_USE_CROSS_COUNTRY] boolValue];
    features.crossCountryPurchasePrice = [featureService.currentFeaturesDictionary valueForKey:FEATURE_KEY_CROSS_COUNTRY_PURCHASE_PRICE];
    features.shouldUseNextYearPercentage = [[featureService.currentFeaturesDictionary valueForKey:FEATURE_KEY_SHOULD_USE_NEXT_YEAR_PERCENTAGE] boolValue];
    features.nextYearPercentageOHF = [featureService.currentFeaturesDictionary valueForKey:FEATURE_KEY_NEXT_YEAR_PERCENTAGE_OHF];
    features.nextYearPercentageMMF = [featureService.currentFeaturesDictionary valueForKey:FEATURE_KEY_NEXT_YEAR_PERCENTAGE_MMF];
    features.nextYearPercentageCard = [featureService.currentFeaturesDictionary valueForKey:FEATURE_KEY_NEXT_YEAR_PERCENTAGE_CARD];
    features.shouldUseCard36MonthsIncentive = [[featureService.currentFeaturesDictionary valueForKey:FEATURE_KEY_SHOULD_USE_CARD_36_MONTHS_INCENTIVE] boolValue];
    features.shouldUseCardUpgradeIncentive = [[featureService.currentFeaturesDictionary valueForKey:FEATURE_KEY_SHOULD_USE_CARD_UPGRADE_INCENTIVE] boolValue];
    
    return features;
}

+ (void)updateAndSaveFeatures:(NFDFeatures *)newFeatures
{
    NFDFeaturesService *featureService = [[self alloc] init];
    NSMutableDictionary *updatedFeatures = [NSMutableDictionary dictionaryWithDictionary:featureService.currentFeaturesDictionary];
    
    [updatedFeatures setValue:[NSNumber numberWithBool:newFeatures.shouldUseCrossCountry] forKey:FEATURE_KEY_SHOULD_USE_CROSS_COUNTRY];
    [updatedFeatures setValue:newFeatures.crossCountryPurchasePrice forKey:FEATURE_KEY_CROSS_COUNTRY_PURCHASE_PRICE];
    [updatedFeatures setValue:[NSNumber numberWithBool:newFeatures.shouldUseNextYearPercentage] forKey:FEATURE_KEY_SHOULD_USE_NEXT_YEAR_PERCENTAGE];
    [updatedFeatures setValue:newFeatures.nextYearPercentageOHF forKey:FEATURE_KEY_NEXT_YEAR_PERCENTAGE_OHF];
    [updatedFeatures setValue:newFeatures.nextYearPercentageMMF forKey:FEATURE_KEY_NEXT_YEAR_PERCENTAGE_MMF];
    [updatedFeatures setValue:newFeatures.nextYearPercentageCard forKey:FEATURE_KEY_NEXT_YEAR_PERCENTAGE_CARD];
    [updatedFeatures setValue:[NSNumber numberWithBool:newFeatures.shouldUseCard36MonthsIncentive] forKey:FEATURE_KEY_SHOULD_USE_CARD_36_MONTHS_INCENTIVE];
    [updatedFeatures setValue:[NSNumber numberWithBool:newFeatures.shouldUseCardUpgradeIncentive] forKey:FEATURE_KEY_SHOULD_USE_CARD_UPGRADE_INCENTIVE];
    
    [updatedFeatures writeToFile:featureService.path atomically:YES];
}

@end
