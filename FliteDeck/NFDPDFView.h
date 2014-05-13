//
//  NFDPDFView.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            10.0

//Line drawing
#define kLineWidth              1.0


@interface NFDPDFView : UIView
{
    
    CGSize pageSize;
    IBOutlet UILabel *message;
    int countForNoofPagesInPDF;
    int positionForAircraftsinPDF;
    int flagForTechStop;
    int flagForCAFees;
     NSString *pdfFileName;
    // This coordinate value is set in the beginning of roundtrip to draw line to separate between trips
    float ycoordinateForLine;
}

@property(nonatomic, retain) IBOutlet UILabel *message;
@property(nonatomic, strong) NSString *pdfFileName;

-(void)generatePDF;
-(void) generatePdfWithFilePath: (NSString *)thefilePath;


- (void)setCoordinates: (NSString *)string withfont:(UIFont *)font withCoordinates:(CGRect)coordinates;
- (void)setCoordinatesForComponent: (NSString *)string withfont:(UIFont *)font withCoordinates:(CGRect) coordinates;

- (void) drawTextAt: (NSString *)string withfont:(UIFont *)font x:(float) x   y:(float) y  w:(float) w  h:(float) h;
- (void) drawTextAt: (NSString *)string withfont:(UIFont *)font x:(float) x   y:(float) y  w:(float) w  h:(float) h alignment:(NSTextAlignment) alignment;

- (void) drawLine;

- (void) drawLineForDisclaimerText;

- (void) drawHeader;

@end
