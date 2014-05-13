//
//  GalleryTile.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "GalleryTile.h"

@implementation GalleryTile
@synthesize image,movie;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setup: (NSString*) fileName {
    DLog(@"Filepath is: %@", fileName);
    if([fileName contains:@".png"] || [fileName contains:@".jpg"]){
        [self setupImage: fileName];
    }
    
    if([fileName contains:@".mov"] || [fileName contains:@".m4v"] || [fileName contains:@".mp4"]){
        [self setupVideo: fileName];
    }
}


-(void) setupImage: (NSString*) imageName {
    image = [[UIImageView alloc] initWithFrame:self.frame];
    NSString *path = [[NFDFileSystemHelper directoryForDocuments] stringByAppendingPathComponent:imageName];
    DLog(@"%@",path);
    image.image = [UIImage imageWithContentsOfFile:path];
    //Look for it in the bundle
    if(image.image == nil){
        image.image = [UIImage imageNamed:imageName];    
    }
    DLog(@"%@",[image.image description]);
    [self addSubview: image];
}

-(void) setupVideo: (NSString*) path {
	NSString *videoFilepath = [[NFDFileSystemHelper directoryForData] stringByAppendingPathComponent:path];
    if(![NFDFileSystemHelper fileExist:videoFilepath]){
        NSBundle *bundle = [NSBundle mainBundle];
        NSArray *components = [path componentsSeparatedByString:@"."];
        videoFilepath = [bundle pathForResource:[components objectAtIndex:0] ofType:[components objectAtIndex:1]];
    }
	NSURL *videoURL = [NSURL fileURLWithPath:videoFilepath];
	movie = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playbackFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:movie];
    movie.view.frame = self.frame;
    
    movie.scalingMode = MPMovieScalingModeAspectFit;
    movie.fullscreen = FALSE;
    movie.controlStyle = MPMovieControlStyleDefault;
    movie.shouldAutoplay = FALSE;
    
    
    [self addSubview: movie.view];
}


-(void) play{
	[movie play];
}

-(void)playbackFinishedCallback:(NSNotification *)notification{
	
	movie = [notification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:movie];
	//[movie release];
	
}
@end
