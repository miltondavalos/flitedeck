//
//  NFDPDFViewController.h
//  FliteDeck
//
//  Created by Chad Predovich on 3/14/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "NFDEventsService.h"

@interface NFDPDFViewControllerComponent : UIViewController <ReaderViewControllerDelegate> {
    ReaderViewController *readerViewController;
    NSString *phrase;
    NSArray *pdfs;
    NSString *newEventID;
    NSString *eventTitle;
    NFDEventsService *service;
    NSArray *events;
}

- (void)loadPDF:(NSString *)filePath;
- (void)newEventSelected:(NSNotification *)notification;
- (void)getPathAndLoadPDF:(NSString *)eventID;

@end
