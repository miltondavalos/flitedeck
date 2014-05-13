//
//  NFDFlightProfileFlightDetailsViewController.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProfileFlightDetailsViewController.h"
#import "NFDAirport.h"
#import "NFDAppDelegate.h"
#import "UIButton+LegContainer.h"

#import "NFDFlightProfileEstimator.h"
#import "PopoverTableViewController.h"
#import "NFDFlightProfileManager.h"
#import "NFDAircraftTypeService.h"
#import "NFDAirportService.h"

@implementation NFDFlightProfileFlightDetailsViewController


//Additional Selection Controls
@synthesize numberOfPassengers;
@synthesize adjustPassengersStepper;
@synthesize backgroundImageView;

//Trip Options Controls
@synthesize tripOptionsTable;
@synthesize popoverContent;
@synthesize seasonsArray;
@synthesize typeArray;
@synthesize tableDataArray;
@synthesize popover;

//Aircraft Tiles
@synthesize aircraftTileContainer;
@synthesize aircraft1;
@synthesize aircraft2;
@synthesize aircraft3;

//Custom Properties
@synthesize parameters, selectedAircraftTypes,legEditor,airports,estimator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        airports = [[NSMutableArray alloc] init ];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    // Loading background image
    backgroundImageView.image = [UIImage imageNamed:@"Background_Flight_Detail_Modal.png"];
    
    [self setTitle:@"Flight Details"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveParameters)]];
    //    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModal)]];
    
   /* UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] 
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self 
                                         action:@selector(dismissModal)];
    
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem];*/
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearedAirportSelection:) 
                                                 name:@"clearedAirportSelection"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearedAirportSelection:) 
                                                 name:@"removeLeg"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(madeAirportSelection:) 
                                                 name:@"madeAirportSelection"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    if (parameters.passengers) {
        adjustPassengersStepper.value = (int)parameters.passengers;
        [self adjustNumberOfPassengers:adjustPassengersStepper];
    }
    
    seasonsArray = [NSArray arrayWithObjects:@"Annual", @"Winter", @"Spring", @"Summer", @"Fall", nil];
    typeArray = [NSArray arrayWithObjects:@"Share", @"Card", @"Demo", nil];
    tableDataArray = [NSMutableArray array];
    
    if (parameters.season == nil) {
        parameters.season = [seasonsArray objectAtIndex:0];
    }
    
    if (parameters.product == nil) {
        parameters.product = [typeArray objectAtIndex:0];
    }
    
    parameters.roundTrip = YES;
    
    NFDAircraftTypeService *service = [[NFDAircraftTypeService alloc] init];
    double max =  [[service maximumNumberOfPassengersInFleet] doubleValue];
    
    adjustPassengersStepper.maximumValue = max;
    
    tripOptionsTable.backgroundView = nil;
    tripOptionsTable.backgroundColor = [UIColor clearColor];
    
    self.popoverContent = [[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil];
    self.popoverContent.tableView.dataSource = self;
    self.popoverContent.tableView.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showAircrafts];
    [self setupAirports];
    [self checkParameters];
}
-(void) setupAirports {
    airports = [[NSMutableArray alloc] init ];
    //Make copy in case we cancel
    for(NFDAirport *a in parameters.airports){
        [airports addObject:a];
    }
    [legEditor setupAirports:airports];
}
- (void)viewDidUnload
{
    [self setAircraft1:nil];
    [self setAircraft2:nil];
    [self setAircraft3:nil];
    [self setAircraftTileContainer:nil];
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clearedAirportSelection" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"madeAirportSelection" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeLeg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (legEditor.origin.aselector.searchResultsPopover.isPopoverVisible) {
        [legEditor.origin.aselector.searchResultsPopover dismissPopoverAnimated:NO];
        [legEditor.origin.aselector findAirports:legEditor.origin.aselector.airportSearchBar.text];
    }
    if (legEditor.destination.aselector.searchResultsPopover.isPopoverVisible) {
        [legEditor.destination.aselector.searchResultsPopover dismissPopoverAnimated:NO];
        [legEditor.destination.aselector findAirports:legEditor.destination.aselector.airportSearchBar.text];
    }
    for (OriginDestinationView *leg in legEditor.legs) {
        if (leg.aselector.searchResultsPopover.isPopoverVisible) {
            [leg.aselector.searchResultsPopover dismissPopoverAnimated:NO];
            [leg.aselector findAirports:leg.aselector.airportSearchBar.text];
        }
    }
    
    [aircraft1 showWarningsForOrientationChange];
    [aircraft2 showWarningsForOrientationChange];
    [aircraft3 showWarningsForOrientationChange];
    
    [self positionTripOptionsPopoverOnOrientationChange];
}


-(void) prepareParameters {
    if (parameters.season == nil) {
        parameters.season = [seasonsArray objectAtIndex:0];
    }
    
    if (parameters.product == nil) {
        parameters.product = [typeArray objectAtIndex:0];
    }
    parameters.aircrafts = [[NSMutableArray alloc] init];
    //Sort selected aircraft by key...
    NSArray *sortedArray = [selectedAircraftTypes.allKeys sortedArrayUsingComparator:^(id a, id b) {
        NSNumber *first = (NSNumber*)a;
        NSNumber *second = (NSNumber*)b;
        return [first compare:second];
    }];
    
    //Display selected aircraft descriptions...
    NSEnumerator *e = [sortedArray objectEnumerator];
    NSString *key;
    while (key = [e nextObject]) {
        //DLog(@"pulling Aircraft with Id %@", key);
        NFDAircraftType *ac = [selectedAircraftTypes objectForKey:key];
        [parameters.aircrafts addObject:ac];
        
    }
    [legEditor getAirports:parameters.airports];
    parameters.passengers = numberOfPassengers.text.intValue;
}

-(void) checkParameters
{
    [self prepareParameters];
    [estimator tripAndRateInfo:parameters];

    [self updateAircraftWarnings];
}

- (void) saveParameters {
    [self checkParameters];
    [self dismissModal];
}

- (void) dismissModal {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissingFlightDetails" object:nil];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancelModal {
    [self dismissModal];
}

- (void) resetControls {
    [selectedAircraftTypes removeAllObjects];
    airports = [[NSMutableArray alloc] init ];
    [self hideAircrafts];
    [legEditor clearAll];
    [adjustPassengersStepper setValue:1.0];
    [self adjustNumberOfPassengers:adjustPassengersStepper];
    [tripOptionsTable reloadData];
}

//Update Number of Passengers...
- (IBAction) adjustNumberOfPassengers:(id)sender {
    numberOfPassengers.text = [NSString stringWithFormat:@"%.f", adjustPassengersStepper.value];
    parameters.passengers = numberOfPassengers.text.intValue;
    [self checkParameters];
}

#pragma mark - Handle Orientation Changes

- (void)keyboardWillHide
{
    if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft || [self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) {
        [self positionTripOptionsPopoverOnOrientationChange];
    }
}

- (void)positionTripOptionsPopoverOnOrientationChange {
    if (popover.isPopoverVisible) {
        [popover dismissPopoverAnimated:NO];
        if (popoverContent.tableView.tag == 1) {
            [tripOptionsTable selectRowAtIndexPath:seasonsIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:tripOptionsTable showTripOptionsPopoverForIndexPath:seasonsIndexPath];
        } else {
            [tripOptionsTable selectRowAtIndexPath:typeIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:tripOptionsTable showTripOptionsPopoverForIndexPath:typeIndexPath];
        }
    }
}


#pragma mark - Airport Selection

-(void) clearedAirportSelection : (NSNotification *) notification {
    
    [self checkParameters];
    
}


-(void) madeAirportSelection : (NSNotification *) notification {
    [self checkParameters];
}


#pragma mark - Show Trip Options Popover

- (void)tableView:(UITableView*)tableView showTripOptionsPopoverForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableDataArray.count > 0) {
        [tableDataArray removeAllObjects];
    }
    
    if (indexPath.section == 0) {
        [tableDataArray addObjectsFromArray:seasonsArray];
        [self.popoverContent setPreferredContentSize:CGSizeMake(240, 222)];
        [self.popoverContent.tableView setTag:1];
    } else {
        [tableDataArray addObjectsFromArray:typeArray];
        [self.popoverContent setPreferredContentSize:CGSizeMake(240, 130)];
        [self.popoverContent.tableView setTag:2];
    }
    [self.popoverContent.tableView reloadData];
    
    CGRect popoverRect = CGRectMake(tableView.frame.origin.x, (cell.frame.origin.y + cell.frame.size.height + 12), cell.frame.size.width, (cell.frame.size.height - 9));
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    self.popover.delegate = self;
    [self.popover presentPopoverFromRect:popoverRect inView:tableView.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView.tag == 0) {
        return 3;        
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        return 36;
    } else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView.tag == 0) {
        return 1;
    }else{
        return [tableDataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // setting scrolling for table view as disabled mode
    
    tableView.scrollEnabled = NO;
    
    
    // Configure the cell...
    cell.backgroundColor = [UIColor whiteColor];
    
    if (tableView.tag == 0) {
        cell.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1.000];
        cell.textLabel.textColor = [UIColor colorWithRed:0.364 green:0.372 blue:0.395 alpha:1.000];
        if (indexPath.section == 0) {
            cell.textLabel.text = @"Season";
            
            cell.detailTextLabel.text = parameters.season;
            
            seasonsIndexPath = indexPath;
            
        } else if (indexPath.section == 1) {
            cell.textLabel.text = @"Round Trip";
            if (parameters.roundTrip) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                parameters.roundTrip = YES;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                parameters.roundTrip = NO;
            }
            
        } else if (indexPath.section == 2) {
            cell.textLabel.text = @"Type";
            
            cell.detailTextLabel.text = parameters.product;
            
            typeIndexPath = indexPath;
        }
        
    } else {
        
        cell.textLabel.textColor = [UIColor colorWithRed:0.184 green:0.188 blue:0.200 alpha:1.000];
        cell.textLabel.text = [tableDataArray objectAtIndex:indexPath.row];
        
        NSString *selected;
        if (tableView.tag == 1) {
            selected = parameters.season;
        } else {
            selected = parameters.product;
        }
        
        if (cell.textLabel.text == selected) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView.tag == 0) {
        if (indexPath.section == 0 || indexPath.section == 2) {
            [self tableView:tableView showTripOptionsPopoverForIndexPath:indexPath];
        } else if(indexPath.section == 1) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                parameters.roundTrip = NO;
            }else{
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                parameters.roundTrip = YES;
            }
            [self updateAircraftWarnings];
        }
    } else if(tableView.tag == 1) {
        parameters.season = [seasonsArray objectAtIndex:indexPath.row];
        [self.popover dismissPopoverAnimated:YES];
        [tripOptionsTable reloadData];
        [self updateAircraftWarnings];
    } else {
        
        parameters.product = [typeArray objectAtIndex:indexPath.row];
        [self.popover dismissPopoverAnimated:YES];
        [self checkParameters];
        [tripOptionsTable reloadData];
        [self updateAircraftWarnings];
    }
}

#pragma mark - Popover delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSIndexPath *selectedIndex = [tripOptionsTable indexPathForSelectedRow];
    [tripOptionsTable deselectRowAtIndexPath:selectedIndex animated:YES];
}

#pragma mark - Aircrafts

- (void) hideAircrafts {
    aircraft1.alpha = 0.0;
    aircraft2.alpha = 0.0;
    aircraft3.alpha = 0.0;
}




- (void) showAircrafts {
    int i = 0;
    [self hideAircrafts];
    
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    UIColor *labelBackgroundColor = [UIColor colorWithWhite:0.104 alpha:1.000];
    
    aircraft1.label.font = labelFont;
    aircraft2.label.font = labelFont;
    aircraft3.label.font = labelFont;
    aircraft1.label.backgroundColor = labelBackgroundColor;
    aircraft2.label.backgroundColor = labelBackgroundColor;
    aircraft3.label.backgroundColor = labelBackgroundColor;
    
    NSArray *sortedArray = [selectedAircraftTypes.allValues sortedArrayUsingComparator:^(id a, id b)
                            {
                                NFDAircraftTypeGroup *first = (NFDAircraftTypeGroup*)a;
                                NFDAircraftTypeGroup *second = (NFDAircraftTypeGroup*)b;
                                return [first.displayOrder compare:second.displayOrder];
                            }];
    
    
    for (NFDAircraftTypeGroup *aircraft in sortedArray) {
        i++;
        switch (i) {
            case 1:
                [aircraft1 setData:aircraft];
                [aircraft1 showCheckmark];
                aircraft1.alpha = 1.0;
                break;
                
            case 2:
                [aircraft2 setData:aircraft];
                [aircraft2 showCheckmark];
                aircraft2.alpha = 1.0;
                break;
                
            case 3:
                [aircraft3 setData:aircraft];
                [aircraft3 showCheckmark];
                aircraft3.alpha = 1.0;
                break;
                
            default:
                break;
        }
    }
    [self updateAircraftWarnings];
}



- (void) updateAircraftWarnings {
    if (aircraft1.aircraft != nil) [aircraft1 toggleWarnings];
    if (aircraft2.aircraft != nil) [aircraft2 toggleWarnings];
    if (aircraft3.aircraft != nil) [aircraft3 toggleWarnings];
}

@end
