//
//  NFDFlightProfileAircraftSelectionViewController.m
//  FliteDeck
//
//  Created by Geoffrey Goetz on 2/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProfileAircraftSelectionViewController.h"
#import "NFDFlightProfileAircraftPhotoViewController.h"
#import "NFDPersistenceManager.h"
#import "NFDFlightQuoteViewController.h"
#import "NFDFlightProfileEstimator.h"
#import "NFDFlightProfileManager.h"
#import "AircraftTypeGroup+Custom.h"
#import "NFDAirportService.h"
#import "NFDNetJetsRemoteService.h"
#import "UIView+FrameUtilities.h"

//Aircract Scroll View Constants for Pulldown Shade
#define SHADE_HEIGHT_TO_HIDE 247
#define PADDING_BETWEEN_AIRCRAFT 20
#define PADDING_ABOVE_AIRCRAFT 10
#define AIRCRAFT_TILE_IMAGE_HEIGHT 165
#define AIRCRAFT_TILE_IMAGE_WIDTH 205
#define AIRCRAFT_DETAIL_IMAGE_HEIGHT_PORTRAIT 475
#define AIRCRAFT_DETAIL_IMAGE_WIDTH_PORTRAIT 600
#define AIRCRAFT_DETAIL_IMAGE_HEIGHT_LANDSCAPE 227
#define AIRCRAFT_DETAIL_IMAGE_WIDTH_LANDSCAPE 287
#define AIRCRAFT_TEXT_HEIGHT 21
#define USE_TEST_AIRPORTS 0
//Aircract Details Scroll View Constants
#define NUMBER_OF_PHOTOS_TO_DISPLAY 4

@implementation NFDFlightProfileAircraftSelectionViewController

@synthesize aircraftSelectionView;
@synthesize aircraftSelectorTab;
@synthesize aircraftThumbnailsView;
@synthesize displayedAircraftPhoto;
@synthesize displayedAircraftType;
@synthesize displayedAircraftCheckmark;
@synthesize displayedAircraftPhotosView;
@synthesize displayedAircraftScrollView;
@synthesize aircraftSelectionScrollView;
@synthesize modalController, backgroundImageView, viewForAircraftDetailComponent;
@synthesize isFirstLoad;
// Synthesizing Labels

@synthesize passengerCapacity_Label, baggageCapacity_Label;
@synthesize cruiseSpeed_Label, range_Label, cabinWidth_Label, cabinHeight_Label, cabinLength_Label, altitude_Label, cabinAmenities_Label;
@synthesize capacity, rangeInHours, speed, cabinWidth, cabinHeight, baggageCapacity;
@synthesize canSelectMore,parameters,estimator;
@synthesize flightDetailController,flightQuoteViewController,selectedAircraftTypes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Flight Profile";
        parameters = [[FlightEstimatorData alloc] init];
        estimator =  [[NFDFlightProfileEstimator alloc] init];
    }
    canSelectMore = YES;
    isFirstLoad = YES;
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NFDNetJetsRemoteService sharedInstance] displayRequiredSetupWarning:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        viewForAircraftDetailComponent.frame = CGRectMake(18, 50, 713, 400);
    }
    else
    {
        viewForAircraftDetailComponent.frame = CGRectMake(135, 50, 715, 400);
    }
    

    [self createAircraftScrollView];
    
    NFDCompanySetting companySetting = [[NFDUserManager sharedManager] companySetting];
    
    // This is an index into the aircraft shade display to show which aircraft
    // is featured when the app starts initially.
    // NOTE: forgive me for continuing this horrible hack...  May this code die in peace soon...
    NSInteger moneyShotKey = (companySetting == NFDCompanySettingNJA ? 11 : 7);
    
    if (selectedAircraftTypes.count > 0) {
        NFDAircraftTypeGroup *firstAircraft = [[selectedAircraftTypes allValues] firstObject];
        moneyShotKey = [[[selectedAircraftTypes allKeysForObject:firstAircraft] firstObject] integerValue];
        
        [self updateAircraftThumbnailsWithSelectedAircraft];
    }
    
    [self updateMoneyShotWithKey:moneyShotKey];
    
    if (self.isFirstLoad || selectedAircraftTypes.count == 0) {
        [self.displayedAircraftPhoto toggleCheck:NO];
        self.isFirstLoad = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //disabling this will need to be handled on the back button
    
    //[self clearAllFieldsInFlightProfileDetailViewModal];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flightDetailsDismissed:)
                                                 name:@"dismissingFlightDetails" object:nil];
    
    [displayedAircraftPhoto toggleCheck:NO];
    [[displayedAircraftPhoto label] setText:@""];
    [[displayedAircraftPhoto checked] offsetViewVertically:20];
    [[displayedAircraftPhoto runwayWarningButton] offsetViewVertically:20];
    [[displayedAircraftPhoto paxWarningButton] offsetViewVertically:20];
    [[displayedAircraftPhoto fuelStopButton] offsetViewVertically:20];
    [[displayedAircraftPhoto acNotAvailableButton] offsetViewVertically:20];
    
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    
    [[self.aircraftSelectionView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.aircraftSelectionView layer] setShadowOffset:CGSizeMake(0, 1)];
    [[self.aircraftSelectionView layer] setShadowOpacity:1.0];
    [[self.aircraftSelectionView layer] setShadowRadius:5];
    [self.view bringSubviewToFront:self.aircraftSelectionView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self updateGestureRecognizers];
    [self loadAllAircraft];
}

- (void)configureButtons {
    
    UIBarButtonItem *estimateFlightButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Estimate"
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(estimateFlight)];
    
    UIBarButtonItem *flightDetailsButton = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Flight Details"
                                            style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(displayFlightDetailsModal)];

    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Clear"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(clearAllFieldsInFlightProfileDetailViewModal)];
    
    NSArray *buttonBarArray = [[NSArray alloc] initWithObjects: estimateFlightButton, flightDetailsButton, clearButton, nil];
    
    [self.navigationItem setRightBarButtonItems:buttonBarArray];
}

- (void)clearAllFieldsInFlightProfileDetailViewModal {
    
    [parameters resetInformation];
    if(displayedAircraftPhoto.selected){
        [displayedAircraftPhoto toggleCheck:canSelectMore];
    }
    
    //uncheck selected tiles in scroll
    for (NFDAircraftTile *tile in aircraftThumbnailsView.subviews){
        if (tile.selected){
            [tile toggleCheck:canSelectMore];
        }
    }
    [flightDetailController resetControls];
    
    [selectedAircraftTypes removeAllObjects];
    
    [self canEstimate];
}

- (void)viewDidUnload
{
    [self setAircraftSelectorTab:nil];
    [self setAircraftSelectionView:nil];
    [self setAircraftThumbnailsView:nil];
    [self setAircraftSelectionScrollView:nil];
    [self setDisplayedAircraftPhoto:nil];
    [self setDisplayedAircraftType:nil];
    [self setDisplayedAircraftPhotosView:nil];
    [self setDisplayedAircraftScrollView:nil];
    [self setDisplayedAircraftCheckmark:nil];
    self.flightDetailController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissingFlightDetails" object:nil];
    [super viewDidUnload];
}

// Starting with iOS6+, this method is not needed here
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self updateGestureRecognizers];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        
        viewForAircraftDetailComponent.frame = CGRectMake(135, 50, 715, 400);
        
    } else {
        
        viewForAircraftDetailComponent.frame = CGRectMake(18, 50, 713, 400);
        
    }
}

- (void)updateGestureRecognizers
{
    
    //NOTE: When orientation changes, the gestures need to be removed and added back
    
    //Swipe up and down on Airctaft Selector Tab
    for (UIGestureRecognizer *gr in [aircraftSelectorTab gestureRecognizers]) 
    {
        [aircraftSelectorTab removeGestureRecognizer:gr];
    }
    
    UITapGestureRecognizer *tapGestureForSelector = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleTab)];
    [tapGestureForSelector setNumberOfTapsRequired:1];
    [tapGestureForSelector setNumberOfTouchesRequired:1];
    [aircraftSelectorTab addGestureRecognizer:tapGestureForSelector];
    
    //Double Tap on Displayed Aircraft Photo
    for (UIGestureRecognizer *gr in [displayedAircraftPhoto gestureRecognizers])
    {
        [displayedAircraftPhoto removeGestureRecognizer:gr];
    }
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTabOnMoneyShot:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setNumberOfTouchesRequired:1];
    [displayedAircraftPhoto addGestureRecognizer:doubleTapGesture];
}

- (void)setDataForAircraftDetails:(NFDAircraftTypeGroup *)aircraft  {
    
    passengerCapacity_Label.text = [NSString stringWithFormat:@"Capacity"];
    capacity.text = [NSString stringWithFormat:@"%@",aircraft.numberOfPax]; 
    
    range_Label.text = [NSString stringWithFormat:@"Maximum Range in Hours"];
    rangeInHours.text = [NSString stringWithFormat:@"%@",aircraft.range]; 
    
    cruiseSpeed_Label.text = [NSString stringWithFormat:@"Speed"];    
    speed.text = [NSString stringWithFormat:@"%@", aircraft.highCruiseSpeed]; 
    
    cabinHeight_Label.text = [NSString stringWithFormat:@"Cabin Height"];
    cabinHeight.text = [NSString stringWithFormat:@"%@", aircraft.cabinHeight];
    
    cabinWidth_Label.text = [NSString stringWithFormat:@"Cabin Width"];
    cabinWidth.text = [NSString stringWithFormat:@"%@", aircraft.cabinWidth];
    
    baggageCapacity_Label.text = [NSString stringWithFormat:@"Baggage Capacity"]; 
    baggageCapacity.text = [NSString stringWithFormat:@"%@", aircraft.baggageCapacity];
}


#pragma mark - Pull down "shade" animations for Aircraft Scroll View Selection

- (void)toggleTab
{
    [self.view bringSubviewToFront:self.aircraftSelectionView];
    CGRect moveViewToFrame = aircraftSelectionView.frame;
    if (aircraftSelectionView.frame.origin.y == 0)
    {
        moveViewToFrame.origin.y = ( -1 * SHADE_HEIGHT_TO_HIDE );
    }
    else
    {
        moveViewToFrame.origin.y = 0;
    }
    [UIView animateWithDuration:.3 animations:^{
        aircraftSelectionView.frame = moveViewToFrame;
    }];
}

#pragma mark - Aircraft Scroll View Selection in Drop Down Shade

- (void)loadAllAircraft
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"AircraftTypeGroup"];
    fetchRequest.includesSubentities=NO;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayOrder != 0"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSManagedObjectContext *context = [[NFDPersistenceManager sharedInstance] mainMOC];
    NSArray *aircraftTypeGroups = [context executeFetchRequest:fetchRequest error:&error];
    
    //Create dictionary for all aircraft types and selected aircraft
    int total_number_of_aircraft = [aircraftTypeGroups count];
    aircraftTypes = [[NSMutableDictionary alloc] initWithCapacity:total_number_of_aircraft];
    checkMarks = [[NSMutableDictionary alloc] initWithCapacity:total_number_of_aircraft];
    selectedAircraftTypes = [[NSMutableDictionary alloc] init];
    
    //Add aircraft types to dictionary
    int counter = 0;
    
    for (NFDAircraftTypeGroup *ac in aircraftTypeGroups)
    {
        // Exclude the Challenger 350 since we don't have performance number to do block times
        if (![ac.acPerformanceTypeName contains:@"CL-350"]) {
            [aircraftTypes setObject:ac forKey:[NSNumber numberWithInt:counter++]];
        }
    }
}

- (void)createAircraftScrollView 
{    
    //Set max size of scroll view content based on number of aircraft types to display...
    int total_number_of_aircraft = [aircraftTypes count];
    if (total_number_of_aircraft > (768 / AIRCRAFT_TILE_IMAGE_WIDTH))
    {
        int width_of_scroll_view = (((AIRCRAFT_TILE_IMAGE_WIDTH + PADDING_BETWEEN_AIRCRAFT) * total_number_of_aircraft) + (PADDING_BETWEEN_AIRCRAFT * 2));
        [aircraftThumbnailsView setFrame:CGRectMake(0, 0, width_of_scroll_view, (AIRCRAFT_TILE_IMAGE_HEIGHT))];
        aircraftSelectionScrollView.contentSize = CGSizeMake(width_of_scroll_view, (AIRCRAFT_TILE_IMAGE_HEIGHT));
    }
    
    //Interate through aircraft types
    for (int i = 0; i < total_number_of_aircraft; i++) 
    {
        [self addAircraftImageToScrollViewAtPosition:i];
    }
}

- (void)addAircraftImageToScrollViewAtPosition:(int)position 
{    
    // *** Retrieve aircraft for posiiton ***
    NFDAircraftTypeGroup *aircraft = [aircraftTypes objectForKey:[NSNumber numberWithInteger:position]];
    CGFloat aircraftButton_x_cordinate = PADDING_BETWEEN_AIRCRAFT + ((AIRCRAFT_TILE_IMAGE_WIDTH + PADDING_BETWEEN_AIRCRAFT) * position);
    
    //Create Aircraft Image
    NFDAircraftTile *tile = [[NFDAircraftTile alloc] initWithFrame:CGRectMake(aircraftButton_x_cordinate, 10, AIRCRAFT_TILE_IMAGE_WIDTH, AIRCRAFT_TILE_IMAGE_HEIGHT+25)];
    
    [aircraftThumbnailsView addSubview:tile];
    
    [tile disableWarningButtons];
    
    [tile setData:aircraft];
    
    //Ensure that image can receive gestures
    [tile setUserInteractionEnabled:YES];
    [tile setTag:position];
    
    //Add double tap gesture to image
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapOnTile:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setNumberOfTouchesRequired:1];
    [tile addGestureRecognizer:doubleTapGesture];
    
    //Add single tap gesture to image
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapOnTile:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [singleTapGesture setNumberOfTouchesRequired:1];
    [tile addGestureRecognizer:singleTapGesture];
    
    //Make sure the two gestures play well together
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    tile.label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    
    tile.label.backgroundColor = [UIColor blackColor];
    [tile.layer setCornerRadius:12];
    [tile setClipsToBounds:YES];
}


#pragma mark - Selecting Aircraft from Scroll View Selection with Gestures

- (void)didSingleTapOnTile:(UITapGestureRecognizer *)gestureRecognizer
{
    [self toggleTab];
    [self updateMoneyShotWithKey:[gestureRecognizer.view tag]];
    NFDAircraftTile *tile = (NFDAircraftTile*) gestureRecognizer.view;
    if (tile.selected)
    {
        DLog(@"!!!");
        [self canEstimate];
    }
    [self setupMoneyShotCheckmark: tile.selected];
}

- (void)didDoubleTapOnTile:(UITapGestureRecognizer *)gestureRecognizer
{
    [self updateMoneyShotWithKey:[gestureRecognizer.view tag]];
    [self updateSelectedAircraftListWithKey:[gestureRecognizer.view tag]];
    NFDAircraftTile *tile = (NFDAircraftTile*) gestureRecognizer.view;
    [tile toggleCheck:canSelectMore];
    [self setupMoneyShotCheckmark: tile.selected];
    [self canEstimate];
}

- (void)setupMoneyShotCheckmark:(BOOL)selected 
{
    displayedAircraftPhoto.selected = !selected;
    [displayedAircraftPhoto toggleCheck:YES];
}

- (void)showCheckmarkOnAircraftInThumbnailsView
{
    for (NFDAircraftTile *tile in aircraftThumbnailsView.subviews)
    {
        if ([tile.aircraft.acPerformanceTypeName isEqualToString:displayedAircraftPhoto.aircraft.acPerformanceTypeName])
        {
            [tile toggleCheck:canSelectMore];
        }
    }
}

- (void)updateAircraftThumbnailsWithSelectedAircraft
{
    for (NFDAircraftTypeGroup *aircraftTypeGroup in [selectedAircraftTypes allValues]) {
        for (NFDAircraftTile *tile in aircraftThumbnailsView.subviews) {
            if ([tile.aircraft.acPerformanceTypeName isEqualToString:aircraftTypeGroup.acPerformanceTypeName]) {
                [tile toggleCheck:YES];
            }
        }
    }
}

- (void)didDoubleTabOnMoneyShot:(UITapGestureRecognizer *)gestureRecognizer
{    
    [self updateSelectedAircraftListWithKey:[gestureRecognizer.view tag]];
    
    [displayedAircraftPhoto toggleCheck:canSelectMore];
    [self showCheckmarkOnAircraftInThumbnailsView];
}

#pragma mark - Update View with Aircraft Information

- (void)updateMoneyShotWithKey:(int)key
{
    // *** Retrieve aircraft with Key ***
    NFDAircraftTypeGroup *aircraft = [aircraftTypes objectForKey:[NSNumber numberWithInteger:key]];
    [self setDataForAircraftDetails:aircraft];
    //Update view outlets with aircraft detail information
    
    [displayedAircraftType setText:[aircraft typeGroupName]];
    
    [displayedAircraftPhoto setData:aircraft];
    [displayedAircraftPhoto setTag:key];
    [displayedAircraftPhoto toggleCheck:YES];
    [[displayedAircraftPhoto label] setText:@""];
    
    [self updateAircraftDetailPhotoScrollView];
}

- (void) flightDetailsDismissed: (NSNotification*) notification
{
    [self canEstimate];
    [self updateWarnings];
}

- (void)canEstimate
{
    [self prepareParameters];
    [estimator tripAndRateInfo:parameters];
    
    if ([selectedAircraftTypes count] > 0 && estimator.valid)
    {
        [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
    }
    else
    {
        [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    }
}

- (void)updateWarnings
{
    for (NFDAircraftTile *tile in aircraftThumbnailsView.subviews)
    {
        if ([tile.aircraft.acPerformanceTypeName isEqualToString:displayedAircraftPhoto.aircraft.acPerformanceTypeName])
        {
            [displayedAircraftPhoto toggleWarnings];
        }
        
        [tile toggleWarnings];
    }
}

- (void)updateAircraftDetailPhotoScrollView
{    
    // *** Retrieve currently viewed aircraft ***
    NFDAircraftTypeGroup *aircraft = [aircraftTypes objectForKey:[NSNumber numberWithInteger:displayedAircraftPhoto.tag]];
    
    //Establish image dimentions based on orientation
    int imageWidth = AIRCRAFT_DETAIL_IMAGE_WIDTH_PORTRAIT;
    int imageHeight = AIRCRAFT_DETAIL_IMAGE_HEIGHT_PORTRAIT;
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        imageWidth = AIRCRAFT_DETAIL_IMAGE_WIDTH_LANDSCAPE;
        imageHeight = AIRCRAFT_DETAIL_IMAGE_HEIGHT_LANDSCAPE;
    }
    
    //Set max size of scroll view content based on number of aircraft types to display...
    int total_number_of_aircraft_photos = NUMBER_OF_PHOTOS_TO_DISPLAY;
    if ([[aircraft acPerformanceTypeName] isEqualToString:@"EMB-505S"])
    {
        total_number_of_aircraft_photos = 6;
    
    }
    if (total_number_of_aircraft_photos > (768 / imageWidth)){
        int width_of_scroll_view = imageWidth * total_number_of_aircraft_photos;
        [displayedAircraftPhotosView setFrame:CGRectMake(0, 0, width_of_scroll_view, (imageHeight))];
        displayedAircraftScrollView.contentSize = CGSizeMake(width_of_scroll_view, (imageHeight));
    }
    
    //Remove all existing views from scroll view
    for (UIView *view in displayedAircraftPhotosView.subviews)
    {
        [view removeFromSuperview];
    }
    
    //Add Aircraft Photos to Scroll View
    for (int numberOfPhoto = 1; numberOfPhoto <= total_number_of_aircraft_photos ; numberOfPhoto++)
    {
        
        //Calculate Position for Button in ScrollView
        CGFloat aircraftButton_x_cordinate = ((imageWidth) * ( numberOfPhoto - 1 ));
        
        //Create Aircraft Image for Scroll View
        NSString *aircraftImageName = [NSString stringWithFormat:@"%@_details%i.png", [aircraft acPerformanceTypeName],numberOfPhoto];
        UIImageView *aircraftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:aircraftImageName]];
        aircraftImage.frame = CGRectMake(aircraftButton_x_cordinate, 0, imageWidth, imageHeight);
        
        //Ensure that image can receive gestures
        [aircraftImage setUserInteractionEnabled:YES];
        [aircraftImage setTag:numberOfPhoto];
        
        //Add single tap gesture to image
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayAircraftPhotoInModal:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [singleTapGesture setNumberOfTouchesRequired:1];
        [aircraftImage addGestureRecognizer:singleTapGesture];
        
        //Add Specific Aircraft Image to Scroll View
        [displayedAircraftPhotosView addSubview:aircraftImage];
    }
    
    [displayedAircraftScrollView scrollRectToVisible:displayedAircraftScrollView.frame animated:YES];
}

#pragma mark - Update List of Selected Aircraft

- (void)updateSelectedAircraftListWithKey:(int)key
{
    // *** Retrieve aircraft with Key ***
    NFDAircraftTypeGroup *aircraft = [aircraftTypes objectForKey:[NSNumber numberWithInteger:key]];
    
    //Determine if aircraft already selected
    NFDAircraftTypeGroup *alreadySelected = [selectedAircraftTypes objectForKey:[NSNumber numberWithInteger:key]];
    if (alreadySelected)
    {
        //Remove aircraft from selected list
        [selectedAircraftTypes removeObjectForKey:[NSNumber numberWithInt:key]];
    }
    else
    {
        if ([selectedAircraftTypes count] < 3)
        {
            //Add aircraft to selected list
            [selectedAircraftTypes setObject:aircraft forKey:[NSNumber numberWithInt:key]];
            //Hide aircraft selector shade if displayed
            canSelectMore = YES;
            if (aircraftSelectionView.frame.origin.y == 0)
            {
                [self toggleTab];
            }
            
        }
        else
        {
            canSelectMore = NO;
            return;
        }
    }
    [self canEstimate];
}

#pragma mark - Flight Details Modal

- (void)displayFlightDetailsModal
{    
    //Hide aircraft selector shade if displayed
    if (aircraftSelectionView.frame.origin.y == 0)
    {
        [self toggleTab];
    }
    
    //Create Flight Details flightDetailController
    if(flightDetailController == nil)
    {
        flightDetailController = [[NFDFlightProfileFlightDetailsViewController alloc] initWithNibName:@"NFDFlightProfileFlightDetailsViewController" bundle:nil];
    }
    
    flightDetailController.selectedAircraftTypes = selectedAircraftTypes;  
    
    flightDetailController.parameters = parameters;
    flightDetailController.estimator = estimator;
    //Display modal view
    modalController = [[UINavigationController alloc] initWithRootViewController:flightDetailController];
    [modalController setNavigationBarHidden:NO animated:NO];
    modalController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // TODO IOS7 - Had to change the transition styl to CrossDissolve to position the modal correctly
    modalController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:modalController animated:YES completion:nil];

    if (selectedAircraftTypes.count > 0) 
    {
        modalController.view.superview.bounds = CGRectMake(0, 0, 750, 550);
        flightDetailController.aircraftTileContainer.hidden = NO;
    } 
    else 
    {
        modalController.view.superview.bounds = CGRectMake(0, 0, 750, 325);
        flightDetailController.aircraftTileContainer.hidden = YES;
    }
}

#pragma mark - Estimate Flight

- (void)estimateFlight
{
    if(flightQuoteViewController == nil)
    {
        flightQuoteViewController = [[NFDFlightQuoteViewController alloc] initWithNibName:@"NFDFlightQuoteViewController" bundle:nil];
    }
    [self prepareParameters];
    [estimator tripAndRateInfo:parameters];
    flightQuoteViewController.parameters = parameters;
    [self.navigationController pushViewController:flightQuoteViewController animated:YES];
}

-(void) prepareParameters
{
    parameters.aircrafts = [[NSMutableArray alloc] init];
    
    //Sort selected aircraft by key...
    NSArray *sortedArray = [selectedAircraftTypes.allKeys sortedArrayUsingComparator:^(id a, id b)
                            {
                                NSNumber *first = (NSNumber*)a;
                                NSNumber *second = (NSNumber*)b;
                                return [first compare:second];
                            }];
    
    //Display selected aircraft descriptions...
    NSEnumerator *e = [sortedArray objectEnumerator];
    NSString *key;
    
    while (key = [e nextObject])
    {
        NFDAircraftTypeGroup *ac = [selectedAircraftTypes objectForKey:key];
        [parameters.aircrafts addObject:ac];
    }
    
    [flightDetailController prepareParameters];
}


#pragma mark - Aircraft Photo Modal

- (void)displayAircraftPhotoInModal:(UITapGestureRecognizer *)gestureRecognizer {
    
    //Hide aircraft selector shade if displayed
    if (aircraftSelectionView.frame.origin.y == 0)
    {
        [self toggleTab];
    }
    
    //Create Photo ModalViewController
    NFDFlightProfileAircraftPhotoViewController *modalViewController = [[NFDFlightProfileAircraftPhotoViewController alloc] initWithNibName:@"NFDFlightProfileAircraftPhotoViewController" bundle:nil];
    [modalViewController.view setBackgroundColor:[UIColor blackColor]];
    
    //Display modal view
    modalController = [[UINavigationController alloc] initWithRootViewController:modalViewController];
    [modalController setNavigationBarHidden:YES animated:NO];
    modalController.modalPresentationStyle = UIModalPresentationFormSheet;
    modalController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:modalController animated:YES completion:nil];
    modalController.view.superview.bounds = CGRectMake(0, 0, 740, 615);
    
    //Add single tap gesture to image
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDismissAircraftPhotoModal:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [singleTapGesture setNumberOfTouchesRequired:1];
    [[modalViewController aircraftPhotoImageView] addGestureRecognizer:singleTapGesture];
    
    //Add swipe next gesture
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(displayNextAircraftImage:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[modalViewController aircraftPhotoImageView] addGestureRecognizer:swipeLeftGesture];
    
    //Add swipe previous gesture
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(displayPreviousAircraftImage:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [[modalViewController aircraftPhotoImageView] addGestureRecognizer:swipeRightGesture];
    
    //Determine which aircraft photo to display
    int numberOfPhoto = [gestureRecognizer.view tag];
    [self updateAircraftDetailImageInModal:numberOfPhoto];
}

- (void)displayNextAircraftImage:(UITapGestureRecognizer *)gestureRecognizer 
{    
    //Determine which aircraft photo to display
    int numberOfPhoto = [gestureRecognizer.view tag];
    int numberOfPhotos = NUMBER_OF_PHOTOS_TO_DISPLAY;
    
    if ([[displayedAircraftType text] isEqualToString:@"Phenom 300"])
    {
        numberOfPhotos = 6;
    }
    if (++numberOfPhoto == (numberOfPhotos + 1))
    {
        numberOfPhoto = 1;
    }
    [self updateAircraftDetailImageInModal:numberOfPhoto];
}

- (void)displayPreviousAircraftImage:(UITapGestureRecognizer *)gestureRecognizer
{
    //Determine which aircraft photo to display
    int numberOfPhoto = [gestureRecognizer.view tag];
    int numberOfPhotos = NUMBER_OF_PHOTOS_TO_DISPLAY;
    
    if ([[displayedAircraftType text] isEqualToString:@"Phenom 300"])
    {
        numberOfPhotos = 6;
    }
    if (--numberOfPhoto == 0)
    {
        numberOfPhoto = numberOfPhotos;
    }
    [self updateAircraftDetailImageInModal:numberOfPhoto];
}

- (void)updateAircraftDetailImageInModal:(int)numberOfPhoto
{
    // *** Retrieve currently viewed aircraft ***
    NFDAircraftTypeGroup *aircraft = [aircraftTypes objectForKey:[NSNumber numberWithInteger:displayedAircraftPhoto.tag]];
    
    //Get reference to modal view
    NFDFlightProfileAircraftPhotoViewController *modalViewController = (NFDFlightProfileAircraftPhotoViewController*)[modalController.viewControllers objectAtIndex:0];
    
    //Update Aircraft Photo
    NSString *aircraftImageName = [NSString stringWithFormat:@"%@_details%i.png", [aircraft acPerformanceTypeName],numberOfPhoto];
    [[modalViewController aircraftPhotoImageView] setImage:[UIImage imageNamed:aircraftImageName]];
    [[modalViewController aircraftPhotoImageView] setTag:numberOfPhoto];
    
    [[modalViewController aircraftPhotoImageView] setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)didDismissAircraftPhotoModal:(UITapGestureRecognizer *)gestureRecognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
