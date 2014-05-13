//
//  NFDNeedsAnalysisViewController.m
//  FliteDeck
//
//  Created by Mohit Jain on 2/17/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDNeedsAnalysisViewController.h"
#import "NFDViewController.h"
#import "NFDFlightProfileAircraftSelectionViewController.h"

@implementation NFDNeedsAnalysisViewController
@synthesize fq, message,needsAnalysisScrollView;
@synthesize campaign_NFDNeedsAnalysisLabel, travelType_NFDNeedsAnalysisLabel, leadCurrentlyTravel_NFDNeedsAnalysisLabel;
@synthesize leadFlyEachYearhours_NFDNeedsAnalysisLabel, leadFlyEachYearTrips_NFDNeedsAnalysisLabel, leadFlyWithCompetitors_NFDNeedsAnalysisLabel;
@synthesize peopleTypicallyFly_NFDNeedsAnalysisLabel,typicalDestinationTo_NFDNeedsAnalysisLabel, typicalDestinationFrom_NFDNeedsAnalysisLabel, typicalDestinationFrequency_NFDNeedsAnalysisLabel;
@synthesize purchasingTimeline_NFDNeedsAnalysisLabel, additionalInformation_NFDNeedsAnalysisLabel, recommendedProducts_NFDNeedsAnalysisLabel;
@synthesize originA, originB, originC, destinationA, destinationB, destinationC;
@synthesize frequencyLabel1, frequencyLabel2, frequencyLabel3;
@synthesize needsAnalysisOptionsTable, campaignArray, travelTypeArray, leadTravelTypeArray, flyWithCompetitorsArray;
@synthesize purchasingTimelineArray, tableDataArray, popover, popoverContent;
@synthesize peopleTypicallyFlyEachYrLabel, tripsEachYrLabel, hrsEachYrLabel, textViewForAdditionalInformation;
@synthesize tripsPerYearStepper, hrsPerYearStepper, peopleFlyEachYrStepper;
@synthesize service;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Needs Analysis";
        /*      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareNeedsAnalysis:)];
         
         
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(gotoLaunchpad:)];
         */
        [self configureButtons];
        
    }
    return self;
}

-(void)configureButtons {
    
    UIBarButtonItem *goToFlightProfileItem = [[UIBarButtonItem alloc] 
                                              initWithTitle:@"Flight Profile"                                            
                                              style:UIBarButtonItemStyleBordered 
                                              target:self 
                                              action:@selector(goToFlightProfile:)];
    
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] 
                                        initWithTitle:@"Share"                                            
                                        style:UIBarButtonItemStylePlain 
                                        target:self 
                                        action:@selector(shareNeedsAnalysis:)];
    
    NSArray *buttonBarArray = [[NSArray alloc] initWithObjects:shareButtonItem, goToFlightProfileItem, nil];
    
    //     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(gotoLaunchpad:)];
    
    [self.navigationItem setRightBarButtonItems:buttonBarArray];
}

// Navigator Controller - Back button implementation 
- (IBAction) gotoLaunchpad:(id)sender {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (IBAction)goToFlightProfile:(id)sender {
    
    
    NFDFlightProfileAircraftSelectionViewController *flightProfileViewController = [[NFDFlightProfileAircraftSelectionViewController alloc] initWithNibName:@"NFDFlightProfileAircraftSelectionViewController" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:flightProfileViewController animated:YES];
}


- (IBAction) shareNeedsAnalysis:(id)sender {
    
    // [fq shareButtonClicked:(id)sender];
    NSLog(@" You have clicked share NeedsAnalysis button");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Need Analysis" delegate:self cancelButtonTitle:@"Ok" destructiveButtonTitle:@"Email" otherButtonTitles:nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self showPicker];
        
    }
    
}


// Custom methods for Stepper control

- (IBAction) adjustTripsPerYr:(id)sender {
    
    
}
- (IBAction) adjustHrsPerYr:(id)sender {
    
    
}
- (IBAction) adjustPeopleTravelPerYr:(id)sender {
    
    
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Setting Proprties for Labels and UI components
- (void)setProperties
{  
    // Creating a custom Font property for Labels
    UIFont *fontForNeedsAnalysisLabels = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    
    // Reusing Font 
    campaign_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    travelType_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    leadFlyWithCompetitors_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    leadFlyEachYearTrips_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    leadFlyEachYearhours_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    leadCurrentlyTravel_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    peopleTypicallyFly_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    typicalDestinationFrom_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    typicalDestinationTo_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    typicalDestinationFrequency_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    // purchasingTimeline.font = fontForNeedsAnalysisLabels;
    purchasingTimeline_NFDNeedsAnalysisLabel.font = fontForNeedsAnalysisLabels;
    
    tripsEachYrLabel.text = @"5";
    hrsEachYrLabel.text = @"20";
    peopleTypicallyFlyEachYrLabel.text = @"5";
    
    
}

// Set contents' frame for landscape mode
- (void)setSizeforUIComponentsinLandscapeMode 
{
    
    campaign_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 50, 450, 20);
    travelType_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 120, 450, 20);
    leadCurrentlyTravel_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 170, 450, 20);
    leadFlyWithCompetitors_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 220, 450, 20);
    leadFlyEachYearTrips_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 270, 450, 20);
    leadFlyEachYearhours_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 320, 450, 20);
    peopleTypicallyFly_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 370, 450, 20);
    
    additionalInformation_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 822, 450, 20);
    //  additionalInformationTextBox.frame = CGRectMake(50, 850, 924, 250);
    textViewForAdditionalInformation.frame = CGRectMake(50, 850, 924, 250);
    
}

// Set contents' frame for Portrait mode

- (void)setSizeforUIComponentsinPortraitMode 
{
    
    campaign_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 50, 450, 20);
    travelType_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 120, 450, 20);
    leadCurrentlyTravel_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 190, 450, 20);
    leadFlyWithCompetitors_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 260, 600, 20);
    purchasingTimeline_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 330, 600, 20);
    
    leadFlyEachYearTrips_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 400, 525, 20);
    leadFlyEachYearhours_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 470, 525, 20);
    peopleTypicallyFly_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 540, 525, 20);
    
    typicalDestinationFrom_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 600, 100, 20);
    typicalDestinationTo_NFDNeedsAnalysisLabel.frame = CGRectMake(355, 600, 100, 20);
    typicalDestinationFrequency_NFDNeedsAnalysisLabel.frame = CGRectMake(645, 600, 100, 20);
    
    tripsEachYrLabel.frame = CGRectMake(600, 400, 20, 20);
    hrsEachYrLabel.frame = CGRectMake(600, 470, 20, 20);
    peopleTypicallyFlyEachYrLabel.frame = CGRectMake(600, 540, 20, 20);
    
    
    additionalInformation_NFDNeedsAnalysisLabel.frame = CGRectMake(50, 850, 450, 20);
    // additionalInformationTextBox.frame = CGRectMake(50, 873, 668, 100);
    textViewForAdditionalInformation.frame =CGRectMake(50, 873, 668, 250);
    
    originA.frame = CGRectMake(50, 625, 150, 40);
    originB.frame = CGRectMake(50, 695, 150, 40);
    originC.frame = CGRectMake(50, 765, 150, 40);
    
    destinationA.frame = CGRectMake(340, 625, 150, 40);
    destinationB.frame = CGRectMake(340, 695, 150, 40);
    destinationC.frame = CGRectMake(340, 765, 150, 40);
    
    frequencyLabel1.frame = CGRectMake(640, 630, 90, 30);
    frequencyLabel2.frame = CGRectMake(640, 700, 90, 30);
    frequencyLabel3.frame = CGRectMake(640, 770, 90, 30);
    
    tripsPerYearStepper.frame = CGRectMake(650, 545, 25, 20);
    hrsPerYearStepper.frame =  CGRectMake(650, 615, 25, 20);
    peopleFlyEachYrStepper.frame = CGRectMake(650, 675, 25, 20);
    
}


// Intializing Labels, Placeholders and Popover with data

- (void)initializeWithData {
    
    originA.airportSearchBar.placeholder = @"Origin: Name, City or Code";
    originB.airportSearchBar.placeholder = @"Origin: Name, City or Code";
    originC.airportSearchBar.placeholder = @"Origin: Name, City or Code";
    destinationA.airportSearchBar.placeholder = @"Destination: Name, City or Code";
    destinationB.airportSearchBar.placeholder = @"Destination: Name, City or Code";
    destinationC.airportSearchBar.placeholder = @"Destination: Name, City or Code";
    
    
    travelTypeArray = [NSArray arrayWithObjects:@"Business",@"Personal", @"Both", nil];
    leadTravelTypeArray = [NSArray arrayWithObjects:@"Charter",@"Commercial", @"Company Jet", @"Competitor", @"Fractional", @"Jet Membership", @"Other", @"Own Aircraft", nil];
    purchasingTimelineArray = [NSArray arrayWithObjects:@"Immediate",@"1 to 3 months", @"3 to 6 months", @"6 months plus", @"unsure", nil];
    
    // campaignArray = [service getAll:@"Campaign" sortedBy: @"name"];
    campaignArray = [NSArray arrayWithObjects:@"Be There - Achieve",@"Be There - Business Launch", @"Be There - Build Business", @"Be There - Safety", @"Be There - Productivity People", nil];
    //  flyWithCompetitorsArray = [service getAll:@"Competitor" sortedBy: @"name"];
    flyWithCompetitorsArray = [NSArray arrayWithObjects:@"Avantair", @"Blue Star Jets",@"Citation Air Card",@"Delata Private Jets",@"FlexJet/Flex 25",@"FlexJet Charter",@"Flight Options/Jet Pass",@"Jets Direct",@"Jets.com",@"Local Charter",@"NetJets",@"Other",@"Revolution Air",@"Sentient", @"XO Jet", nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setProperties];
    
    
    
    // Setting size for Scroll View
    needsAnalysisScrollView.contentSize = CGSizeMake(768, 1380);
    
    
    needsAnalysisOptionsTable.backgroundView = nil;
    needsAnalysisOptionsTable.backgroundColor = [UIColor clearColor];
    
    self.popoverContent = [[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil];
    self.popoverContent.tableView.dataSource = self;
    self.popoverContent.tableView.delegate = self;
    
    [self initializeWithData];
    
    
    tableDataArray = [NSMutableArray array];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    /*   if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
     
     // set contents' frame for landscape mode
     
     [self setSizeforUIComponentsinLandscapeMode];
     
     
     }
     else {
     
     // set contents' frame for portrait mode
     [self setSizeforUIComponentsinPortraitMode];
     }
     
     */
    
    [self setSizeforUIComponentsinPortraitMode];
    
	return NO;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView.tag == 0) {
        return 5;        
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
    
    // return 44; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView.tag == 0) {
        return 1;
    }  
    
    else {
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
            cell.textLabel.text = @"Campaign";
            cell.detailTextLabel.text = [campaignArray objectAtIndex:0];
            
        } 
        
        if (indexPath.section == 1) {
            cell.textLabel.text = @"Travel Type";
            
            cell.detailTextLabel.text = [travelTypeArray objectAtIndex:0];
            
        }
        if (indexPath.section == 2) {
            cell.textLabel.text = @"Lead";
            
            cell.detailTextLabel.text = [leadTravelTypeArray objectAtIndex:0];
            
        }
        
        if (indexPath.section == 3) {
            cell.textLabel.text = @"Competitors";
            
            cell.detailTextLabel.text = [flyWithCompetitorsArray objectAtIndex:0];
            
        }
        
        if (indexPath.section == 4) {
            cell.textLabel.text = @"Purchasing";
            
            cell.detailTextLabel.text = [purchasingTimelineArray objectAtIndex:0];
            
        }
        
    }
    else {
        
        cell.textLabel.textColor = [UIColor colorWithRed:0.184 green:0.188 blue:0.200 alpha:1.000];
        cell.textLabel.text = [tableDataArray objectAtIndex:indexPath.row];
        
        NSString *selected;
        if (tableView.tag == 1) {
            selected = [campaignArray objectAtIndex:0];
        } else {
            // selected = parameters.product;
            selected = [campaignArray objectAtIndex:0];
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
        
        if (tableDataArray.count > 0) {
            [tableDataArray removeAllObjects];
        }
        
        
        if (indexPath.section == 0) {
            [tableDataArray addObjectsFromArray:campaignArray];
            [self.popoverContent setContentSizeForViewInPopover:CGSizeMake(240, 217)];
            
            [self.popoverContent.tableView setTag:1];
        } else if(indexPath.section == 1) {
            [tableDataArray addObjectsFromArray:travelTypeArray];
            [self.popoverContent setContentSizeForViewInPopover:CGSizeMake(240, 130)];
            [self.popoverContent.tableView setTag:2];
        }
        else if(indexPath.section == 2) {
            [tableDataArray addObjectsFromArray:leadTravelTypeArray];
            [self.popoverContent setContentSizeForViewInPopover:CGSizeMake(240, 347)];
            [self.popoverContent.tableView setTag:2];
        }
        else if(indexPath.section == 3) {
            [tableDataArray addObjectsFromArray:flyWithCompetitorsArray];
            [self.popoverContent setContentSizeForViewInPopover:CGSizeMake(240, 709)];
            [self.popoverContent.tableView setTag:2];
        }
        else if(indexPath.section == 4) {
            [tableDataArray addObjectsFromArray:purchasingTimelineArray];
            [self.popoverContent setContentSizeForViewInPopover:CGSizeMake(240, 217)];
            [self.popoverContent.tableView setTag:2];
        }
        
        
        //
        
        
        [self.popoverContent.tableView reloadData];
        
        CGRect popoverRect = CGRectMake(tableView.frame.origin.x, (cell.frame.origin.y + cell.frame.size.height + 8), cell.frame.size.width, (cell.frame.size.height - 9));
        
        
        //  CGRect popoverRect = CGRectMake(350,50,300,300);
        self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } 
    else if(tableView.tag == 1) {
        // parameters.season = [seasonsArray objectAtIndex:indexPath.row];
        [self.popover dismissPopoverAnimated:YES];
        [needsAnalysisOptionsTable reloadData];
    } else {
        
        [self.popover dismissPopoverAnimated:YES];
        
        [needsAnalysisOptionsTable reloadData];
    }
}

//

#pragma mark - Popover delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSIndexPath *selectedIndex = [needsAnalysisOptionsTable indexPathForSelectedRow];
    [needsAnalysisOptionsTable deselectRowAtIndexPath:selectedIndex animated:YES];
}



#pragma mark -
#pragma mark Compose Mail

-(void)showPicker

{
    
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
    
    
}




// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    //	picker.wantsFullScreenLayout = TRUE;
    
	[picker setSubject:@"Netjets Needs Analysis"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
    
	[picker setToRecipients:toRecipients];
    
	// Attach a pdf to the email
	
    /*  
     NSData *myData = [NSData dataWithContentsOfFile:pdf.pdfFileName]; 
     NSLog(@"PDF file name is %@", pdf.pdfFileName);
     
     [picker addAttachmentData:myData mimeType:@"application/pdf" fileName:@"NeedsAnalysis.pdf"];
     [picker addAttachmentData:myData mimeType:@"application/pdf" fileName:pdfFileName];
     */
	
	
    // Fill out the email body text
	
    NSString *emailBody = @"Needs Analysis";
	[picker setMessageBody:emailBody isHTML:NO];
	
    [self presentModalViewController:picker animated:YES];
    
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message.text = @"Result: failed";
			break;
		default:
			message.text = @"Result: not sent";
			break;
	}
    [self dismissModalViewControllerAnimated:YES];
}



// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    
    
    NSString *recipients = @"mailto:test@compuware.com&subject=NetJets Estimation Pdf Attached!";
	NSString *body = @"&body= Check the attachment";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}




@end
