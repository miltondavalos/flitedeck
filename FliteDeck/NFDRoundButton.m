//
//  NFDRoundButton.m
//
//  Created by Jeff Bailey on 10/15/13.
//
//

#import "NFDRoundButton.h"

#import "UIColor+FliteDeckColors.h"

@implementation NFDRoundButton

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self initRoundButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initRoundButton];


    }
    return self;
}

- (void)initMaskForCircle
{
    CGFloat xOffset = (self.frame.size.width - self.circleDiameter)/2;
    CGFloat yOffset = (self.frame.size.height - self.circleDiameter)/2;

    UIBezierPath *rounded = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(xOffset, yOffset, self.circleDiameter, self.circleDiameter)];
    
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

- (void)initRoundButton
{
    _circleDiameter = 38;
    self.backgroundColor = [UIColor tintColorForLightBackground];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self initMaskForCircle];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initMaskForCircle];
}

@end
