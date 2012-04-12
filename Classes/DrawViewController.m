//
//  DrawViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Animations.h"

@implementation DrawViewController
@synthesize cannon;
@synthesize gear;
@synthesize cannon2;
@synthesize gear2;
@synthesize hintButton;
@synthesize laser;
@synthesize laser2;
@synthesize nextButton;

// This is defined in Math.h
#define M_PI 3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

SystemSoundID explosion;
NSArray *myImages;
CGPoint firstPoint;
UIImageView *deadArrow;

double iPadScale;
double currentCannonAngle;
double currentCannon2Angle;

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

    
    [problemView showProblemMarkers];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		iPadScale = 2.5;
	}
	else {
		iPadScale = 1.0;
	}
	
	nextButton.hidden = YES;
	
	deadArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
	deadArrow.userInteractionEnabled = NO;
	[self.view addSubview:deadArrow];
	
	NSMutableArray *tempImages = [[NSMutableArray alloc] init];
	
	for (int i=1; i < 17+1; i++)
	{
		[tempImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%d.png", i]]];
	}
	
	myImages = (NSArray*) tempImages;
	
	[self.view bringSubviewToFront:cannon];
	[self.view bringSubviewToFront:cannon2];
	
	laser.layer.anchorPoint = CGPointMake(0.5, 1);
	laser2.layer.anchorPoint = CGPointMake(0.5, 1);

	
	cannon.layer.anchorPoint = CGPointMake(0.5, 0.72);
	cannon.center = CGPointMake(cannon.center.x, cannon.center.y + 22);
	
	cannon2.layer.anchorPoint = CGPointMake(0.5, 0.72);
	cannon2.center = CGPointMake(cannon2.center.x, cannon2.center.y + 22);
	
	gear.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(13));
	gear2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(13));
	
	// Initialize sound
	NSString *path  = [[NSBundle mainBundle] pathForResource :@"explosion" ofType:@"wav"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &explosion);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];

    CGPoint hitbox = [problemView isHitbox:touchPoint];
    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)) && ([problemView getProblemArrowCount] > [problemView getArrowStackCount])) {
        [problemView startArrow:hitbox];
		firstPoint = touchPoint; // remember the first point of the arrow
		
        if ([problemView getArrowStackCount] == 1)
        {
            [problemView showNucleophileMarker:hitbox];
        }
    }
	
	[Animations rotateCannon:cannon towardPoint:touchPoint duration:0.5];
	[Animations rotateGear:gear towardPoint:touchPoint duration:0.5];
	
	[Animations rotateCannon:cannon2 towardPoint:touchPoint duration:0.5];
	[Animations rotateGear:gear2 towardPoint:touchPoint duration:0.5];
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
    if ([problemView isArrowInProgress]) 
    {
        [problemView setArrowEnd:touchPoint];
		
		[Animations rotateCannon:cannon2 towardPoint:touchPoint];
		[Animations rotateGear:gear2 towardPoint:touchPoint];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
	
    if ([problemView isArrowInProgress]) 
    {
		
        CGPoint hitbox = [problemView isHitbox:touchPoint];
        if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)))
		{
            if ([problemView getArrowStackCount] == 1)
            {
                int arrowStack = [problemView getArrowStackCount];
                [problemView endArrow:hitbox];
				//Checks to see if the current arrow drawn is on the correct hitbox and direction
                if (arrowStack == [problemView getArrowStackCount])
                {
                    if([problemView doesLastArrowMatchProblem]) 
                    {
                        [problemView showElectrophileMarker:hitbox];
                        
                        [self addScore:100];
                        
                        if([problemView getArrowStackCount] == [problemView getProblemArrowCount])
                        {
                            
                            // Problem was correct!
                            nextButton.hidden = NO;
                        }
                    } 
                    else 
                    {
                        [self removeScore:25];
                        [problemView removeLastArrow];
                        [problemView clearNucleophileMarker];
                        
                        [Animations fireLaser:laser fromCannon:cannon toPoint:firstPoint];
                        [Animations fireLaser:laser2 fromCannon:cannon2 toPoint:touchPoint];
                        
                        [Animations createExplosionInView:self.view atPoint:firstPoint withImages:myImages];
                        [Animations createExplosionInView:self.view atPoint:touchPoint withImages:myImages];
                        
                        [Animations shakeView:problemView power:8.0];
                    }
                } else 
                {
                    [problemView clearNucleophileMarker];
                }
            } else if ([problemView getArrowStackCount] > 1)
            {
                int arrowStack = [problemView getArrowStackCount];
                [problemView endArrow:hitbox];
                
                if (arrowStack == [problemView getArrowStackCount])
                {
                    if([problemView doesLastArrowMatchProblem])
                    {
                        if ([problemView getProblemArrowCount] == 3) {
                            
                            [self addScore:25];
                            
                        } else if ([problemView getProblemArrowCount] == 2) {
                            
                            [self addScore:50];
                        }
                        
                        if([problemView getArrowStackCount] == [problemView getProblemArrowCount])
                        {
                            
                            // Problem was correct!
                            nextButton.hidden = NO;
                        }
                    }
                    else
                    {
                        if ([problemView getProblemArrowCount] == 3) {
                            
                            [self removeScore:10];
                            
                        } else if ([problemView getProblemArrowCount] == 2) {
                            
                            [self removeScore:25];
                        }
                        [problemView removeLastArrow];
                        
                        [Animations createExplosionInView:self.view atPoint:firstPoint withImages:myImages];
                        [Animations createExplosionInView:self.view atPoint:touchPoint withImages:myImages];
                        
                        [Animations fireLaser:laser fromCannon:cannon toPoint:firstPoint];
                        [Animations fireLaser:laser2 fromCannon:cannon2 toPoint:touchPoint];
                        
                        [Animations shakeView:problemView power:8.0];
                    }
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
		}
		
    }
}

-(void) dropArrow
{	
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2];
	[UIView setAnimationCurve:5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	deadArrow.center = CGPointMake(self.view.center.x, self.view.center.y*4);
	
	// Commit the changes
	[UIView commitAnimations];
}

- (IBAction)tappedNext:(id)sender 
{
	[self goToNextProblem];
	nextButton.hidden = YES;
}

-(IBAction)hintPressed:(id)sender
{
	
	[self hintPopUp];
}

-(void)hintPopUp
{
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



- (void)viewDidUnload
{
	[self setCannon:nil];
	[self setGear:nil];
	[self setCannon2:nil];
	[self setGear2:nil];
	[self setLaser:nil];
	[self setLaser2:nil];
	[self setNextButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}


-(void) dealloc 
{
	AudioServicesDisposeSystemSoundID(explosion);
	[cannon release];
	[gear release];
	[cannon2 release];
	[gear2 release];
	[laser release];
	[laser2 release];
	[nextButton release];
    [super dealloc];
	[hintButton	release];
}

@end