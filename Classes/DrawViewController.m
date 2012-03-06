//
//  DrawViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawViewController.h"

@implementation DrawViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:@"ModeViewController" bundle:nibBundleOrNil]) 
    {

    }
    return self;
}

// The point the arrow is drawn and checks to see if it exceeds the number of drawn arrows for the problem
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];

    CGPoint hitbox = [problemView isHitbox:touchPoint];
	NSLog(@"StartB");
    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)) && ([problemView getProblemArrowCount] > [problemView getArrowStackCount])) {
        [problemView startArrow:hitbox];
        if ([problemView getArrowStackCount] == 1)
        {
            [problemView showNucleophileMarker:hitbox];
        }
    }
}

// keep arrow drawn as you drag tha arrow.
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    if ([problemView isArrowInProgress]) {
		[problemView setArrowEnd:touchPoint];
    }
}

// This is the function that "Sticks" the arrow to the hitbox.
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
	//NSString *arrowCount = (NSString *) [problemView getProblemArrowCount]; // How many Arrows in the problem are needed
	//NSString *arrowStack = (NSString *) [problemView getArrowStackCount]; // How many arrows where used
	//NSLog(@"StartE");
    if ([problemView isArrowInProgress]) {
        CGPoint hitbox = [problemView isHitbox:touchPoint];
        if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) {
            [problemView endArrow:hitbox];
            if ([problemView getArrowStackCount] == 1)
            {
				//Checks to see if the current arrow drawn is on the correct hitbox and direction
				if([problemView doesLastArrowMatchProblem]) {
				NSLog(@"Arrow Match");
                [problemView showElectrophileMarker:hitbox];
				} else {
					NSLog(@"Arrow does not Match");
					[problemView removeLastArrow];
				}

            }
        } else {
            if ([problemView getArrowStackCount] == 1)
            {
                [problemView clearElectrophileMarker];
			}
			[problemView removeLastArrow];
        }
		//NSLog(@"%d",arrowStack);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [problemView showProblemMarkers];
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
