//
//  ModeViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModeViewController.h"

@implementation ModeViewController

@synthesize problemView, problemNumberLabel, scoreLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        problemView = [[ProblemView alloc] init];
        score = 0;
        problemNumber = 1;
    }
	
    return self;
}

-(void) goToNextProblem
{
    if (problemNumber < MAX_PROBLEMS) 
    {
        [problemView showNextProblem];
        problemNumber++;
        [problemNumberLabel setText:[NSString stringWithFormat:@"%i/%i", problemNumber, MAX_PROBLEMS]];
    } else 
    {
		UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Game Over"
                              message: [NSString stringWithFormat:@"Your score was %i !", score]
                              delegate: nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self.navigationController popViewControllerAnimated:YES];
	}
    
}

-(void) addScore:(int) amount
{
    score += amount;
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %i", score]];
}

-(void) removeScore:(int) amount
{
    if ((score - amount) < 0)
    {
        score = 0;
    } else 
    {
        score -= amount;
    }
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %i", score]];
}

-(IBAction) exitView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void) dealloc 
{
    [problemView release];
    [problemNumberLabel release];
    [scoreLabel release];
    [super dealloc];
}

@end
