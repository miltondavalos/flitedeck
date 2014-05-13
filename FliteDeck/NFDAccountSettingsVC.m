//
//  NFDAccountSettingsVC.m
//  FliteDeck
//
//  Created by Chad Long on 4/16/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFDAccountSettingsVC.h"
#import <QuartzCore/QuartzCore.h>
#import "NFDUserManager.h"
#import "NFDNetJetsRemoteService.h"
#import "NCLFramework.h"
#import "NCLPhoneNumberFormatter.h"

@implementation NFDAccountSettingsVC

@synthesize label;
@synthesize textField = _textField;
@synthesize passwordLabel;
@synthesize passwordBox;
@synthesize key = _key;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame key:(NSString*)key
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
        //flag = 0;
        [self.view setFrame:frame];
        [self setPreferredContentSize:frame.size];

        [self.textField setDelegate:self];
        [self.passwordBox setDelegate:self];
        
        _key = key;
        [self.label setText:key];
     
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        // setup behavior for the main text field
        if (key == NFDUserSettingsName ||
            key == NFDUserSettingsTitle)
        {
            [_textField setAutocorrectionType:UITextAutocorrectionTypeYes];
            [_textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        }
        
        if (key == NFDUserSettingsName)
        {
            [_textField setSpellCheckingType:UITextSpellCheckingTypeNo];
        }
        
        if (key == NFDUserSettingsEmail)
        {
            [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [_textField setKeyboardType:UIKeyboardTypeEmailAddress];
        }
        
        if (key == NFDUserSettingsPhoneMobile ||
            key == NFDUserSettingsPhoneWork)
        {
            [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [_textField setKeyboardType:UIKeyboardTypePhonePad];
        }

        // the password field is only visible when editing the account settings
        if (key == NFDAccountSettingsUsername)
        {
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(popView)];
            [self.navigationItem setRightBarButtonItem:doneButton];
        }
        else
        {
            [passwordLabel setHidden:YES];
            [passwordBox setHidden:YES];
        }
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

#pragma mark - Edit management

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField != passwordBox)
    {
        NSString *value = [textField text];
        if (self.key == NFDAccountSettingsUsername)
        {
            NSArray *comps = [value componentsSeparatedByString:@"@"];
            value = [comps objectAtIndex:0];
            [textField setText:value];
        }
        [[NFDUserManager sharedManager] setInfo:value forKey:self.key];
    }
    
    if (_key == NFDAccountSettingsUsername)
    {
        NCLUserPassword *userPass = [[NCLUserPassword alloc] initWithUsername:[_textField text] password:[passwordBox text] host:[NFDNetJetsRemoteService sharedInstance].host];
        [NCLKeychainStorage saveUserPassword:userPass error:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (_key != NFDAccountSettingsUsername)
    {
        [self popView];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Device notifications

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setPasswordLabel:nil];
    [self setPasswordBox:nil];
    [self setLabel:nil];
    [self setTextField:nil];
    [super viewDidUnload];
}

@end
