//
//  NFDFlightProposalPDF.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NFDFlightProposalPDF.h"
#import "NFDFlightProposalCompareViewController.h"
#import "NFDFlightProposalPDFBlueprintManager.h"
#import "NFDUserManager.h"

@implementation NFDFlightProposalPDF

@synthesize prospect = _prospect;
@synthesize selectedProposals = _selectedProposals;
@synthesize blueprint = _blueprint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code  
        positionForAircraftsinPDF = 0;
        flagForTechStop = 0;
        
        self.blueprint = [[NFDFlightProposalPDFBlueprintManager sharedInstance] blueprint];
        
//        NFDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//        self.prospect = (Prospect*)[delegate.session objectForKey:@"currentProspect"];
    }
    
    return self;
}

- (void)generatePDF
{
    pageSize = CGSizeMake(1024, 790);
    NSString *fileName = @"FlightProposal.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    countForNoofPagesInPDF = 1;
    
    // Call to generate PDF method
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
    NSArray *entities = [self.blueprint objectForKey:@"entities"];
    
    NSMutableArray *gradients = [[NSMutableArray alloc] init];
    NSMutableArray *rowHighlights = [[NSMutableArray alloc] init];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    NSMutableArray *underlines = [[NSMutableArray alloc] init];
    
    for (NSDictionary *entity in entities)
    {        
        NSString *entityType = [entity objectForKey:@"type"];
        
        if ([entityType isEqualToString:@"GradientLayer"])
        {
            [gradients addObject:entity];
        }
        else if ([entityType isEqualToString:@"RowHighlight"])
        {
            [rowHighlights addObject:entity];
        }
        else if ([entityType isEqualToString:@"Label"])
        {
            [labels addObject:entity];
        }
        else if ([entityType isEqualToString:@"ImageView"] && [entity objectForKey:@"purpose"])
        {
            [underlines addObject:entity];
        }
    }
    // draw shaded areas first
    [self drawGradients:gradients];
    // now, draw row tinting over shaded areas, but before text
    [self drawRowHighlights:rowHighlights];      
    // draw the thin blue underlines
    [self drawUnderlines:underlines];
    // ok, draw text AFTER shading since I can't figure out how to get alpha values to actually work
    [self drawLabels:labels];

    [self drawDisclaimer];
    
    [self drawProspectInformation];
    
    [self drawSalesPersonInformation];
    
    [self drawLogo];
    
    [self drawDate];
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

- (void)drawGradients:(NSArray *)gradients
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (NSDictionary *entity in gradients)
    {        
        CGPoint origin = CGPointMake([[entity objectForKey:@"origin.x"] floatValue],
                                     [[entity objectForKey:@"origin.y"] floatValue]);
        
        CGSize size = CGSizeMake([[entity objectForKey:@"size.width"] floatValue],
                                 [[entity objectForKey:@"size.height"] floatValue]);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGFloat locations[] = {0.0,1.0};
        
        
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        if (size.height > ROW_HEIGHT*1.25)
        {
            // shaded column
            
            // only want to draw visible rectangular region between header and footer
            // increase origin.y by 8
            origin.y += 8;
            // decrease size.height by shaded heading height
            size.height -= ROW_HEIGHT*1.25;
            
            // gradient is painted between a starting point and an ending point.
            // we'll make the starting point the origin of the rectangular area we want shaded.
            // the endpoint should be at the bottom of the rectangular area along the same vertical
            // axis of the starting point.
            
            // create an endpoint for the gradient
            CGPoint endPoint = CGPointMake(origin.x, origin.y);
            endPoint.y += size.height;
            
            // create a cgrect for clipping the gradient to a rectangle
            CGRect drawRect = CGRectMake(origin.x, origin.y, size.width, size.height);
            
            // save context as it currently is
            CGContextSaveGState(context);
            
            // add the rect to the context and then clip context to it
            CGContextAddRect(context, drawRect);
            CGContextClip(context);
            
            // define the gradient that will be painted to screen (and clipped)
            CGFloat comps[] = {
                0.988, 0.988, 0.992, 1.0,
                0.929, 0.941, 0.953, 1.0
            };
            CGGradientRef grad = CGGradientCreateWithColorComponents(colorSpace, comps, locations, 2);
            
            // draw the linear gradient to screen between start and end points
            CGContextDrawLinearGradient(context, grad, origin, endPoint, 0);
            
            // restore context to previous state (unclipped) so it is ready for next drawing
            CGContextRestoreGState(context);
        }
        else if (size.height == LABEL_HEIGHT)
        {
            // footer
            
            // save context as it currently is
            CGContextSaveGState(context);
            
            // correct width to respect inset
            size.width -= 8;
            // correct origin to respect inset
            //origin.y -= 8;
            // create an endpoint for the gradient
            CGPoint endPoint = CGPointMake(origin.x, origin.y);
            endPoint.y += size.height;
            
            // set the radius of the rounded corners
            float radius = 12;
            
            // actually start at upper left corner since the bottoms corners are rounded.
            CGContextMoveToPoint(context, origin.x, origin.y);
            CGContextAddLineToPoint(context, origin.x+size.width, origin.y);
            CGContextAddArcToPoint(context, origin.x+size.width, origin.y+size.height, origin.x, origin.y+size.height, radius);
            CGContextAddArcToPoint(context, origin.x, origin.y+size.height, origin.x, origin.y, radius);
            CGContextAddLineToPoint(context, origin.x, origin.y);
            CGContextClosePath(context);
            
            // add the path to the context and then clip context to it
            CGContextClip(context);
            
            // define the gradient that will be painted to screen (and clipped)
            CGFloat comps[] = {
                0.298, 0.412, 0.553, 1.0,
                0.004, 0.169, 0.365, 1.0
            };
            CGGradientRef grad = CGGradientCreateWithColorComponents(colorSpace, comps, locations, 2);
            
            // draw the linear gradient to screen between start and end points
            CGContextDrawLinearGradient(context, grad, origin, endPoint, 0);
            
            // restore context to previous state (unclipped) so it is ready for next drawing
            CGContextRestoreGState(context);
        }
        else 
        {
            // header with rounded top corners
            
            // save context as it currently is
            CGContextSaveGState(context);
            
            size.height += 4;
            
            // correct width to respect inset
            size.width -= 8;
            // correct origin to respect inset
            origin.y -= 8;
            // create an endpoint for the gradient
            CGPoint endPoint = CGPointMake(origin.x, origin.y);
            endPoint.y += size.height;
            
            // set the radius of the rounded corners
            float radius = 12;
            
            // actually start at lower left corner since the top corners are rounded.
            CGContextMoveToPoint(context, origin.x, origin.y+size.height);
            CGContextAddArcToPoint(context, origin.x, origin.y, origin.x+radius, origin.y, radius);
            CGContextAddArcToPoint(context, origin.x+size.width, origin.y, origin.x+size.width, origin.y+size.height, radius);
            CGContextAddLineToPoint(context, origin.x+size.width, origin.y+size.height);
            CGContextClosePath(context);
            
            // add the path to the context and then clip context to it
            CGContextClip(context);
            
            // define the gradient that will be painted to screen (and clipped)
            CGFloat comps[] = {
                0.298, 0.412, 0.553, 1.0,
                0.004, 0.169, 0.365, 1.0
            };
            CGGradientRef grad = CGGradientCreateWithColorComponents(colorSpace, comps, locations, 2);
            
            // draw the linear gradient to screen between start and end points
            CGContextDrawLinearGradient(context, grad, origin, endPoint, 0);
            
            // restore context to previous state (unclipped) so it is ready for next drawing
            CGContextRestoreGState(context);
        }
    }
}

- (void)drawRowHighlights:(NSArray *)rowHighlights
{    
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (NSDictionary *entity in rowHighlights)
    {        
        CGPoint origin = CGPointMake([[entity objectForKey:@"origin.x"] floatValue],
                                     [[entity objectForKey:@"origin.y"] floatValue]);
        
        CGSize size = CGSizeMake([[entity objectForKey:@"size.width"] floatValue],
                                 [[entity objectForKey:@"size.height"] floatValue]);
        
        CGRect shadeRect = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        CGContextSaveGState(context);
        CGContextSetRGBFillColor(context, 0, 0.165, 0.361, 0.05);
        CGContextFillRect(context, shadeRect);
        CGContextRestoreGState(context);
    }
}

- (void)drawUnderlines:(NSArray *)underlines
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (NSDictionary *entity in underlines)
    {
        // still can't get transparency to work right, so faking it with very thin blue diamond shape
        // (oh, cool. it looks good)
        CGSize size = CGSizeMake([[entity objectForKey:@"size.width"] floatValue],1);
        CGPoint origin = CGPointMake([[entity objectForKey:@"origin.x"] floatValue], [[entity objectForKey:@"origin.y"] floatValue]);
        
        origin.y -= 2;
        origin.x += 4;
        size.width -= 8;
        
        CGRect drawRect = CGRectMake(origin.x, origin.y, size.width, 1);
        
        CGContextSaveGState(context);
        
        CGContextAddRect(context, drawRect);
        
        UIColor *color = [UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:1];
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        
//        CGContextMoveToPoint(context, origin.x, origin.y+size.height/2.0);
//        CGContextAddLineToPoint(context, origin.x+size.width/2.0, origin.y);
//        CGContextAddLineToPoint(context, origin.x+size.width, origin.y+size.height/2.0);
//        CGContextAddLineToPoint(context, origin.x+size.width/2.0, origin.y+size.height);
//        CGContextAddLineToPoint(context, origin.x, origin.y+size.height/2.0);
//        CGContextClosePath(context);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }  
}

- (NSMutableParagraphStyle *)createParagraphStyleWithLineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    
    return paragraphStyle;
}

- (void)drawLabels:(NSArray *)labels
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (NSDictionary *entity in labels)
    {      
        NSString *text = [entity objectForKey:@"text"];
        UIFont *font = [UIFont fontWithName:[entity objectForKey:@"fontName"] size:[[entity objectForKey:@"pointSize"] floatValue]];
        CGRect drawRect = CGRectMake([[entity objectForKey:@"origin.x"] floatValue],
                                     [[entity objectForKey:@"origin.y"] floatValue],
                                     [[entity objectForKey:@"size.width"] floatValue],
                                     [[entity objectForKey:@"size.height"] floatValue]);
        

        CGContextSaveGState(context);
        
        if ([entity objectForKey:@"shadowColor"])
        {
            CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, [[UIColor colorWithWhite:0 alpha:1] CGColor]);
        }
        

        CGContextSetTextDrawingMode(context, kCGTextFill);
        UIColor *textColor = [entity objectForKey:@"textColor"];
        CGColorRef color = [textColor CGColor];
        CGContextSetFillColorWithColor(context, color);
        
        NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:[[entity objectForKey:@"lineBreakMode"] intValue] alignment:[[entity objectForKey:@"textAlignment"] intValue]];
        [text drawInRect:drawRect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle}];
        
        CGContextRestoreGState(context);
    }
}

- (void)drawSalesPersonInformation
{
    NSString *salesName = [[NFDUserManager sharedManager] name];
    NSString *salesEmail = [[NFDUserManager sharedManager] email];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.1647, 0.36078, 1.0);
    
    CGRect textRect = CGRectMake(pageSize.width-310, 45, 300, 16);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    NSString *nameAndEmail = @"";
    
    if (![salesName  isEqual: @""])
    {
        nameAndEmail = salesName;
        
        if (![salesEmail  isEqual: @""])
        {
            nameAndEmail = [NSString stringWithFormat:@"%@ • %@", nameAndEmail, salesEmail];
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
    [nameAndEmail drawInRect:textRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    textRect.origin.y += 16;

}

- (void)drawProspectInformation
{    
    NSString *prospectNameText = @"";
    
    if ([[NSString stringWithFormat:@"%@", self.prospect.entity] isEqualToString:@""])
    {
        if (![self.prospect.title  isEqual: @""] && self.prospect.title)
        {
            prospectNameText = [NSString stringWithFormat:@"%@ ", self.prospect.title];
        }
        if (![self.prospect.first_name  isEqual: @""] && self.prospect.first_name)
        {
            prospectNameText = [NSString stringWithFormat:@"%@%@ ", prospectNameText, self.prospect.first_name];
        }
        if (![self.prospect.last_name  isEqual: @""] && self.prospect.last_name)
        {
            prospectNameText = [NSString stringWithFormat:@"%@%@", prospectNameText, self.prospect.last_name];
        }
    }
    else 
    {
        prospectNameText = self.prospect.entity;
    }
    
    NSString *prospectEmailText = @"";
    if (![self.prospect.email  isEqual: @""] && self.prospect.email)
    {
        prospectEmailText = self.prospect.email;
    }
    
    if ([prospectNameText  isEqual: @""])
    {
        prospectNameText = @"Prepared for no one.";
    }
    
    if ([prospectEmailText  isEqual: @""])
    {
        prospectEmailText = @"No email address provided.";
    }
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.1647, 0.36078, 1.0);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    CGRect preparedRect = CGRectMake(10, 10, 80, 16);
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    [@"Prepared for:" drawInRect:preparedRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect nameRect = CGRectMake(90, 10, 200, 16);
    
    [prospectNameText drawInRect:nameRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect emailRect = CGRectMake(90, 26, 200, 16);
    
    [prospectEmailText drawInRect:emailRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
}

// Drawing Header for PDF
- (void)drawDisclaimer
{
    NSString *disclaimerText = @"(1) This Cost Analysis is an estimate, not a contract or an offer. Prices are subject to change. (2) The Monthly Management Fee and Occupied Hourly Fee will be adjusted on January 1st each year. For Owners of the Phenom, the Monthly Management Fee and Occupied Hourly Fee will be adjusted beginning on January 1st 2014 and each January 1st thereafter. (3) Fuel will vary from month to month based on the cost of Fuel. (4) All Owners will be charged Federal noncommercial fuel taxes at a rate of $.219 per gallon plus a Federal fractional fuel surcharge at $.141 per gallon on fractional and positioning flights.  Owners of stand-alone 1/32nd shares and Owners whose contract terms do not meet the multi-year lease or ownership requirements will be subject to the 7.5% FET on the occupied hourly fees, monthly management fees, fuel variable charges, and lease or aircraft purchase costs. (5) Prepay Savings are an estimate only. Actual savings will be determined based on contract close date.";
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.1647, 0.36078, 1.0);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
  
    CGRect renderingRectForDisclaimer = CGRectMake(10, pageSize.height-100, pageSize.width - 20, 100);
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    [disclaimerText drawInRect:renderingRectForDisclaimer withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
}

- (void)drawLogo
{
    UIImage *logo = [UIImage imageNamed:@"NJLogo700W.png"];
    
    [logo drawInRect:CGRectMake(pageSize.width-168-10, 10, 168, 33)];
}

- (void)drawDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *dateText = [dateFormatter stringFromDate:date];
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.1647, 0.36078, 1.0);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
    
    CGRect renderingRect = CGRectMake(90, 42, 200, 16);
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    [dateText drawInRect:renderingRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];

}
@end
