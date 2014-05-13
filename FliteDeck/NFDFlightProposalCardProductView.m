//
//  NFDFlightProposalCardProductView.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 3/14/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NFDFlightProposalCardProductView.h"
#import "NFDFlightProposalCalculatorService.h"
#import "PopoverTableViewController.h"
#import "NFDFeaturesService.h"
#import "NSDate+CommonUtilities.h"

@implementation NFDFlightProposalCardProductView

#define CARD_HOURS_TABLE_VIEW 2
#define FUEL_PERIOD_TABLE_VIEW 3
#define INCENTIVES_TABLE_VIEW 4

#define AIRCRAFT_PICKER_VIEW 1
#define AIRCRAFT_COMBO_PICKER_VIEW 2
#define NUMBER_CARDS_PICKER_VIEW 3

#define AIRCRAFT_BUTTON 1
#define CARD_TYPE_BUTTON 2
#define NUMBER_CARDS_BUTTON 3
#define FUEL_PERIOD_BUTTON 4
#define INCENTIVES_BUTTON 5

#define PICKER_HEIGHT 216
#define PICKER_WIDTH 340
#define PICKER_X_OFFSET -12
#define PICKER_Y_OFFSET -12

#define POPOVER_TABLE_HEIGHT_1_ROW 44
#define BUTTONS_BACKGROUND_VIEW_HEIGHT 169

#define CROSS_COUNTRY_TRIGGER @"Citation X"
#define INCENTIVE_UPGRADE @"Aircraft Upgrade"
#define INCENTIVE_36_MONTHS @"36 Month Term"

@synthesize detailViewController = _detailViewController;
@synthesize popover;
@synthesize cardHoursArray = _cardHoursArray;
@synthesize numberOfCardsArray = _numberOfCardsArray;
@synthesize fuelPeriodsArray = _fuelPeriodsArray;
@synthesize aircraftArray = _aircraftCombosArray;

@synthesize proposalParametersAnnualCostLabel = _proposalParametersAnnualCostLabel;
@synthesize proposalParametersAverageHourlyCost = _proposalParametersAverageHourlyCost;
@synthesize proposalOperatingCostRateFuelVariableLabel = _proposalOperatingCostRateFuelVariableLabel;
@synthesize proposalOperatingCostAnnualFuelVariableLabel = _proposalOperatingCostAnnualFuelVariableLabel;
@synthesize proposalOperatingCostRateFuelFETLabel = _proposalOperatingCostRateFuelFETLabel;
@synthesize proposalOperatingCostAnnualFuelFETLabel = _proposalOperatingCostAnnualFuelFETLabel;

@synthesize proposalCardPurchasePurchasePriceLabel = _proposalCardPurchasePurchasePriceLabel;
@synthesize proposalCardPurchaseFETLabel = _proposalCardPurchaseFETLabel;
@synthesize proposalCardTermLabel = _proposalCardTermLabel;
@synthesize proposalCardTermValueLabel = _proposalCardTermValueLabel;
@synthesize proposalAircraftGroupNameLabel = _proposalAircraftGroupNameLabel;
@synthesize cardResultsView = _cardResultsView;
@synthesize aircraftButton = _aircraftButton;
@synthesize cardTypeButton = _cardTypeButton;
@synthesize numberOfCardsButton = _numberOfCardsButton;
@synthesize fuelMonthsButton = _fuelMonthsButton;
@synthesize cardTypeButtonChevron = _cardTypeButtonChevron;
@synthesize popoverOriginator = _popoverOriginator;

@synthesize nextYearPercentageIncreaseStaticLabel = _nextYearPercentageIncreaseStaticLabel;
@synthesize nextYearSwitch = _nextYearSwitch;
@synthesize nextYearPercentageLabel = _nextYearPercentageLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)configureView
{    
    [self.detailViewController setTitle:@"25 Hour Card"];
    
    [self configureParameterControls];
    
    NFDProposal *proposal = [self retrieveProposalForThisView];
    
    NFDFeatures *features = [NFDFeaturesService currentFeatures];
    
    isCrossCountryEnabled = features.shouldUseCrossCountry;
    if (isCrossCountryEnabled) {
        crossCountryPurchasePrice = features.crossCountryPurchasePrice;
        
        [[proposal productParameters] setObject:crossCountryPurchasePrice forKey:@"CrossCountryPurchasePrice"];
    }
    
    isPercentageIncreaseEnabled = features.shouldUseNextYearPercentage;
    if (isPercentageIncreaseEnabled) {
        nextYearPercentage = features.nextYearPercentageCard;
        
        [[proposal productParameters] setObject:nextYearPercentage forKey:@"NextYearPercentageForPurchasePrice"];
        
        NSString *nextYearString = [NSDate nextYearString];
        
        self.nextYearPercentageIncreaseStaticLabel.text = [NSString stringWithFormat:@"%@ Estimated %% increase", nextYearString];
        self.nextYearPercentageLabel.text = [NSString stringWithFormat:@"Purchase price - %@%%", features.nextYearPercentageCard.stringValue];
        
        self.nextYearPercentageIncreaseStaticLabel.hidden = NO;
        self.nextYearSwitch.hidden = NO;
        self.nextYearPercentageLabel.hidden = NO;
    }
    
    if (features.shouldUseCard36MonthsIncentive || features.shouldUseCardUpgradeIncentive) {
        self.buttonsBackgroundView.frame = CGRectMake(self.buttonsBackgroundView.frame.origin.x,
                                                      self.buttonsBackgroundView.frame.origin.y,
                                                      self.buttonsBackgroundView.frame.size.width,
                                                      (BUTTONS_BACKGROUND_VIEW_HEIGHT + 42));
        
        self.incentivesLabel.hidden = NO;
        self.incentivesButton.hidden = NO;
        self.incentivesDropDownArrow.hidden = NO;
        
        incentivesArray = [NSMutableArray arrayWithObjects:@"None", nil];
    } else {
        self.buttonsBackgroundView.frame = CGRectMake(self.buttonsBackgroundView.frame.origin.x,
                                                      self.buttonsBackgroundView.frame.origin.y,
                                                      self.buttonsBackgroundView.frame.size.width,
                                                      BUTTONS_BACKGROUND_VIEW_HEIGHT);
    }
    
    if (features.shouldUseCard36MonthsIncentive) {
        [incentivesArray insertObject:INCENTIVE_36_MONTHS atIndex:0];
    }
    
    if (features.shouldUseCardUpgradeIncentive) {
        [incentivesArray insertObject:INCENTIVE_UPGRADE atIndex:0];
    }
    
    self.aircraftArray = [NFDFlightProposalCalculatorService aircraftChoicesForCard];
    
    if ([[[self retrieveProposalForThisView] productCode] intValue] == COMBO_CARD_PRODUCT)
    {
        [self.cardTypeButtonChevron setHidden:YES];
        [self.detailViewController setTitle:@"25 Hour Combo Card"];
    }
    
    [[self.cardResultsView layer] setCornerRadius:12];
    
    [[self.cardResultsView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.cardResultsView layer] setShadowOffset:CGSizeMake(0, 1)];
    [[self.cardResultsView layer] setShadowOpacity:0.2];
    [[self.cardResultsView layer] setShadowRadius:2];
    
    [self.aircraftButton setTag:AIRCRAFT_BUTTON];
    [self.aircraftButton addTarget:self action:@selector(openPickerPopover:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cardTypeButton setTag:CARD_TYPE_BUTTON];
    [self.cardTypeButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.numberOfCardsButton setTag:NUMBER_CARDS_BUTTON];
    [self.numberOfCardsButton addTarget:self action:@selector(openPickerPopover:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fuelMonthsButton setTag:FUEL_PERIOD_BUTTON];
    [self.fuelMonthsButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.incentivesButton setTag:INCENTIVES_BUTTON];
    [self.incentivesButton addTarget:self action:@selector(openTablePopover:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureParameterControls
{
    self.cardHoursArray = [NSMutableArray arrayWithArray:[NFDFlightProposalCalculatorService annualHourAllotmentChoicesForGeneralProductType:kGeneralProductTypeCard maxHoursAvailable:nil]];
    
    self.numberOfCardsArray = [NFDFlightProposalCalculatorService numberOfAnnualCardsChoices];
    
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NSString *aircraftChoice = [[proposal productParameters] objectForKey:@"AircraftChoice"];
    NSArray *fuelMonthData;
    
    if (!isCrossCountryEnabled || ![aircraftChoice isEqualToString:CROSS_COUNTRY_TRIGGER]) {
        [self.cardHoursArray removeObject:CROSS_COUNTRY_CARD_TYPE_LABEL];
    }
    
    [self.cardTypeButton setTitle:[[proposal productParameters] objectForKey:@"CardHours"] forState:UIControlStateNormal];
    [self.numberOfCardsButton setTitle:[[proposal productParameters] objectForKey:@"NumberOfCards"] forState:UIControlStateNormal];
    [self.fuelMonthsButton setTitle:[[proposal productParameters] objectForKey:@"FuelPeriod"] forState:UIControlStateNormal];
    
    self.nextYearSwitch.on = [[[proposal productParameters] objectForKey:@"ShouldApplyNextYearPercentageIncrease"] boolValue];
    
    if (proposal.productCode.intValue == CARD_PRODUCT || aircraftChoice == nil)
    {
        NFDFuelRate *fuelRate = [NFDFlightProposalCalculatorService fuelRateInfoForAircraftGroupName:aircraftChoice];
        NSString *aircraftType = [fuelRate typeName];
        
        fuelMonthData = [NFDFlightProposalCalculatorService fuelPeriodChoicesForAircraftType:aircraftType isQualified:YES];
        [self.aircraftButton setTitle:aircraftChoice forState:UIControlStateNormal];
    }
    else 
    {
        NSArray *aircraftChoices = [aircraftChoice componentsSeparatedByString:@"\r"];
        fuelMonthData = [NFDFlightProposalCalculatorService fuelPeriodChoicesForAircraftChoices:aircraftChoices isQualified:YES];
        [[self.aircraftButton titleLabel] setNumberOfLines:2];
        [[self.aircraftButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
        [self.aircraftButton setTitle:aircraftChoice forState:UIControlStateNormal];
    }
    fuelMonthRatesDisplayNames = [fuelMonthData objectAtIndex:0];
    fuelMonthRates = [fuelMonthData objectAtIndex:1];
    
    NSString *cardIncentiveChoice = [[proposal productParameters] objectForKey:@"Incentive"];
    if ([cardIncentiveChoice isEqualToString:@"None"]) {
        [self.incentivesButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.incentivesButton setTitle:cardIncentiveChoice forState:UIControlStateNormal];
    }
}

- (BOOL)isCrossCountryCardSelected
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NSString *aircraftChoice = [[proposal productParameters] objectForKey:@"AircraftChoice"];
    
    if([[[proposal productParameters] objectForKey:@"CardHours"] isEqualToString:CROSS_COUNTRY_CARD_TYPE_LABEL]
       && [aircraftChoice isEqualToString:CROSS_COUNTRY_TRIGGER]) {
        return YES;
    }
    return NO;
}

- (void)updateSubtitleOfMasterView
{
    NFDProposal *proposal = [self retrieveProposalForThisView];

    //Determine the Selected Aircraft Type
    NSString *aircraftChoice = [[proposal productParameters] objectForKey:@"AircraftChoice"];
    if (!aircraftChoice){
        aircraftChoice = @"Aircraft";
    }

    //Determine Number of Cards and Card Hourse Selected
    NSString *cardChoice = [proposal.productParameters objectForKey:@"CardHours"];
    NSString *numberOfCards = [[proposal productParameters] objectForKey:@"NumberOfCards"];
    NSString *displayTitle = [NSString stringWithFormat:@"%@",cardChoice];
    if ( numberOfCards && ( [numberOfCards intValue] > 1 ) ){
        displayTitle = [NSString stringWithFormat:@"%@ (%@)",cardChoice,numberOfCards];
    }
    
    //Update the Detail View's Title on the Navigation Bar
    [self.detailViewController setTitle:displayTitle];

    if (proposal.productCode.intValue == COMBO_CARD_PRODUCT)
    {
        if ([[proposal productParameters] objectForKey:@"AircraftChoice_1"] && [[proposal productParameters] objectForKey:@"AircraftChoice_2"])
        {
            aircraftChoice = [NSString stringWithFormat:@"%@ & %@", [[proposal productParameters] objectForKey:@"AircraftChoice_1"], [[proposal productParameters] objectForKey:@"AircraftChoice_2"]];
        }
            
    }
    //Update the Master Table Cell's Title and Sub-Title
    [proposal setTitle:displayTitle];
    [proposal setSubTitle:[NSString stringWithFormat:@"%@",aircraftChoice]];
    
    //Notify Master Table Cell of the Update
    [[NSNotificationCenter defaultCenter] postNotificationName:PROPOSAL_SUBTITLE_UPDATED object:self];
}

#pragma mark - Manager, Proposal, Results Methods

- (NFDProposal *)retrieveProposalForThisView
{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;

    return [manager retrieveProposalAtIndex:self.tag];
}

- (void)updateProposalParameterData
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    if(![[[proposal productParameters] objectForKey:@"Incentive"] isEqualToString:INCENTIVE_36_MONTHS])
    {
        if ([[[proposal productParameters] objectForKey:@"CardHours"] isEqualToString:@"25 Hour Combo Card"])
        {
            [self.proposalCardTermValueLabel setText:@"12 months"];
            [[proposal productParameters] setObject:@"12 Months" forKey:@"ContractsUntil"];
        }
        else
        {
            int cardHoursChoice = [self.cardHoursArray indexOfObject:[[proposal productParameters] objectForKey:@"CardHours"]];
            switch (cardHoursChoice)
            {
                case kCardTypeCrossCountry:
                case kCardType25Hours:
                    [self.proposalCardTermValueLabel setText:@"12 months"];
                    [[proposal productParameters] setObject:@"12 Months" forKey:@"ContractsUntil"];
                    break;
                case kCardType50Hours:
                    [self.proposalCardTermValueLabel setText:@"24 months"];
                    [[proposal productParameters] setObject:@"24 Months" forKey:@"ContractsUntil"];
                    break;
                case kCardTypeHalf:
                    [self.proposalCardTermValueLabel setText:@"12 months"];
                    [[proposal productParameters] setObject:@"12 Months" forKey:@"ContractsUntil"];
                    break;
                default:
                    break;
            }
        }
    }

    [self updateSubtitleOfMasterView];
    [self configureParameterControls];
}

- (void)updateProposalResultData
{
    //Retrieve Proposal Data
    NFDProposal *proposal = [self retrieveProposalForThisView];
    NSDictionary *result = [proposal calculatedResults];

    if (result)
    {
        //Create Number Formatter for Currency
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [numberFormatter setMaximumFractionDigits:0];

        //Display Calculated Fuel Variable
        [self.proposalOperatingCostRateFuelVariableLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FuelVariableRate"]]];
        [self.proposalOperatingCostAnnualFuelVariableLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FuelVariableAnnual"]]];
        
        
        [self.proposalOperatingCostRateFuelFETLabel setText:[result objectForKey:@"FederalExciseTaxRate"]];
        [self.proposalOperatingCostAnnualFuelFETLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FederalExciseTaxAnnual"]]];
        
        //Display Calculated Purchase Price
        [self.proposalCardPurchasePurchasePriceLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"PurchasePrice"]]];
        
        //Display Calculated Purchase Price Federal Excise Tax
        [self.proposalCardPurchaseFETLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"FederalExciseTaxPurchase"]]];
        
        //Display Calculated Annual Costs
        [self.proposalParametersAnnualCostLabel setText:[numberFormatter stringFromNumber:[result objectForKey:@"AnnualCost"]]];
        [self.proposalParametersAverageHourlyCost setText:[numberFormatter stringFromNumber:[result objectForKey:@"AverageHourlyCost"]]];
        
    }
}

#pragma mark - Button Action Methods

- (IBAction)displayInventoryModalView:(id)sender 
{
    if (self.detailViewController)
    {
        [self.detailViewController displayInventoryModalView];
    }
}

- (IBAction)nextYearSwitchChanged:(id)sender
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    [[proposal productParameters] setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"ShouldApplyNextYearPercentageIncrease"];
    [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (tableView.tag) 
    {  
        case CARD_HOURS_TABLE_VIEW:
        case FUEL_PERIOD_TABLE_VIEW:
        case INCENTIVES_TABLE_VIEW:
        {
            return 1;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) 
    {
        case CARD_HOURS_TABLE_VIEW:
        {
            return [self.cardHoursArray count];
            break;
        }
        case FUEL_PERIOD_TABLE_VIEW:
        {
            return fuelMonthRatesDisplayNames.count;
            break;
        }
        case INCENTIVES_TABLE_VIEW:
        {
            return incentivesArray.count;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return POPOVER_TABLE_HEIGHT_1_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:0.0]];
    [[cell detailTextLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:0.0]];
    switch (tableView.tag) 
    {
        case CARD_HOURS_TABLE_VIEW:
        {
            [cell.textLabel setText:[self.cardHoursArray objectAtIndex:indexPath.row]];
            break;
        }
        case FUEL_PERIOD_TABLE_VIEW:
        {
            cell.textLabel.text = [fuelMonthRatesDisplayNames objectAtIndex:indexPath.row];
            NFDProposal *proposal = [self retrieveProposalForThisView];
            if ([cell.textLabel.text isEqualToString:[[proposal productParameters] objectForKey:@"FuelPeriod"]]) 
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        case INCENTIVES_TABLE_VIEW:
        {
            cell.textLabel.text = [incentivesArray objectAtIndex:indexPath.row];
            NFDProposal *proposal = [self retrieveProposalForThisView];
            if ([cell.textLabel.text isEqualToString:[[proposal productParameters] objectForKey:@"Incentive"]])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        default:
        {
            break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    
    [self resetButtonHighlight];
    
    switch (tableView.tag) 
    {
        case CARD_HOURS_TABLE_VIEW:
        {
            NSString *cardHours = [self.cardHoursArray objectAtIndex:indexPath.row];
            [[proposal productParameters] setObject:cardHours forKey:@"CardHours"];
            
//            if (self.isCrossCountryCardSelected) {
            if ([cardHours isEqualToString:CROSS_COUNTRY_CARD_TYPE_LABEL]) {
                [[proposal productParameters] setObject:[NSNumber numberWithBool:YES] forKey:@"IsCrossCountrySelected"];
            } else {
                [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"IsCrossCountrySelected"];
            }
            
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            
            [self.popover dismissPopoverAnimated:YES];
            break;
        }
        case FUEL_PERIOD_TABLE_VIEW:
        {   
            NSString *fuelPeriod = [fuelMonthRatesDisplayNames objectAtIndex:indexPath.row];
            if ([[proposal productParameters] objectForKey:@"AircraftChoice"] != nil) 
            {
                [[proposal productParameters] setObject:fuelPeriod forKey:@"FuelPeriod"];
            }
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            [self.popover dismissPopoverAnimated:YES];
            break;
        }
        case INCENTIVES_TABLE_VIEW:
        {
            NSString *incentiveChoice = [incentivesArray objectAtIndex:indexPath.row];
            [[proposal productParameters] setObject:incentiveChoice forKey:@"Incentive"];
            if ([incentiveChoice isEqualToString:INCENTIVE_36_MONTHS]) {
                [self.proposalCardTermValueLabel setText:@"36 months"];
                [[proposal productParameters] setObject:@"36 Months" forKey:@"ContractsUntil"];
            }
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            [self.popover dismissPopoverAnimated:YES];
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (pickerView.tag) 
    {
        case AIRCRAFT_PICKER_VIEW:
        {
            return 1;
            break;
        }
        case AIRCRAFT_COMBO_PICKER_VIEW:
        {
            return 2;
            break;
        }
        case NUMBER_CARDS_PICKER_VIEW:
        {
            return 1;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) 
    {
        case AIRCRAFT_PICKER_VIEW:
        case AIRCRAFT_COMBO_PICKER_VIEW:
        {
            return [self.aircraftArray count];
            break;
        }
        case NUMBER_CARDS_PICKER_VIEW:
        {
            return [self.numberOfCardsArray count];
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{    
    switch (pickerView.tag) 
    {
        case AIRCRAFT_PICKER_VIEW:
        {
            return [self.aircraftArray objectAtIndex:row];
            break;
        }
        case AIRCRAFT_COMBO_PICKER_VIEW:
        {
            return [self.aircraftArray objectAtIndex:row];
            break;
        }
        case NUMBER_CARDS_PICKER_VIEW:
        {
            return [self.numberOfCardsArray objectAtIndex:row];
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
} 

#pragma mark - UIPickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NFDProposal *proposal = [self retrieveProposalForThisView];

    switch (pickerView.tag)
    {
        case AIRCRAFT_PICKER_VIEW:
        {
            NSString *aircraftChoice = [self.aircraftArray objectAtIndex:row];
            
            if([self isCrossCountryCardSelected] && ![aircraftChoice isEqualToString:CROSS_COUNTRY_TRIGGER]) {
                NSString *cardHours = [self.cardHoursArray objectAtIndex:0];
                [[proposal productParameters] setObject:cardHours forKey:@"CardHours"];
                
                [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"IsCrossCountrySelected"];
            }
            
            [[proposal productParameters] setObject:aircraftChoice forKey:@"AircraftChoice"];
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            break;
        }
        case AIRCRAFT_COMBO_PICKER_VIEW:
        {
            NSString *aircraftChoice = [self.aircraftArray objectAtIndex:row];
            if (component == 0)
            {
                [[proposal productParameters] setObject:aircraftChoice forKey:@"AircraftChoice_1"];
            }
            else 
            {
                [[proposal productParameters] setObject:aircraftChoice forKey:@"AircraftChoice_2"];
            }
            
            if ([[proposal productParameters] objectForKey:@"AircraftChoice_1"] && [[proposal productParameters] objectForKey:@"AircraftChoice_2"])
            {
                aircraftChoice = [NSString stringWithFormat:@"%@\r%@", [[proposal productParameters] objectForKey:@"AircraftChoice_1"], [[proposal productParameters] objectForKey:@"AircraftChoice_2"]];
                                  
                [[proposal productParameters] setObject:aircraftChoice forKey:@"AircraftChoice"];
                [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            }
            break;
        }
        case NUMBER_CARDS_PICKER_VIEW:
        {
            NSString *numberCards = [self.numberOfCardsArray objectAtIndex:row];
            [[proposal productParameters] setObject:numberCards forKey:@"NumberOfCards"];
            [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)openTablePopover:(id)sender
{
    UITableViewController *popoverContent = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [popoverContent.tableView setScrollEnabled:NO];
    [popoverContent.tableView setDataSource:self];
    [popoverContent.tableView setDelegate:self];
    [popoverContent.tableView reloadData];
    float contentWidth = 220;
    float contentHeight = 0.0; 
    
    NFDProposal *proposal = [self retrieveProposalForThisView];
    
    switch ([(UIButton *)sender tag]) {
        case CARD_TYPE_BUTTON:
        {
            if (proposal.productCode.intValue == COMBO_CARD_PRODUCT)
            {
                return;
            }
            if (isCrossCountryEnabled) {
                contentWidth = 255;
            }
            contentHeight = self.cardHoursArray.count * 44;
            [popoverContent.tableView setTag:CARD_HOURS_TABLE_VIEW];
            
            break;
        } 
        case FUEL_PERIOD_BUTTON:
        {
            contentHeight = fuelMonthRatesDisplayNames.count * 44;
            [popoverContent.tableView setTag:FUEL_PERIOD_TABLE_VIEW];            
            break;
        }
        case INCENTIVES_BUTTON:
        {
            contentHeight = incentivesArray.count * 44;
            [popoverContent.tableView setTag:INCENTIVES_TABLE_VIEW];
            break;
        }
        default:
            break;
    }
    
    [popoverContent setPreferredContentSize:CGSizeMake(contentWidth, contentHeight)];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [self.popover presentPopoverFromRect:CGRectMake(0, 0, [(UIButton *)sender frame].size.width, [(UIButton *)sender frame].size.height) inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [self.popover setDelegate:self];
    
    [self setPopoverOriginator:sender];
    [(UIButton *)sender setBackgroundColor:[UIColor colorWithWhite:0.12 alpha:1]];
}

- (void)openPickerPopover:(id)sender
{
    NFDProposal *proposal = [self retrieveProposalForThisView];
    UIViewController *popoverContent = [[UIViewController alloc] init];
    [popoverContent setPreferredContentSize:CGSizeMake(PICKER_WIDTH + 2*PICKER_X_OFFSET, PICKER_HEIGHT + 2*PICKER_Y_OFFSET)];
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.frame = CGRectMake(PICKER_X_OFFSET, PICKER_Y_OFFSET, PICKER_WIDTH, PICKER_HEIGHT);
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setShowsSelectionIndicator:YES];
    
    [(UIButton *)sender setBackgroundColor:[UIColor colorWithWhite:0.12 alpha:1]];
    
    switch ([(UIButton *)sender tag]) {
        case AIRCRAFT_BUTTON:
        {
            if ([proposal.productCode intValue] == CARD_PRODUCT)
            {
                [pickerView setTag:AIRCRAFT_PICKER_VIEW];
                
                NSString *aircrafChoice = [[proposal productParameters] objectForKey:@"AircraftChoice"];
                if (!aircrafChoice)
                {
                    aircrafChoice = [self.aircraftArray objectAtIndex:0];
                    [[proposal productParameters] setObject:aircrafChoice forKey:@"AircraftChoice"];
                }
                [pickerView selectRow:[self.aircraftArray indexOfObject:aircrafChoice] inComponent:0 animated:NO];
                //[tableView reloadData];
                [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
                //[self.productOptionsTableView reloadData]; 
            }
            else
            {
                [pickerView setTag:AIRCRAFT_COMBO_PICKER_VIEW];
                [popoverContent setPreferredContentSize:CGSizeMake(1.5*PICKER_WIDTH + 2*PICKER_X_OFFSET, PICKER_HEIGHT + 2*PICKER_Y_OFFSET)];
                pickerView.frame = CGRectMake(PICKER_X_OFFSET, PICKER_Y_OFFSET, 1.5*PICKER_WIDTH, PICKER_HEIGHT);

                NSString *aircrafChoice1 = [[proposal productParameters] objectForKey:@"AircraftChoice_1"];
                if (!aircrafChoice1) {
                    aircrafChoice1 = [self.aircraftArray objectAtIndex:0];
                    [[proposal productParameters] setObject:aircrafChoice1 forKey:@"AircraftChoice_1"];
                }
                NSString *aircrafChoice2 = [[proposal productParameters] objectForKey:@"AircraftChoice_2"];
                if (!aircrafChoice2) {
                    aircrafChoice2 = [self.aircraftArray objectAtIndex:0];
                    [[proposal productParameters] setObject:aircrafChoice2 forKey:@"AircraftChoice_2"];
                }
                [[proposal productParameters] setObject:[NSString stringWithFormat:@"%@\r%@",aircrafChoice1, aircrafChoice2] forKey:@"AircraftChoice"];
                [pickerView selectRow:[self.aircraftArray indexOfObject:aircrafChoice1] inComponent:0 animated:NO];
                [pickerView selectRow:[self.aircraftArray indexOfObject:aircrafChoice2] inComponent:1 animated:NO];
                //[tableView reloadData];
                
                [NFDFlightProposalManager.sharedInstance performCalculationsForProposal:proposal];
//                [self.productOptionsTableView reloadData]; 
            }

            break;
        }   
        case NUMBER_CARDS_BUTTON:
        {
            [pickerView setTag:NUMBER_CARDS_PICKER_VIEW];
            
            NSString *numberOfCardsChoice = [[proposal productParameters] objectForKey:@"NumberOfCards"];
            if (!numberOfCardsChoice)
            {
                numberOfCardsChoice = [self.numberOfCardsArray objectAtIndex:0];
                [[proposal productParameters] setObject:numberOfCardsChoice forKey:@"NumberOfCards"];
                [[NFDFlightProposalManager sharedInstance] performCalculationsForProposal:proposal];
            }
            [pickerView selectRow:[self.numberOfCardsArray indexOfObject:numberOfCardsChoice] inComponent:0 animated:NO];
            break;
        }            
        default:
            break;
    }
    
    [[popoverContent view] addSubview:pickerView];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent]; 
    [self.popover presentPopoverFromRect:CGRectMake(0, 0, [(UIButton *)sender frame].size.width, [(UIButton *)sender frame].size.height) inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [self setPopoverOriginator:sender];
    [self.popover setDelegate:self];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self resetButtonHighlight];
    [self setPopoverOriginator:nil];
}

- (void)resetButtonHighlight
{
    [self.aircraftButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.cardTypeButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.numberOfCardsButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.fuelMonthsButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self.incentivesButton setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
}


- (void)interfaceDidChangeOrientation
{
    if ([self.popover isPopoverVisible] && self.popoverOriginator)
    {
        [self.popover dismissPopoverAnimated:NO];
        [self.popover presentPopoverFromRect:CGRectMake(0, 0, [self.popoverOriginator frame].size.width, [self.popoverOriginator frame].size.height) inView:self.popoverOriginator permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)dismissPopover
{
    if ([self.popover isPopoverVisible]) {
        [self.popover dismissPopoverAnimated:NO];
    }
}

@end
