//
// AircraftButton.h
// FlightProfile
//
// Created by Evol Johnson on 1/27/12.
// Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDAircraftType.h"

@interface AircraftButton : UIButton
@property (nonatomic,strong) NFDAircraftType *aircraft;
@property (nonatomic,strong) NSNumber *position;
@property (nonatomic,strong) UIImageView *checked;
@property (nonatomic,strong) UIImageView *hilite;
-(void) setData : (NFDAircraftType *) ac;
@end