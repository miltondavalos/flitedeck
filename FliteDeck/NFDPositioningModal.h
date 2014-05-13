//
//  NFDPositioningModal.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDCompany.h"
#import "NFDPositioningMatrix.h"
#import "ReaderViewController.h"

@interface NFDPositioningModal : UIViewController <ReaderViewControllerDelegate>
{
    
    // IBOutlet UITextView *info;
    // IBOutlet UIWebView *text;
    IBOutlet UIWebView *info;
}
//@property (nonatomic,strong) IBOutlet UITextView *info;
@property (nonatomic,strong) NFDCompany *company;
@property (nonatomic,strong) NFDPositioningMatrix *aircraft;
@property (nonatomic,strong) IBOutlet UIButton *details;
//@property (nonatomic,strong) IBOutlet UIWebView *text;
@property (nonatomic,strong) IBOutlet UIWebView *info;

-(void) displayInfo;
- (IBAction) dismissModal;
-(IBAction) displayPDF : (id) sender;

@end
