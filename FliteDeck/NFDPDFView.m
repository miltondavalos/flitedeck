//
//  NFDPDFView.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDPDFView.h"

@implementation NFDPDFView

@synthesize message, pdfFileName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)generatePDF
{
    
}

-(void) generatePdfWithFilePath: (NSString *)thefilePath
{
    
}

- (NSMutableParagraphStyle *)createParagraphStyleWithLineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    
    return paragraphStyle;
}

- (void) drawTextAt: (NSString *)string withfont:(UIFont *)font x:(float) x   y:(float) y  w:(float) w  h:(float) h
{
    CGRect coordinates = CGRectMake(x,y,w,h);
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    [string drawInRect:coordinates withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
}

- (void) drawTextAt: (NSString *)string withfont:(UIFont *)font x:(float) x   y:(float) y  w:(float) w  h:(float) h alignment:(NSTextAlignment) alignment
{
    CGRect coordinates = CGRectMake(x,y,w,h);
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:alignment];
    [string drawInRect:coordinates withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
}

- (void)setCoordinates: (NSString *)string withfont:(UIFont *)font withCoordinates:(CGRect) coordinates
{
    CGRect renderingRect = coordinates;
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    [string drawInRect:renderingRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
}

- (void)setCoordinatesForComponent: (NSString *)string withfont:(UIFont *)font withCoordinates:(CGRect) coordinates
{
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    [string drawInRect:coordinates withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
}

// Draw Line

- (void) drawLine {
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetRGBFillColor(currentContext, 0.0, 0.1647, 0.36078, 1.0);
    
    CGPoint startPoint = CGPointMake(kMarginInset + kBorderInset, ycoordinateForLine );
    CGPoint endPoint = CGPointMake(pageSize.width - 2*kMarginInset -2*kBorderInset +40, ycoordinateForLine);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);    
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
}

// Draw Line for on top of disclaimer text

- (void) drawLineForDisclaimerText {
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetRGBFillColor(currentContext, 0.0, 0.1647, 0.36078, 1.0);
    
    CGPoint startPoint = CGPointMake(kMarginInset + kBorderInset, 790);
    CGPoint endPoint = CGPointMake(pageSize.width - 2*kMarginInset -2*kBorderInset +40, 790);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);    
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

// Drawing images for header, Netjets Logo, etc.

- (void) drawHeader
{
    UIImage * netjetsImage = [UIImage imageNamed:@"NetJets_approvedlogo.jpg"];
    
    [netjetsImage drawInRect:CGRectMake(970, kBorderInset + kMarginInset - 10, 250, 50)];
}

@end
