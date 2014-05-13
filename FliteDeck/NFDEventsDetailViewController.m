//
//  NFDEventsDetailViewController.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDEventsDetailViewController.h"
#import "NFDAppDelegate.h"
#import "EventTile.h"
#import "NFDEventMedia.h"
#import "NFDPDFViewController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#define NUMBER_OF_VISIBLE_ITEMS 12
#define ITEM_SPACING 375
#define INCLUDE_PLACEHOLDERS YES



@implementation NFDEventsDetailViewController

@synthesize masterPopoverController;
@synthesize name,description,startDate,endDate,location,carousel,event,service;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        service = [[NFDEventsService alloc] init];
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
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] 
                                       initWithTitle:@"Back"                                            
                                       style:UIBarButtonItemStylePlain 
                                       target:self 
                                       action:@selector(popBack)];
    [self.navigationItem setLeftBarButtonItem:backButtonItem animated:YES];
   
    name.text = event.name;
    //description.text = event.event_description;
//    startDate.text = event.start_date;
//    endDate.text = event.end_date;
    location.text = event.location;
    event.media = [service getEventMedia : event.event_id];
    [carousel reloadData];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void) setData: (NFDEventInformation *) eventData {
    self.event = eventData;
    if(name != nil){
        name.text = event.name;
        //description.text = event.event_description;
//        startDate.text = event.start_date;
//        endDate.text = event.end_date;
        location.text = event.location;
        event.media = [service getEventMedia : event.event_id];
        [carousel reloadData];
    }
    [masterPopoverController dismissPopoverAnimated:YES];
}
- (void)displayMasterPopover{
    if (self.masterPopoverController != nil) {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait){
            [self.masterPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                                 permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                                 animated:YES];
        }
    }        
}



- (void)popBack{
    
    NFDAppDelegate *appDelegate = (NFDAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController popViewControllerAnimated:YES];
    [self.masterPopoverController dismissPopoverAnimated:YES];
    
}


- (IBAction)viewPDF {

    NFDPDFViewController *pdfView = [[NFDPDFViewController alloc] initWithNibName:@"NFDPDFViewController" bundle:nil];
    [self.navigationController pushViewController:pdfView animated:YES];
    
}

#pragma mark - UISplitViewControllerDelegate Methods

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Events", @"Events");
    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setRightBarButtonItem:nil animated:YES];    
    self.masterPopoverController = nil;
}

#pragma mark - Tableview Delegate Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [event.media count];
    
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return [event.media count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	EventTile *tile = nil;
	//create new view if no view is available for recycling
    NFDEventMedia *media = [event.media objectAtIndex:index];
	if (view == nil)
	{
        if([media.filename contains:@".m4v"]){
            tile = [[EventTile alloc] initWithFrame:CGRectMake(0, 0, 350, 227)];
        }else{
            tile = [[EventTile alloc] initWithFrame:CGRectMake(0, 0, 227, 350)];
        }
        [tile setup:media.filename];
	}
	return tile;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    carousel.type = iCarouselTypeLinear
    ;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return NO;
}



@end
