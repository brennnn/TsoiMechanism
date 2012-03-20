//
//  IdentifyViewController.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IdentifyViewController.h"
#import "Element.h"

@implementation IdentifyViewController
@synthesize nextButton;
@synthesize epImage;
@synthesize npImage;
@synthesize npLabel;
@synthesize epLabel;
@synthesize npSuccessImage;
@synthesize epSuccessImage;

enum { NONE, ELECTROKNUCKLES, NUCLEOSONIC };

int draggingType = 0; // 0 = user isn't dragging anything
int answered = 0;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
		
    }
    return self;
}

-(void) showEpImageAndText
{
	[epLabel setHidden:NO];
	[epImage setHidden:NO];
	[epSuccessImage setHidden:YES];
}

-(void) showNpImageAndText
{
	[npLabel setHidden:NO];
	[npImage setHidden:NO];
	[npSuccessImage setHidden:YES];
}

-(void) showEpSuccessImage
{
	[epLabel setHidden:YES];
	[epImage setHidden:YES];
	[epSuccessImage setHidden:NO];
	
	[self moveImage:epSuccessImage duration:0.25 scale:2 x:30 y:-30];
}

-(void) showNpSuccessImage
{
	[npLabel setHidden:YES];
	[npImage setHidden:YES];
	[npSuccessImage setHidden:NO];
	
	[self moveImage:npSuccessImage duration:0.25 scale:2 x:-10 y:-30];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
//    [problemView clearElectrophileMarker];
//    [problemView clearNucleophileMarker];
    
	if (CGRectContainsPoint(epImage.frame, touchPoint) && !epImage.isHidden) // if user clicks on electrophile
	{
		draggingType = ELECTROKNUCKLES; // set type being dragged as Ep
		[problemView createMovableMarker:touchPoint ofType:1]; // create an Ep movable marker
	}
	else if (CGRectContainsPoint(npImage.frame, touchPoint) && !npImage.isHidden) // else if user clicks on a nucleophile
	{
		draggingType = NUCLEOSONIC; // set type being dragged as Np
		[problemView createMovableMarker:touchPoint ofType:2]; // create an Np movable marker
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
				NSLog(@"Guess again!");
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
				NSLog(@"Guess again!");
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
	
	[self newProblem];
}

- (void) newProblem
{
	draggingType = 0;
	
	
	[nextButton setHidden:YES];
	[self showEpImageAndText];
	[self showNpImageAndText];
	
	[self moveImage:epSuccessImage duration:0.5 scale:1 x:0 y:0];
	[self moveImage:npSuccessImage duration:0.5 scale:1 x:0 y:0];
	
//	[self moveImage:epSuccessImage duration:0.25 scale:2 x:30 y:-30];
//	[self moveImage:npSuccessImage duration:0.25 scale:2 x:-10 y:-30];
	
	[self goToNextProblem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	[self newProblem];
	
	[nextButton setHidden:YES];
	[self showEpImageAndText];
	[self showNpImageAndText];
	
}

- (void)viewDidUnload
{
	[self setEpImage:nil];
	[self setNpImage:nil];
	[self setNpLabel:nil];
	[self setEpLabel:nil];
	[self setNpSuccessImage:nil];
	[self setEpSuccessImage:nil];
	[self setNextButton:nil];
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

-(void) dealloc {
	[epImage release];
	[npImage release];
	[npLabel release];
	[epLabel release];
	[npSuccessImage release];
	[epSuccessImage release];
	[nextButton release];
    [super dealloc];
}


@end