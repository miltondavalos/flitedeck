//
//  NFDFlightProposalDetailViewController.h
//  SplitViewTest
//
//  Created by Geoffrey Goetz on 2/1/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"
#import "NFDAppDelegate.h"
#import "NFDFlightProposalManager.h"
#import "NFDProposal.h"


@protocol NFDFlightProposalDetailViewControllerOrientationDelegate
- (void)interfaceDidChangeOrientation;
@end

@interface NFDFlightProposalDetailViewController : UIViewController <MGSplitViewControllerDelegate, NFDProposalParameterUpdater, NFDProposalResultUpdater>{

    //Ensures that only one modal displays at a time...
    UINavigationController *modalController;
    UIView *productView;

}

@property(nonatomic, retain) UINavigationController *modalController;
@property (nonatomic, strong) UIBarButtonItem *compareButton;
@property (nonatomic, strong) UIBarButtonItem *aggregateButton;
@property (weak, nonatomic) IBOutlet UIScrollView *productScrollView;

- (void)updateProposalParameterData;
- (void)updateProposalParameterFields;
- (void)displayProductsModalView;
- (void)displayInventoryModalView;

    
@end
