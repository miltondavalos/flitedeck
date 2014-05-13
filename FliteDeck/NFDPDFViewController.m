//
//  NFDPDFViewController.m
//  FliteDeck
//
//  Created by Chad Predovich on 3/14/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDPDFViewController.h"
#import "ReaderDocument.h"
#import "NFDEventInformation.h"

@implementation NFDPDFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        service =[[NFDEventsService alloc] init];
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
    // Do any additional setup after loading the view from its nib.
    
    phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
    events = [service getEvents:@""];
    
    NFDEventInformation *event = [events objectAtIndex:0];
    
    eventTitle = event.name;
    
    NSString *eventID = [event.event_id stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self getPathAndLoadPDF:eventID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newEventSelected:) name:@"newEventSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readerDidDisappear:) name:@"readerDisappeared" object:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    [[NSNotificationCenter defaultCenter] unregisterForRemoteNotifications];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif
    
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

- (void)newEventSelected:(NSNotification *)notification
{
    NFDEventInformation *event = (NFDEventInformation *)[notification object];
    newEventID = [event.event_id stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    eventTitle = event.name;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)readerDidDisappear:(NSNotification *)notification
{
    [self getPathAndLoadPDF:newEventID];
}
     
- (void)getPathAndLoadPDF:(NSString *)eventID
{
    NSString *endOfFilePath = [NSString stringWithFormat:@"/%@.pdf", eventID];
    
    for (NSString *newFilePath in pdfs) {
        NSRange textRange = [newFilePath rangeOfString:endOfFilePath];
        
        if (textRange.location != NSNotFound) {
            [self loadPDF:newFilePath];
            break;
        }
    }
}

#pragma mark - Custom FliteDeck Methods

- (void)loadPDF:(NSString *)filePath
{
    
//	NSString *filePath = [pdfs lastObject]; 
    assert(filePath != nil); // Path to last PDF file
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];

	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.toolbarTitle = eventTitle;
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:nil];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
        
        //		[readerViewController release]; // Release the ReaderViewController
	}
    newEventID = nil;
}

@end
