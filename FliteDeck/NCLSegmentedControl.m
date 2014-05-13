//
//  NCLSegmentedControll.m
//  FliteDeck
//
//  Created by Jeff Bailey on 12/9/13.
//
//

#import "NCLSegmentedControl.h"

@interface NCLSegmentedControl ()

@property (nonatomic) NSInteger currentIndex;

@end

@implementation NCLSegmentedControl

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentIndex = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.enableSelectingCurrentSegment && self.currentIndex == self.selectedSegmentIndex)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
