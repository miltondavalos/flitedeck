//
//  NFDServerSettings.m
//  FliteDeck
//
//  Created by Ryan Smith on 6/21/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import "NFDServerSettingsVC.h"
#import <QuartzCore/QuartzCore.h>
#import "NFDNetJetsRemoteService.h"
#import "UIColor+FliteDeckColors.h"

#define PROD_SERVER_BUTTON 1
#define QA_SERVER_BUTTON 2
#define ITG_SERVER_BUTTON 3

@implementation NFDServerSettingsVC

@synthesize serverAddressField = _serverAddressField;


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
        self.view.frame = frame;
        [self setPreferredContentSize:frame.size];
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        UIButton *prodButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [prodButton setTitle:@"Production" forState:UIControlStateNormal];
        [prodButton setFrame:CGRectMake(20, 40, frame.size.width-40, 40)];
        [prodButton setTag:PROD_SERVER_BUTTON];
        
        UIButton *qaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [qaButton setTitle:@"QA" forState:UIControlStateNormal];
        [qaButton setFrame:CGRectMake(20, 100, frame.size.width-40, 40)];
        [qaButton setTag:QA_SERVER_BUTTON];
        
        UIButton *itgButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [itgButton setTitle:@"ITG" forState:UIControlStateNormal];
        [itgButton setFrame:CGRectMake(20, 160, frame.size.width-40, 40)];
        [itgButton setTag:ITG_SERVER_BUTTON];
        
        [self styleButtons:@[prodButton, qaButton, itgButton]];
        
        [self.view addSubview:prodButton];
        [self.view addSubview:qaButton];
        [self.view addSubview:itgButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, frame.size.width-40, 20)];
        [label setText:@"Server address"];
        [label setTextColor:[UIColor darkGrayColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:label];
        
        self.serverAddressField = [[UITextField alloc] initWithFrame:CGRectMake(20, 260, frame.size.width-40, 28)];
        [self.serverAddressField setDelegate:self];
        [self.serverAddressField setText:[[NFDNetJetsRemoteService sharedInstance] host]];
        [self.serverAddressField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.serverAddressField setBackgroundColor:[UIColor whiteColor]];
        [self.serverAddressField setReturnKeyType:UIReturnKeyDone];
        [self.view addSubview:self.serverAddressField];
        
    }
    return self;
}

- (void)styleButtons:(NSArray *)buttons
{
    for (UIButton *button in buttons) {
        button.layer.cornerRadius = 4.0;
        
        button.backgroundColor = [UIColor buttonBackgroundColorEnabled];
        
        [button setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor buttonTitleColorEnabled] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor buttonTitleColorDisabled] forState:UIControlStateDisabled];
        
        [button addTarget:self action:@selector(selectPresetServerAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)selectPresetServerAddress:(id)sender
{
    switch ([(UIButton *)sender tag]) {
        case PROD_SERVER_BUTTON:
            [[NFDNetJetsRemoteService sharedInstance] setServicesHost:BASE_SERVICES_HOST_FOR_PRODUCTION];
            break;
        case QA_SERVER_BUTTON:
            [[NFDNetJetsRemoteService sharedInstance] setServicesHost:BASE_SERVICES_HOST_FOR_QA];
            break;
        case ITG_SERVER_BUTTON:
            [[NFDNetJetsRemoteService sharedInstance] setServicesHost:BASE_SERVICES_HOST_FOR_ITG];
            break;
        default:
            break;
    }
    [self.serverAddressField setText:[[NFDNetJetsRemoteService sharedInstance] host]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NFDNetJetsRemoteService sharedInstance] setServicesHost:[textField text]];
    DLog(@"server address updated");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
