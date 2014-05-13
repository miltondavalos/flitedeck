//
//  NFDProspectView.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prospect.h"
#import "NFDAppDelegate.h"

@interface NFDProspectView : UIView <UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UITextField *ptitle;
@property (nonatomic,strong) IBOutlet UITextField *firstName;
@property (nonatomic,strong) IBOutlet UITextField *lastName;
@property (nonatomic,strong) IBOutlet UITextField *email;
@property (nonatomic,strong) Prospect *prospect;

-(void) updateProspectInformation;
@end
