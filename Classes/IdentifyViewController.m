//
//  IdentifyViewController.m
//  TsoiMechanism
//
//  Created by Derek Cannon on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IdentifyViewController.h"
#import "Element.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation IdentifyViewController
@synthesize nextButton;
@synthesize cannon;
@synthesize gear;
@synthesize laser;
@synthesize background;
@synthesize epImage;
@synthesize npImage;

SystemSoundID explosion;
NSArray *myImages;
double currentCannonAngle;
double iPadScale;

enum { NONE, ELECTROKNUCKLES, NUCLEOSONIC };

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

int draggingType = 0; // 0 = user isn't dragging anything
int answered = 0;

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
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 3.2 or later.
		iPadScale = 2.5;
	}
	else {
		iPadScale = 1.0;
	}
	
	[epImage setUserInteractionEnabled:YES];
	[npImage setUserInteractionEnabled:YES];
	
	currentCannonAngle = DEGREES_TO_RADIANS(0);
	
	[nextButton setHidden:YES];
	[self showEpImageAndText];
	[self showNpImageAndText];
	
	NSMutableArray *tempImages = [[NSMutableArray alloc] init];
	
//	laser = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, 20, 200)];
//	[laser setImage:[UIImage imageNamed:@"laser.png"]];
//	[self.view addSubview:laser];
//	[self.view insertSubview:laser atIndex:1];
	[self.view bringSubviewToFront:cannon];
	
	
	for (int i=1; i < 17+1; i++)
	{
		[tempImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%d.png", i]]];
		
//		NSLog(@"explosion%d.png", i);
	}
	
	myImages = (NSArray*) tempImages;
	
	cannon.layer.anchorPoint = CGPointMake(0.5, 0.72);
	cannon.center = CGPointMake(cannon.center.x, cannon.center.y + 15);
	
	laser.layer.anchorPoint = CGPointMake(0.5, 1);
//	laser.layer.zPosition = 100;
//	[self.view bringSubviewToFront:cannon];
	
	gear.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(12));
	
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

-(void) showEpImageAndText
{
	//	[epLabel setHidden:NO];
	[epImage setHidden:NO];
	//	[epSuccessImage setHidden:YES];
}

-(void) showNpImageAndText
{
	//	[npLabel setHidden:NO];
	[npImage setHidden:NO];
	//	[npSuccessImage setHidden:YES];
}

-(void) showEpSuccessImage
{
	//	[epLabel setHidden:YES];
	[epImage setHidden:YES];
	//	[epSuccessImage setHidden:NO];
	
	//	[self moveImage:epSuccessImage duration:0.25 scale:2 x:30 y:-30];
}

-(void) showNpSuccessImage
{
	//	[npLabel setHidden:YES];
	[npImage setHidden:YES];
	//	[npSuccessImage setHidden:NO];
	
	//	[self moveImage:npSuccessImage duration:0.25 scale:2 x:-10 y:-30];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
	[self rotateCannon:cannon TowardPointX:touchPoint.x Y:touchPoint.y];
	[self rotateGear:gear TowardPointX:touchPoint.x Y:touchPoint.y];
	
	if (CGRectContainsPoint(epImage.frame, touchPoint) && !epImage.isHidden && [epImage isUserInteractionEnabled]) // if user clicks on electrophile
	{
		draggingType = ELECTROKNUCKLES; // set type being dragged as Ep
		[problemView createMovableMarker:touchPoint ofType:1]; // create an Ep movable marker
		epImage.hidden = YES;
		[epImage setUserInteractionEnabled:NO];
//		[epImage setAlpha:0.0];
	}
	else if (CGRectContainsPoint(npImage.frame, touchPoint) && !npImage.isHidden && [npImage isUserInteractionEnabled]) // else if user clicks on a nucleophile
	{
		draggingType = NUCLEOSONIC; // set type being dragged as Np
		[problemView createMovableMarker:touchPoint ofType:2]; // create an Np movable marker
		npImage.hidden = YES;
		[npImage setUserInteractionEnabled:NO];
//		[npImage setAlpha:0.0];
	}
	else // if user clicks on neither of those
	{
		draggingType = NONE; // set type being dragged as nothing
	}
	
	//	
	//    [problemView createMovableMarker:touchPoint ofType:(arc4random()%2)+1];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
	float dy = cannon.center.y - touchPoint.y;
	float dx = cannon.center.x - touchPoint.x;

	currentCannonAngle = atan2(dy,dx) - DEGREES_TO_RADIANS(90);
	
	cannon.transform = CGAffineTransformMakeRotation(currentCannonAngle);
	gear.transform = CGAffineTransformMakeRotation(-atan2(dy,dx));
	
    [problemView setMovableMarkerPosition:touchPoint];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject]; // make a touch variable to easily reference touch events
    CGPoint touchPoint = [touch locationInView:problemView]; // get the (X,Y) coordinates that were touched
    CGPoint hitbox;
	
	switch (draggingType) // based on the dragging type, do the following on the release of a finger:
	{
		case NONE:
			// Nothing is being dragged... do nothing!
			
			// Maybe later we can make the Ep and Np buttons flash so the user
			// knows to do something relating to them
			
			break;
			
		case ELECTROKNUCKLES: // If an Ep was being dragged
			
			hitbox = [problemView isHitbox:touchPoint ofType:ELEMENT_ELECTROPHILE]; // get the (X,Y) center of the Ep element
			
			if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) // if released on correct answer*
			{
				[problemView showElectrophileMarker:hitbox]; // create a marker at that spot
				[self showEpSuccessImage];
				
				[self recordAnswer];
			}
			else
			{
				//				NSLog(@"Guess again!");
				[self createExplosionAtX:touchPoint.x Y:touchPoint.y];
				[self fireLaserFromCannonToPoint:touchPoint];
				[self fadeInMarkers];
			}
			
			break;
			
		case NUCLEOSONIC: // If the Np was being dragged
			
			hitbox = [problemView isHitbox:touchPoint ofType:ELEMENT_NUCLEOPHILE]; // get the (X,Y) center of the Np element
			
			if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) // if released on correct answer*
			{
				[problemView showNucleophileMarker:hitbox]; // create a marker at that spot
				[self showNpSuccessImage];
				
				[self recordAnswer];
			}
			else
			{
				//				NSLog(@"Guess again!");
				[self createExplosionAtX:touchPoint.x Y:touchPoint.y];
				[self fireLaserFromCannonToPoint:touchPoint];
				[self fadeInMarkers];
			}
			
			break;
			
		default:
			break;
	}
	
	// * this code works because if the current hovered on item is, for example an Np, and we're looking for an Np,
	//   it will return the center of that Np. If the clicked on it's not an Np, it will return (-1.0,-1.0). So if the center point
	//   is not equal to (-1.0, -1.0), we know that the element hovered over is of that type (either Np or Ep)
	
	[problemView clearMovableMarker]; // either way, the movable marker is cleared
	
	
}

- (void) fadeInMarkers
{
	// If neither are hidden, why do anything!?!?!?!
	if (!npImage.isHidden && !epImage.isHidden) {
		return;
	}
	
	int yPos;
	int currentMarker;
	
	if (npImage.isHidden) {
		yPos = npImage.center.y;
		currentMarker = NUCLEOSONIC;
		npImage.center = CGPointMake(npImage.center.x, -30 * iPadScale);
	}
	else if (epImage.isHidden) {
		currentMarker = ELECTROKNUCKLES;
		yPos = epImage.center.y;
		epImage.center = CGPointMake(epImage.center.x, -30 * iPadScale);
	}
		
	[UIView animateWithDuration:0.4
						  delay: 1.0
						options: UIViewAnimationOptionCurveEaseIn
					 animations:^{
						if (npImage.isHidden) {
							npImage.center = CGPointMake(npImage.center.x, yPos);
							npImage.hidden = NO;
						}
						else if (epImage.isHidden) {
							epImage.center = CGPointMake(epImage.center.x, yPos);
							epImage.hidden = NO;
						}
					 }
					 completion:^(BOOL finished){
						 // once the marker hits the scale, bounce that baby!!!
						 [UIView animateWithDuration:0.2
											   delay: 0.0
											 options: UIViewAnimationOptionCurveEaseOut
										  animations:^{
											  if (currentMarker == NUCLEOSONIC) {
												  npImage.center = CGPointMake(npImage.center.x, npImage.center.y - 30 * iPadScale);
												  npImage.hidden = NO;
											  }
											  else if (currentMarker == ELECTROKNUCKLES) {
												  epImage.center = CGPointMake(epImage.center.x, epImage.center.y - 30 * iPadScale);
												  epImage.hidden = NO;
											  }
										  }
										  completion:^(BOOL finished){
											  // once the marker hits the scale, bounce that baby!!!
											  [UIView animateWithDuration:0.2
																	delay: 0.0
																  options: UIViewAnimationOptionCurveEaseIn
															   animations:^{
																   if (currentMarker == NUCLEOSONIC) {
																	   npImage.center = CGPointMake(npImage.center.x, npImage.center.y + 30 * iPadScale);
																	   npImage.hidden = NO;
																   }
																   else if (currentMarker == ELECTROKNUCKLES) {
																	   epImage.center = CGPointMake(epImage.center.x, epImage.center.y + 30 * iPadScale);
																	   epImage.hidden = NO;
																   }
															   }
															   completion:^(BOOL finished){
																   // once the marker hits the scale, bounce that baby!!!
																   [epImage setUserInteractionEnabled:YES];
																   [npImage setUserInteractionEnabled:YES];
															   }];
										  }];
					 }];
}

-(void) fadeInMarkersBounce:(NSString*) animationID finished:(NSNumber*) finished context:(void*) context 
{
	NSLog(@"Was called!");
}

-(void) fireLaserFromCannonToPoint:(CGPoint)touchPoint
{
	[laser setAlpha:1.0];
	
	double distance = sqrt(pow((touchPoint.x - laser.center.x), 2.0) + pow(touchPoint.y - laser.center.y, 2.0));
	
	laser.bounds = CGRectMake(cannon.center.x, cannon.center.y, 20 * iPadScale, distance);
	laser.center = cannon.center;
	
	laser.transform = CGAffineTransformMakeRotation(currentCannonAngle);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:10];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	
	[laser setAlpha:0.0];
	
	// Commit the changes
	[UIView commitAnimations];
}

- (void) recordAnswer
{
	answered++;
	
	if (answered >= 2) {
		[nextButton setHidden:NO];
		answered = 0;
	}
}

- (IBAction)tappedNext:(UIButton *)sender
{
	// Clear markers
	[problemView clearElectrophileMarker];
	[problemView clearNucleophileMarker];
	
	
	[self rotateCannon:cannon TowardPointX:self.view.center.x+10 Y:self.view.center.y];
	[self rotateGear:gear TowardPointX:self.view.center.x+10 Y:self.view.center.y];
	
	[self newProblem];
}

- (void) newProblem
{
	draggingType = 0;
	
	
	[nextButton setHidden:YES];
	[self showEpImageAndText];
	[self showNpImageAndText];
	
	[epImage setUserInteractionEnabled:YES];
	[npImage setUserInteractionEnabled:YES];
	
	//	[self moveImage:epSuccessImage duration:0.5 scale:1 x:0 y:0];
	//	[self moveImage:npSuccessImage duration:0.5 scale:1 x:0 y:0];
	
	[self goToNextProblem];
}

- (void)viewDidUnload
{
	[self setEpImage:nil];
	[self setNpImage:nil];
	//	[self setNpLabel:nil];
	//	[self setEpLabel:nil];
	//	[self setNpSuccessImage:nil];
	//	[self setEpSuccessImage:nil];
	[self setNextButton:nil];
	[self setCannon:nil];
	[self setGear:nil];
	[self setLaser:nil];
	[self setBackground:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

// Taken from http://iphonedevelopertips.com/user-interface/move-an-image-with-animation.html
- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
			scale:(int)scale x:(CGFloat)x y:(CGFloat)y
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	//	[UIView setAnimationCurve:curve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	// The transform matrix
	CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
	image.transform = transform;
	
	CGAffineTransform scaleTo = CGAffineTransformScale(transform, scale, scale);//CGAffineTransformMakeTranslation(x, y);
	image.transform = scaleTo;
	
	// Commit the changes
	[UIView commitAnimations];
	
}

-(void) createExplosionAtX:(int)x Y:(int)y
{
	AudioServicesPlaySystemSound(explosion); // Play explosion sound FX
	UIImageView *explode = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140.0/2 * iPadScale, 200.0/2 * iPadScale)];
	
	explode.center = CGPointMake(x, y);
	
	explode.animationImages = myImages;
	explode.animationDuration = 1.0;
	explode.animationRepeatCount = 1;
	
	[self.view addSubview:explode];
	[explode startAnimating];
	
	[explode release];
	
}

//- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat clockwise:(bool)clockwise;
//{
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration * (clockwise ? 1 : -1) ];
//    rotationAnimation.duration = duration;
//    rotationAnimation.cumulative = YES; 
//	rotationAnimation.repeatCount = (repeat == -1 ? HUGE_VALF : repeat);
//	
//    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//}

-(void) rotateCannon:(UIView*)c TowardPointX:(int)x Y:(int)y;
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:2];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	float dy = c.center.y - y;
	float dx = c.center.x - x;
	
	currentCannonAngle = atan2(dy,dx) - DEGREES_TO_RADIANS(90); // ugh, sloppy and unflexible (assigns only to one cannon)
	
	cannon.transform = CGAffineTransformMakeRotation(currentCannonAngle);

//	c.transform = CGAffineTransformMakeRotation(atan2(dy,dx) - DEGREES_TO_RADIANS(95));
	
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

-(void) dealloc {
	AudioServicesDisposeSystemSoundID(explosion);
	[epImage release];
	[npImage release];
	//	[npLabel release];
	//	[epLabel release];
	//	[npSuccessImage release];
	//	[epSuccessImage release];
	[nextButton release];
	[cannon release];
	[gear release];
	[myImages release];
	[laser release];
	[background release];
    [super dealloc];
}


@end