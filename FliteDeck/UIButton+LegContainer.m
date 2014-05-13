//
//  UIButton+LegContainer.m
//  FlightProfile
//
//  Created by BCMCXP0 on 1/23/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "UIButton+LegContainer.h"
#import <objc/runtime.h>

@implementation UIButton (LegContainer)

static char UIB_PROPERTY_KEY;

@dynamic legContainer;

-(void)setLegContainer:(UIView *)legContainer
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, legContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject*)legContainer
{
    return (UIView*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

@end
