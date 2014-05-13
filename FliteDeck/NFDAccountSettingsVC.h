//
//  NFDAccountSettingsVC.h
//  FliteDeck
//
//  Created by Chad Long on 4/16/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDAccountSettingsVC : UIViewController <UITextFieldDelegate> {
    
    int flag;
}

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordBox;
@property (strong, nonatomic) NSString *key;

- (id)initWithFrame:(CGRect)frame key:(NSString*)key;
- (void)textFieldDidEndEditing:(UITextField*)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)popView;

@end
