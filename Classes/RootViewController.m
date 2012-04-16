//
//  RootViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DemoViewController.h"
//#import "IdentifyViewController.h"
//#import "DrawViewController.h"
//#import "ChallengeViewController.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        [self.navigationController setNavigationBarHidden:NO];
        
        self.view.multipleTouchEnabled=NO;
        self.view.exclusiveTouch=YES;
    }
    return self;
}

-(IBAction)identifyAct:(id)sender
{
    DemoViewController *demoView = [[DemoViewController alloc] init];
    demoView.mode = MODE_IDENTIFY;
    [self.navigationController pushViewController:demoView animated:YES];
    [demoView release];

//    IdentifyViewController *identifyView = [[IdentifyViewController alloc] initWithNibName:@"IdentifyViewController" bundle:nil];;
//    [self.navigationController pushViewController:identifyView animated:YES];
//    [identifyView release];

}

-(IBAction)drawAct:(id)sender
{
    DemoViewController *demoView = [[DemoViewController alloc] init];
    demoView.mode = MODE_DRAW;
    [self.navigationController pushViewController:demoView animated:YES];
    [demoView release];
//    DrawViewController *drawView = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
//    [self.navigationController pushViewController:drawView animated:YES];
//    [drawView release];

}

-(IBAction)challengeAct:(id)sender
{
    DemoViewController *demoView = [[DemoViewController alloc] init];
    demoView.mode = MODE_CHALLENGE;
    [self.navigationController pushViewController:demoView animated:YES];
    [demoView release];
//    ChallengeViewController *challengeView = [[ChallengeViewController alloc] initWithNibName:@"ChallengeViewController" bundle:nil];
//    [self.navigationController pushViewController:challengeView animated:YES];
//    [challengeView release];
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
    [super dealloc];
}

@end
