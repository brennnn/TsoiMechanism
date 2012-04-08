//
//  ChallengeViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation ChallengeViewController
@synthesize megalaser;

SystemSoundID laserFire;
CGRect originalFrame;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        [instructionsLabel setText:@"Draw the arrows to the appropiate spots"];
		tries = 0;
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (tries > 1)
    {
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
    CGPoint hitbox = [problemView isHitbox:touchPoint];
    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) {
        [problemView startArrow:hitbox];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
    if ([problemView isArrowInProgress]) {
        [problemView setArrowEnd:touchPoint];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
    if ([problemView isArrowInProgress]) {
        CGPoint hitbox = [problemView isHitbox:touchPoint];
        if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) {
            [problemView endArrow:hitbox];
            
            if ([problemView doesLastArrowMatchProblem])
            {
            }
            if ([problemView doesAllArrowsMatchProblem])
            {
            }
            
        } else {
            [problemView removeLastArrow];
        }
    }
}

-(void) answerCorrect
{
    submitButton.hidden = YES;
    nextButton.hidden = NO;
    responseText.message = @"CORRECT!!! Hit [Next] to move to the next problem!";
    [responseText show];
    [self addScore:100];
}

-(void)answerIncorrect
{
    if (tries > 0)
    {
        submitButton.hidden = YES;
        nextButton.hidden = NO;
        responseText.message = @"I'm Sorry, you're out of tries. Hit [Next] to move to the next problem.";
    }
    else
    {
        responseText.message = @"That was incorrect. Try again.";
    }
    tries++;
    [self removeScore:50];
//    [responseText show];
}

-(IBAction)nextAct:(id)sender
{
    nextButton.hidden = YES; 
    submitButton.hidden = NO;
    tries = 0;
    [self goToNextProblem];
}

-(IBAction)submitAct:(id)sender
{
    if ([problemView doesAllArrowsMatchProblem])
    {
        [self answerCorrect];
    } else
    {
        [self answerIncorrect];
		AudioServicesPlayAlertSound(laserFire);
		[self playFireAnimation];
    }
}

-(void) playFireAnimation
{
	megalaser.frame = originalFrame;
	[megalaser setHidden:NO];
	
	[UIView animateWithDuration:2.0 
						  delay:1.5 
						options:UIViewAnimationOptionCurveEaseOut 
					 animations:^{
						 megalaser.alpha = 0.0;
						 megalaser.bounds = CGRectMake(megalaser.center.x, megalaser.center.y, megalaser.bounds.size.width/4, megalaser.bounds.size.height);
						 megalaser.alpha = 0.0;
					 }
					 completion:^(BOOL finished){
						 [megalaser setHidden:YES];
						 megalaser.alpha = 1.0;
					 }];
	
}

-(IBAction)eraseAct:(id)sender
{
    if (tries <= 1)
    {
        [problemView removeLastArrow];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[megalaser setHidden:YES];
	originalFrame = megalaser.frame;
	
	// Initialize sound
	NSString *path  = [[NSBundle mainBundle] pathForResource :@"laser-boom" ofType:@"wav"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &laserFire);
		//		AudioServicesPlaySystemSound(explosion);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
}

- (void)viewDidUnload
{
    [self setMegalaser:nil];
    [super viewDidUnload];
	AudioServicesDisposeSystemSoundID(laserFire);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

-(void) dealloc {
    [megalaser release];
    [super dealloc];
}

@end
