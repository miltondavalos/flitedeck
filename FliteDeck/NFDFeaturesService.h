//
//  NFDFeaturesService.h
//  FliteDeck
//
//  Created by Chad Predovich on 2/27/13.
//
//

#import <Foundation/Foundation.h>
#import "NFDFeatures.h"

@interface NFDFeaturesService : NSObject

@property (readonly) NSString *path;
@property (readonly) NSDictionary *currentFeaturesDictionary;

+ (NFDFeatures *)currentFeatures;
+ (void)updateAndSaveFeatures:(NFDFeatures *)newFeatures;

@end
