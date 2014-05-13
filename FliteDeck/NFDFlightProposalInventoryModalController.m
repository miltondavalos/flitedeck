//
//  NFDFlightProposalInventoryModalController.m
//  ProposalCalculatorPrototype
//
//  Created by Geoffrey Goetz on 3/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalInventoryModalController.h"
#import "NFDPersistenceManager.h"
#import "NFDFlightProposalInventoryTableViewCell.h"
#import "NFDProposal.h"
#import "NFDAircraftInventory.h"
#import "NFDAircraftTypeService.h"
#import "NFDInventoryType.h"
#import "NFDFlightProposalCalculatorService.h"

#import <QuartzCore/QuartzCore.h>

#define SORT_BY_DELIVERY 1
#define SORT_BY_TAIL 2
#define SORT_BY_YEAR 3
#define SORT_BY_AVAILABILITY 4
#define SORT_BY_COST 5
#define SORT_BY_CONTRACTS 6

@interface NFDFlightProposalInventoryModalController ()
{
    int col1Sort;
    int col2Sort;
    int col3Sort;
    int col4Sort;
    int col5Sort;
    int col6Sort;
}

@property (nonatomic, strong) UIBarButtonItem *column1Button;
@property (nonatomic, strong) UIBarButtonItem *column2Button;
@property (nonatomic, strong) UIBarButtonItem *column3Button;
@property (nonatomic, strong) UIBarButtonItem *column4Button;
@property (nonatomic, strong) UIBarButtonItem *column5Button;
@property (nonatomic, strong) UIBarButtonItem *column6Button;



@end

@implementation NFDFlightProposalInventoryModalController

@synthesize aircraftSelectionView;
@synthesize aircraftSelectionScrollView;
@synthesize aircraftThumbnailsView;
@synthesize selectedAircraftName;
@synthesize inventoryTableView;
@synthesize column1Heading;
@synthesize column2Heading;
@synthesize column3Heading;
@synthesize column4Heading;
@synthesize column5Heading;
@synthesize column6Heading;

@synthesize column1Button = _column1Button;
@synthesize column2Button = _column2Button;
@synthesize column3Button = _column3Button;
@synthesize column4Button = _column4Button;
@synthesize column5Button = _column5Button;
@synthesize column6Button = _column6Button;

@synthesize columnHeadingToolbar = _columnHeadingToolbar;
@synthesize inventorySyncDateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    [self loadAllAircraft];
    [self createAircraftScrollView];
    
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    
    self.column1Button = [[UIBarButtonItem alloc] initWithTitle:@"Delivery" style:UIBarButtonItemStylePlain target:self action:@selector(sortAircrafts:)];
    [self.column1Button setTag:1];
    [self.column1Button setWidth:90];
    [self.column1Button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.column2Button = [[UIBarButtonItem alloc] initWithTitle:@"Tail" style:UIBarButtonItemStylePlain target:self action:@selector(sortAircrafts:)];
    [self.column2Button setTag:2];
    [self.column2Button setWidth:90];
    [self.column2Button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.column3Button = [[UIBarButtonItem alloc] initWithTitle:@"Year" style:UIBarButtonItemStylePlain target:self action:@selector(sortAircrafts:)];
    [self.column3Button setTag:3];
    [self.column3Button setWidth:90];
    [self.column3Button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [spacer setWidth:15];
    
    self.column4Button = [[UIBarButtonItem alloc] initWithTitle:@"Availability" style:UIBarButtonItemStylePlain target:self action:@selector(sortAircrafts:)];
    [self.column4Button setTag:4];
    [self.column4Button setWidth:90];
    [self.column4Button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.column5Button = [[UIBarButtonItem alloc] initWithTitle:@"Value" style:UIBarButtonItemStylePlain target:self action:@selector(sortAircrafts:)];
    [self.column5Button setTag:5];
    [self.column5Button setWidth:120];
    [self.column5Button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.column6Button = [[UIBarButtonItem alloc] initWithTitle:@"Contracts" style:UIBarButtonItemStylePlain target:self action:@selector(sortAircrafts:)];
    [self.column6Button setTag:6];
    [self.column6Button setWidth:70];
    [self.column6Button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
    [self.columnHeadingToolbar setItems:[NSArray arrayWithObjects:self.column1Button, self.column2Button, self.column3Button, spacer, self.column4Button, self.column5Button, self.column6Button, nil]];
    
    col1Sort = 1;
    col2Sort = 1;
    col3Sort = 1;
    col4Sort = 1;
    col5Sort = 1;
    col6Sort = 1;
    
    [self.inventorySyncDateLabel setText:[NSString stringWithFormat:@"Last sync: %@", [NSString stringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"LastAircraftInventorySync"] formatType:NCLDateFormatDateAndTime]]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidUnload {
    [self setAircraftSelectionView:nil];
    [self setAircraftSelectionScrollView:nil];
    [self setAircraftThumbnailsView:nil];
    [self setSelectedAircraftName:nil];
    [self setInventoryTableView:nil];
    [self setColumn1Heading:nil];
    [self setColumn2Heading:nil];
    [self setColumn3Heading:nil];
    [self setColumn4Heading:nil];
    [self setColumn5Heading:nil];
    [self setColumn6Heading:nil];
    [self setInventorySyncDateLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Manager, Proposal, Results Methods

- (NFDProposal *)retrieveProposalForThisView
{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    return [manager retrieveProposalAtIndex:self.view.tag];
}

#pragma mark - Aircraft Scroll View Selection in Drop Down Shade

- (void)loadAllAircraft
{   
    NSFetchRequest *fetchRequestForAircraftType = [[NSFetchRequest alloc] initWithEntityName:@"AircraftInventory"];

    [fetchRequestForAircraftType setReturnsDistinctResults:YES];
    NSSortDescriptor *sortByLegalName = [[NSSortDescriptor alloc] initWithKey:@"legal_name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByLegalName, nil];
    [fetchRequestForAircraftType setSortDescriptors:sortDescriptors];
    NSError *errorForInventory = nil;
    NSManagedObjectContext *context = [[NFDPersistenceManager sharedInstance] mainMOC];
    NSArray *inventory = [context executeFetchRequest:fetchRequestForAircraftType error:&errorForInventory];
    
    aircraftTypes = [NSMutableArray array];

    for (NFDAircraftInventory *ai in inventory) {
        if (![aircraftTypes containsObject:ai.type]) {
            [aircraftTypes addObject:ai.type];
        }
    }
    
    NSMutableArray *inventoryTypes = [NSMutableArray array];
    
    NSFetchRequest *fetchTypeGroup = [[NSFetchRequest alloc] initWithEntityName:@"AircraftType"];
    fetchTypeGroup.includesSubentities=NO;

    [fetchTypeGroup setReturnsDistinctResults:YES];
    NSManagedObjectContext *contextForTypeGroup = [[NFDPersistenceManager sharedInstance] mainMOC];
    NSError *error = nil;
    
    NSFetchRequest *fetchDisplayOrder = [[NSFetchRequest alloc] initWithEntityName:@"AircraftTypeGroup"];
    fetchDisplayOrder.includesSubentities=NO;

    [fetchDisplayOrder setReturnsDistinctResults:YES];
    NSManagedObjectContext *contextForDisplayOrder = [[NFDPersistenceManager sharedInstance] mainMOC];
    NSError *errorForDisplayOrder = nil;
    
    for (NSString *inventoryTypeString in aircraftTypes) {

        NSPredicate *typeGroupPredicate = [NSPredicate predicateWithFormat:@"typeName = %@", inventoryTypeString];
        [fetchTypeGroup setPredicate:typeGroupPredicate];
        NSArray *returnedType = [contextForTypeGroup executeFetchRequest:fetchTypeGroup error:&error];

        if (returnedType.count > 0) {
            NFDAircraftType *aircraftType = [returnedType objectAtIndex:0];

            NSPredicate *displayOrderPredicate = [NSPredicate predicateWithFormat:@"typeGroupName = %@", aircraftType.typeGroupName];
            [fetchDisplayOrder setPredicate:displayOrderPredicate];
            NSArray *returned = [contextForDisplayOrder executeFetchRequest:fetchDisplayOrder error:&errorForDisplayOrder];
            
            if (returned.count > 0) {
                NFDAircraftTypeGroup *returnedAircraftTypeGroup = [returned objectAtIndex:0];
                
                NFDInventoryType *inventoryType = [[NFDInventoryType alloc] init];
                
                inventoryType.aircraftTypeGroup = returnedAircraftTypeGroup;
                inventoryType.aircraftType = aircraftType;
                inventoryType.displayOrder = returnedAircraftTypeGroup.displayOrder;
                
                [inventoryTypes addObject:inventoryType];
            }
        }
    }
    
    // Sort the inventory types so the tiles display in the proper order
    sortedInventoryTypes = [NSArray array];
    sortedInventoryTypes = [inventoryTypes sortedArrayUsingComparator:^(id a, id b) {
        NSNumber *first = [(NFDInventoryType *)a displayOrder];
        NSNumber *second = [(NFDInventoryType *)b displayOrder];
        return [first compare:second];
    }];
}

- (void)createAircraftScrollView {
    //Set max size of scroll view content based on number of aircraft types to display...
    int total_number_of_aircraft = [sortedInventoryTypes count];
    if (total_number_of_aircraft > (768 / AIRCRAFT_IMAGE_WIDTH_2)){
        int width_of_scroll_view = (((AIRCRAFT_IMAGE_WIDTH_2 + PADDING_BETWEEN_AIRCRAFT) * total_number_of_aircraft) + (PADDING_BETWEEN_AIRCRAFT * 2));
        [aircraftThumbnailsView setFrame:CGRectMake(0, 0, width_of_scroll_view, (AIRCRAFT_IMAGE_HEIGHT_2 + 2*PADDING_ABOVE_AIRCRAFT))];
        aircraftSelectionScrollView.contentSize = CGSizeMake(width_of_scroll_view, (AIRCRAFT_IMAGE_HEIGHT_2 + 2*PADDING_ABOVE_AIRCRAFT));
    }
    
    //Interate through aircraft types
    for (int i = 0; i < total_number_of_aircraft; i++) {
        [self addAircraftImageToScrollViewAtPosition:i];
    }
}

- (void)addAircraftImageToScrollViewAtPosition:(int)position {
    // Set the x coordinate of the tile based on the position
    CGFloat aircraftButton_x_coordinate = PADDING_BETWEEN_AIRCRAFT + ((AIRCRAFT_IMAGE_WIDTH_2 + PADDING_BETWEEN_AIRCRAFT) * position);
    
    // Get the inventoryType object out of the sortedInventoryTypes array and setup a tile
    NFDInventoryType *inventoryType = [sortedInventoryTypes objectAtIndex:position];
    NFDAircraftTile *tile = [[NFDAircraftTile alloc] initWithFrame:CGRectMake(aircraftButton_x_coordinate, 10, AIRCRAFT_IMAGE_WIDTH_2, AIRCRAFT_IMAGE_HEIGHT_2+22)];
    
    [aircraftThumbnailsView addSubview:tile];
    
    tile.aircraft = inventoryType.aircraftTypeGroup;
    tile.aircraftType = inventoryType.aircraftType;
    
    [tile setData:tile.aircraft];
    
    tile.label.text = tile.aircraftType.typeFullName;
    
    tile.label.font = [UIFont systemFontOfSize:12];
    
    tile.label.backgroundColor = [UIColor blackColor];
    
    [tile.layer setCornerRadius:12];
    [tile setClipsToBounds:YES];
    
    //Ensure that image can receive gestures
    [tile setUserInteractionEnabled:YES];
    [tile setTag:position];
    
    
    
    //Add single tap gesture to image
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapOnAircraftImage:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [singleTapGesture setNumberOfTouchesRequired:1];
    [tile addGestureRecognizer:singleTapGesture];
}

- (void)didSingleTapOnAircraftImage:(UITapGestureRecognizer *)gestureRecognizer
{
    aircrafts = nil;
    aircrafts = [NSMutableArray array];
    
    NFDAircraftTile *tile;
    for (tile in [aircraftThumbnailsView subviews]) {
        if (tile.selected) {
            [tile toggleCheck:YES];
        }
    }
    selectedTile = (NFDAircraftTile *)gestureRecognizer.view;
    [selectedTile toggleCheck:YES];
    
    selectedAircraftTypeGroup = selectedTile.aircraft;

    selectedAircraftName.text = [NSString stringWithFormat:@"%@ - %@", selectedTile.aircraftType.typeFullName, selectedTile.aircraftType.typeName];
    
    NSString *selectedTypeName = [[selectedTile aircraftType] typeName];
    
    NFDAircraftTypeService *aircraftTypeService = [[NFDAircraftTypeService alloc] init];
    NFDAircraftType *type = [aircraftTypeService queryAircraftTypesByTypeName:selectedTypeName];
    
    NFDProposal *proposal = [self retrieveProposalForThisView];
    if ([proposal.productCode intValue] == SHARE_FINANCE_PRODUCT) {
        [aircrafts addObjectsFromArray:[NFDFlightProposalCalculatorService inventoryForAircraftType:type.typeName yearsOfServiceRemaining:6]];
    } else {
        [aircrafts addObjectsFromArray:[NFDFlightProposalCalculatorService inventoryForAircraftType:type.typeName yearsOfServiceRemaining:1]];
    }
    
    [inventoryTableView reloadData];
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([aircrafts count] == 0) {
        return 1;
    } else {
        return [aircrafts count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NFDFlightProposalInventoryTableViewCell";
	NFDFlightProposalInventoryTableViewCell *cell = 
    (NFDFlightProposalInventoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"NFDFlightProposalInventoryTableViewCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (NFDFlightProposalInventoryTableViewCell*)view;
            }
        }
	}
    if (aircrafts.count == 0) {
        // Display a message indicating there are no aircrafts found
        if (aircrafts != nil) {
            cell.noAircraftAvailableMessage.hidden = NO;
        }
        cell.column1Label.hidden = YES;
        cell.column2Label.hidden = YES;
        cell.column3Label.hidden = YES;
        cell.column4Label.hidden = YES;
        cell.column5Label.hidden = YES;
        cell.column6Label.hidden = YES;
    } else {
        // Set the frames of the cell labels to line up with the headings
        cell.column1Label.frame = column1Heading.frame;
        cell.column2Label.frame = column2Heading.frame;
        cell.column3Label.frame = column3Heading.frame;
        cell.column4Label.frame = column4Heading.frame;
        cell.column5Label.frame = column5Heading.frame;
        cell.column6Label.frame = column6Heading.frame;

        NFDAircraftInventory *aircraftInventory = [aircrafts objectAtIndex:indexPath.row];
        
        // Format the Anticipated Delivery Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSString *deliveryStringFromDate = [dateFormatter stringFromDate:[aircraftInventory anticipated_delivery_date]];
        
        // Format Shares Immediately Availabel into a Percentage
        float available = ([[aircraftInventory share_immediately_available] floatValue] * 100);
        NSString *formattedPercentage = [NSString stringWithFormat:@"%.2f%%", available];
        
        // Format Acquisition Cost for Value column
        float priceInt = ([[aircraftInventory sales_value] floatValue] / 16);
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setMaximumFractionDigits:0];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        NSString *price = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:priceInt]];
        
        //Calculate Number of Years for Contracts Until
        NSString *contractStringFromDate = @"";
        if ([aircraftInventory contracts_until_date])
        {
            NSDate *contractUntil = [aircraftInventory contracts_until_date];
            NSTimeInterval secondsBetween = [contractUntil timeIntervalSinceDate:[NSDate date]];
            int numberOfYears = ( ( secondsBetween / 86400 ) / 365 );        
            NSString *yearsString = (numberOfYears == 1) ? @"Year" : @"Years";
            contractStringFromDate = [NSString stringWithFormat:@"%i %@",numberOfYears, yearsString];
        }
        else {
            contractStringFromDate = @"10+ Years";
        }
        
        // Display Formatted Lables
        cell.column1Label.text = deliveryStringFromDate;
        cell.column2Label.text = [aircraftInventory tail];
        cell.column3Label.text = [aircraftInventory year];
        cell.column4Label.text = formattedPercentage;
        cell.column5Label.text = price;
        cell.column6Label.text = contractStringFromDate;
    }

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( (aircrafts) && [aircrafts count] > 0 ) {
        NFDAircraftInventory *aircraftInventory = [aircrafts objectAtIndex:indexPath.row];
        NFDProposal *proposal = [self retrieveProposalForThisView];
        [[proposal productParameters] setObject:aircraftInventory forKey:@"AircraftInventory"];
        [[proposal productParameters] setObject:@"25" forKey:@"AnnualHours"];
        [[proposal productParameters] setObject:@"25" forKey:@"AnnualHoursChoice"];
        [[proposal productParameters] setObject:[NSNumber numberWithBool:NO] forKey:@"MultiShare"];
        [[proposal productParameters] setObject:selectedAircraftTypeGroup.typeGroupName forKey:@"DisplayName"];
        //Calculate Years for Contracts Until Date
        int numberOfYears;
        if ([aircraftInventory contracts_until_date]) // a valid date
        {
            NSDate *contractUntil = [aircraftInventory contracts_until_date];
            NSTimeInterval secondsBetween = [contractUntil timeIntervalSinceDate:[NSDate date]];
            numberOfYears = ( ( secondsBetween / 86400 ) / 365 );
        }
        else // a null value 
        {
            numberOfYears = 5;
        }
        if (proposal.productCode.intValue == SHARE_PURCHASE_PRODUCT)
        {
            if (numberOfYears > 5)
            {
                numberOfYears = 5;
            }
        }
        else if (proposal.productCode.intValue == SHARE_FINANCE_PRODUCT)
        {
            numberOfYears = 5;
        }
        NSString *yearsString = (numberOfYears == 1) ? @"Year" : @"Years";
        NSString *contractStringFromDate = [NSString stringWithFormat:@"%i %@",numberOfYears, yearsString];
        [[proposal productParameters] setObject:contractStringFromDate forKey:@"ContractsUntil"];
        [[NSNotificationCenter defaultCenter] postNotificationName:PROPOSAL_PARAMETERS_UPDATED object:nil];
        [[NFDFlightProposalManager sharedInstance] performCalculationsForProposal:proposal];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Toolbar Button Action Methods for Sorting

- (IBAction)sortAircrafts:(id)sender {
    NSArray *sortedArray;
    switch ([sender tag]) {
        case SORT_BY_DELIVERY:
        {
            int sortDirection = col1Sort;
            col1Sort *= -1;
            sortedArray = [aircrafts sortedArrayUsingComparator:^(id a, id b) {
                NSDate *first = [(NFDAircraftInventory*)a anticipated_delivery_date];
                NSDate *second = [(NFDAircraftInventory*)b anticipated_delivery_date];
                return (sortDirection > 0) ? [first compare:second] : [second compare:first];
            }];
            break;
        }
        case SORT_BY_TAIL:
        {
            int sortDirection = col2Sort;
            col2Sort *= -1;
            sortedArray = [aircrafts sortedArrayUsingComparator:^(id a, id b) {
                NSString *first = [(NFDAircraftInventory*)a tail];
                NSString *second = [(NFDAircraftInventory*)b tail];
                return (sortDirection > 0) ? [first compare:second] : [second compare:first];
            }];
            break;
        }
        case SORT_BY_YEAR:
        {
            int sortDirection = col3Sort;
            col3Sort *= -1;
            sortedArray = [aircrafts sortedArrayUsingComparator:^(id a, id b) {
                NSString *first = [(NFDAircraftInventory*)a year] ;
                NSString *second = [(NFDAircraftInventory*)b year];
                return (sortDirection > 0) ? [first compare:second] : [second compare:first];
            }];
            break;
        }
        case SORT_BY_AVAILABILITY:
        {
            int sortDirection = col4Sort;
            col4Sort *= -1;
            sortedArray = [aircrafts sortedArrayUsingComparator:^(id a, id b) {
                NSString *first = [(NFDAircraftInventory*)a share_immediately_available];
                NSString *second = [(NFDAircraftInventory*)b share_immediately_available];
                return (sortDirection > 0) ? [first compare:second] : [second compare:first];
            }];
            break;
        }
        case SORT_BY_COST:
        {
            int sortDirection = col5Sort;
            col5Sort *= -1;
            sortedArray = [aircrafts sortedArrayUsingComparator:^(id a, id b) {
                int aInt = [[(NFDAircraftInventory*)a sales_value] intValue];
                int bInt = [[(NFDAircraftInventory*)b sales_value] intValue];
                
                NSNumber *first = [NSNumber numberWithInt:aInt];
                NSNumber *second = [NSNumber numberWithInt:bInt];
                return (sortDirection > 0) ? [first compare:second] : [second compare:first];
            }];
            break;
        }
        case SORT_BY_CONTRACTS:
        {
            int sortDirection = col6Sort;
            col6Sort *= -1;
            sortedArray = [aircrafts sortedArrayUsingComparator:^(id a, id b) {
                NSDate *first = [(NFDAircraftInventory*)a contracts_until_date];
                NSDate *second = [(NFDAircraftInventory*)b contracts_until_date];
                return (sortDirection > 0) ? [first compare:second] : [second compare:first];
            }];
            break;
        }
        default:
            break;
    }
    aircrafts = nil;
    aircrafts = [NSMutableArray arrayWithArray:sortedArray];
    [inventoryTableView reloadData];
}


@end
