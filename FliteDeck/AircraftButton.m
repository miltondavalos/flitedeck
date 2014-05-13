//
// AircraftButton.m
// FlightProfile
//
// Created by Evol Johnson on 1/27/12.
// Copyright (c) 2012 NetJets. All rights reserved.
//

#import "AircraftButton.h"

@implementation AircraftButton
@synthesize aircraft, position,checked,hilite;

-(id) init{
    self = [super init];
    if(self){
        
        
    }
    
    return self;
    
}
-(void) setData : (NFDAircraftType *) ac {
    
    self.aircraft = ac;
    
    NSString *aircraftImageName = [aircraft typeName];
    //Set Four Button State Images to Aircraft Button
    UIImage *aircraftImageNormal = [UIImage imageNamed:[NSString stringWithFormat:@"%@_default.png",aircraftImageName]];
    [self setImage:aircraftImageNormal forState:UIControlStateNormal];
    //UIImage *aircraftImageSelected = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected.png",aircraftImageName]];
    //[self setImage:aircraftImageSelected forState:UIControlStateSelected];
    //UIImage *aircraftImageHighlighted = [UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted.png",aircraftImageName]];
    //[self setImage:aircraftImageHighlighted forState:UIControlStateHighlighted];
    //UIImage *aircraftImageDisabled = [UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled.png",aircraftImageName]];
    //[self setImage:aircraftImageDisabled forState:UIControlStateDisabled];
    
    
    checked = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width -35, self.frame.size.height -40, 31, 31)];
    checked.image = [UIImage imageNamed:@"checkmark.png"];
    [self addSubview: checked];
    checked.alpha = 0;
    
    hilite = [[UIImageView alloc] initWithFrame:self.bounds];
    hilite.image = [UIImage imageNamed:@"hilite.png"];
    [self addSubview: hilite];
    hilite.alpha = 0;
}

-(void) setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        checked.alpha = 1;
    }else{
        checked.alpha = 0;
    }
}

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        hilite.alpha = 1;
    }else{
        hilite.alpha = 0;
    }
}
@end