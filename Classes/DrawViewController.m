//
//  DrawViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawViewController.h"

@implementation DrawViewController
@synthesize hintButton, correctValue, incorrectValue;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
		[self setDrawInstructions];
		//console check of what the arrow count currently is, at default before anything is drawn, is 1
		[problemView getProblemArrowCount];
		NSLog([NSString stringWithFormat:@"getArrowCount is: %i", [problemView getProblemArrowCount]]);
    }
    return self;
}

-(void) getinCorrectScore {
	//determines the value of the incorrect bond 
	if (score != 0) {
		if ([problemView getProblemArrowCount] == 3) {
			incorrectValue = 10;
		}
		if ([problemView getProblemArrowCount] == 2) {
			incorrectValue = 25;
		}
		else {
			incorrectValue = 25;
		}
	}
	else {
		incorrectValue = 0;
	}
	
}

-(void) getCorrectScore {
	//determines the value of a correct value
	if ([problemView getProblemArrowCount] == 3) {
		correctValue = 25;
	} 
	if ([problemView getProblemArrowCount] == 2) {
		correctValue = 50;
	} 
	else {
		correctValue = 100;
	}
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
	
    CGPoint hitbox = [problemView isHitbox:touchPoint];
	//NSLog(@"StartB");
	//NSLog(@"Before test: %d",[problemView getArrowStackCount]);
    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)) && ([problemView getProblemArrowCount] > [problemView getArrowStackCount])) {
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
	//Determines correctValues and incorrectValues
	[self getCorrectScore];
	[self getinCorrectScore];
	
	//console check on the values of the correctValue and incorrectValue
	NSLog([NSString stringWithFormat:@"correctValue is: %i", correctValue]);
	NSLog([NSString stringWithFormat:@"incorrectValue is %i", incorrectValue]);	
	
	UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
	//NSString *arrowCount = (NSString *) [problemView getProblemArrowCount]; // How many Arrows in the problem are needed
	//NSString *arrowStack = (NSString *) [problemView getArrowStackCount]; // How many arrows where used
	//NSString *arrowIsHitBox = (NSString *) CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)); // Is arrow on hitbox
	//NSLog(@"StartE");
	//NSLog(@"Before test: %d",arrowStack);
    if ([problemView isArrowInProgress]) {
        CGPoint hitbox = [problemView isHitbox:touchPoint];
        if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)))
		{
            [problemView endArrow:hitbox];
            if ([problemView getArrowStackCount] == 1)
            {
				//Checks to see if the current arrow drawn is on the correct hitbox and direction
				if([problemView doesLastArrowMatchProblem]) {
					NSLog(@"Arrow Match");
					[problemView showElectrophileMarker:hitbox];
					//correct arrow drawn adds correctValue to the score
					[self addScore:correctValue];
				} 
				else 
				{
					NSLog(@"Arrow does not Match");
					[problemView removeLastArrow];
					[problemView clearNucleophileMarker];
					[self hintPopUp];
					//incorrect arrow drawn subtracts incorrectValue from the score
					[self removeScore:(incorrectValue)];
				}
            }
			
			if ([problemView getArrowStackCount] > 1)
            {
				//NSLog(@"%d",!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)));
				if([problemView doesLastArrowMatchProblem]) {
					NSLog(@"Arrow Match past first");
					[problemView showElectrophileMarker:hitbox];
					if([problemView getArrowStackCount] == [problemView getProblemArrowCount])
					{
						UIAlertView *hintView = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Go to the next problem." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
						[hintView show];
						[hintView release];
					}
					//correct arrow drawn adds correctValue to the score
					[self addScore:(correctValue)];
				}
				else
				{
					NSLog(@"Arrow does not Match past first");
					[problemView removeLastArrow];
					[self hintPopUp];
					//incorrect arrow drawn subtracts incorrectValue from the score
					[self removeScore:(incorrectValue)];
				}
				
			}
        }
		else
		{
            [problemView removeLastArrow];
			if ([problemView getArrowStackCount] < 1)
			{
				[problemView clearNucleophileMarker];	
			}
			//NSLog(@"After test: %d",arrowStack);
		}
		
    }
	NSLog([NSString stringWithFormat:@"arrow stack count: %i", [problemView getProblemArrowCount]]);
}

-(void)setDrawInstructions
{
	self.instructionsLabel.text = @"Draw arrows from the highlighted elements and bonds in order to complete the problem. Drawing an incorrect arrow will cause a hint to pop up. Click the hint button to receive a hint otherwise. When you finish drawing all the correct arrows, a confirmation to go to the next problem will appear.";
}

-(IBAction)hintPressed:(id)sender{
	
	[self hintPopUp];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if ([problemView doesAllArrowsMatchProblem])
	{
		if ([problemView getProblemArrowCount]==3) {
			[self addScore:(25)];
		} else {
			[self goToNextProblem];
		}
	}
	else
	{
		NSLog(@"cancel");
	}
}

-(void)hintPopUp{
	NSMutableArray *hintArray = [[NSMutableArray alloc] init];
	
	[hintArray addObject:@"Are you sure that is the right bond?"];
	[hintArray addObject:@"Try a different element!"];
	[hintArray addObject:@"How many bonds are there in this problem?"];
	[hintArray addObject:@"Try a different bond"];
	[hintArray addObject:@"That arrow might not go there"];
	
	int numObjects = [hintArray count];
	int randomInt = arc4random() % (numObjects);
	
	NSString *randomHint = [NSString stringWithString:[hintArray objectAtIndex: randomInt]];
	UIAlertView *hintView = [[UIAlertView alloc]initWithTitle:@"Hint!" message:randomHint delegate:self cancelButtonTitle:@"Return to Game" otherButtonTitles:nil];
	[hintView show];
	[hintView release];
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
	[hintButton	release];
}

@end