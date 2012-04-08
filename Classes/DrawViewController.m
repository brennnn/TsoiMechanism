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
		[self setDrawInstructions];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [problemView showProblemMarkers];
	
//	problemView.backgroundColor = [UIColor redColor];
//	self.view.backgroundColor = [UIColor redColor];
	
	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 3.2 or later.
		iPadScale = 2.5;
	}
	else {
		iPadScale = 1.0;
	}
	
	deadArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
	deadArrow.userInteractionEnabled = NO;
	[self.view addSubview:deadArrow];
	
	NSMutableArray *tempImages = [[NSMutableArray alloc] init];
	
	for (int i=1; i < 17+1; i++)
	{
		[tempImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%d.png", i]]];
		
//		NSLog(@"explosion%d.png", i);
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
		//		AudioServicesPlaySystemSound(explosion);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
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
		firstPoint = touchPoint; // remember the first point of the arrow
		
        if ([problemView getArrowStackCount] == 1)
        {
            [problemView showNucleophileMarker:hitbox];
        }
    }
	
	[self rotateCannon:cannon TowardPointX:touchPoint.x Y:touchPoint.y];
	[self rotateGear:gear TowardPointX:touchPoint.x Y:touchPoint.y];
	
	[self rotateCannon:cannon2 TowardPointX:touchPoint.x Y:touchPoint.y];
	[self rotateGear:gear2 TowardPointX:touchPoint.x Y:touchPoint.y];
}

-(void) rotateCannon:(UIView*)c TowardPointX:(int)x Y:(int)y;
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:2];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	float dy = c.center.y - y;
	float dx = c.center.x - x;
	
	c.transform = CGAffineTransformMakeRotation(atan2(dy,dx) - DEGREES_TO_RADIANS(90));
	
	// Commit the changes
	[UIView commitAnimations];
}

-(void) rotateGear:(UIView*)g TowardPointX:(int)x Y:(int)y;
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:2];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	float dy = g.center.y - y;
	float dx = g.center.x - x;
	
	g.transform = CGAffineTransformMakeRotation(-atan2(dy,dx) - DEGREES_TO_RADIANS(13));
	
	// Commit the changes
	[UIView commitAnimations];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
    if ([problemView isArrowInProgress]) {
        [problemView setArrowEnd:touchPoint];
    }
	
	if ([problemView isArrowInProgress]) {
		
		float dy = cannon2.center.y - touchPoint.y;
		float dx = cannon2.center.x - touchPoint.x;
		
		cannon2.transform = CGAffineTransformMakeRotation(atan2(dy,dx) - DEGREES_TO_RADIANS(90));
		gear2.transform = CGAffineTransformMakeRotation(-atan2(dy,dx) - DEGREES_TO_RADIANS(13));
	}
	
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
	
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
				} 
				else 
				{
					NSLog(@"Arrow does not Match");
					[problemView removeLastArrow];
					[problemView clearNucleophileMarker];
//					[self hintPopUp];
					
					[Animations fireLaser:laser fromCannon:cannon toPoint:firstPoint];
					[Animations fireLaser:laser2 fromCannon:cannon2 toPoint:touchPoint];
					
					[Animations createExplosionInView:self.view atPoint:firstPoint withImages:myImages];
					[Animations createExplosionInView:self.view atPoint:touchPoint withImages:myImages];
					
					[deadArrow setImage:[self getArrowImageFrom:touchPoint and:firstPoint]];
					deadArrow.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
					[self dropArrow];
				}
            }
			
			if ([problemView getArrowStackCount] > 1)
            {
				//NSLog(@"%d",!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f)));
				if([problemView doesLastArrowMatchProblem])
				{
					NSLog(@"Arrow Match past first");
					[problemView showElectrophileMarker:hitbox];
					
					if([problemView getArrowStackCount] == [problemView getProblemArrowCount])
					{
//						UIAlertView *hintView = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Go to the next problem." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
//						[hintView show];
//						[hintView release];
						
						// Problem was correct!
						
					}
				}
				else
				{
					NSLog(@"Arrow does not Match past first");
					[problemView removeLastArrow];
					
					[Animations createExplosionInView:self.view atPoint:firstPoint withImages:myImages];
					[Animations createExplosionInView:self.view atPoint:touchPoint withImages:myImages];
					
					[Animations fireLaser:laser fromCannon:cannon toPoint:firstPoint];
					[Animations fireLaser:laser2 fromCannon:cannon2 toPoint:touchPoint];
					
					
//					[self hintPopUp];
					
//					[self getArrowImageFrom:firstPoint and:touchPoint];
					[deadArrow setImage:[self getArrowImageFrom:touchPoint and:firstPoint]];
					deadArrow.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
					[self dropArrow];
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
		[self goToNextProblem];
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



- (void)viewDidUnload
{
	[self setCannon:nil];
	[self setGear:nil];
	[self setCannon2:nil];
	[self setGear2:nil];
	[self setLaser:nil];
	[self setLaser2:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

-(UIImage*) getArrowImageFrom:(CGPoint) pointA and:(CGPoint) pointB
{
	float width = 480.0f;
	float height = 320.0f;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	CGContextSetRGBStrokeColor(context, 140.0f/255.0f, 200.0f/255.0f, 60.0f/255.0f, 1.0f);
	CGContextSetLineWidth(context, 2.0f);
	CGContextMoveToPoint(context, pointA.x, pointA.y);
	
	float dx = pointA.x - pointB.x;
	float dy = pointB.y - pointA.y;
	float dist = sqrtf(dx*dx + dy*dy);
	
	float length = 60.0;
	
	float x1p = pointA.x + length * (pointB.y-pointA.y) / dist;
	float y1p = pointA.y + length * (pointA.x-pointB.x) / dist;
	float x2p = pointB.x + length * (pointB.y-pointA.y) / dist;
	float y2p = pointB.y + length * (pointA.x-pointB.x) / dist;
	
	CGPoint cp1 = CGPointMake(x1p,y1p);
	CGPoint cp2 = CGPointMake(x2p,y2p);
	
	CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, pointB.x, pointB.y);
	CGContextStrokePath(context);
	
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	UIImage *arrowImage = [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	return arrowImage;	
}


-(void) dealloc {
	AudioServicesDisposeSystemSoundID(explosion);
	[cannon release];
	[gear release];
	[cannon2 release];
	[gear2 release];
	[laser release];
	[laser2 release];
    [super dealloc];
	[hintButton	release];
}

@end


//-(void) fireLaserFromFirstCannon
//{
//	[laser setAlpha:1.0];
//	
//	double distance = sqrt(pow((firstPoint.x - laser.center.x), 2.0) + pow(firstPoint.y - laser.center.y, 2.0));
//	
//	laser.bounds = CGRectMake(cannon.center.x, cannon.center.y, 20 * iPadScale, distance);
//	laser.center = cannon.center;
//	
//	float dy = cannon.center.y - firstPoint.y;
//	float dx = cannon.center.x - firstPoint.x;
//	
//	float angle = atan2(dy,dx) - DEGREES_TO_RADIANS(90);
//	
//	laser.transform = CGAffineTransformMakeRotation(angle);
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:1.0];
//	[UIView setAnimationCurve:10];
//	//	[UIView setAnimationBeginsFromCurrentState:YES];
//	
//	[laser setAlpha:0.0];
//	
//	// Commit the changes
//	[UIView commitAnimations];
//}
//
//-(void) fireLaserFromCannon2ToPoint:(CGPoint)touchPoint
//{
//	[laser2 setAlpha:1.0];
//	
//	double distance = sqrt(pow((touchPoint.x - laser2.center.x), 2.0) + pow(touchPoint.y - laser2.center.y, 2.0));
//	
//	laser2.bounds = CGRectMake(cannon.center.x, cannon.center.y, 20 * iPadScale, distance);
//	laser2.center = cannon2.center;
//	
//	float dy = cannon2.center.y - touchPoint.y;
//	float dx = cannon2.center.x - touchPoint.x;
//	
//	float angle = atan2(dy,dx) - DEGREES_TO_RADIANS(90);
//	
//	laser2.transform = CGAffineTransformMakeRotation(angle);
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:1.0];
//	[UIView setAnimationCurve:10];
//	//	[UIView setAnimationBeginsFromCurrentState:YES];
//	
//	[laser2 setAlpha:0.0];
//	
//	// Commit the changes
//	[UIView commitAnimations];
//}

//					[self createExplosionAt:firstPoint];
//					[self createExplosionAt:touchPoint];
//					[self fireLaserFromFirstCannon];
//					[self fireLaserFromCannon2ToPoint:touchPoint];

//					NSLog(@"firstPoint (%i, %i); touchPoint (%i, %i)", firstPoint.x, firstPoint.y, touchPoint.x, touchPoint.y);
//					[self createExplosionAt:firstPoint];
//					[self createExplosionAt:touchPoint];
//					[self fireLaserFromFirstCannon];
//					[self fireLaserFromCannon2ToPoint:touchPoint];

//-(void) createArrowFallingFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB
//{
//	NSLog(@"I was called!");
//	
//}

//	float dy = c.center.y - y;
//	float dx = c.center.x - x;

//	c.transform = CGAffineTransformMakeRotation(atan2(dy,dx) - DEGREES_TO_RADIANS(95));

//-(void) createExplosionAt:(CGPoint)location
//{
//	AudioServicesPlaySystemSound(explosion); // Play explosion sound FX
//	UIImageView *explode = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140.0/2 * iPadScale, 200.0/2 * iPadScale)];
//	
//	explode.center = location;
//	
//	explode.animationImages = myImages;
//	explode.animationDuration = 1.0;
//	explode.animationRepeatCount = 1;
//	
//	[self.view addSubview:explode];
//	[explode startAnimating];
//	
//	[explode release];
//	
//}
