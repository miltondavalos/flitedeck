//
//  AlternateFBODetailViewController.m
//  FliteDeck
//
//  Created by Chad Long on 6/19/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import "NFDAlternateFBODetailViewController.h"

@interface NFDAlternateFBODetailViewController ()

@end

@implementation NFDAlternateFBODetailViewController
@synthesize fboName;
@synthesize fboPhone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setFboName:nil];
    [self setFboPhone:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
