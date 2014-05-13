//
//  NFDAircraftTile.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/24/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDAircraftTile.h"
#import "AircraftButton.h"
#import "NFDFlightProfileEstimator.h"
#import "NFDFlightProfileManager.h"


#define LABEL_HEIGHT 22

// Button Tags
#define RUNWAY_BUTTON 0
#define PAX_BUTTON 1
#define FUEL_BUTTON 2
#define AC_BUTTON 3

@implementation NFDAircraftTile
@synthesize aircraft,position,background,label,selected,checked,hilite,belongs;

@synthesize runwayWarningButton;
@synthesize paxWarningButton;
@synthesize fuelStopButton;
@synthesize acNotAvailableButton;
@synthesize warningsContent;
@synthesize popover;
@synthesize warningsArray;
@synthesize runwayWarning;
@synthesize paxWarning;
@synthesize fuelStopWarning;
@synthesize acNotAvailableWarning;
@synthesize aircraftType;

#pragma mark - Setup

- (id)initWithCoder:(NSCoder*)coder {
    
    self = [super initWithCoder: coder ];
    if (self) { 
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    CGRect imageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-LABEL_HEIGHT);
    background = [[UIImageView alloc] initWithFrame:imageFrame];
    [background setContentMode:UIViewContentModeScaleAspectFill];
    [background setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview: background];
    
    checked= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
    checked.frame = CGRectMake((self.frame.size.width- 33), (self.frame.size.height - 33 -LABEL_HEIGHT), 24, 24);
    [checked setAlpha:0];
    [self addSubview:checked];
    
    runwayWarningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    runwayWarningButton.tag = RUNWAY_BUTTON;
    runwayWarningButton.frame = CGRectMake((self.frame.size.width- (2 * 37)), (self.frame.size.height - 37 -LABEL_HEIGHT), 31, 31);
    [runwayWarningButton setImage:[UIImage imageNamed:@"NJ_Flight_Profiles_Validation_RunwayLength.png"] forState:UIControlStateNormal];
    [runwayWarningButton addTarget:self action:@selector(showWarnings:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:runwayWarningButton];
    
    paxWarningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    paxWarningButton.tag = PAX_BUTTON;
    paxWarningButton.frame = CGRectMake((self.frame.size.width - (3 * 37)), (self.frame.size.height - 37-LABEL_HEIGHT), 31, 31);
    [paxWarningButton setImage:[UIImage imageNamed:@"NJ_Flight_Profiles_Validation_PassengerCapacity.png"] forState:UIControlStateNormal];
    [paxWarningButton addTarget:self action:@selector(showWarnings:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:paxWarningButton];
    
    fuelStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fuelStopButton.tag = FUEL_BUTTON;
    fuelStopButton.frame = CGRectMake((self.frame.size.width - (4 * 37)), (self.frame.size.height - 37-LABEL_HEIGHT), 31, 31);
    [fuelStopButton setImage:[UIImage imageNamed:@"NJ_Flight_Profiles_Validation_FuelStopRequired.png"] forState:UIControlStateNormal];
    [fuelStopButton addTarget:self action:@selector(showWarnings:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fuelStopButton];
    
    acNotAvailableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    acNotAvailableButton.tag = AC_BUTTON;
    acNotAvailableButton.frame = CGRectMake((self.frame.size.width - (5 * 37)), (self.frame.size.height - 37-LABEL_HEIGHT), 31, 31);
    [acNotAvailableButton setImage:[UIImage imageNamed:@"NJ_Flight_Profiles_Validation_AircraftnotAvailable.png"] forState:UIControlStateNormal];
    [acNotAvailableButton addTarget:self action:@selector(showWarnings:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acNotAvailableButton];
    
    [self hideWarningButtons];
    
    hilite = [[UIImageView alloc] initWithFrame:self.bounds];
    hilite.image = [UIImage imageNamed:@"hilite.png"];
    [self addSubview: hilite];
    hilite.alpha = 0;
    
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(0,imageFrame.size.height,self.frame.size.width,LABEL_HEIGHT);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [self addSubview: label];
    //[self setUpGestures:nil];
    selected = NO;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggle:) name:@"selectedOnMoneyShot" object:nil];
}

#pragma mark - Setting the tile's Aircraft

- (void)setData:(NFDAircraftTypeGroup *)ac {
    self.aircraft = ac;
    label.text = ac.typeGroupName;
    NSString *name = [NSString stringWithFormat:@"%@_default.png", ac.acPerformanceTypeName];
    background.image = [UIImage imageNamed:name];
    if(background.image == nil){
        DLog(@"Image null %@",name);
    }
    selected = NO;
    checked.alpha = 0;
    [self.aircraft clearWarnings];
    [self hideWarningButtons];
}

#pragma mark - Warning Button Management

- (void)enableWarningButtons {
    runwayWarningButton.enabled = YES;
    paxWarningButton.enabled = YES;
    fuelStopButton.enabled = YES;
    acNotAvailableButton.enabled = YES;
}

- (void)disableWarningButtons {
    runwayWarningButton.enabled = NO;
    paxWarningButton.enabled = NO;
    fuelStopButton.enabled = NO;
    acNotAvailableButton.enabled = NO;
}

- (void)hideWarningButtons {
    runwayWarningButton.hidden = YES;
    paxWarningButton.hidden = YES;
    fuelStopButton.hidden = YES;
    acNotAvailableButton.hidden = YES;
}

-(void) dealloc{
    //[[NSNotificationCenter defaultCenter] removeObserver:self  name:@"selectedOnMoneyShot" object:nil];
}
#pragma mark - Warning Messages

- (void)showWarnings:(id)sender {
    warningsButton = (UIButton *)sender;
    
    NSString *popoverText;
    switch (warningsButton.tag) {
        case RUNWAY_BUTTON:
            popoverText = runwayWarning;
            break;
        case PAX_BUTTON:
            popoverText = paxWarning;
            break;
        case FUEL_BUTTON:
            popoverText = fuelStopWarning;
            break;
        case AC_BUTTON:
            popoverText = acNotAvailableWarning;
            break;
        default:
            popoverText = @"No warnings available";
            break;
    }

    warningsContent = [[NFDAircraftWarningMessageViewController alloc] initWithNibName:@"NFDAircraftWarningMessageViewController" bundle:nil];
    
    static UILabel *tempLabel;
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    tempLabel.text = popoverText;
    tempLabel.numberOfLines = 0;
    tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tempLabel.adjustsFontSizeToFitWidth = NO;
    [tempLabel sizeToFit];
    
    CGFloat widthWithPadding = tempLabel.frame.size.width + 20;
    CGFloat heightWithPadding = tempLabel.frame.size.height + 20;
    
    [warningsContent setPreferredContentSize:CGSizeMake(widthWithPadding, heightWithPadding)];
    warningsContent.view.backgroundColor = [UIColor darkGrayColor];
    
    warningsContent.warningsLabel.frame = CGRectMake(10, 10, tempLabel.frame.size.width, tempLabel.frame.size.height);
    warningsContent.warningsLabel.text = popoverText;
    warningsContent.warningsLabel.numberOfLines = 0;
    warningsContent.warningsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    warningsContent.warningsLabel.adjustsFontSizeToFitWidth = NO;
    [warningsContent.warningsLabel sizeToFit];
    
    CGRect popoverRect = CGRectMake(((warningsButton.frame.origin.x - (widthWithPadding / 2)) + (warningsButton.frame.size.width / 2)), warningsButton.frame.origin.y, widthWithPadding, heightWithPadding);
    
    popover = [[UIPopoverController alloc] initWithContentViewController:warningsContent];
    popover.contentViewController.edgesForExtendedLayout = UIRectEdgeNone;
    [popover presentPopoverFromRect:popoverRect inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

-(void)showWarningsForOrientationChange {
    if (popover.isPopoverVisible) {
        [popover dismissPopoverAnimated:NO];
        [self showWarnings:warningsButton];
    }
}

/*- (NSArray*)getWarningMessagesArray {
    NSArray *warningsTempArray = [NSMutableArray array];
    
    NFDFlightProfileEstimator *est = [[NFDFlightProfileManager sharedInstance] estimator];
    AircraftType *type = [est aircraftTypeForTypeName:aircraft.typeName];
    NSString *warnings = [type warnings];
    
    warningsTempArray = [warnings componentsSeparatedByString:@", "];

    return warningsTempArray;
}*/

- (void)toggleWarnings {
    [self hideWarningButtons];
    
    
    for (NSString *warningString in aircraft.warnings) {
        if([warningString contains:@"Runway"]){
            runwayWarning = warningString;
            runwayWarningButton.hidden = NO;
        }
        if([warningString contains:@"Exceeds"]){
            paxWarning = warningString;
            paxWarningButton.hidden = NO;
        }
        if([warningString contains:@"Fuel"]){
            fuelStopWarning = warningString;
            fuelStopButton.hidden = NO;
        }
        if([warningString contains:@"Not Available"]){
            acNotAvailableWarning = warningString;
            acNotAvailableButton.hidden = NO;
        }
    }
}

#pragma mark - Toggle Checkmark

-(void)toggle:(NSNotification *)notification {
    NFDAircraftTypeGroup *actype = [notification object];
    if([actype.acPerformanceTypeName isEqualToString:aircraft.acPerformanceTypeName]){
        [self toggleCheck:YES];
    }
}

-(void)toggleCheck:(BOOL)canSelectMore {
    if(selected){
        selected = NO;
        checked.alpha = 0;
        [self.aircraft clearWarnings];
        [self hideWarningButtons];
        /*[[NSNotificationCenter defaultCenter] 
         postNotificationName:@"uncheckedAircraft" 
         object:aircraft];*/
    }else{
        if(canSelectMore){
            selected = YES;
            checked.alpha = 1;
            [self toggleWarnings];
            /*[[NSNotificationCenter defaultCenter] 
             postNotificationName:@"checkedAircraft" 
             object:aircraft];*/
        }        
        
    }
}

-(void)showCheckmark {
    checked.alpha = 1;
}

#pragma mark - Dealloc



-(void) touched {
    /*[[NSNotificationCenter defaultCenter] 
     postNotificationName:@"touchedAircraft" 
     object:aircraft];*/ 
}

/*
 -(void) setUpGestures: (NSNotification*) notification {
 
 self.gestureRecognizers = nil;
 
 UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCheck)];
 [doubleTapGesture setNumberOfTapsRequired:2];
 //[doubleTapGesture setNumberOfTouchesRequired:2];
 [self addGestureRecognizer:doubleTapGesture];
 
 UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched)];
 [tapGesture setNumberOfTapsRequired:1];
 [tapGesture requireGestureRecognizerToFail: doubleTapGesture];
 //[tapGesture setNumberOfTouchesRequired:1];
 [self addGestureRecognizer:tapGesture];
 
 
 }*/

@end
