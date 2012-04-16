//
//  DemoViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#define MODE_IDENTIFY 1
#define MODE_DRAW 2
#define MODE_CHALLENGE 3

@interface DemoViewController : UIViewController
{
    int mode;
	MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, readwrite) int mode;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;


-(void) moviePlayBackDidFinish:(NSNotification*)notification;
-(void) pushMode;

@end
