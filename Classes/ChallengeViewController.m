//
//  ChallengeViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeViewController.h"

@implementation ChallengeViewController


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        [instructionsLabel setText:@"Draw the arrows to the appropiate spots"];
		isSecondTry = FALSE;
		//test
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
	if (isSecondTry)
	{
		submitButton.hidden = YES;
		nextButton.hidden = NO;
		responseText.message = @"I'm Sorry, you're out of tries. Hit [Next] to move to the next problem.";
	}
	else
	{
		isSecondTry = TRUE;
		responseText.message = @"That was incorrect. Try again.";
	}
	[self removeScore:50];
	[responseText show];
}

-(IBAction)nextProblem:(id)sender
{
	nextButton.hidden = YES; 
	submitButton.hidden = NO;
	[self goToNextProblem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

-(void) dealloc {
    [super dealloc];
}

@end
