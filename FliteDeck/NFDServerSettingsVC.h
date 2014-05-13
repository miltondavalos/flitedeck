//
//  NFDServerSettings.h
//  FliteDeck
//
//  Created by Ryan Smith on 6/21/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDServerSettingsVC : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *serverAddressField;

- (id)initWithFrame:(CGRect)frame;

@end
