//
//  NFDFlightProposalProductsModalController.h
//  SampleDropDown
//
//  Created by Geoffrey Goetz on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDFlightProposalManager.h"
#import "NFDNetJetsStyleHelper.h"
#import "NFDProposal.h"
#import "iCarousel.h"

@interface NFDFlightProposalProductsModalController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *productsCarousel;

- (void)selectedProduct:(UITapGestureRecognizer *)gestureRecognizer;

@end
