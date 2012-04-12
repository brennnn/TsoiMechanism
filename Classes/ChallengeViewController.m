//
//  ChallengeViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Animations.h"

@implementation ChallengeViewController
@synthesize megalaser;
@synthesize charge;
@synthesize undoButtons;
@synthesize cannonContainerView;

SystemSoundID laserFire;
SystemSoundID laserCharge;

CGRect originalFrame;
CGPoint originalProblemViewPos;

NSArray *frames;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.multipleTouchEnabled=NO;
    self.view.exclusiveTouch=YES;

	
    tries = 0;
    
	frames = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"laser_red.png"], [UIImage imageNamed:@"laser_red2.png"], nil];
	
	originalProblemViewPos = problemView.center;
	
	[nextButton setHidden:YES];
	
	[megalaser setHidden:YES];
	[megalaser stopAnimating];
	[self pulsateLaser];
	
	originalFrame = megalaser.frame;
	
	[charge setHidden:YES];
	charge.alpha = 0.0;
	
	// Initialize sound
	NSString *path  = [[NSBundle mainBundle] pathForResource :@"laser_release" ofType:@"wav"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &laserFire);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
	
	// Initialize sound
	path  = [[NSBundle mainBundle] pathForResource :@"laser_charging" ofType:@"wav"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &laserCharge);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
}

-(void) pulsateLaser
{			   
	[UIView animateWithDuration: 1.0
						  delay: 0.0
						options: UIViewAnimationOptionCurveLinear
					 animations:^{
						 megalaser.animationImages = frames;
						 megalaser.animationDuration = 0.1;
						 megalaser.animationRepeatCount = 1000;
						 
						 [megalaser startAnimating];
					 }
					 completion:^(BOOL finished){
					 }];
	
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (tries > 1)
    {
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
    CGPoint hitbox = [problemView isHitbox:touchPoint];
    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) 
    {
        [problemView startArrow:hitbox];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
    if ([problemView isArrowInProgress]) {
        [problemView setArrowEnd:touchPoint];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
    if ([problemView isArrowInProgress]) {
        CGPoint hitbox = [problemView isHitbox:touchPoint];
        if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) {
            [problemView endArrow:hitbox];
        } else {
            [problemView removeLastArrow];
        }
    }
}

-(void) answerCorrect
{
    [problemView setArrowMode:ARROW_CORRECT];
    submitButton.hidden = YES;
	undoButtons.hidden = YES;
    nextButton.hidden = NO;
    [self addScore:100];
}

-(void)answerIncorrect
{
    if (tries > 0)
    {
        [problemView setArrowMode:ARROW_INCORRECT];
        submitButton.hidden = YES;
		undoButtons.hidden = YES;
		AudioServicesPlayAlertSound(laserFire);
		[self playFireAnimation];
    }
    else
    {
		AudioServicesPlayAlertSound(laserCharge);
		[self playFlashCharge];
        [problemView removeAllArrows];
    }
    tries++;
    [self removeScore:50];
}

-(IBAction)nextAct:(id)sender
{
	[self slideInProblemView];
    nextButton.hidden = YES; 
	undoButtons.hidden = NO;
    submitButton.hidden = NO;
    tries = 0;
    [problemView setArrowMode:ARROW_NORMAL];
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
    }
}

-(void) slideInProblemView
{
	[UIView animateWithDuration:1.0 
						  delay:0.0 
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 problemView.center = originalProblemViewPos;
					 }
					 completion:NULL];
}

-(void) playFireAnimation
{
	[megalaser startAnimating];
	megalaser.frame = originalFrame;
	[megalaser setHidden:NO];
	
	problemView.center = CGPointMake(self.view.frame.size.width*2, problemView.center.y);
	
	[Animations shakeView:cannonContainerView power:20.0];
	
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
						 [nextButton setHidden:NO];
						 [megalaser stopAnimating];
					 }];
	
}

-(void) playFlashCharge
{
	[charge setHidden:YES];
	charge.alpha = 0.0;
	
	[UIView animateWithDuration:0.5 
						  delay:0.0 
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 [charge setHidden:NO];
						 charge.alpha = 1.0;
					 }
					 completion:^(BOOL finished){
						 [UIView animateWithDuration:0.5 
											   delay:0.0 
											 options:UIViewAnimationOptionCurveEaseOut 
										  animations:^{
											  charge.alpha = 0.0;
										  } 
										  completion:^(BOOL finished){
											  [charge setHidden:YES];
										  }];
					 }];
}

-(IBAction)eraseAct:(id)sender
{
    if (tries <= 1)
    {
        [problemView removeLastArrow];
    }
}

- (void)viewDidUnload
{
    [self setMegalaser:nil];
	[self setCharge:nil];
	[self setUndoButtons:nil];
	[self setCannonContainerView:nil];
    [super viewDidUnload];
	AudioServicesDisposeSystemSoundID(laserFire);
	AudioServicesDisposeSystemSoundID(laserCharge);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

-(void) dealloc {
    [megalaser release];
	[charge release];
	
	[submitButton release];
	[nextButton release];
	
	[undoButtons release];
	[cannonContainerView release];
	
	[frames release];
	
    [super dealloc];
}

@end
