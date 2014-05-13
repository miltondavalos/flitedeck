//
//  NFDNetJetsStyleHelper.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/1/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>
#import "NFDNetJetsStyleHelper.h"

#define RGB(r, g, b) static UIColor *ret; if (ret == nil) ret = [UIColor colorWithRed:(CGFloat)r/255.0 green:(CGFloat)g/255.0 blue:(CGFloat)b/255.0 alpha:1.0]; return ret

@implementation UIColor(MoreColors)
+ (id)netJetsBlue {RGB(9, 91, 182);}
+ (id)netJetsDarkBlue {RGB(0, 42, 92);}
+ (id)netJetsWhite {RGB(240, 248, 255);}
+ (id)netJetsGrey {RGB(240, 248, 255);}
@end

@implementation NFDNetJetsStyleHelper

/*
  USAGE: The following is an example of how a view controller would apply a background gradiwent using the helper method:
 
 [NFDNetJetsStyleHelper applyPageBackgroundsGradient:NFDGradientBlueToDarkBlue forView:self.view];
 */

+ (void)applyPageBackgroundsGradient:(NFDGradientType)gradientType forView:(UIView*)view{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    // gradient.frame = view.bounds;
    
    // For both Portrait and Horizontal view
    gradient.frame = CGRectMake(0, 0, 1024, 1024);
    
    UIColor *colorTop;
    UIColor *colorBottom;
    
    switch (gradientType) {
        case NFDGradientBlueToDarkBlue:
            colorTop = [UIColor netJetsBlue];
            colorBottom = [UIColor netJetsDarkBlue];
            break;

        case NFDGradientWhiteToGrey:
            colorTop = [UIColor netJetsWhite];
            colorBottom = [UIColor netJetsGrey];
            break;
            
        default:
            break;
    }
    
    gradient.colors = [NSArray arrayWithObjects:(id)[colorTop CGColor], (id)[colorBottom CGColor], nil];

    [view.layer insertSublayer:gradient atIndex:0];

}

@end
