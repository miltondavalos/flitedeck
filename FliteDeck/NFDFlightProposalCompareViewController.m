//
//  NFDFlightProposalCompareViewController.m
//  ProposalCalculatorPrototype
//
//  Created by Geoffrey Goetz on 3/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalCompareViewController.h"
#import "NFDFlightProposalManager.h"
#import "NFDFlightProposalCalculatorService.h"
#import "NFDProposal.h"
#import "NFDCompareSharePurchaseView.h"
#import "NFDShareFractionator.h"
#import "NFDFlightProposalAggregator.h"
#import "NFDFlightProposalPDFBlueprintManager.h"
#import "NSDate+CommonUtilities.h"

@implementation NFDFlightProposalCompareViewController
@synthesize  prospectModalViewController,modalController;

@synthesize proposalSections = _proposalSections;
@synthesize sectionDefinitions = _sectionDefinitions;
@synthesize rowDefinitions = _rowDefinitions;
@synthesize proposalColumns = _proposalColumns;
@synthesize rowLabelView = _rowLabelView;
@synthesize scrollView = _scrollView;
@synthesize columnWidth = _columnWidth;
@synthesize columnHeight = _columnHeight;
@synthesize firstColumnX = _firstColumnX;
@synthesize numberOfColumns = _numberOfColumns;
@synthesize aggregate = _aggregate;
@synthesize numberOfProposals = _numberOfProposals;
@synthesize rowHeight = _rowHeight;
@synthesize labelHeight = _labelHeight;
@synthesize paddingX = _paddingX;
@synthesize blueprint = _blueprint;
@synthesize hasFET = _hasFET;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        [self.view setAutoresizesSubviews:YES];
        [self setupSections];
        self.columnWidth = MIN_COLUMN_WIDTH;
        self.firstColumnX = ROW_LABEL_COLUMN_WIDTH;
        self.rowHeight = ROW_HEIGHT;
        self.labelHeight = LABEL_HEIGHT;
        self.paddingX = 0;
        self.aggregate = NO;
        self.hasFET = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupSections
{
    if (self.proposalSections)
    {
        self.proposalSections = nil;
    }
    
    // section names
    self.proposalSections = [NSArray arrayWithObjects:
                             @"Selection",
                             @"Purchase",
                             @"Phenom",
                             @"Lease",
                             @"Financing",
                             @"Operating",
                             @"Totals",
                             @"Prepayment", nil];
    // rows for each section
    NSMutableDictionary *sectionSelection = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             [NSMutableArray arrayWithObjects:
                                              @"Tail", 
                                              @"ContractsUntil",
                                              @"AnnualHours", nil], @"rows", nil];
    NSMutableDictionary *sectionPurchase = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSMutableArray arrayWithObjects:
                                             @"PurchasePrice", 
                                             @"FederalExciseTaxPurchase", nil], @"rows", nil];
    
    NSMutableDictionary *sectionPhenom = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSMutableArray arrayWithObjects:
                                           @"Deposit",
                                           @"ProgressPayment",
                                           @"CashDue", nil], @"rows", nil];
    
    NSMutableDictionary *sectionLease = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [NSMutableArray arrayWithObjects:
                                          @"MonthlyLeaseFee", 
                                          @"MonthlyLeaseFeeFET", nil], @"rows", nil];
    
    NSMutableDictionary *sectionFinancing = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             [NSMutableArray arrayWithObjects:
                                              @"FinancedAmount", 
                                              @"DownPayment", 
                                              @"MonthlyPayment", 
                                              @"BalloonPayment", nil], @"rows", nil];
    
    NSMutableDictionary *sectionOperating = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             [NSMutableArray arrayWithObjects:
                                              @"MonthlyManagementFee", // values will be this + "Rate" and this + "Annual"
                                              @"OccupiedHourlyFee",
                                              @"FuelVariable",
                                              @"FederalExciseTax", nil], @"rows", nil];
    
    NSMutableDictionary *sectionTotals = [[NSMutableDictionary alloc] init];
                                          
    if ([[NFDUserManager sharedManager] proposalShowHourly])
    {
        [sectionTotals setObject:[NSMutableArray arrayWithObjects:
                                  @"AnnualCost",
                                  @"AverageHourlyCost", nil] forKey:@"rows"];
    }
    else {
        [sectionTotals setObject:[NSMutableArray arrayWithObjects:
                                  @"AnnualCost", nil] forKey:@"rows"];
    }
    
    NSMutableDictionary *sectionPrepayment = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              [NSMutableArray arrayWithObjects:
                                               @"PrepaymentSavings", nil], @"rows", nil];
    
    // section display
    [sectionSelection setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [sectionPurchase setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [sectionPhenom setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [sectionLease setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [sectionFinancing setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [sectionOperating setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [sectionTotals setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [sectionPrepayment setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    
    // section heading text
    [sectionSelection setObject:@"" forKey:@"heading"];
    [sectionPurchase setObject:@"Acquisition" forKey:@"heading"];
    [sectionPhenom setObject:@"" forKey:@"heading"];
    [sectionLease setObject:@"Lease" forKey:@"heading"];
    [sectionFinancing setObject:@"Financing" forKey:@"heading"];
    [sectionOperating setObject:@"Operating" forKey:@"heading"];
    [sectionTotals setObject:@"" forKey:@"heading"];
    [sectionPrepayment setObject:@"" forKey:@"heading"];  
    // row label text
    self.rowDefinitions = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Tail", @"Tail",
                                    @"Contract", @"ContractsUntil",
                                    //@"Available", @"Available",
                                    @"Annual allotment", @"AnnualHours",
                                    @"Purchase price", @"PurchasePrice",
                                    @"Federal excise tax", @"FederalExciseTaxPurchase",
                                    @"Deposit", @"Deposit",
                                    @"Progress payment", @"ProgressPayment",
                                    @"Cash due", @"CashDue",
                                    @"Monthly lease fee", @"MonthlyLeaseFee",
                                    @"Federal excise tax", @"MonthlyLeaseFeeFET",
                                    @"Amount financed", @"FinancedAmount",
                                    @"Down payment", @"DownPayment",
                                    @"Monthly P & I", @"MonthlyPayment",
                                    @"Balloon payment", @"BalloonPayment",
                                    @"Monthly management fee (MMF)", @"MonthlyManagementFee",
                                    @"Occupied hourly fee (OHF)", @"OccupiedHourlyFee",
                                    @"Fuel", @"FuelVariable",
                                    @"Federal excise tax", @"FederalExciseTax",
                                    @"Annual cost", @"AnnualCost",
                                    @"Cost per hour", @"AverageHourlyCost",
                                    @"Annual prepay savings", @"PrepaymentSavings", nil];
    // 
    self.sectionDefinitions = [NSDictionary dictionaryWithObjectsAndKeys:
                               sectionSelection, @"Selection",
                               sectionPurchase, @"Purchase",
                               sectionPhenom, @"Phenom",
                               sectionLease, @"Lease",
                               sectionFinancing, @"Financing",
                               sectionOperating, @"Operating",
                               sectionTotals, @"Totals",
                               sectionPrepayment, @"Prepayment", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(displayFlightDetailsModal:)];
    [self.navigationItem setRightBarButtonItem:shareButton];
    
    shouldShowPricingLabel = NO;
    NSArray *proposals = [self retrieveAllSelectedProposalsForThisView];
    for (NFDProposal *proposal in proposals)
    {
        if ([[[proposal unifiedDictionary] objectForKey:@"ShouldApplyNextYearPercentageIncrease"] boolValue]) {
            shouldShowPricingLabel = YES;
        }
        
        NSString *incentiveValue = [[proposal unifiedDictionary] objectForKey:@"Incentive"];
        if (![incentiveValue isEqualToString:@"None"] && incentiveValue != nil) {
            shouldShowIncentivesLabel = YES;
        }
    }
    
    [self setupBackground];
    [self setupLogo];
    [self setupSections];
    [self setupProposals];
    self.rowLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, FIRST_ROW_Y, 1024, self.view.frame.size.height-FIRST_ROW_Y)];
    [self.rowLabelView setBackgroundColor:TRANS_COLOR];

    [self.view addSubview:self.rowLabelView];
    [self setupScrollView];
    [self updateRowDisplay];
    [self shadeColumns];
    [self updateColumnHeadings];
    self.blueprint = [[NSMutableDictionary alloc] init];
    [self parseThis:self.view atLevel:0 withParentHash:0];
    [[NFDFlightProposalPDFBlueprintManager sharedInstance] setBlueprint:self.blueprint];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)parseThis:(id)thing atLevel:(int)level withParentHash:(NSInteger)hash
{
    NSMutableDictionary *entityDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *entities = [[NSMutableArray alloc] init];
    
    float headingHeight = 80.0;
    
    if ([self.blueprint objectForKey:@"entities"])
    {
        entities = [self.blueprint objectForKey:@"entities"];
    }
    
    NSString *tracer = @"|-";
    if (level > 0)
    {   tracer = @"|-";
        for (int i=0;i<level;i++)
        {
            tracer = [NSString stringWithFormat:@"  %@",tracer];
        }
    }
    if ([thing isKindOfClass:[UIView class]])
    {
        UIView *view = (UIView *)thing;
       
        if (view.tag != kCompareViewLogoImageView && view.tag != kCompareViewBackgroundImageView)
        {
            if ([view isKindOfClass:[UILabel class]])
            {
                UILabel *labelView = (UILabel *)view;
                if (labelView.text)
                {
                    if (labelView.shadowColor)
                    {
                        [entityDict setObject:labelView.shadowColor forKey:@"shadowColor"];
                        [entityDict setObject:[NSNumber numberWithFloat:labelView.shadowOffset.width] forKey:@"shadowOffset.width"];
                        [entityDict setObject:[NSNumber numberWithFloat:labelView.shadowOffset.height] forKey:@"shadowOffset.height"];
                    }
                    [entityDict setObject:@"Label" forKey:@"type"];
                    [entityDict setObject:labelView.text forKey:@"text"];
                    [entityDict setObject:labelView.textColor forKey:@"textColor"];
                    [entityDict setObject:labelView.font forKey:@"font"];
                    [entityDict setObject:labelView.font.fontName forKey:@"fontName"];
                    [entityDict setObject:[NSNumber numberWithFloat:labelView.font.pointSize] forKey:@"pointSize"];
                    [entityDict setObject:[NSNumber numberWithInt:labelView.textAlignment] forKey:@"textAlignment"];
                    [entityDict setObject:[NSNumber numberWithInt:labelView.numberOfLines] forKey:@"numberOfLines"];
                    [entityDict setObject:[NSNumber numberWithInt:labelView.lineBreakMode] forKey:@"lineBreakMode"];
                }
                
            }
            else if ([view isKindOfClass:[UIImageView class]])
            {
                [entityDict setObject:@"ImageView" forKey:@"type"];
                if (view.frame.size.height == 1)
                {
                    [entityDict setObject:@"underline" forKey:@"purpose"];
                }
            }
            else if ([view isKindOfClass:[UIScrollView class]])
            {
            }
            else if (view.frame.origin.x == 0 && view.frame.size.width == 1024 && view.frame.size.height == 16)
            {
                [entityDict setObject:@"RowHighlight" forKey:@"type"];
            }
            else 
            {
                [entityDict setObject:@"View" forKey:@"type"];
            }
            if (view.backgroundColor && view.backgroundColor != TRANS_COLOR)
            {                
                [entityDict setObject:view.backgroundColor forKey:@"backgroundColor"];
            }
            CGPoint worldPoint = [[view superview] convertPoint:view.frame.origin toView:self.view];            
            CGSize size = view.frame.size;
            [entityDict setObject:[NSNumber numberWithFloat:view.alpha] forKey:@"alpha"];
            [entityDict setObject:[NSNumber numberWithFloat:worldPoint.x] forKey:@"origin.x"];
            [entityDict setObject:[NSNumber numberWithFloat:worldPoint.y+headingHeight] forKey:@"origin.y"];
            [entityDict setObject:[NSNumber numberWithFloat:size.width] forKey:@"size.width"];
            [entityDict setObject:[NSNumber numberWithFloat:size.height] forKey:@"size.height"];
            [entityDict setObject:[NSNumber numberWithInt:level] forKey:@"level"];
            [entityDict setObject:[NSNumber numberWithInteger:view.hash] forKey:@"hash"];

            [entityDict setObject:[NSNumber numberWithInteger:hash] forKey:@"parentHash"];
            [entities addObject:entityDict];
            [self.blueprint setObject:entities forKey:@"entities"];
            
            if ([view layer])
            {
                [self parseThis:view.layer atLevel:level withParentHash:view.hash];
            }
            if ([[view subviews] count] > 0)
            {
                level++;
                for (id subthing in [view subviews])
                {
                    [self parseThis:subthing atLevel:level withParentHash:view.hash];
                }
            }
        }
    }
    else if ([thing isKindOfClass:[CALayer class]])
    {
        CALayer *lyr = (CALayer *)thing;
        if ([lyr isKindOfClass:[CAGradientLayer class]])
        {            
            [entityDict setObject:@"GradientLayer" forKey:@"type"];
            
            for (int i=0;i<[[(CAGradientLayer *)lyr colors] count]; i++)
            {
                [entityDict setObject:[[(CAGradientLayer *)lyr colors] objectAtIndex:i] forKey:[NSString stringWithFormat:@"color%i", i]];
            }
            CGPoint worldPoint = [lyr convertPoint:lyr.frame.origin toLayer:self.view.layer];
            CGSize size = lyr.frame.size;
            
            [entityDict setObject:[NSNumber numberWithFloat:worldPoint.x] forKey:@"origin.x"];
            [entityDict setObject:[NSNumber numberWithFloat:worldPoint.y+headingHeight] forKey:@"origin.y"];
            [entityDict setObject:[NSNumber numberWithFloat:size.width] forKey:@"size.width"];
            [entityDict setObject:[NSNumber numberWithFloat:size.height] forKey:@"size.height"];

        }
        else {
            [entityDict setObject:@"Layer" forKey:@"type"];
        }
        [entityDict setObject:[NSNumber numberWithInt:level] forKey:@"level"];
        [entityDict setObject:[NSNumber numberWithInteger:lyr.hash] forKey:@"hash"];
        [entityDict setObject:[NSNumber numberWithInteger:hash] forKey:@"parentHash"];

        [entities addObject:entityDict];
        [self.blueprint setObject:entities forKey:@"entities"];
        
        if ([[lyr sublayers] count] > 0)
        {
            level++;
            for (id subthing in [lyr sublayers])
            {
                if ([subthing isKindOfClass:[CAGradientLayer class]])
                {
                    [self parseThis:subthing atLevel:level withParentHash:lyr.hash];
                }
            }
        }
    }
    else {
    }
}

- (void)setupBackground
{
    UIImage *image = [UIImage imageNamed:@"LightBG.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [imageView setContentMode:UIViewContentModeTopLeft];
    [imageView setImage:image];
    [imageView setTag:kCompareViewBackgroundImageView];
    [self.view addSubview:imageView];
}

- (void)setupLogo
{
    UIImage *image = [UIImage imageNamed:@"NJLogoSmall.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-160, self.view.frame.size.height-40, 150, 40)];

    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
    [imageView setContentMode:UIViewContentModeBottomRight];
    [imageView setImage:image];
    [imageView setTag:kCompareViewLogoImageView];
    [self.view addSubview:imageView];
}

- (void)setupProposals
{
    // switch off product-dependent sections
    [[self.sectionDefinitions objectForKey:@"Purchase"] setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    [[self.sectionDefinitions objectForKey:@"Phenom"] setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    [[self.sectionDefinitions objectForKey:@"Lease"] setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    [[self.sectionDefinitions objectForKey:@"Financing"] setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    [[self.sectionDefinitions objectForKey:@"Prepayment"] setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    self.hasFET = NO;
    
    BOOL showOHFRow = NO;
    BOOL showMMFRow = NO;
    
    NSArray *proposals = [self retrieveAllSelectedProposalsForThisView];
    for (NFDProposal *proposal in proposals)
    {
        switch ([[proposal productCode] intValue]) {
            case SHARE_FINANCE_PRODUCT:
                [[self.sectionDefinitions objectForKey:@"Financing"] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
                break;
            case SHARE_LEASE_PRODUCT:
                [[self.sectionDefinitions objectForKey:@"Lease"] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
                break;
            case SHARE_PURCHASE_PRODUCT:
            case CARD_PRODUCT:
            case COMBO_CARD_PRODUCT:
                [[self.sectionDefinitions objectForKey:@"Purchase"] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
                break;
            case PHENOM_TRANSITION_LEASE_PRODUCT:
                [[self.sectionDefinitions objectForKey:@"Lease"] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
                break;
            case PHENOM_TRANSITION_PURCHASE_PRODUCT:
                [[self.sectionDefinitions objectForKey:@"Purchase"] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
                [[self.sectionDefinitions objectForKey:@"Phenom"] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
                break;
            default:
                break;
        }
        
        switch ([[proposal productCode] intValue]) {
            case SHARE_FINANCE_PRODUCT:
            case SHARE_LEASE_PRODUCT:
            case SHARE_PURCHASE_PRODUCT:
                if ([[[proposal unifiedDictionary] objectForKey:@"FederalExciseTaxAnnual"] floatValue] > 0)
                {
                    self.hasFET = YES;
                }
                showMMFRow = YES;
                showOHFRow = YES;
                break;
            case CARD_PRODUCT:
            case COMBO_CARD_PRODUCT:
                self.hasFET = YES;
                break;
            case PHENOM_TRANSITION_LEASE_PRODUCT:
            {
                if ([[[proposal unifiedDictionary] objectForKey:@"FederalExciseTaxAnnual"] floatValue] > 0)
                {
                    self.hasFET = YES;
                }
                showMMFRow = YES;
                showOHFRow = YES;
            }
            default:
                break;
        }
        
        if ([[[proposal unifiedDictionary] objectForKey:@"PrepaymentSavings"] floatValue] > 0)
        {
            [[self.sectionDefinitions objectForKey:@"Prepayment"] setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        }
        
        
        
    }
    
    if (!self.hasFET)
    {
        [[[self.sectionDefinitions objectForKey:@"Purchase"] objectForKey:@"rows"] removeObject:@"FederalExciseTaxPurchase"];
        [[[self.sectionDefinitions objectForKey:@"Lease"] objectForKey:@"rows"] removeObject:@"MonthlyLeaseFeeFET"];
        [[[self.sectionDefinitions objectForKey:@"Operating"] objectForKey:@"rows"] removeObject:@"FederalExciseTax"];
    }

    if (!showMMFRow)
    {
        [[[self.sectionDefinitions objectForKey:@"Operating"] objectForKey:@"rows"] removeObject:@"MonthlyManagementFee"];
    }
    
    if (!showOHFRow)
    {
        [[[self.sectionDefinitions objectForKey:@"Operating"] objectForKey:@"rows"] removeObject:@"OccupiedHourlyFee"];
    }
    
    self.numberOfProposals = [[self retrieveAllSelectedProposalsForThisView] count];
    self.numberOfColumns = self.aggregate ? self.numberOfProposals + 1 : self.numberOfProposals;
    
    self.columnWidth = MIN_COLUMN_WIDTH;
    self.rowHeight = ROW_HEIGHT;
    self.labelHeight = LABEL_HEIGHT;
    self.paddingX = 0;
    self.firstColumnX = self.paddingX + ROW_LABEL_COLUMN_WIDTH;
    
    if (self.numberOfProposals == 1)
    {
        self.columnWidth = 240;
    }

}


- (void)updateColumnHeadings
{
    for (int colNum=0; colNum<self.numberOfColumns; colNum++)
    {
        
        NSString *productText = @"";
        
        NSString *aircraftText = @"";
        
        NSString *cardHoursText = @"";
        
        BOOL shouldShowIncentive = NO;
        NSString *incentiveText = @"";
        
        int widthFactor = 1;
        
        if (colNum < self.numberOfProposals)
        {            
            NFDProposal *proposal = [[self retrieveAllSelectedProposalsForThisView] objectAtIndex:colNum];
            switch (proposal.productCode.intValue) 
            {
                case SHARE_FINANCE_PRODUCT:
                    productText = [NSString stringWithFormat:@"%@ FINANCE", [NFDShareFractionator fractionStringForShareHours:[[[proposal unifiedDictionary] objectForKey:@"AnnualHours"] intValue]]];
                    break;
                case SHARE_LEASE_PRODUCT:
                    productText = [NSString stringWithFormat:@"%@ LEASE", [NFDShareFractionator fractionStringForShareHours:[[[proposal unifiedDictionary] objectForKey:@"AnnualHours"] intValue]]];
                    break;
                case SHARE_PURCHASE_PRODUCT:
                    productText = [NSString stringWithFormat:@"%@ PURCHASE", [NFDShareFractionator fractionStringForShareHours:[[[proposal unifiedDictionary] objectForKey:@"AnnualHours"] intValue]]];
                    break;
                case CARD_PRODUCT:
                    cardHoursText = [[[proposal unifiedDictionary] objectForKey:@"CardHours"] uppercaseString];
                    if ([[[proposal unifiedDictionary] objectForKey:@"IsCrossCountrySelected"] boolValue]) {
                        cardHoursText = @"X-Country Card";
                    }
                    if ([[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue] > 1)
                    {
                        productText = [NSString stringWithFormat:@"(%i) %@", [[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue], cardHoursText];
                    }
                    else 
                    {
                        productText = cardHoursText;
                    }
                    break;
                case COMBO_CARD_PRODUCT:
                    if ([[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue] > 1)
                    {
                        productText = [[NSString stringWithFormat:@"(%i) %@", [[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue], @"25 HR COMBO CARDS"] uppercaseString];
                    }
                    else 
                    {
                        productText = @"25 HR COMBO CARD";
                    }
                    break;
                case PHENOM_TRANSITION_LEASE_PRODUCT:
                    productText = @"PHENOM TRANSITION";
                    widthFactor = 2;
                    break;
                    
                case PHENOM_TRANSITION_PURCHASE_PRODUCT:
                    productText = @"";
                    break;
                default:
                    break;
            }
            NFDAircraftInventory *aircraftInventory;
            switch (proposal.productCode.intValue) {
                case SHARE_FINANCE_PRODUCT:
                case SHARE_PURCHASE_PRODUCT:
                    aircraftInventory = [[proposal productParameters] objectForKey:@"AircraftInventory"];

                    aircraftText = [NSString stringWithFormat:@"%@ %@", [[proposal unifiedDictionary] objectForKey:@"Year"], [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[aircraftInventory type]]];
                    break;
                case SHARE_LEASE_PRODUCT:
                    aircraftText = [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[[proposal unifiedDictionary] objectForKey:@"AircraftChoice"]];
                    break;
                case CARD_PRODUCT:
                case COMBO_CARD_PRODUCT:{
                    aircraftText = [[proposal unifiedDictionary] objectForKey:@"AircraftChoice"];
                    incentiveText = [[proposal unifiedDictionary] objectForKey:@"Incentive"];
                    if (![incentiveText isEqualToString:@"None"]) {
                        shouldShowIncentive = YES;
                    }
                    break;
                }
                case PHENOM_TRANSITION_LEASE_PRODUCT:
                    aircraftText = @"CITATION EXCEL";
                    break;
                    
                case PHENOM_TRANSITION_PURCHASE_PRODUCT:
                    aircraftText = @"PHENOM 300";
                    break;
                default:
                    break;
            }
        }
        else if (self.aggregate)
        {
            productText = @"AGGREGATE";
        }
        
        UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth, 10, self.columnWidth*widthFactor, self.rowHeight*1.5)];
        [productLabel setText:productText];
        [productLabel setTextColor:[UIColor whiteColor]];
        [productLabel setFont:PRODUCT_HEADING_FONT];
        [productLabel setBackgroundColor:TRANS_COLOR];
        [productLabel setTextAlignment:NSTextAlignmentCenter];
        [productLabel setShadowColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [productLabel setShadowOffset:CGSizeMake(0, 1)];
        [self.scrollView addSubview:productLabel];

        UILabel *aircraftLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth, productLabel.frame.size.height+10, self.columnWidth, self.rowHeight*2)];
        [aircraftLabel setText:[aircraftText uppercaseString]];
        [aircraftLabel setTextColor:NORMAL_TEXT_COLOR];
        [aircraftLabel setFont:AIRCRAFT_TEXT_FONT];
        [aircraftLabel setBackgroundColor:TRANS_COLOR];
        [aircraftLabel setTextAlignment:NSTextAlignmentCenter];
        [aircraftLabel setNumberOfLines:2];
        [aircraftLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        [self.scrollView addSubview:aircraftLabel];
        
        if (shouldShowIncentive) {
            UILabel *incentiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth, (productLabel.frame.size.height + aircraftLabel.frame.size.height + 10), self.columnWidth, self.rowHeight)];
            [incentiveLabel setText:[incentiveText uppercaseString]];
            [incentiveLabel setTextColor:NORMAL_TEXT_COLOR];
            [incentiveLabel setFont:[UIFont boldSystemFontOfSize:10]];
            [incentiveLabel setBackgroundColor:TRANS_COLOR];
            [incentiveLabel setTextAlignment:NSTextAlignmentCenter];
            [incentiveLabel setNumberOfLines:1];
            
            [self.scrollView addSubview:incentiveLabel];
        }
        
        UIImage *underlineImage = [UIImage imageWithCGImage:[[UIImage imageNamed:@"StipeTransBlueTrans.png"] CGImage] scale:1.0 orientation:UIImageOrientationLeft];
        
        UIImageView *underlineView = [[UIImageView alloc] initWithImage:underlineImage];
        float underlineViewYCoord = productLabel.frame.size.height + aircraftLabel.frame.size.height + (self.rowHeight*2) + 9;
        [underlineView setFrame:CGRectMake(colNum*self.columnWidth, underlineViewYCoord, self.columnWidth, 1)];
        [underlineView setAlpha:0.9];
        [self.scrollView addSubview:underlineView];
    }
}

- (void)updateRowDisplay
{
    self.columnHeight = 0.0;
    CGFloat sectionY = 0.0;
    
    UIImage *underlineImage = [UIImage imageWithCGImage:[[UIImage imageNamed:@"StipeTransBlueTrans.png"] CGImage] scale:1.0 orientation:UIImageOrientationLeft];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [numberFormatter setMaximumFractionDigits:0];
    
    if (shouldShowIncentivesLabel) {
        UIView *incentiveRowShadeView = [[UIView alloc] initWithFrame:CGRectMake(0, (FIRST_ROW_Y - (ROW_HEIGHT*1) + 3), 1024, self.labelHeight)];
        [incentiveRowShadeView setBackgroundColor:[UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:0.05]];
        [self.view addSubview:incentiveRowShadeView];
        
        UILabel *incentiveRowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.paddingX+10, 0, self.firstColumnX, incentiveRowShadeView.frame.size.height)];
        [incentiveRowLabel setTextColor:NORMAL_TEXT_COLOR];
        [incentiveRowLabel setBackgroundColor:TRANS_COLOR];
        [incentiveRowLabel setFont:ROW_LABEL_FONT];
        [incentiveRowLabel setText:@"ENHANCEMENT"];
        [incentiveRowShadeView addSubview:incentiveRowLabel];
    }
    
    for (NSString *section in self.proposalSections)
    {
        if ([[[self.sectionDefinitions objectForKey:section] objectForKey:@"enabled"] boolValue])
        {
            int numberOfRows = [[[self.sectionDefinitions objectForKey:section] objectForKey:@"rows"] count];
            CGFloat sectionHeight = (1+numberOfRows) * self.rowHeight; 
            CGFloat sectionWidth = self.firstColumnX;
            UIView *sectionLabelsView = [[UIView alloc] initWithFrame:CGRectMake(0, sectionY, sectionWidth, sectionHeight)];
            [sectionLabelsView setBackgroundColor:TRANS_COLOR];
            [self.rowLabelView addSubview:sectionLabelsView];
            
            NSString *sectionHeadingLabelText = [[self.sectionDefinitions objectForKey:section] objectForKey:@"heading"];
            if (![sectionHeadingLabelText isEqualToString:@""])
            {
                UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.paddingX+10, 0, sectionWidth, self.labelHeight)];
                [sectionLabel setText:[sectionHeadingLabelText uppercaseString]];
                [sectionLabel setTextColor:HEADING_TEXT_COLOR];
                [sectionLabel setBackgroundColor:TRANS_COLOR];
                [sectionLabel setFont:HEADING_TEXT_FONT];
                [sectionLabelsView addSubview:sectionLabel];

                UIImageView *underlineView = [[UIImageView alloc] initWithImage:underlineImage];
                [underlineView setFrame:CGRectMake(self.paddingX, self.rowHeight, ROW_LABEL_COLUMN_WIDTH, 1)];
                [underlineView setAlpha:0.9];
                [sectionLabelsView addSubview:underlineView];
            }            
            int i = 1;
            
            for (NSString *row in [[self.sectionDefinitions objectForKey:section] objectForKey:@"rows"])
            {
                // shade every other row, starting with first row after section heading
                if ((i+1)%2 == 0)
                {
                    UIView *rowShadeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.rowHeight * i, 1024, self.labelHeight)];
                    [rowShadeView setBackgroundColor:[UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:0.05]];
                    [sectionLabelsView addSubview:rowShadeView];
                }
                
                // add row label in left-hand column
                
                UILabel *rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.paddingX+10, self.rowHeight * i, sectionWidth-10, self.labelHeight)];
                [rowLabel setText:[[self.rowDefinitions objectForKey:row] uppercaseString]];
                [rowLabel setTextColor:NORMAL_TEXT_COLOR];
                [rowLabel setBackgroundColor:TRANS_COLOR];
                [rowLabel setFont:ROW_LABEL_FONT];
                [sectionLabelsView addSubview:rowLabel];
                
                
                // add label with value for row in each column
                
                NSArray *proposals = [self retrieveAllSelectedProposalsForThisView];
                
                UIView *sectionDetailsView = [[UIView alloc] initWithFrame:CGRectMake(0, (sectionY+80), self.numberOfColumns * self.columnWidth, sectionHeight)];
                [self.scrollView addSubview:sectionDetailsView];
                
                for (int colNum=0; colNum<self.numberOfColumns; colNum++)
                {
                    if (![section isEqualToString:@"Operating"] && ![section isEqualToString:@"Lease"])
                    {
                        NSNumber *rowValue;
                        if (colNum < proposals.count)
                        {
                            rowValue = [[[proposals objectAtIndex:colNum] unifiedDictionary] objectForKey:row];
                        }
                        else if (self.aggregate)
                        {
                            rowValue = [NFDFlightProposalAggregator aggregatedValueFor:row];
                        }
                        if ([row isEqualToString:@"PrepaymentSavings"])
                        {
                            UIImage *underlineImage = [UIImage imageWithCGImage:[[UIImage imageNamed:@"StipeTransBlueTrans.png"] CGImage] scale:1.0 orientation:UIImageOrientationLeft];
                            
                            UIImageView *underlineView = [[UIImageView alloc] initWithImage:underlineImage];
                            [underlineView setFrame:CGRectMake(colNum*self.columnWidth, self.rowHeight, self.columnWidth, 1)];
                            [underlineView setAlpha:0.9];
                            [sectionDetailsView addSubview:underlineView];
                        }
                        if (rowValue)
                        {
                            UILabel *rowValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth, self.rowHeight * i, self.columnWidth, self.labelHeight)];
                            
                            if ([row isEqualToString:@"AnnualHours"])
                            {
                                [rowValueLabel setText:[NSString stringWithFormat:@"%@ hours", rowValue]];
                            }
                            
                            if ([section isEqualToString:@"Selection"])
                            {
                                [rowValueLabel setText:[[NSString stringWithFormat:@"%@",rowValue] uppercaseString]];
                            }
                            else if ([rowValue floatValue] == 0)
                            {
              
                                    [rowValueLabel setText:@""]; 
                                
                            }
                            else
                            {
                                [rowValueLabel setText:[numberFormatter stringFromNumber:rowValue]];
                            }
                            
                            if ([row isEqualToString:@"PurchasePrice"] && colNum < proposals.count)
                            {
                                if ([[[proposals objectAtIndex:colNum] productCode] intValue] == SHARE_FINANCE_PRODUCT)
                                {
                                    [rowValueLabel setText:@""];
                                }
                            }
                            
                            [rowValueLabel setTextColor:NORMAL_TEXT_COLOR];
                            [rowValueLabel setBackgroundColor:TRANS_COLOR];
                            [rowValueLabel setFont:NORMAL_TEXT_FONT];
                            [rowValueLabel setTextAlignment:NSTextAlignmentCenter];
                            [sectionDetailsView addSubview:rowValueLabel];       
                            
                            if ([row isEqualToString:@"PrepaymentSavings"] && colNum < proposals.count)
                            {
                                if (![[[[proposals objectAtIndex:colNum] unifiedDictionary] objectForKey:@"PrepayEstimate"] isEqual:@"None"])
                                {
                                    UILabel *prepayLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth, 0, self.columnWidth, self.rowHeight)];
                                    [prepayLabel setText:[[[proposals objectAtIndex:colNum] unifiedDictionary] objectForKey:@"PrepayEstimate"]];
                                    [prepayLabel setTextColor:HEADING_TEXT_COLOR];
                                    [prepayLabel setFont:HEADING_TEXT_FONT];
                                    [prepayLabel setBackgroundColor:TRANS_COLOR];
                                    [prepayLabel setTextAlignment:NSTextAlignmentCenter];
                                    
                                    [sectionDetailsView addSubview:prepayLabel];
                                }
                            }
                        }
                    }
                    else
                    {
                        BOOL showLeaseSection = NO;
                        if ((colNum == proposals.count) || ([[[proposals objectAtIndex:colNum] productCode] intValue] == SHARE_LEASE_PRODUCT || [[[proposals objectAtIndex:colNum] productCode] intValue] == PHENOM_TRANSITION_LEASE_PRODUCT))
                        {
                            showLeaseSection = YES;
                        }
                        if ((showLeaseSection && [section isEqualToString:@"Lease"]) || ![section isEqualToString:@"Lease"])
                        {
                            if (i == 1)
                            {
                                UILabel *rowRateHeadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth, 0, self.columnWidth/2, self.labelHeight)];
                                UILabel *rowAnnualHeadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth + self.columnWidth/2, 0, self.columnWidth/2, self.labelHeight)];
                                
                                [rowRateHeadingLabel setText:@"Rate"];
                                [rowRateHeadingLabel setTextColor:HEADING_TEXT_COLOR];
                                [rowRateHeadingLabel setFont:HEADING_TEXT_FONT];
                                [rowRateHeadingLabel setBackgroundColor:TRANS_COLOR];
                                [rowRateHeadingLabel setTextAlignment:NSTextAlignmentCenter];
                                
                                [rowAnnualHeadingLabel setText:@"Annual"];
                                [rowAnnualHeadingLabel setTextColor:HEADING_TEXT_COLOR];
                                [rowAnnualHeadingLabel setFont:HEADING_TEXT_FONT];
                                [rowAnnualHeadingLabel setBackgroundColor:TRANS_COLOR];
                                [rowAnnualHeadingLabel setTextAlignment:NSTextAlignmentCenter];
                                
                                [sectionDetailsView addSubview:rowRateHeadingLabel];
                                [sectionDetailsView addSubview:rowAnnualHeadingLabel];
                                
                                
                                UIImageView *underlineRateView = [[UIImageView alloc] initWithImage:underlineImage];
                                [underlineRateView setFrame:CGRectMake(colNum*self.columnWidth, self.rowHeight, self.columnWidth/2, 1)];
                                [underlineRateView setAlpha:0.9];
                                [sectionDetailsView addSubview:underlineRateView];
                                
                                UIImageView *underlineAnnualView = [[UIImageView alloc] initWithImage:underlineImage];
                                [underlineAnnualView setFrame:CGRectMake(colNum*self.columnWidth + self.columnWidth/2, self.rowHeight, self.columnWidth/2, 1)];
                                [underlineAnnualView setAlpha:0.9];
                                [sectionDetailsView addSubview:underlineAnnualView];
                            }
                            
                            NSNumber *rowRateValue;
                            
                            NSNumber *rowAnnualValue;
                            
                            
                            if (colNum < proposals.count)
                            {
                                rowRateValue = [[[proposals objectAtIndex:colNum] unifiedDictionary] objectForKey:[NSString stringWithFormat:@"%@Rate", row]];
                                rowAnnualValue = [[[proposals objectAtIndex:colNum] unifiedDictionary] objectForKey:[NSString stringWithFormat:@"%@Annual", row]];
                            }
                            else if (self.aggregate)
                            {
                                rowRateValue = [NFDFlightProposalAggregator aggregatedValueFor:[NSString stringWithFormat:@"%@Rate", row]];
                                rowAnnualValue = [NFDFlightProposalAggregator aggregatedValueFor:[NSString stringWithFormat:@"%@Annual", row]];
                            }
                            
                            if (!(([row isEqual:@"FederalExciseTax"] || [row isEqual:@"MonthlyLeaseFeeFET"]) && (rowAnnualValue.intValue == 0)))
                            {
                                if (rowRateValue)
                                {
                                    UILabel *rowRateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth, self.rowHeight * i, self.columnWidth/2, self.labelHeight)];
                                    if ([row isEqualToString:@"FederalExciseTax"])
                                    {
                                        [rowRateValueLabel setText:@"7.5%"];
                                    }
                                    else 
                                    {
                                        [rowRateValueLabel setText:[numberFormatter stringFromNumber:rowRateValue]];

                                    }
                                    [rowRateValueLabel setTextColor:NORMAL_TEXT_COLOR];
                                    [rowRateValueLabel setBackgroundColor:TRANS_COLOR];
                                    [rowRateValueLabel setFont:NORMAL_TEXT_FONT];
                                    [rowRateValueLabel setTextAlignment:NSTextAlignmentCenter];
                                    [sectionDetailsView addSubview:rowRateValueLabel]; 
                                }
                                
                                if (rowAnnualValue)
                                {
                                    UILabel *rowAnnualValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(colNum*self.columnWidth + self.columnWidth/2, self.rowHeight * i, self.columnWidth/2, self.labelHeight)];
                                    [rowAnnualValueLabel setText:[numberFormatter stringFromNumber:rowAnnualValue]];
                                    
                                    [rowAnnualValueLabel setTextColor:NORMAL_TEXT_COLOR];
                                    [rowAnnualValueLabel setBackgroundColor:TRANS_COLOR];
                                    [rowAnnualValueLabel setFont:NORMAL_TEXT_FONT];
                                    [rowAnnualValueLabel setTextAlignment:NSTextAlignmentCenter];
                                    [sectionDetailsView addSubview:rowAnnualValueLabel]; 
                                }
                            }
                        }
                    }
                }
                
                i++;
            }
            
            sectionY += sectionHeight + self.rowHeight/2.0;
            self.columnHeight = sectionY;
        }
    }
}

- (void)shadeColumns
{
    NSArray *proposals = [self retrieveAllSelectedProposalsForThisView];
    
    for (int i=0; i<self.numberOfColumns; i++)
    {
        int widthFactor = 1;
        BOOL drawColumn = YES;
        
        if (i < proposals.count)
        {
            if ([[[proposals objectAtIndex:i] productCode] intValue] == PHENOM_TRANSITION_PURCHASE_PRODUCT)
            {
                drawColumn = NO;
            }
            else if ([[[proposals objectAtIndex:i] productCode] intValue] == PHENOM_TRANSITION_LEASE_PRODUCT)
            {
                widthFactor = 2;
                drawColumn = YES;
            }
        }
        
        if (drawColumn)
        {
            // round rect shade over column
            UIView *columnShaderView = [[UIView alloc] initWithFrame:CGRectMake(i*self.columnWidth, 10, self.columnWidth * widthFactor, ((self.columnHeight+2.75*self.rowHeight)+30))];
            
            CGRect frame = columnShaderView.frame;
            
            frame = CGRectInset(frame, 4, 2);
            
            [columnShaderView setFrame:frame];
            
            [columnShaderView setBackgroundColor:TRANS_COLOR];
            
            UIView *gradientShade = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [gradientShade setBackgroundColor:TRANS_COLOR];
            [columnShaderView addSubview:gradientShade];
            
            [columnShaderView.layer setCornerRadius:12];
            [columnShaderView setClipsToBounds:YES];
            
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = gradientShade.bounds;
            
            if (i < self.numberOfProposals)
            {
                gradient.colors = [NSArray arrayWithObjects:
                                   (id)[[UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:0.01] CGColor],
                                   (id)[[UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:0.07] CGColor], nil];
            }
            else if (self.aggregate)
            {
                gradient.colors = [NSArray arrayWithObjects:
                                   (id)[[UIColor colorWithWhite:0 alpha:0.01] CGColor],
                                   (id)[[UIColor colorWithWhite:0 alpha:0.07] CGColor], nil];
            }
            [gradientShade.layer insertSublayer:gradient atIndex:0];
            
            // lower 'cap' of column
            UIView *bookend = [[UIView alloc] initWithFrame:CGRectMake(0, columnShaderView.frame.size.height-self.labelHeight, self.columnWidth*widthFactor, self.labelHeight)];
            [bookend setBackgroundColor:TRANS_COLOR];
            
            CAGradientLayer *bookendGradient = [CAGradientLayer layer];
            bookendGradient.frame = bookend.bounds;
            if (i < self.numberOfProposals)
            {
                bookendGradient.colors = [NSArray arrayWithObjects:
                                      (id)[[UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:0.7] CGColor],
                                      (id)[[UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:1.0] CGColor], nil];
            }
            else if (self.aggregate)
            {
                bookendGradient.colors = [NSArray arrayWithObjects:
                                          (id)[[UIColor colorWithWhite:0 alpha:0.7] CGColor],
                                          (id)[[UIColor colorWithWhite:0 alpha:0.9] CGColor], nil];
            }
            [bookend.layer insertSublayer:bookendGradient atIndex:0];
            
            [columnShaderView addSubview:bookend];
            
            // upper 'cap' of column
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.columnWidth*widthFactor, 1.25*self.rowHeight)];
            [header setBackgroundColor:TRANS_COLOR];
            [header setAlpha:1];
            
            CAGradientLayer *headerGradient = [CAGradientLayer layer];
            headerGradient.frame = header.bounds;
            if (i < self.numberOfProposals)
            {
                headerGradient.colors = [NSArray arrayWithObjects:
                                     (id)[[UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:0.7] CGColor],
                                     (id)[[UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:1.0] CGColor], nil];
            }
            else if (self.aggregate)
            {
                headerGradient.colors = [NSArray arrayWithObjects:
                                          (id)[[UIColor colorWithWhite:0 alpha:0.7] CGColor],
                                          (id)[[UIColor colorWithWhite:0 alpha:0.9] CGColor], nil];
            }
            [header.layer insertSublayer:headerGradient atIndex:0];
            
            [columnShaderView addSubview:header];
            
            if (shouldShowPricingLabel && i < [proposals count]) {
                NFDProposal *proposal = [proposals objectAtIndex:i];
                UILabel *nextYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(columnShaderView.frame.origin.x, columnShaderView.frame.size.height + 13, columnShaderView.frame.size.width, 20)];
                nextYearLabel.textColor = COLUMN_FOOTER_TEXT_COLOR;
                nextYearLabel.backgroundColor = TRANS_COLOR;
                nextYearLabel.numberOfLines = 2;
                nextYearLabel.font = COLUMN_FOOTER_FONT;
                nextYearLabel.textAlignment = NSTextAlignmentCenter;
                
                if ([[[proposal unifiedDictionary] objectForKey:@"ShouldApplyNextYearPercentageIncrease"] boolValue]) {
                    nextYearLabel.text = [NSString stringWithFormat:@"ESTIMATED %@ PRICING", [NSDate nextYearString]];
                } else {
                    nextYearLabel.text = @"CURRENT PRICING";
                }
                
                [self.scrollView addSubview:nextYearLabel];
            }
            
            [self.scrollView addSubview:columnShaderView];
        }
    }

}

- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.firstColumnX, 0, self.view.frame.size.width-self.firstColumnX, self.view.frame.size.height-(FIRST_ROW_Y-2.5*self.rowHeight))];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.scrollView setContentSize:CGSizeMake(self.numberOfColumns * self.columnWidth, self.scrollView.frame.size.height)];
    [self.view addSubview:self.scrollView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)backButtonTapped:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (NSArray *)retrieveAllSelectedProposalsForThisView
{
    //Fetch the array of NFDProposal objects from the NFDFlightProposalManager...
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    NSMutableArray *selectedProposals = [NSMutableArray arrayWithArray:[manager retrieveAllSelectedProposals]];
    
    BOOL allPhenom = YES;
    for (NFDProposal *proposal in selectedProposals)
    {
        if (proposal.productType.intValue != PHENOM_TRANSITION_PRODUCT_TYPE)
        {
            allPhenom = NO;
        }
    }
    
    if (allPhenom && selectedProposals.count > 2)
    {
        NSArray *phenomLeases = [selectedProposals objectsAtIndexes:[selectedProposals indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([[(NFDProposal *)obj productCode] intValue] == PHENOM_TRANSITION_LEASE_PRODUCT)
            {
                return YES;
            }
            return NO;
        }]];
        NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:(NFDProposal *)[phenomLeases objectAtIndex:0],
                                     [(NFDProposal *)[phenomLeases objectAtIndex:0] relatedProposal],
                                     [phenomLeases objectAtIndex:1],
                                     [(NFDProposal *)[phenomLeases objectAtIndex:1] relatedProposal], nil];
        selectedProposals = tempArray;
    }
    return selectedProposals;
}

- (void)displayFlightDetailsModal:(id)sender {
    
    if(prospectModalViewController == nil){
        prospectModalViewController = [[NFDProspectViewController alloc] initWithNibName:@"NFDProspectViewController" bundle:nil];
        prospectModalViewController.edgesForExtendedLayout=UIRectEdgeNone;
    }
    //Display modal view
    modalController = [[UINavigationController alloc] initWithRootViewController:prospectModalViewController];
    prospectModalViewController.selectedProposals = [[NFDFlightProposalManager sharedInstance] selectedProposals];
    prospectModalViewController.parameters = nil;
    [modalController setNavigationBarHidden:NO animated:NO];
    modalController.modalPresentationStyle = UIModalPresentationFormSheet;
    modalController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:modalController animated:YES completion:nil];
    modalController.view.superview.bounds = CGRectMake(0, 0, 750, 250);
}
@end
