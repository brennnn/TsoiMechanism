//
//  DemoViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DemoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IdentifyViewController.h"
#import "DrawViewController.h"
#import "ChallengeViewController.h"

#define Demo_iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@implementation DemoViewController

@synthesize mode;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSURL *url;
    
    if (mode == MODE_IDENTIFY)
    {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: Demo_iPad ? @"identify-ipad" : @"identify" ofType:@"mov"]];
    } else if (mode == MODE_DRAW)
    {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: Demo_iPad ? @"draw-ipad" : @"draw" ofType:@"mov"]];
    } else if (mode == MODE_CHALLENGE)
    {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: Demo_iPad ? @"challenge-ipad" : @"challenge" ofType:@"mov"]];
    } else 
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
  
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    moviePlayer.view.frame = CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x-20, self.view.frame.size.height, self.view.frame.size.width);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    [moviePlayer setFullscreen:YES];
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES];
    [moviePlayer play];
    
    
    
}

-(void) pushMode
{
    if (mode == MODE_IDENTIFY)
    {
        IdentifyViewController *identifyView = [[IdentifyViewController alloc] initWithNibName:@"IdentifyViewController" bundle:nil];
        UINavigationController *navController = self.navigationController;
        [[self retain] autorelease];
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:identifyView animated:YES];
        [identifyView release];
    } else if (mode == MODE_DRAW)
    {
        DrawViewController *drawView = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
        UINavigationController *navController = self.navigationController;
        [[self retain] autorelease];
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:drawView animated:YES];
        [drawView release];
    } else if (mode == MODE_CHALLENGE)
    {
        ChallengeViewController *challengeView = [[ChallengeViewController alloc] initWithNibName:@"ChallengeViewController" bundle:nil];
        UINavigationController *navController = self.navigationController;
        [[self retain] autorelease];
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:challengeView animated:YES];
        [challengeView release];
    } else 
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{  
    MPMoviePlayerController *moviePlayer = [notification object];  
    [[NSNotificationCenter defaultCenter] removeObserver:self  
                                                    name:MPMoviePlayerPlaybackDidFinishNotification  
                                                  object:moviePlayer];  
    
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {  
        [moviePlayer.view removeFromSuperview];  
    }  
    
    [moviePlayer release];  
    [self pushMode];
}  

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
