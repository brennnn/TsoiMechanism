//
//  RootViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "IdentifyViewController.h"
#import "DrawViewController.h"
#import "ChallengeViewController.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        [self.navigationController setNavigationBarHidden:NO];
    }
    return self;
}

-(IBAction)identifyAct:(id)sender
{
    IdentifyViewController *identifyView = [[IdentifyViewController alloc] initWithNibName:@"IdentifyViewController" bundle:nil];;
    [self.navigationController pushViewController:identifyView animated:YES];
    [identifyView release];

}

-(IBAction)drawAct:(id)sender
{
    DrawViewController *drawView = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
    [self.navigationController pushViewController:drawView animated:YES];
    [drawView release];

}

-(IBAction)challengeAct:(id)sender
{
    
    ChallengeViewController *challengeView = [[ChallengeViewController alloc] initWithNibName:@"ChallengeViewController" bundle:nil];
    [self.navigationController pushViewController:challengeView animated:YES];
    [challengeView release];
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
