//
//  NFDProspectView.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDProspectView.h"

@implementation NFDProspectView
@synthesize prospect,ptitle,firstName,lastName,email;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *topLevelObjs = nil;
        topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"NFDProspectView" owner:self options:nil];
        [self addSubview: [topLevelObjs objectAtIndex:0]];
        
        NFDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        prospect = (Prospect*)[delegate.session objectForKey:@"currentProspect"];
        ptitle.text = prospect.title;
        firstName.text = prospect.first_name;
        lastName.text = prospect.last_name;
        email.text = prospect.email;
        
    }
    return self;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self updateProspectInformation];
    return YES;
}

-(void) updateProspectInformation {
    prospect.first_name = firstName.text;
    prospect.last_name = lastName.text;
    prospect.email = email.text;
    prospect.title = ptitle.text;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
