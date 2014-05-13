//
//  NFDUserSettingsUserInfoDetailViewController.m
//  FliteDeck
//
//  Created by Ryan Smith on 3/15/12.
//  Copyright (c) 2012 indiePixel Studios. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NFDUserSettingsUserInfoDetailViewController.h"
#import "NFDUserManager.h"

@implementation NFDUserSettingsUserInfoDetailViewController

@synthesize label = _label;
@synthesize textField = _textField;
@synthesize key = _key;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        flag = 0;
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    flag = 0;
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
        [self.view setFrame:frame];
        [self setContentSizeForViewInPopover:frame.size];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, frame.size.width - 40, 20)];
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 45, frame.size.width - 40, 40)];
        
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setFont:[UIFont boldSystemFontOfSize:14]];
        
        [self.textField setBackgroundColor:[UIColor whiteColor]];
        [self.textField setTextColor:[UIColor blackColor]];
        [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.textField setFont:[UIFont systemFontOfSize:18]];
        [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.textField setReturnKeyType:UIReturnKeyDone];
        
        [self.view addSubview:self.label];
        [self.view addSubview:self.textField];
        [self.textField setDelegate:self];
        
        [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.89 green:0.89 blue:0.92 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.82 blue:0.85 alpha:1.0] CGColor], nil];
        [self.view.layer insertSublayer:gradient atIndex:0];
    }
    return self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NFDUserManager sharedManager] setInfo:[textField text] forKey:self.key];
    NSLog(@"key: %@ | value: %@", self.key, [[NFDUserManager sharedManager] objectForKey:self.key]);
    //[self updateTextFields];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}


// Only allow numeric characters in the phone number fields
// Format as you type based on country code for USA or without code

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self.key isEqualToString:NFDUserSettingsPhoneMobile] || [self.key isEqualToString:NFDUserSettingsPhoneWork])
    {
        
        
        int length = [self getLength:textField.text];
        
        NSLog(@"%i", [[textField text] length]);
        NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([string stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]].length != 0)
        {
            
            
            // Checks for first digit entered and set the flag
            if([[textField text] length] == 0){
                if([string isEqualToString:@"1"]){
                    flag = 1;
                }else{
                    flag = 0;
                }
            }
            
            // Format phone no using country code Format => 1 567 876 2134 
            
            if(([[textField text] length] < 14) && (flag ==1)) {
                if(length == 1) {
                
                    if(flag==1)
                    {
                        NSString *num = [self formatNumber:textField.text];
                        textField.text = [NSString stringWithFormat:@"%@ ",num];
                        if(range.length > 0)
                            textField.text = [NSString stringWithFormat:@"%@ ",[num substringToIndex:1]];
      
                    }
                    
                    else {
                        flag = 0;
                    }
                }
                
     
                
                if((length == 4) && flag ==1)
                {
                    NSString *num = [self formatNumber:textField.text];
                    NSLog(@"%@",[num  substringToIndex:1]);
                    NSLog(@"%@",[num substringFromIndex:1]);
                    textField.text = [NSString stringWithFormat:@"%@ %@-",[num substringToIndex:1],[num substringFromIndex:1]];
                    if(range.length > 0)
                        textField.text = [NSString stringWithFormat:@"%@ %@-",[num substringToIndex:1],[num substringFromIndex:1]];
                }
                
                
                
                if((length == 7) && flag==1)
                {
                    NSString *num = [self formatNumber:textField.text];
                    NSLog(@"%@",[num  substringToIndex:1]);
                    NSLog(@"%@",[num substringWithRange:NSMakeRange (1, 3)]);
                    NSLog(@"%@",[num substringFromIndex:4]);

                    textField.text = [NSString stringWithFormat:@"%@ %@-%@-",[num substringToIndex:1],[num substringWithRange:NSMakeRange (1, 3)],[num substringFromIndex:4]];
                    if(range.length > 0)
                        textField.text = [NSString stringWithFormat:@"%@ %@-%@",[num substringToIndex:1], [num substringWithRange:NSMakeRange (1, 3)],[num substringFromIndex:4]];
                }
                
                return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
            }
            
            
            // Format phone no with out using country code Format => 567 876 2134 
            else if(([[textField text] length] < 12) && (flag ==0)) {
                if(length == 3)
                {
                    NSString *num = [self formatNumber:textField.text];
                    textField.text = [NSString stringWithFormat:@"%@-",num];
                    if(range.length > 0)
                        textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
                }
                
                else if(length == 6)
                {
                    NSString *num = [self formatNumber:textField.text];
                    textField.text = [NSString stringWithFormat:@"%@-%@-",[num  substringToIndex:3],[num substringFromIndex:3]];
                    if(range.length > 0)
                        textField.text = [NSString stringWithFormat:@"%@-%@",[num substringToIndex:3],[num substringFromIndex:3]];
                    
                }
                
                
                return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
            }
            
            
         
            else 
            {
                return NO;
            }
            
            
        }  
        
    }
    
    
    return YES;
}





-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];

    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    NSLog(@"mobile no formatted is %@",mobileNumber);
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    return length;
    
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
