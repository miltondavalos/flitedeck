//
//  NFDFlightProposalPDF.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prospect.h"

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NFDPDFView.h"

@class Prospect;

@interface NFDFlightProposalPDF : NFDPDFView <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary *selectedProposals;
@property (nonatomic, strong) Prospect *prospect;
@property (nonatomic, strong) NSDictionary *blueprint;

@end
