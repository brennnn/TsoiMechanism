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
					[problemView clearNucleophileMarker];
				}
				
            }
        } else {
            if ([problemView getArrowStackCount] == 1)
            {
				[problemView clearNucleophileMarker];
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
	[instructionButton release];
	[hintButton release];
}

//method for the intructionsButton interface builder action
- (IBAction)instructionPressed:(id)sender{
	UIAlertView *instructionView = [[UIAlertView alloc]initWithTitle:@"How to Play" message:@"Draw arrows to show the bonds" delegate:nil cancelButtonTitle:@"Return to Game" otherButtonTitles:nil];
	[instructionView show];
	[instructionView release];
}

//method for the hintButton interface builder action
- (IBAction)hintPressed:(id)sender{
	
	//Array of random hints, add and change as many hints here as you want
	NSMutableArray *hintArray = [[NSMutableArray alloc] init];
	[hintArray addObject:@"Are you sure that is the right bond?"];
	[hintArray addObject:@"Try a different element!"];
	[hintArray addObject:@"How many bonds are there in this problem?"];
	[hintArray addObject:@"Try a different bond"];
	[hintArray addObject:@"That arrow might not go there"];
	
	//just finding the number of variables in the array of hints
	int numObjects = [hintArray count];
	
	//random integer used help display a random message in the alertview
	int randomInt = arc4random() % (numObjects);
	
	//creates random hint in a form of a variable that can be called in the alertview
	NSString *randomHint = [NSString stringWithFormat:[hintArray objectAtIndex: randomInt]];
	
	//alertview that displays hint
	UIAlertView *hintView = [[UIAlertView alloc]initWithTitle:@"Hint!" message:randomHint delegate:self cancelButtonTitle:@"Return to Game" otherButtonTitles:nil];
	[hintView show];
	[hintView release];
}

@end
