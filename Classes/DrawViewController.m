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
<<<<<<< HEAD
    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) {
=======
	//NSLog(@"StartB");
	//NSLog(@"Before test: %d",[problemView getArrowStackCount]);
    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)) && ([problemView getProblemArrowCount] > [problemView getArrowStackCount])) {
>>>>>>> Cleaned arrow code
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
<<<<<<< HEAD
    
=======
	//NSString *arrowCount = (NSString *) [problemView getProblemArrowCount]; // How many Arrows in the problem are needed
	//NSString *arrowStack = (NSString *) [problemView getArrowStackCount]; // How many arrows where used
	//NSString *arrowIsHitBox = (NSString *) CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)); // Is arrow on hitbox
	//NSLog(@"StartE");
	//NSLog(@"Before test: %d",arrowStack);
>>>>>>> Cleaned arrow code
    if ([problemView isArrowInProgress]) {
        CGPoint hitbox = [problemView isHitbox:touchPoint];
        if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)))
		{
            [problemView endArrow:hitbox];
            if ([problemView getArrowStackCount] == 1)
            {
<<<<<<< HEAD
                [problemView showElectrophileMarker:hitbox];
=======
				//Checks to see if the current arrow drawn is on the correct hitbox and direction
				if([problemView doesLastArrowMatchProblem]) {
					NSLog(@"Arrow Match");
					[problemView showElectrophileMarker:hitbox];
				} 
				else 
				{
					NSLog(@"Arrow does not Match");
					[problemView removeLastArrow];
					[problemView clearNucleophileMarker];
				}
>>>>>>> Cleaned arrow code
            }
			
			if ([problemView getArrowStackCount] > 1)
            {
<<<<<<< HEAD
                [problemView clearElectrophileMarker];
            }
            [problemView removeLastArrow];
        }
=======
				//NSLog(@"%d",!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)));
				if([problemView doesLastArrowMatchProblem]) {
					NSLog(@"Arrow Match past first");
					[problemView showElectrophileMarker:hitbox];
				}
				else
				{
					NSLog(@"Arrow does not Match past first");
					[problemView removeLastArrow];
				}
				
			}
        }
		else
		{
            [problemView removeLastArrow];
			[problemView clearNucleophileMarker];
			//NSLog(@"After test: %d",arrowStack);
		}
		
>>>>>>> Cleaned arrow code
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
