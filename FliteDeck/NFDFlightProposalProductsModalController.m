//
//  NFDFlightProposalProductsModalController.m
//  SampleDropDown
//
//  Created by Geoffrey Goetz on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDFlightProposalProductsModalController.h"
#import "UIColor+FliteDeckColors.h"

@implementation NFDFlightProposalProductsModalController
@synthesize productsCarousel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    //[NFDNetJetsStyleHelper applyPageBackgroundsGradient:NFDGradientBlueToDarkBlue forView:self.view];
    
    self.view.backgroundColor = [UIColor modalBackgroundColor];
    
    productsCarousel.type = iCarouselTypeCoverFlow;
    [productsCarousel scrollToItemAtIndex:2 animated:NO];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedProduct:)];
    [tapper setNumberOfTapsRequired:3];
    [tapper setNumberOfTouchesRequired:2];
    [self.view setTag:6];
    [self.view addGestureRecognizer:tapper];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor = [UIColor modalNavigationBarTintColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidUnload {
    [self setProductsCarousel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Gesture Recognizer for Product Selection

- (void)selectedProduct:(UITapGestureRecognizer *)gestureRecognizer
{
    NFDFlightProposalManager *manager = NFDFlightProposalManager.sharedInstance;
    NFDProposal *proposal = [NFDFlightProposalManager createNewProposalForProduct:gestureRecognizer.view.tag];
    NFDProposal *relatedProposal;
    
    if (proposal.productCode.intValue == PHENOM_TRANSITION_LEASE_PRODUCT)
    {
        relatedProposal = [NFDFlightProposalManager createNewProposalForProduct:PHENOM_TRANSITION_PURCHASE_PRODUCT];
        [proposal setRelatedProposal:relatedProposal];
    }   
    [manager.proposals addObject:proposal];
    if (relatedProposal)
    {
        if ([manager totalCountOfSelectedProposals] < MAX_SELECTED_PROPOSALS-1)
        {        
            [proposal setSelected:YES];
            [manager.selectedProposals setObject:proposal forKey:[NSNumber numberWithInt:([manager totalCountOfProposals] - 1)]];
            [relatedProposal setSelected:YES];        
            [manager.selectedProposals setObject:relatedProposal forKey:[NSNumber numberWithInt:-1*([manager totalCountOfProposals] + 1)]];
        }
        else
        {
            [proposal setSelected:NO];
            [relatedProposal setSelected:NO];
        }
    }
    else 
    {
        if ([manager totalCountOfSelectedProposals] < MAX_SELECTED_PROPOSALS)
        {        
            [proposal setSelected:YES];
            [manager.selectedProposals setObject:proposal forKey:[NSNumber numberWithInt:([manager totalCountOfProposals] - 1)]];
        }
        else
        {
            [proposal setSelected:NO];
        }
    }


    
    [[NSNotificationCenter defaultCenter] postNotificationName:PROPOSAL_LIST_UPDATED object:self];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - iCarouselDataSource and iCarouselDelegate methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 6;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return 6;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	UILabel *label = nil;
    UILabel *bottomLabel = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NJ_Proposal_Calculator_Product_Icon_Background.png"]];
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, view.frame.size.width, 90)];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:110];
		[view addSubview:label];
        
        bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, view.frame.size.width, 70)];
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textAlignment = NSTextAlignmentCenter;
		bottomLabel.font = [bottomLabel.font fontWithSize:20];
		[view addSubview:bottomLabel];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //Add single tap gesture to view
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedProduct:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [singleTapGesture setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:singleTapGesture];
    [view setUserInteractionEnabled:YES];

    //set label
    switch (((int)index)) {
        case 0:
            label.text = @"F";
            bottomLabel.text = @"Finance";
            [view setTag:SHARE_FINANCE_PRODUCT];
            break;
        case 1:
            label.text = @"P";
            bottomLabel.text = @"Purchase";
            [view setTag:SHARE_PURCHASE_PRODUCT];
            break;
        case 2:
            label.text = @"L";
            bottomLabel.text = @"Lease";
            [view setTag:SHARE_LEASE_PRODUCT];
            break;
        case 3:
            label.text = @"C";
            bottomLabel.text = @"Card";
            [view setTag:CARD_PRODUCT];
            break;
        case 4:
            label.text = @"CC";
            bottomLabel.text = @"Combo Card";
            [view setTag:COMBO_CARD_PRODUCT];
            break;
        case 5:
            label.text = @"PT";
            bottomLabel.text = @"Phenom Transition";
            [view setTag:PHENOM_TRANSITION_LEASE_PRODUCT];
            break;
        default:
            label.text = @"UN";
            bottomLabel.text = @"Unknown";
            [view setTag:0];
            break;
    }
	
	return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed on some carousels if wrapping is disabled
	return 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	UILabel *label = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NJ_Proposal_Calculator_Product_Icon_Background.png"]];
		label = [[UILabel alloc] initWithFrame:view.bounds];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [label.font fontWithSize:50.0f];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //set label
	label.text = (index == 0)? @"[": @"]";
	
	return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return 210.0f;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * productsCarousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return NO;
}

@end
