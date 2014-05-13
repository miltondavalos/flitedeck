//
//  NFDProspectViewController.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prospect.h"
#import <QuickLook/QuickLook.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FlightProfileTripEstimatePDF.h"
#import "NFDFlightProposalPDF.h"
#import "FlightEstimatorData.h"
#import "NFDUserManager.h"
#import "NFDProspectView.h"
#import "NFDProposal.h"
#import "NCLFramework.h"

@interface NFDProspectViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *message;
@property (nonatomic,strong) IBOutlet UIWebView *preview;
@property (nonatomic, strong) IBOutlet NFDProspectView *prospectView;

@property (nonatomic, strong) FlightProfileTripEstimatePDF *flightProfilePDF;
@property (nonatomic, strong) NFDFlightProposalPDF *flightProposalPDF;
@property (nonatomic, weak) FlightEstimatorData *parameters;
@property (nonatomic, weak) NSMutableDictionary *selectedProposals;

@property (nonatomic,strong) IBOutlet UITextField *ptitle;
@property (nonatomic,strong) IBOutlet UITextField *firstName;
@property (nonatomic,strong) IBOutlet UITextField *lastName;
@property (nonatomic,strong) IBOutlet UITextField *email;
@property (nonatomic,strong) IBOutlet UITextField *entity;
@property (nonatomic,strong) Prospect *prospect;
@property (nonatomic,strong) NSDictionary *userInfo;


-(void) prepareParameters;
-(void)launchMailAppOnDevice;
-(void)displayComposerSheet ;
-(void)showPicker;
-(IBAction) previewDocument: (id) sender;
-(void)justSendEmail;
-(void)alertForEmailValidation;

@end
