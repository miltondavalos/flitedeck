//
//  NFDFlightProposalCompareViewController.h
//  ProposalCalculatorPrototype
//
//  Created by Geoffrey Goetz on 3/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDCompareLeftColumn.h"
#import "NFDProspectViewController.h"
#import "NFDProposal.h"

#define MIN_COLUMN_WIDTH 152
#define ROW_LABEL_COLUMN_WIDTH 220
#define FIRST_ROW_Y 80

#define NORMAL_TEXT_COLOR [UIColor colorWithWhite:0 alpha:1.0]
//#define HEADING_TEXT_COLOR [UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:1.0]
#define HEADING_TEXT_COLOR [UIColor colorWithRed:0 green:0.165 blue:0.361 alpha:1.0]
#define COLUMN_FOOTER_TEXT_COLOR [UIColor colorWithWhite:0.315 alpha:1.000];

#define TRANS_COLOR [UIColor clearColor]
#define NORMAL_TEXT_FONT [UIFont fontWithName:@"Helvetica" size:11.0]
#define AIRCRAFT_TEXT_FONT [UIFont fontWithName:@"Helvetica" size:11.0]
#define HEADING_TEXT_FONT [UIFont fontWithName:@"Helvetica-Bold" size:11.0]
#define PRODUCT_HEADING_FONT [UIFont fontWithName:@"Helvetica-Bold" size:11.0]
#define ROW_LABEL_FONT [UIFont fontWithName:@"Helvetica" size:11.0]
#define COLUMN_FOOTER_FONT [UIFont fontWithName:@"Helvetica" size:10.0]

#define ROW_HEIGHT 16
#define LABEL_HEIGHT 14

typedef enum 
{
    kCompareViewBackgroundImageView = 9001,
    kCompareViewLogoImageView,
} kCompareViewTag;

@interface NFDFlightProposalCompareViewController : UIViewController {
    BOOL shouldShowPricingLabel;
    BOOL shouldShowIncentivesLabel;
}

@property (nonatomic, strong) UINavigationController *modalController;
@property (nonatomic, strong) NFDProspectViewController *prospectModalViewController;
@property (nonatomic, strong) NSArray *proposalSections;
@property (nonatomic, strong) NSDictionary *sectionDefinitions;
@property (nonatomic, strong) NSDictionary *rowDefinitions;
@property (nonatomic, strong) NSMutableArray *proposalColumns;
@property (nonatomic, strong) UIView *rowLabelView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (readwrite, assign) float columnWidth;
@property (readwrite, assign) float columnHeight;
@property (readwrite, assign) float firstColumnX;
@property (readwrite, assign) float paddingX;
@property (readwrite, assign) int numberOfProposals;
@property (readwrite, assign) int numberOfColumns;
@property (readwrite, assign) BOOL aggregate;
@property (readwrite, assign) float rowHeight;
@property (readwrite, assign) float labelHeight;
@property (nonatomic, strong) NSMutableDictionary *blueprint;
@property (readwrite, assign) BOOL hasFET;

- (void)setupBackground;
- (void)setupLogo;
- (void)setupSections;
- (void)setupScrollView;
- (void)shadeColumns;
- (void)setupProposals;
- (void)updateColumnHeadings;
- (void)updateRowDisplay;
- (NSArray *)retrieveAllSelectedProposalsForThisView;
- (void)parseThis:(id)thing atLevel:(int)level withParentHash:(NSInteger)hash;

@end
