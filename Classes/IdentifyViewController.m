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
    if (self = [super initWithNibName:nil bundle:nibBundleOrNil]) 
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
}

-(void) showNpSuccessImage
{
	[npLabel setHidden:YES];
	[npImage setHidden:YES];
	[npSuccessImage setHidden:NO];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
//    [problemView clearElectrophileMarker];
//    [problemView clearNucleophileMarker];
    
	if (CGRectContainsPoint(epImage.frame, touchPoint)) // if user clicks on electrophile
	{
		draggingType = ELECTROKNUCKLES; // set type being dragged as Ep
		[problemView createMovableMarker:touchPoint ofType:1]; // create an Ep movable marker
	}
	else if (CGRectContainsPoint(npImage.frame, touchPoint)) // else if user clicks on a nucleophile
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
	
	[problemView showNextProblem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self newProblem];
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

	
// Do the following if user releases on a element or bond:
//    if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) {
//		
//		if ([problemView isHitbox:touchPoint ofType:0]) {
//			NSLog(@"it's 0");
//		}
//		
//        if ([problemView getMovableMarkerType] == ELEMENT_ELECTROPHILE)
//        {
//            [problemView showElectrophileMarker:hitbox];
//        } else if ([problemView getMovableMarkerType] == ELEMENT_NUCLEOPHILE)
//        {
//            [problemView showNucleophileMarker:hitbox];
//        }
//    }
    
	
//	if ([problemView isMemberOfClass:[Element class]]) {
//		NSLog(@"You got it!");
//	}
//	else {
//		NSLog(@"Guess again!");
//	}