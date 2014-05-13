//
//  EventTile.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDEventInformation.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NCLFramework.h"
#import "NFDFileSystemHelper.h"

@interface GalleryTile : UIView{
    UIImageView *image;
    MPMoviePlayerController *movie;
}

@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) MPMoviePlayerController *movie;


-(void) setup: (NSString*) filename ;
-(void) setupImage: (NSString*) imageName;
-(void) setupVideo: (NSString*) videoFilepath;
-(void) play;
-(void)playbackFinishedCallback:(NSNotification *)notification;
@end
