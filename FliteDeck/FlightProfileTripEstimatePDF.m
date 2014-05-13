//
//  FlightProfileTripEstimatePDF.m
//  FliteDeck
//
//  Created by Mohit Jain on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "FlightProfileTripEstimatePDF.h"
#import "NFDAirport.h"
#import "Leg.h"
#import "NSNumber+Utilities.h"
#import "NFDUserManager.h"
#import "NFDPhoneNoFormatter.h"

@implementation FlightProfileTripEstimatePDF

@synthesize parameters;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code  
        positionForAircraftsinPDF = 0;
        flagForTechStop = 0;
        flagForCAFees = 0;
    }
    
    return self;
}

- (void)generatePDF
{
    
    // Setting properties: size, default name, path for PDF page
    //[parameters retrieveAirportsFromIds];
    pageSize = CGSizeMake(1250, 900);
    NSString *fileName = @"FlightTripEstimate.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    countForNoofPagesInPDF = [parameters.results count];
    
    // Call to generate PDF method
    [self generatePdfWithFilePath:pdfFileName];
    
}

- (NSMutableParagraphStyle *)createParagraphStyleWithLineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    
    return paragraphStyle;
}

// Drawing Header for PDF
- (void) drawSubHeader
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.1647, 0.36078, 1.0);
    
    UIFont *fontwithSize15 = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    UIFont *fontWithSize13 = [UIFont fontWithName: @"HelveticaNeue" size: 13.0];
    
    NSString *textToDrawForHeader = @"FLIGHT PROFILE TRIP ESTIMATE";
    NSString *prospectName = nil;
    
    if([parameters.prospect.entity isEqualToString:@""]){
        prospectName = [NSString stringWithFormat:@"Prepared for: %@ %@",parameters.prospect.first_name,parameters.prospect.last_name];    
    }else{
        prospectName = [NSString stringWithFormat:@"Prepared for: %@",parameters.prospect.entity]; 
    }
    
    NSString *labelAnalysis = @"Travel Profile Analysis";
    NSString *noteForRoundTrip = @"**Please note: A fuel stop is required.";
    
    NSString *productType = [NSString stringWithFormat:@"Product Type: %@",parameters.product];
    NSString *estimatePreparedBy = [NSString stringWithFormat: @"Estimate Prepared By: %@",[parameters.userInfo objectForKey:NFDUserSettingsName]];
    
    // No formatting of Phone number due to difficulty between formats globally
    NSString *officeNumber = [NSString stringWithFormat:@"Office Number: %@",[parameters.userInfo objectForKey:NFDUserSettingsPhoneWork]];
    NSString *cellNumber   = [NSString stringWithFormat:@"Mobile Number: %@",[parameters.userInfo objectForKey:NFDUserSettingsPhoneMobile]];
    
    NSString *computationCriteria_Label = @"Computation Criteria";

    // Fetching current date :
    NSDate *date = [NSDate date];
    
    // Format it
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];  
    
    
    // Convert it to a string
    
    NSString *dateString = [dateFormat stringFromDate:date];
    NSString *dateCreated = [NSString stringWithFormat:@"Prepared on: %@", dateString];
    
    // Disclaimer Text
    NSString *disclaimerText = @"Disclaimer: This quote is prepared as an estimate only.  Billing will be based on actual flight times, rates, fuel prices and taxes related to the flight.  The cost is based on current pricing at the time of the quote and does not include fees due to flying in excess of your contractual hours or incidental charges which may occur.  Incidentals can include, but not be limited to: catering, ground transportation, international fees, and crew expenses.  This document is not contractual.  All information is subject to change without notice.";
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    NSMutableParagraphStyle *paragraphStyleRightAlign = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
    
    CGSize sizeConstraint = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
    CGRect stringRect = [textToDrawForHeader boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    CGSize stringSize = stringRect.size;
    
    CGRect renderingRect = CGRectMake(50, 50, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height+20);
    
    CGRect renderingRectForDisclaimer = CGRectMake(30, 800, pageSize.width - 70, stringSize.height+30);

    [textToDrawForHeader drawInRect:renderingRect withAttributes:@{NSFontAttributeName:[UIFont fontWithName: @"HelveticaNeue-Bold" size: 24.0], NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect renderingRectForLabel = CGRectMake(50, 100, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height+20);
    
    [prospectName drawInRect:renderingRectForLabel withAttributes:@{NSFontAttributeName:[UIFont fontWithName: @"HelveticaNeue" size: 21.0], NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect renderingRectForProductType = CGRectMake(50, 123, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height+20);
    
    [productType drawInRect:renderingRectForProductType withAttributes:@{NSFontAttributeName:[UIFont fontWithName: @"HelveticaNeue" size: 21.0], NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect renderingRectForestimatePreparedBy_Label = CGRectMake(35, 600, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height+20);
    
    [estimatePreparedBy drawInRect:renderingRectForestimatePreparedBy_Label withAttributes:@{NSFontAttributeName:fontWithSize13, NSParagraphStyleAttributeName:paragraphStyle}];
        
    CGRect renderingRectForDatePreparedOn_Label = CGRectMake(35, 670, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height+20);
    
    [dateCreated drawInRect:renderingRectForDatePreparedOn_Label withAttributes:@{NSFontAttributeName:fontWithSize13, NSParagraphStyleAttributeName:paragraphStyle}];
    
    
    // Displaying a Note if Fuel Stop is required :
    
    if(flagForTechStop == 1) {
        
        CGRect renderingRectFornoteForRoundTrip_Label = CGRectMake(35, 540, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height+20);
        
        [noteForRoundTrip drawInRect:renderingRectFornoteForRoundTrip_Label withAttributes:@{NSFontAttributeName:fontWithSize13, NSParagraphStyleAttributeName:paragraphStyle}];
        
        // Reseting flag to zero to validate for other fuel stops
        flagForTechStop = 0;        
    }
    
    CGRect renderingRectForOfficeNumber_Label = CGRectMake(35, 622, pageSize.width - 2*kBorderInset - 2*kMarginInset, 
                                                           stringSize.height+20);
    
    [officeNumber drawInRect:renderingRectForOfficeNumber_Label withAttributes:@{NSFontAttributeName:fontWithSize13, NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect renderingRectForCellNumber_Label = CGRectMake(35, 646, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height+20);
    
    [cellNumber drawInRect:renderingRectForCellNumber_Label withAttributes:@{NSFontAttributeName:fontWithSize13, NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect renderingRectForDisclaimerText_Label = CGRectMake(30, 770, 200, stringSize.height+20);
    
    [computationCriteria_Label drawInRect:renderingRectForDisclaimerText_Label withAttributes:@{NSFontAttributeName:[UIFont fontWithName: @"HelveticaNeue-BoldItalic" size: 16.0], NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    CGRect renderingRectForlabelAnalysis = CGRectMake(50, kBorderInset + kMarginInset + 70, pageSize.width - 110, stringSize.height+45);
    
    [labelAnalysis drawInRect:renderingRectForlabelAnalysis withAttributes:@{NSFontAttributeName:fontwithSize15, NSParagraphStyleAttributeName:paragraphStyleRightAlign}];
    
    CGContextSetRGBFillColor(currentContext, 0.42745, 0.43137, 0.44313, 1);
    
    // "HelveticaNeue-Thin_Italic" is renamed to "HelveticaNeue-ThinItalic" in 7.1.
    UIFont *disclaimerFont = [UIFont fontWithName:@"HelveticaNeue-Thin_Italic" size:15.0];
    if (!disclaimerFont) {
        disclaimerFont = [UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:15.0];
    }
    
    [disclaimerText drawInRect:renderingRectForDisclaimer withAttributes:@{NSFontAttributeName:disclaimerFont, NSParagraphStyleAttributeName:paragraphStyle}];
}

// Drawing Text 
- (void) drawText
{
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    NSString *distance_pdf ;
    
    NSString *tripType = parameters.roundTrip ? @"round trip" : @"one way";
    if(parameters.roundTrip){
        distance_pdf = [NSString stringWithFormat:@"Distance: %.0f miles (%@)", [parameters.totalDistance floatValue]*2, tripType];  
    }else{
        distance_pdf = [NSString stringWithFormat:@"Distance: %.0f miles (%@)", [parameters.totalDistance floatValue], tripType];
    }
    
}

-(void)drawFlightComponents {
    
    AircraftTypeResults *result = [parameters.results objectAtIndex:positionForAircraftsinPDF];
    [self setAircraftData:result position:0];
}

- (void)setAircraftData:(AircraftTypeResults *)result position: (int) position{
    
    // Initializing variables
    int cont = 0;
    float ycoordinate = 240;
    
    float totalDistanceRet=0;
    float totalCostForTripRet=0;
    
    float totalDistanceOut=0;
    int totalCostForTripOut=0;
    
    
    float totalBlockTimeOut = 0;
    float totalBlockTimeRet = 0;
    float totalCostPerLegOut=0;
    
    float totalCaliforniaFeesOut = 0.0;
    
    // defining coordinate points to print values in allignment
    
    int xcoordinateForOrigin, xcoordinateForDestination, xcoordinateForFuelStop,
    xcoordinateForBlockTime, xcoordinateForDistance, xcoordinateForHourly, xcoordinateForFuel, xcoordinateForCAfees, xcoordinateForTotal;
    
    int widthForOrigin, widthForDestination;
    
    UIFont *legsFont = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
    UIFont *boldFontforTotal = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
    
    // Drawing image for aircraft selected
    
    UIImage * jetImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_silhouette.png",result.aircraft.typeName]];  
    
    [jetImage drawInRect:CGRectMake(530, 470, jetImage.size.width*0.4, jetImage.size.height*0.45)];
    
    // For One way trip 
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.1647, 0.36078, 1.0); 
    
    NSString *aircraftType = [NSString stringWithFormat:@"Aircraft Type: %@",result.name];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    
    NSMutableParagraphStyle *paragraphStyle = [self createParagraphStyleWithLineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    CGSize sizeConstraint = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
    CGRect stringRect = [aircraftType boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    CGSize stringSize = stringRect.size;
    
    CGRect renderingRectForAircraftType = CGRectMake(50, 149, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height+20);
    
    
    [aircraftType drawInRect:renderingRectForAircraftType withAttributes:@{NSFontAttributeName:[UIFont fontWithName: @"HelveticaNeue" size: 21.0], NSParagraphStyleAttributeName:paragraphStyle}];
    
    // are california taxes/fees applicable?
    for (Leg *leg in result.outLegs)
    {
        int californiaFeesCheck = (int) leg.californiaFee;
        
        if(californiaFeesCheck > 0)
        {
            flagForCAFees = 1;
        }
    }
    
    // draw the leg details
    for (Leg *leg in result.outLegs)
    {
        xcoordinateForOrigin = 40;
        
        if ([self shouldShowMoney:[[result aircraft] typeName]] )
        {
            if (flagForCAFees == 1)
            {
                widthForOrigin = widthForDestination = 330;

                xcoordinateForDestination = 370;
                xcoordinateForFuelStop = 590;
                xcoordinateForDistance = 745;
                xcoordinateForBlockTime = 840;
                xcoordinateForHourly = 879;
                xcoordinateForFuel = 1002;
                xcoordinateForCAfees = 1076;
                xcoordinateForTotal = 1135;
            }
            else
            {
                widthForOrigin = widthForDestination = 386;

                xcoordinateForDestination = 426;
                xcoordinateForFuelStop = 702;
                xcoordinateForDistance = 857;
                xcoordinateForBlockTime = 955;
                xcoordinateForHourly = 991;
                xcoordinateForFuel = 1114;
                xcoordinateForCAfees = 9999;
                xcoordinateForTotal = 1135;
            }
        }
        else
        {
            widthForOrigin = widthForDestination = 470;

            xcoordinateForDestination = 510;
            xcoordinateForFuelStop = 870;
            xcoordinateForDistance = 1040;
            xcoordinateForBlockTime = 1155;
            
            xcoordinateForHourly = 9999;
            xcoordinateForFuel = 9999;
            xcoordinateForCAfees = 9999;
            xcoordinateForTotal = 9999;
        }
        
        [self drawTextAt:[NSString stringWithFormat:@"%@ - %@ (%@)",leg.origin.airport_name,leg.origin.city_name, leg.origin.airportid] withfont:legsFont x:xcoordinateForOrigin y:ycoordinate + (position*100) w:widthForOrigin h:25 alignment:NSTextAlignmentLeft];
        
        
        [self drawTextAt:[NSString stringWithFormat:@"%@ - %@ (%@)",leg.destination.airport_name,leg.destination.city_name, leg.destination.airportid] withfont:legsFont x:xcoordinateForDestination y:ycoordinate + (position*100) w:widthForDestination h:25 alignment:NSTextAlignmentLeft];
        
        if (leg.fuelStops > 0)
        {
            NSString *fuelDisplay = @"Yes";
            
            if (leg.fuelStops > 1)
                fuelDisplay = [NSString stringWithFormat:@"Yes (%i)", leg.fuelStops];
            
            [self drawTextAt:fuelDisplay withfont:legsFont x:xcoordinateForFuelStop y:ycoordinate
             + (position*100) w:250 h:25 alignment:NSTextAlignmentLeft];
            
            flagForTechStop = 1;
        }
                
        NSString *legDistance = [[NSNumber numberWithFloat:leg.distance] numberWithCommas:0];
        
        [self drawTextAt:[NSString stringWithFormat:@"%@",legDistance] withfont:legsFont x:xcoordinateForDistance y:ycoordinate + (position*100) w:60 h:25 alignment:NSTextAlignmentRight];
        
        [self drawTextAt:[NSString stringWithFormat:@"%.1f",(float)leg.blockTime] withfont:legsFont x:xcoordinateForBlockTime y:ycoordinate + (position*100) w:40 h:25 alignment:NSTextAlignmentRight];
        
        
        NSString *occupiedhrlyRate = [[NSNumber numberWithInt: (int) leg.hourlyCost] numberWithCommas:1];
        
        [self drawTextAt:[NSString stringWithFormat:@"$%@",occupiedhrlyRate] withfont:legsFont x:xcoordinateForHourly y:ycoordinate + (position*100) w:95 h:25 alignment:NSTextAlignmentRight];
        
        NSString *fuelRate = [[NSNumber numberWithInt: (int)leg.fuelCost] numberWithCommas:1];
        
        [self drawTextAt:[NSString stringWithFormat:@"$%@",fuelRate] withfont:legsFont x:xcoordinateForFuel y:ycoordinate + (position*100) w:40 h:25 alignment:NSTextAlignmentRight];
        
        // California fees
        
        NSString *californiaFeesOutTrip = [[NSNumber numberWithInt: (int) leg.californiaFee] numberWithCommas:1];
        
        [self drawTextAt:[NSString stringWithFormat:@"$%@",californiaFeesOutTrip] withfont:legsFont x:xcoordinateForCAfees y:ycoordinate + (position*100) w:50 h:25 alignment:NSTextAlignmentRight];
        
        
        NSString *totalCostPerLeg = [[NSNumber numberWithFloat:(int)leg.totalCost] numberWithCommas:1];
        
        [self drawTextAt:[NSString stringWithFormat:@"$%@",totalCostPerLeg] withfont:legsFont x:xcoordinateForTotal y:ycoordinate + (position*100) w:88 h:25 alignment:NSTextAlignmentRight];
        
        ycoordinate +=30;
        cont++;
        
        // Rounding cost per leg to int 
        totalCostPerLegOut = (int)totalCostPerLegOut;
        // Calculating total distance, total block time and total cost for the trip 
        totalDistanceOut += leg.distance;
        totalCostForTripOut += leg.totalCost;
        totalBlockTimeOut += leg.blockTime;
        totalCaliforniaFeesOut += leg.californiaFee;
        
    }
    
    NSString *totalDistance    = [[NSNumber numberWithFloat:totalDistanceOut] numberWithCommas:0];
    NSString *totalCostForTrip = [[NSNumber numberWithFloat:totalCostForTripOut] numberWithCommas:1];
    
    [self drawTextAt:[NSString stringWithFormat:@"%@", totalDistance] withfont:boldFontforTotal x:xcoordinateForDistance y:ycoordinate + (position*100) w:60 h:25 alignment:NSTextAlignmentRight];
    
    [self drawTextAt:[NSString stringWithFormat:@"$%@", totalCostForTrip] withfont:boldFontforTotal x:xcoordinateForTotal y:ycoordinate + (position*100) w:88 h:25 
           alignment:NSTextAlignmentRight];
    
    [self drawTextAt:[NSString stringWithFormat:@"%.1f", totalBlockTimeOut] withfont:boldFontforTotal x:xcoordinateForBlockTime y:ycoordinate + (position*100) w:40 h:25 alignment:NSTextAlignmentRight];
        
    // For Round way trip
    
    if(parameters.roundTrip){
        int index = [result.retLegs count] - 1;
        
        // Drawing line at this y-coordinate position
        ycoordinateForLine = ycoordinate+30;
        
        // Roundtrip starting with this coordinate points
        ycoordinate = ycoordinateForLine + 15;
        
        for(;index >= 0; index--){
            
            Leg *leg = [result.retLegs objectAtIndex:index];
            
            [self drawTextAt:[NSString stringWithFormat:@"%@ - %@ (%@)",leg.origin.airport_name,leg.origin.city_name, leg.origin.airportid] withfont:legsFont x:xcoordinateForOrigin y:ycoordinate + (position*100) w:widthForOrigin h:25 alignment:NSTextAlignmentLeft];
            
            [self drawTextAt:[NSString stringWithFormat:@"%@ - %@ (%@)",leg.destination.airport_name,leg.destination.city_name, leg.destination.airportid] withfont:legsFont x:xcoordinateForDestination y:ycoordinate + (position*100) w:widthForDestination h:25 alignment:NSTextAlignmentLeft];
            
            
            if (leg.fuelStops > 0)
            {
                NSString *fuelDisplay = @"Yes";
                
                if (leg.fuelStops > 1)
                    fuelDisplay = [NSString stringWithFormat:@"Yes (%i)", leg.fuelStops];
                
                [self drawTextAt:fuelDisplay withfont:legsFont x:xcoordinateForFuelStop y:ycoordinate + (position*100) w:250 h:25 alignment:NSTextAlignmentCenter];
            }
            
            NSString *legDistanceRoundTrip = [[NSNumber numberWithFloat:leg.distance] numberWithCommas:0];
            
            [self drawTextAt:[NSString stringWithFormat:@"%@",legDistanceRoundTrip] withfont:legsFont x:xcoordinateForDistance y:ycoordinate + (position*100) w:60 h:25 alignment:NSTextAlignmentRight];
            
            [self drawTextAt:[NSString stringWithFormat:@"%.1f",(float)leg.blockTime] withfont:legsFont x:xcoordinateForBlockTime y:ycoordinate + (position*100) w:40 h:25 alignment:NSTextAlignmentRight];
            
            NSString *occupiedhrlyRateRoundTrip = [[NSNumber numberWithInt:(int)leg.hourlyCost] numberWithCommas:1];
            
            [self drawTextAt:[NSString stringWithFormat:@"$%@",occupiedhrlyRateRoundTrip] withfont:legsFont x:xcoordinateForHourly y:ycoordinate + (position*100) w:95 h:25 alignment:NSTextAlignmentRight];
            
            
            NSString *fuelRateRoundTrip = [[NSNumber numberWithInt:(int)leg.fuelCost] numberWithCommas:1];
            
            [self drawTextAt:[NSString stringWithFormat:@"$%@",fuelRateRoundTrip] withfont:legsFont x:xcoordinateForFuel y:ycoordinate + (position*100) w:40 h:25 alignment:NSTextAlignmentRight];
            
            // California fees for round trip
            
            NSString *californiaFeesRetTrip = [[NSNumber numberWithInt: (int) leg.californiaFee] numberWithCommas:1];
            
            [self drawTextAt:[NSString stringWithFormat:@"$%@",californiaFeesRetTrip] withfont:legsFont x:xcoordinateForCAfees y:ycoordinate + (position*100) w:50 h:25 alignment:NSTextAlignmentRight];
            
            NSString *totalCostPerLegRoundTrip = [[NSNumber numberWithFloat:(int)leg.totalCost] numberWithCommas:1];
            
            
            [self drawTextAt:[NSString stringWithFormat:@"$%@",totalCostPerLegRoundTrip] withfont:legsFont x:xcoordinateForTotal y:ycoordinate + (position*100) w:88 h:25 alignment:NSTextAlignmentRight];
            
            ycoordinate +=30;
            
            // Calculating total distance, total block time and total cost for the trip 
            totalDistanceRet += leg.distance;
            totalCostForTripRet += leg.totalCost ;
            totalBlockTimeRet += leg.blockTime;
            
        }
        
        NSString *totalDistanceRoundTrip = [[NSNumber numberWithFloat:totalDistanceRet] numberWithCommas:0];  
        
        NSString *totalCostForTripReturn = [[NSNumber numberWithFloat:totalCostForTripRet] numberWithCommas:1];        
        
        [self drawTextAt:[NSString stringWithFormat:@"%@", totalDistanceRoundTrip] withfont:boldFontforTotal x:xcoordinateForDistance y:ycoordinate + (position*100) w:60 h:25 alignment:NSTextAlignmentRight];
        
        [self drawTextAt:[NSString stringWithFormat:@"$%@", totalCostForTripReturn] withfont:boldFontforTotal x:xcoordinateForTotal y:ycoordinate + (position*100) w:88 h:25 alignment:NSTextAlignmentRight];
        
        [self drawTextAt:[NSString stringWithFormat:@"%.1f", totalBlockTimeRet] withfont:boldFontforTotal x:xcoordinateForBlockTime y:ycoordinate + (position*100) w:40 h:25 alignment:NSTextAlignmentRight];
    }
}

// Drawing images for header, Netjets Logo, etc.
- (void) drawHeader
{
    [super drawHeader];
    
    UIImage * headerComponent;
    
    AircraftTypeResults *result = [parameters.results objectAtIndex:positionForAircraftsinPDF];
    
    if (![self shouldShowMoney:result.aircraft.typeName])
    {
        headerComponent = [UIImage imageNamed:@"FlightProfileTripEstimate_PDF_Header_Minimized.PNG"]; 
    }
    else
    {
        if (flagForCAFees == 1)
        {
            headerComponent = [UIImage imageNamed:@"FlightProfileTripEstimate_PDF_Header_CA.png"]; 
        }
        else
        {
            headerComponent = [UIImage imageNamed:@"FlightProfileTripEstimate_PDF_Header.png"]; 
        }
    }
    
    [headerComponent drawInRect:CGRectMake(30, 184, 1200, headerComponent.size.height*0.4)];
}

// Main function in PDF generation
- (void) generatePdfWithFilePath: (NSString *)thefilePath
{
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    do
    {
        // Mark the beginning of a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);        
        
        // Draw some text for the page.
        [self drawText];
        
        [self drawFlightComponents];
        
        //Draw text fo our subHeader.
        [self drawSubHeader];
        
        [self drawLine];
        
        [self drawLineForDisclaimerText];
        
        // Draw an image
        [self drawHeader];
        
        countForNoofPagesInPDF--;
        positionForAircraftsinPDF++;
        
    } 
    while (countForNoofPagesInPDF!=0);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
}

/**
 Check the user preferences to determine if costs (money) should be shown.  Note 
 that costs for CE-560 (Cit V Ultra) are never shown.
 **/

-(BOOL)shouldShowMoney:(NSString *) aircraftTypeName
{
    BOOL showMoney = NO;
    
    // Never show costs for CE-560
    if ([aircraftTypeName caseInsensitiveCompare:@"CE-560"] != NSOrderedSame) {
        showMoney = [[NFDUserManager sharedManager] profileShowMoney];        
    }
    
    return showMoney;
}

@end
