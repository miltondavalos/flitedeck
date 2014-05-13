//
//  LaunchPadPage.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/2/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NFDLaunchPadPage.h"
#import "NFDLaunchPadButton.h"

@implementation NFDLaunchPadPage
@synthesize buttons;


float marginLeft = 10.0;
float marginRight = 10.0;
float marginTop = 10;
float marginBottom = 20.0;



float buttonWidth = 222;
float buttonHeight = 250;
float buttonPadingX = 30;
float buttonPadingY = 10;


float buttonsPerRow = 3;
float totalRows = 3;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.buttons = [[NSMutableArray alloc] init];
    
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.layer setShadowOpacity:0.7];
    [self.layer setShadowRadius:5];
    
    return self;
}

-(NFDLaunchPadButton *) addLauncher : (NSString *) title  imageName: (NSString *) imageName  notificationToFire: (NSString *) notificationToFire {
    
    NFDLaunchPadButton *button = [[NFDLaunchPadButton alloc] init];
    button.title = title;
    button.imagename = imageName;
    button.imagenameselected = imageName;
    button.notification = notificationToFire;
    [button setup];
    
    [buttons addObject: button];

    [self addSubview: button];
    
    return button;
}

- (void) didRotate:(NSNotification *)notification
{	
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationLandscapeLeft ||orientation == UIDeviceOrientationLandscapeRight )
    {
       marginTop = 50;
       buttonPadingY = 0;
    }
    
    if (orientation == UIDeviceOrientationPortrait ||orientation == UIDeviceOrientationPortraitUpsideDown )
    {
        marginTop = 75;
        buttonPadingY = 5;
    }
    [self doLayout];
}



-(void) doLayout{
    int buttonsInRow = 0;
    int row = 0;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;

    float marginLeft = (screenWidth - ((buttonsPerRow-1)*(buttonPadingX+buttonWidth)+buttonWidth))/2;
    float xx = marginLeft;
    float yy = marginTop;
    for(NFDLaunchPadButton *button in buttons){
        
        if (button.hidden) {
            continue;
        }
  
        if(buttonsInRow > 0){
            xx += buttonWidth+buttonPadingX;
        }
        
        button.frame= CGRectMake(xx,yy , buttonWidth, buttonHeight);
        buttonsInRow++;
        if(buttonsInRow >= buttonsPerRow){
            row++;
            xx = marginLeft;
            yy += buttonHeight+buttonPadingY;
            buttonsInRow = 0;
        }
        
        if(row > totalRows){
            break;
        }
    }
}
@end
