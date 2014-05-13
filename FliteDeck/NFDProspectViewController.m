//
//  NFDProspectViewController.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/12/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDProspectViewController.h"
#import "NFDFileSystemHelper.h"
#import "NFDPhoneNoFormatter.h"
#import "NFDFlightProposalManager.h"
#import "NFDAircraftInventory.h"
#import "NFDFlightProposalCalculatorService.h"
#import "UIView+FrameUtilities.h"

#define MAX_LENGTH_TITLE 10
#define MAX_LENGTH_FIRSTNAME 15
#define MAX_LENGTH_LASTNAME 30
#define MAX_LENGTH_EMAIL 50
#define MAX_LENGTH_ENTITY 50


@implementation NFDProspectViewController
@synthesize preview,flightProposalPDF,flightProfilePDF,message,parameters,prospectView;
@synthesize prospect,ptitle,firstName,lastName,email,entity,selectedProposals,userInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(displayActivity:)]];
        
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModal)];
    
    
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void ) dismissModal {
    //[preview  loadHTMLString:@"<html><body></body></html>" baseURL:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Setting Max length for texfields 
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField.text.length >= MAX_LENGTH_TITLE && range.length == 0 && textField.tag == 0)
    {          
        return NO; // return NO to not change text
    }
    
    if(textField.text.length >= MAX_LENGTH_FIRSTNAME && range.length == 0 && textField.tag == 1)
    {          
        return NO; // return NO to not change text
    }
    
    if(textField.text.length >= MAX_LENGTH_LASTNAME && range.length == 0 && textField.tag == 2)
    {          
        return NO; // return NO to not change text
    }
    
    if (textField.text.length >= MAX_LENGTH_EMAIL && range.length == 0 && textField.tag == 3)
    {          
        return NO; // return NO to not change text
    }
    
    if (textField.text.length >= MAX_LENGTH_ENTITY && range.length == 0 && textField.tag == 4)
    {  
        return NO; // return NO to not change text
    }
    
    return YES;
}


// Dismiss Keyboard

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    [self.view findAndResignFirstResponder];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    preview.delegate= self;
    
    NFDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    prospect = (Prospect*)[delegate.session objectForKey:@"currentProspect"];
    
    ptitle.text = prospect.title;
    firstName.text = prospect.first_name;
    lastName.text = prospect.last_name;
    email.text = prospect.email;
    
    if (!entity.text)
    {
        entity.text = @"";
    }
    
    entity.text = prospect.entity;
    
}

-(void) prepareParameters {
    prospect.first_name = firstName.text;
    prospect.last_name = lastName.text;
    prospect.email = email.text;
    prospect.title = ptitle.text;
    prospect.entity = entity.text;
    userInfo = [[NFDUserManager sharedManager] userInfo];
    
    if(parameters != nil){
        parameters.prospect = prospect;
        parameters.userInfo = [[NFDUserManager sharedManager] userInfo];
    }
    
    
}

-(IBAction) previewDocument: (id) sender {
    
    [self.view findAndResignFirstResponder];
    
    if(parameters != nil){
        [self prepareParameters];
        flightProfilePDF = [[FlightProfileTripEstimatePDF alloc] init];
        flightProfilePDF.parameters = parameters;
        [flightProfilePDF generatePDF];
        [preview  loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:flightProfilePDF.pdfFileName]]];
    }
	
    if(selectedProposals != nil){
        [self prepareParameters];
        flightProposalPDF = [[NFDFlightProposalPDF alloc] init];
        flightProposalPDF.prospect = prospect;
        flightProposalPDF.selectedProposals = selectedProposals;
        [flightProposalPDF generatePDF];
        [preview  loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:flightProposalPDF.pdfFileName]]];
    }
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
	UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle
                                   :UIActivityIndicatorViewStyleGray];
	av.frame=CGRectMake(130, 180, 50, 50);
	av.tag  = 1;
	[preview addSubview:av];
	[av startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
	UIActivityIndicatorView *av = (UIActivityIndicatorView *
                                   )[preview viewWithTag:1];
	[av removeFromSuperview];
    
    self.parentViewController.view.superview.bounds = CGRectMake(0, 0, 750, 750);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
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

#pragma - mark Quick Preview 

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller 
{
    return 1;
}

#pragma mark Compose Mail

-(void) displayActivity: (id) sender {
    
    [self prepareParameters];
    
    if([email.text isValidEmail]) {
        [self previewDocument:nil];
        [self showPicker];
    }else{
        [self alertForEmailValidation];
    }
    
}

// Alert View
- (void)alertForEmailValidation {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Address" message:[NSString stringWithFormat:@" \"%@\" does not appear to be a valid email address. Do you want to send it anyway?", parameters.prospect.email] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0) {
        
        // Do Nothing when cancel button is clicked  - just cancel the alert view
    }
    
    
    if(buttonIndex == 1) {
        
        [self justSendEmail]; 
    }
}

// Send email with no restriction
-(void)justSendEmail {
    
    [self prepareParameters];
    [self previewDocument:nil];
    [self showPicker];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self showPicker];
        
    }
    
}

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
    
    // No formatting of Phone number due to difficulty between formats globally
    NSString *officeNumber = [NSString stringWithFormat:@"Office Number: %@",[userInfo objectForKey:NFDUserSettingsPhoneWork]];
    NSString *cellNumber   = [NSString stringWithFormat:@"Mobile Number: %@",[userInfo objectForKey:NFDUserSettingsPhoneMobile]];
    
    // Setting Email content
    
    NSString *subjectForEmail  = nil;
    
    if([prospect.entity isEqualToString:@""]){
        subjectForEmail = [NSString stringWithFormat:@"NetJets Estimate Prepared for %@ %@", prospect.first_name, prospect.last_name];    
    }else{
        subjectForEmail = [NSString stringWithFormat:@"NetJets Estimate Prepared for %@",prospect.entity]; 
    }
    
    NSString *salutation = nil;
    
    if([prospect.entity isEqualToString:@""] && ![prospect.last_name isEqualToString:@""])
    {
        salutation = [NSString stringWithFormat:@"Dear %@ %@, \n\n",prospect.title, prospect.last_name];     
    }
    else
    {
        salutation = @"To Whom It May Concern,\n\n"; 
    }    
    
    NSString *emailBody = nil;
    NSString *attachmentNoteText = @"";
    
    if(parameters != nil){
        emailBody = @"Please find the attached trip estimate for your review. If you have any questions pertaining to this estimate or why NetJets is the industry leader, please feel free to contact me at your convenience. We look forward to having you onboard.";
    }
    
    if(selectedProposals != nil){
        emailBody = @"Please find the attached proposal for your review. If you have any questions pertaining to this proposal or why NetJets is the industry leader, please feel free to contact me at your convenience. We look forward to having you onboard.";
        
        NSArray *proposals = [[NFDFlightProposalManager sharedInstance] retrieveAllSelectedProposals];
        
//        attachmentNoteText = (proposals.count > 1) ? @"The attached pdf includes estiamtes for the following products:" :
//                                                     @"The attached pdf includes an estimate for the following product:";

        attachmentNoteText = @"Attachment: ";
        
        BOOL firstProposal = YES;
        
        for (NFDProposal *proposal in proposals)
        {
            NSString *productText = @"";
            NSString *aircraftText = @"";
            
            NFDAircraftInventory *aircraftInventory;
            switch (proposal.productCode.intValue) 
            {
                case SHARE_FINANCE_PRODUCT:
                case SHARE_PURCHASE_PRODUCT:
                {
                    aircraftInventory = [[proposal productParameters] objectForKey:@"AircraftInventory"];
                    
                    aircraftText = [NSString stringWithFormat:@"%@ %@", [[proposal unifiedDictionary] objectForKey:@"Year"], [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[aircraftInventory type]]];
                    break;
                }
                case SHARE_LEASE_PRODUCT:
                {
                    aircraftText = [NFDFlightProposalCalculatorService aircraftDisplayNameFromTypeName:[[proposal unifiedDictionary] objectForKey:@"AircraftChoice"]];
                    break;
                }
                case CARD_PRODUCT:
                {
                    aircraftText = [[proposal unifiedDictionary] objectForKey:@"AircraftChoice"];
                    break;
                }
                case COMBO_CARD_PRODUCT:
                {
                    NSString *comboText = [[proposal unifiedDictionary] objectForKey:@"AircraftChoice"];
                    NSArray *aircraftChoices = [comboText componentsSeparatedByString:@"\r"];
                    aircraftText = [NSString stringWithFormat:@"%@ & %@", [aircraftChoices objectAtIndex:0], [aircraftChoices objectAtIndex:1]];
                    break;
                }
                case PHENOM_TRANSITION_LEASE_PRODUCT:
                {
                    aircraftText = @"Citation Excel";
                    break;
                }    
                case PHENOM_TRANSITION_PURCHASE_PRODUCT:
                {
                    aircraftText = @"Phenom 300";
                    break;
                }
                default:
                    break;
            }
            
            switch (proposal.productCode.intValue) 
            {
                case SHARE_FINANCE_PRODUCT:
                    productText = [NSString stringWithFormat:@"%@ Hour Finance %@", [[proposal unifiedDictionary] objectForKey:@"AnnualHours"], aircraftText];
                    break;
                case SHARE_LEASE_PRODUCT:
                    productText = [NSString stringWithFormat:@"%@ Hour %@ Lease %@", [[proposal unifiedDictionary] objectForKey:@"AnnualHours"], [[proposal unifiedDictionary] objectForKey:@"LeaseTerm"], aircraftText];
                    break;
                case SHARE_PURCHASE_PRODUCT:
                    productText = [NSString stringWithFormat:@"%@ Hour Purchase %@", [[proposal unifiedDictionary] objectForKey:@"AnnualHours"], aircraftText];
//                    productText = [NSString stringWithFormat:@"%@ Hours %@ Share", [[proposal unifiedDictionary] objectForKey:@"AnnualHours"], aircraftText];
                    break;
                case CARD_PRODUCT:
                    if ([[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue] > 1)
                    {
                        productText = [NSString stringWithFormat:@"(%i) %@s %@", [[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue], [[proposal unifiedDictionary] objectForKey:@"CardHours"], aircraftText];
                    }
                    else 
                    {
                        productText = [NSString stringWithFormat:@"%@ %@ ", [[proposal unifiedDictionary] objectForKey:@"CardHours"], aircraftText];
                    }
//                    if ([[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue] > 1)
//                    {
//                        productText = [NSString stringWithFormat:@"(%i) %@ Cards", [[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue], aircraftText];
//                    }
//                    else 
//                    {
//                        productText = [NSString stringWithFormat:@"(1) %@ Card", [[proposal unifiedDictionary] objectForKey:@"CardHours"], aircraftText];
//                    }
                    break;
                case COMBO_CARD_PRODUCT:
                    if ([[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue] > 1)
                    {
                        productText = [NSString stringWithFormat:@"(%i) 25 Hour Combo Cards %@", [[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue], aircraftText];
                    }
                    else 
                    {
                        productText = [NSString stringWithFormat:@"25 Hour Combo Card %@", aircraftText];
                    }
//                    if ([[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue] > 1)
//                    {
//                        productText = [NSString stringWithFormat:@"(%i) %@ Cards", [[[proposal unifiedDictionary] objectForKey:@"NumberOfCards"] intValue], aircraftText];
//                    }
//                    else 
//                    {
//                        productText = [NSString stringWithFormat:@"(1) %@ Card", [[proposal unifiedDictionary] objectForKey:@"CardHours"], aircraftText];
//                    }
                    break;
                case PHENOM_TRANSITION_LEASE_PRODUCT:
                    productText = [NSString stringWithFormat:@"%@ Hour Phenom Transition", [[proposal unifiedDictionary] objectForKey:@"AnnualHours"]];
                    break;

                    break;
                default:
                    break;
            }
            
            if (!firstProposal && ![productText isEqualToString:@""])
            {
                productText = [NSString stringWithFormat:@"• %@", productText];
            }
            
            attachmentNoteText = [NSString stringWithFormat:@"%@ %@", attachmentNoteText, productText];
            
            firstProposal = NO;
        }
        
        if ([[NFDFlightProposalManager sharedInstance] aggregated])
        {
            attachmentNoteText = [NSString stringWithFormat:@"%@ • Aggregated", attachmentNoteText];
        }
    }
    
    NSString *valediction = [NSString stringWithFormat:@"\n \n Regards, \n\n%@ \n%@ \n%@ \n%@", [userInfo objectForKey:NFDUserSettingsName], [userInfo objectForKey:NFDUserSettingsTitle], officeNumber, cellNumber];
    
    NSString *emailText = [NSString stringWithFormat:@" %@ %@ %@ \n\n %@", salutation, emailBody, valediction, attachmentNoteText];
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
	[picker setSubject:subjectForEmail];
	    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:prospect.email];
    
	[picker setToRecipients:toRecipients];
    
    NSString *salesEmail = [[NFDUserManager sharedManager] email];
    if (salesEmail && ![salesEmail  isEqual: @""])
    {
        [picker setCcRecipients:[NSArray arrayWithObject:salesEmail]];
    }
    [picker setBccRecipients:[NSArray arrayWithObject:@"proposals@netjets.com"]];
	// Attach a pdf to the email
	
    NSData *myData = nil;
    
    if(parameters != nil){
        myData = [NSData dataWithContentsOfFile:flightProfilePDF.pdfFileName];
        [picker addAttachmentData:myData mimeType:@"application/pdf" fileName:@"TripEstimation.pdf"];
    }
    
    if(selectedProposals != nil){
        myData = [NSData dataWithContentsOfFile:flightProposalPDF.pdfFileName];
        [picker addAttachmentData:myData mimeType:@"application/pdf" fileName:@"NetJetsProposal.pdf"];
    }    
	
	// Fill out the email body text
	[picker setMessageBody:emailText isHTML:NO];
    //[picker setEditing:NO];
	
    [self presentViewController:picker animated:YES completion:nil];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			//message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			//message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			//message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message.text = @"Email failed to send";
			break;
		default:
			message.text = @"Email failed to send";
			break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    
    NSString *recipients = @"mailto:test@compuware.com&subject=NetJets Estimation Pdf Attached!";
	NSString *body = @"&body= Check the attachment";
	
	NSString *emailadd = [NSString stringWithFormat:@"%@%@", recipients, body];
	emailadd = [emailadd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailadd]];
}
@end
