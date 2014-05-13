//
//  NFDUserSettingsUserInfoDetailViewController.h
//  FliteDeck
//
//  Created by Ryan Smith on 3/15/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDUserSettingsUserInfoDetailViewController : UIViewController <UITextFieldDelegate> {
    
    int flag;
}

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSString *key;

- (id)initWithFrame:(CGRect)frame;
-(int)getLength:(NSString*)mobileNumber;
-(NSString*)formatNumber:(NSString*)mobileNumber;
@end
