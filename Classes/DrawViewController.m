//
//  DrawViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawViewController.h"

@implementation DrawViewController
@synthesize instructionButton;
@synthesize hintButton;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {

    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];

    CGPoint hitbox = [problemView isHitbox:touchPoint];
    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) {
        [problemView startArrow:hitbox];
        if ([problemView getArrowStackCount] == 1)
        {
            [problemView showNucleophileMarker:hitbox];
        }
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
            if ([problemView getArrowStackCount] == 1)
            {
                [problemView showElectrophileMarker:hitbox];
            }
        } else {
            if ([problemView getArrowStackCount] == 1)
            {
                [problemView clearElectrophileMarker];
            }
            [problemView removeLastArrow];
        }
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
	[instructionButton release];
	[hintButton	release];
}

-(IBAction)hintPressed:(id)sender{
	
	NSMutableArray *hintArray = [[NSMutableArray alloc] init];
	
	[hintArray addObject:@"Are you sure that is the right bond?"];
	[hintArray addObject:@"Try a different element!"];
	[hintArray addObject:@"How many bonds are there in this problem?"];
	[hintArray addObject:@"Try a different bond"];
	[hintArray addObject:@"That arrow might not go there"];
	
	int numObjects = [hintArray count];
	int randomInt = arc4random() % (numObjects);
	
	NSString *randomHint = [NSString stringWithFormat:[hintArray objectAtIndex: randomInt]];
	UIAlertView *hintView = [[UIAlertView alloc]initWithTitle:@"Hint!" message:randomHint delegate:self cancelButtonTitle:@"Return to Game" otherButtonTitles:nil];
	[hintView show];
	[hintView release];
}

@end
