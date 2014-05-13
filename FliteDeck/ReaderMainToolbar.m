//
//	ReaderMainToolbar.m
//	Reader v2.5.4
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2012 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"

#import <MessageUI/MessageUI.h>

@implementation ReaderMainToolbar

#pragma mark Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define DONE_BUTTON_WIDTH 56.0f
#define THUMBS_BUTTON_WIDTH 40.0f
#define MENU_BUTTON_WIDTH 80.0f
#define PRINT_BUTTON_WIDTH 40.0f
#define EMAIL_BUTTON_WIDTH 40.0f
#define MARK_BUTTON_WIDTH 40.0f

#define TITLE_HEIGHT 28.0f

#pragma mark Properties

@synthesize delegate;
@synthesize menuButton;
@synthesize emailButton;

#pragma mark ReaderMainToolbar instance methods

- (id)initWithFrame:(CGRect)frame
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	return [self initWithFrame:frame document:nil title:nil];
}

- (id)initWithFrame:(CGRect)frame document:(ReaderDocument *)object title:(NSString *)titleString
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	assert(object != nil); // Check

	if ((self = [super initWithFrame:frame]))
	{
		CGFloat viewWidth = self.bounds.size.width;

		CGFloat titleX = BUTTON_X; CGFloat titleWidth = (viewWidth - (titleX + titleX));

		CGFloat leftButtonX = BUTTON_X; // Left button start X position

#if (READER_STANDALONE == FALSE) // Option

		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backH = [UIImage imageNamed:@"Back_Highlighted.png"];
		UIImage *backN = [UIImage imageNamed:@"Back_Normal.png"];

		doneButton.frame = CGRectMake(leftButtonX, BUTTON_Y, DONE_BUTTON_WIDTH, BUTTON_HEIGHT);
		[doneButton setTitle:NSLocalizedString(@"Back", @"button") forState:UIControlStateNormal];
        doneButton.titleEdgeInsets=UIEdgeInsetsMake(0, 8, 0, 0);
		[doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[doneButton setBackgroundImage:backH forState:UIControlStateHighlighted];
		[doneButton setBackgroundImage:backN forState:UIControlStateNormal];
		doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		doneButton.autoresizingMask = UIViewAutoresizingNone;

		[self addSubview:doneButton]; leftButtonX += (DONE_BUTTON_WIDTH + BUTTON_SPACE);

		titleX += (DONE_BUTTON_WIDTH + BUTTON_SPACE); titleWidth -= (DONE_BUTTON_WIDTH + BUTTON_SPACE);

#endif // end of READER_STANDALONE Option

#if (READER_ENABLE_THUMBS == TRUE) // Option

		UIButton *thumbsButton = [UIButton buttonWithType:UIButtonTypeCustom];

		thumbsButton.frame = CGRectMake(leftButtonX, BUTTON_Y, 54, 29);
		[thumbsButton setImage:[UIImage imageNamed:@"Grid_Normal.png"] forState:UIControlStateNormal];
        [thumbsButton setImage:[UIImage imageNamed:@"Grid_Highlighted.png"] forState:UIControlStateHighlighted];
		[thumbsButton addTarget:self action:@selector(thumbsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		thumbsButton.autoresizingMask = UIViewAutoresizingNone;

		[self addSubview:thumbsButton]; //leftButtonX += (THUMBS_BUTTON_WIDTH + BUTTON_SPACE);

		titleX += (THUMBS_BUTTON_WIDTH + BUTTON_SPACE); titleWidth -= (THUMBS_BUTTON_WIDTH + BUTTON_SPACE);

#endif // end of READER_ENABLE_THUMBS Option

		CGFloat rightButtonX = viewWidth; // Right button start X position
        
        rightButtonX -= (MENU_BUTTON_WIDTH + BUTTON_SPACE);
        
        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        menuButton.frame = CGRectMake(rightButtonX, BUTTON_Y, MENU_BUTTON_WIDTH, BUTTON_HEIGHT);
        //        [menuButton setImage:[UIImage imageNamed:@"Reader-Print.png"] forState:UIControlStateNormal];
        
        UIImage *searchH = [UIImage imageNamed:@"Reader_Button_Highlighted.png"];
		UIImage *searchN = [UIImage imageNamed:@"Reader_Button_Normal.png"];
        
        UIImage *searchButtonH = [searchH stretchableImageWithLeftCapWidth:5 topCapHeight:0];
		UIImage *searchButtonN = [searchN stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        
        [menuButton setTitle:@"Search" forState:UIControlStateNormal];
        [menuButton setTitle:@"Search" forState:UIControlStateApplication];
        [menuButton setTitle:@"Search" forState:UIControlStateHighlighted];
        [menuButton setTitle:@"Search" forState:UIControlStateReserved];
        [menuButton setTitle:@"Search" forState:UIControlStateSelected];
        [menuButton setTitle:@"Search" forState:UIControlStateDisabled];
        menuButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UIColor *menuButtonTextColor = [UIColor whiteColor];
        
        [menuButton setTitleColor:menuButtonTextColor forState:UIControlStateNormal];
        [menuButton setTitleColor:menuButtonTextColor forState:UIControlStateApplication];
        [menuButton setTitleColor:menuButtonTextColor forState:UIControlStateHighlighted];
        [menuButton setTitleColor:menuButtonTextColor forState:UIControlStateReserved];
        [menuButton setTitleColor:menuButtonTextColor forState:UIControlStateSelected];
        [menuButton setTitleColor:menuButtonTextColor forState:UIControlStateDisabled];
        
        [menuButton addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [menuButton setBackgroundImage:searchButtonH forState:UIControlStateHighlighted];
        [menuButton setBackgroundImage:searchButtonN forState:UIControlStateNormal];
        menuButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [self addSubview:menuButton]; titleWidth -= (MENU_BUTTON_WIDTH + BUTTON_SPACE);

#if (READER_BOOKMARKS == TRUE) // Option

		rightButtonX -= (MARK_BUTTON_WIDTH + BUTTON_SPACE);

		UIButton *flagButton = [UIButton buttonWithType:UIButtonTypeCustom];

		flagButton.frame = CGRectMake(rightButtonX, BUTTON_Y, MARK_BUTTON_WIDTH, BUTTON_HEIGHT);
		//[flagButton setImage:[UIImage imageNamed:@"Reader-Mark-N.png"] forState:UIControlStateNormal];
		[flagButton addTarget:self action:@selector(markButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[flagButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[flagButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		flagButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

		[self addSubview:flagButton]; titleWidth -= (MARK_BUTTON_WIDTH + BUTTON_SPACE);

		markButton = [flagButton retain]; markButton.enabled = NO; markButton.tag = NSIntegerMin;

		markImageN = [[UIImage imageNamed:@"Reader-Mark-N.png"] retain]; // N image
		markImageY = [[UIImage imageNamed:@"Reader-Mark-Y.png"] retain]; // Y image

#endif // end of READER_BOOKMARKS Option

#if (READER_ENABLE_MAIL == TRUE) // Option

		if ([MFMailComposeViewController canSendMail] == YES) // Can email
		{
			unsigned long long fileSize = [object.fileSize unsignedLongLongValue];

			if (fileSize < (unsigned long long)15728640) // Check attachment size limit (15MB)
			{
				rightButtonX -= (54 + BUTTON_SPACE);

                //	UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
                emailButton = [UIButton buttonWithType:UIButtonTypeCustom];

				emailButton.frame = CGRectMake(rightButtonX, BUTTON_Y, 54, BUTTON_HEIGHT);
				[emailButton setImage:[UIImage imageNamed:@"Mail_Normal.png"] forState:UIControlStateNormal];
                [emailButton setImage:[UIImage imageNamed:@"Mail_Highlighted.png"] forState:UIControlStateHighlighted];
				[emailButton addTarget:self action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
				emailButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

				[self addSubview:emailButton]; titleWidth -= (EMAIL_BUTTON_WIDTH + BUTTON_SPACE);
			}
		}

#endif // end of READER_ENABLE_MAIL Option

#if (READER_ENABLE_PRINT == TRUE) // Option

		if (object.password == nil) // We can only print documents without passwords
		{
			Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");

			if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
			{
				rightButtonX -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);

				UIButton *printButton = [UIButton buttonWithType:UIButtonTypeCustom];

				printButton.frame = CGRectMake(rightButtonX, BUTTON_Y, PRINT_BUTTON_WIDTH, BUTTON_HEIGHT);
				[printButton setImage:[UIImage imageNamed:@"Reader-Print.png"] forState:UIControlStateNormal];
				[printButton addTarget:self action:@selector(printButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
				[printButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
				[printButton setBackgroundImage:buttonN forState:UIControlStateNormal];
				printButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

				[self addSubview:printButton]; titleWidth -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);
			}
		}

#endif // end of READER_ENABLE_PRINT Option

		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			CGRect titleRect = CGRectMake(titleX, BUTTON_Y, titleWidth, TITLE_HEIGHT);

			UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];

			titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
			titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			titleLabel.textColor = [UIColor colorWithRed:0.443 green:0.471 blue:0.502 alpha:1.000];
			titleLabel.shadowColor = [UIColor whiteColor];
			titleLabel.backgroundColor = [UIColor clearColor];
			titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
			titleLabel.adjustsFontSizeToFitWidth = YES;
            if (titleString == nil) {
                titleLabel.text = [object.fileName stringByDeletingPathExtension];
            } else {
                titleLabel.text = titleString;
            }

			[self addSubview:titleLabel]; [titleLabel release];
		}
	}

	return self;
}

- (void)dealloc
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	[markButton release], markButton = nil;

	[markImageN release], markImageN = nil;
	[markImageY release], markImageY = nil;

	[super dealloc];
}

- (void)setBookmarkState:(BOOL)state
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

#if (READER_BOOKMARKS == TRUE) // Option

	if (state != markButton.tag) // Only if different state
	{
		if (self.hidden == NO) // Only if toolbar is visible
		{
			UIImage *image = (state ? markImageY : markImageN);

			[markButton setImage:image forState:UIControlStateNormal];
		}

		markButton.tag = state; // Update bookmarked state tag
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)updateBookmarkImage
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

#if (READER_BOOKMARKS == TRUE) // Option

	if (markButton.tag != NSIntegerMin) // Valid tag
	{
		BOOL state = markButton.tag; // Bookmarked state

		UIImage *image = (state ? markImageY : markImageN);

		[markButton setImage:image forState:UIControlStateNormal];
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)hideToolbar
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	if (self.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.alpha = 0.0f;
			}
			completion:^(BOOL finished)
			{
				self.hidden = YES;
			}
		];
	}
}

- (void)showToolbar
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	if (self.hidden == YES)
	{
		[self updateBookmarkImage]; // First

		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.hidden = NO;
				self.alpha = 1.0f;
			}
			completion:NULL
		];
	}
}

#pragma mark UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self doneButton:button];
}

- (void)thumbsButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self thumbsButton:button];
}

- (void)printButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self printButton:button];
}

- (void)emailButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self emailButton:button];
}

- (void)markButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif

	[delegate tappedInToolbar:self markButton:button];
}

- (void)menuButtonTapped:(UIButton *)button
{
#ifdef DEBUGX
	DLog(@"%s", __FUNCTION__);
#endif
    [delegate tappedInToolbar:self menuButton:button];
}

@end
