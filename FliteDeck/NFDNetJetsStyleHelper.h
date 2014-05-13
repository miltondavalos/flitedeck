//
//  NFDNetJetsStyleHelper.h
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/1/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NFDGradientBlueToDarkBlue = 0,
    NFDGradientWhiteToGrey,
} NFDGradientType;

@interface UIColor(MoreColors)
+ (id)netJetsBlue;
+ (id)netJetsDarkBlue ;
+ (id)netJetsWhite ;
+ (id)netJetsGrey ;
@end

@interface NFDNetJetsStyleHelper : NSObject
+ (void)applyPageBackgroundsGradient:(NFDGradientType)gradientType forView:(UIView*)view;

@end
