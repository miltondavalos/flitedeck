//
//  NFDDogEarView.m
//  FliteDeck
//
//  Created by Jeff Bailey on 10/22/13.
//
//

#import "NFDDogEarView.h"

@interface NFDDogEarView()

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL displayDogEar;

@end

@implementation NFDDogEarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _dogEarWidth = 20;
        _displayDogEar=NO;
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    if (self.displayDogEar) {
        [self drawDogEar:self.dogEarWidth];
    }
}

-(void)setDisplayDogEar:(BOOL)displayDogEar color:(UIColor *)color
{
    [self setNeedsDisplay];
    
    _displayDogEar = displayDogEar;
    self.color = color;
}

-(void) drawDogEar: (CGFloat) changeIndicatorWidth
{
    /* Set UIView Border */
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(contextRef);
    CGContextSetFillColorWithColor(contextRef, self.color.CGColor);
    
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width, 0);
    CGContextAddLineToPoint(contextRef, self.bounds.size.width, self.bounds.size.width);
    CGContextAddLineToPoint(contextRef, 0, 0);

    CGContextFillPath(contextRef);
}
@end
