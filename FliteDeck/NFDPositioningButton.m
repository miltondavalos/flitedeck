//
//  NFDPositioningButton.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NFDPositioningButton.h"

@implementation NFDPositioningButton
@synthesize warningsContent,aircraft,popover,company;


/*- (void)showInfo {
    
    
    warningsContent = [[NFDPositioningPopupViewController alloc] initWithNibName:@"NFDPositioningPopupViewController" bundle:nil];
    
    warningsContent.warningsLabel.numberOfLines = 7;
    
    CGSize maximumSize = CGSizeMake(400, 300);
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize warningsTextSize = [[self textFromEntity] sizeWithFont:font 
                                      constrainedToSize:maximumSize 
                                          lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect newFrame = CGRectMake(10, 10, warningsTextSize.width, warningsTextSize.height);
    
    int widthWithPadding = warningsTextSize.width + 20;
    int heightWithPadding = warningsTextSize.height + 20;
    
    [warningsContent setContentSizeForViewInPopover:CGSizeMake(widthWithPadding, heightWithPadding)];
    warningsContent.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    warningsContent.warningsLabel.frame = newFrame;
    warningsContent.warningsLabel.text = [self textFromEntity];
    warningsContent.warningsLabel.lineBreakMode = UILineBreakModeWordWrap;
    warningsContent.warningsLabel.adjustsFontSizeToFitWidth = NO;
    
    popover = [[UIPopoverController alloc] initWithContentViewController:warningsContent];
    
   
    
  CGRect popoverRect = popoverRect = CGRectMake(((self.frame.origin.x - (widthWithPadding / 2)) + (self.frame.size.width / 2)),-100, widthWithPadding, heightWithPadding);

        [popover presentPopoverFromRect:popoverRect inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    DLog(@"%f",self.bounds.origin.y);
    
    
}*/


- (void)showInfo {
    if(company != nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayCompanyPopup" object:company];
    }
    
    if(aircraft != nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayAircraftPopup" object:aircraft];
    }
}


-(NSString *) textFromEntity {
    if(company != nil){
        return company.competitive_analysis;
    }
    if(aircraft != nil){
        return [NSString stringWithFormat:@"%@\n Cost: %@\nPassengers: %d\nSpeed: %@\nRange: %@",aircraft.acname, aircraft.accost,[aircraft.acpassengers intValue],aircraft.acspeed,aircraft.acrange];
    }
    return nil;
}
-(void)showWarningsForOrientationChange {
    if (popover.isPopoverVisible) {
        [popover dismissPopoverAnimated:NO];
        [self showInfo];
    }
}

@end
