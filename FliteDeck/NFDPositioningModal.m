//NFDPositioningModal.m

//
//  NFDPositioningModal.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDPositioningModal.h"
#import "NFDFileSystemHelper.h"

@implementation NFDPositioningModal
@synthesize info,company,aircraft,details;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModal)]];
        //    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModal)]];
        
        /*UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] 
         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
         target:self 
         action:@selector(dismissModal)];*/
        
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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self displayInfo];
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

-(IBAction) displayPDF : (id) sender {
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],aircraft.detailslink] password:nil];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.toolbarTitle = aircraft.acname;
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
        [self presentViewController:readerViewController animated:NO completion:nil];
        [readerViewController hideSearch];        
        
    }
    //newEventID = nil;
    
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetPopupSize" object:nil];
    
}

-(void) displayInfo {
    
    if(company != nil){
        
        //   text.text = company.competitive_analysis;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        NSString *html = [[company.competitive_analysis stringByReplacingOccurrencesOfString:@"'" withString:@"\""] stringByReplacingOccurrencesOfString:@"~" withString:@","];
        //        [info  loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>",html] baseURL:nil];
        [info  loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>",html] baseURL:baseURL];
        self.title = company.name;
        details.hidden = YES;
    }
    if(aircraft != nil){
        //info.text = [NSString stringWithFormat:@"%@\nCost: %@\nPassengers: %d\nSpeed: %@\nRange: %@\nComparable: %@",aircraft.acname, aircraft.accost,[aircraft.acpassengers intValue],aircraft.acspeed,aircraft.acrange,aircraft.comparableac];
        //        [info  loadHTMLString:[NSString stringWithFormat:@"<html><body>%@<p>Cost: %@</p><p>Passengers: %d</p><p>Speed: %@</p><p>Range: %@</p><p>Comparable: %@</body></html>",aircraft.acname, aircraft.accost,[aircraft.acpassengers intValue],aircraft.acspeed,aircraft.acrange,aircraft.comparableac] baseURL:nil];
        NSString *costFormatted = [aircraft.accost stringByReplacingOccurrencesOfString:@";" withString:@","];
        
        NSString *rangeFormatted = [aircraft.acrange stringByReplacingOccurrencesOfString:@";" withString:@","];
        
        [info  loadHTMLString:[NSString stringWithFormat:@"<html><body>%@<p>Cost: %@</p><p>Passengers: %@</p><p>Speed: %@</p><p>Range: %@</p><p>Comparable: %@</body></html>",aircraft.acname, costFormatted,aircraft.acpassengers,aircraft.acspeed,rangeFormatted,aircraft.comparableac] baseURL:nil];
                
        self.title = aircraft.acname;
        if([NFDFileSystemHelper fileExist:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],aircraft.detailslink]]){
            details.hidden = NO;
        }else{
            details.hidden = YES;
        }
        
    }
}

- (IBAction) dismissModal {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
@end




