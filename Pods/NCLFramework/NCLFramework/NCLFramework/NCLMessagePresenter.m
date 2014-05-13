//
//  NCLInfoPresenter.m
//  NCLFramework
//
//  Created by Chad Long on 8/29/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "NCLMessagePresenter.h"
#import "NCLFramework.h"
#import "NCLAppOverlayWindow.h"
#import "NCLMessageView.h"
#import "NCLMessage.h"

@interface NCLMessagePresenter()

@property (nonatomic, strong) NSMutableDictionary *messageStack;
@property (nonatomic) SystemSoundID alertSound;

@end

@implementation NCLMessagePresenter

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0.55 green:0.65 blue:0.8 alpha:1];
        self.textColor = [UIColor blackColor];
        self.messageStack = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)registerSoundNamed:(NSString*)name
{
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)name, CFSTR("aif"), NULL);
    AudioServicesCreateSystemSoundID(soundFileURLRef, &_alertSound);
}

- (void)pushViewWithMessage:(NCLMessage*)message
{
    if (message.text == nil)
        return;
    
    dispatch_async
    (
     dispatch_get_main_queue(), ^
     {
         @synchronized(self)
         {
             UIView *blockParentView = message.parentView;
             BOOL useMessageStack = NO;
             
             // use the UIWindow by default
             if (blockParentView == nil)
             {
                 useMessageStack = YES;
             }
             
             blockParentView = [self determineParentView:blockParentView];

             if (!useMessageStack ||
                 (self.messageStack.count < 4 && [self.messageStack objectForKey:message.text] == nil))
             {
                 // create the message view
                 DEBUGLog(@"creating NCLMessageView in parent %@ for text... %@", NSStringFromClass([blockParentView class]), message.text);
                 
                 __block NCLMessageView *msgView = [[NCLMessageView alloc] init];
                 msgView.delegate = self;
                 msgView.backgroundColor = self.backgroundColor;
                 msgView.textLabel.font = self.font;
                 msgView.textLabel.text = message.text;
                 [msgView setHidden:YES];
                 [blockParentView addSubview:msgView];
                 
                 [self.messageStack setObject:msgView forKey:message.text];
                 
                 // position the message view in it's parent
                 [blockParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[msgView]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(msgView)]];
                 
                 NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:msgView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:blockParentView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1
                                                                                      constant:0];
                 
                 [blockParentView addConstraint:bottomConstraint];
                 [blockParentView layoutIfNeeded];

                 DEBUGLog(@"NCLMessageView frame destination is %f:%f:%f:%f", msgView.frame.origin.x, msgView.frame.origin.y, msgView.frame.size.width, msgView.frame.size.height);

                 // play sound if registered
                 if (message.playSound &&
                     _alertSound)
                 {
                     AudioServicesPlayAlertSound(_alertSound);
                 }
                 
                 // animate the message view into the viewable region
                 bottomConstraint.constant = msgView.frame.size.height;
                 [blockParentView layoutIfNeeded];
                 [msgView setHidden:NO];
                 
                 [UIView animateWithDuration:.35
                                  animations:^
                  {
                      bottomConstraint.constant = 0;
                      [blockParentView layoutIfNeeded];
                  }];
             }
         }
     });
}

- (void)popViewWithText:(NSString *)text
{
    dispatch_async
    (
     dispatch_get_main_queue(), ^
     {
         @synchronized(self)
         {
             UIView *messageView = (UIView*)[self.messageStack objectForKey:text];
             
             if (messageView)
             {
                 [self.messageStack removeObjectForKey:text];
             }
         }
     });
}

- (void) removeAllPresenters: (UIView *) parentView
{    
    parentView = [self determineParentView:parentView];
    
    for (UIView *currentView in parentView.subviews) {
        if ([currentView isMemberOfClass:[NCLMessageView class]]) {
            [currentView removeFromSuperview];
        }
    }
}

- (UIView *) determineParentView:(UIView *)parentView
{
    // table views do not like the message view being added to it as a subview
    while (parentView != nil &&
           [parentView isMemberOfClass:[UITableView class]])
    {
        parentView = [parentView superview];
    }
    
    if (parentView == nil) {
        parentView = [NCLAppOverlayWindow view];
    }
    
    return parentView;
}

@end
