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
#import "Animations.h"

@implementation IdentifyViewController
@synthesize nextButton;
@synthesize cannon;
@synthesize gear;
@synthesize laser;
@synthesize background;
@synthesize epImage;
@synthesize npImage;

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

SystemSoundID explosion;
NSArray *explosionFrames; // The animation frames (images) of the explosion
NSArray *explosionBlueFrames;
NSArray *explosionRedFrames;
double iPadScale;

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
	
	[nextButton setHidden:YES];
	[self showEpImageAndText];
	[self showNpImageAndText];
	
	NSMutableArray *tempYellowImages = [[NSMutableArray alloc] init];
	NSMutableArray *tempRedImages = [[NSMutableArray alloc] init];
	NSMutableArray *tempBlueImages = [[NSMutableArray alloc] init];
	
	[self.view bringSubviewToFront:cannon];
	
	for (int i=0; i <= 15; i++)
	{
		[tempYellowImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%d.png", i+1]]];
		[tempRedImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"explode_red%d.png", i]]];
		[tempBlueImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"explode_blue%d.png", i]]];
	}
	
	explosionFrames = (NSArray*) tempYellowImages;
	explosionRedFrames = (NSArray*) tempRedImages;
	explosionBlueFrames = (NSArray*) tempBlueImages;
	
	cannon.layer.anchorPoint = CGPointMake(0.5, 0.72);
	cannon.center = CGPointMake(cannon.center.x, cannon.center.y + 15);
	
	laser.layer.anchorPoint = CGPointMake(0.5, 1);
	
	gear.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(12));
	
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

-(void) showEpImageAndText
{
	[epImage setHidden:NO];
}

-(void) showNpImageAndText
{
	[npImage setHidden:NO];
}

-(void) showEpSuccessImage
{
	[epImage setHidden:YES];
}

-(void) showNpSuccessImage
{
	[npImage setHidden:YES];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
    
	[Animations rotateCannon:cannon towardPoint:touchPoint duration:0.5];
	[Animations rotateGear:gear towardPoint:touchPoint];
	
	if (CGRectContainsPoint(epImage.frame, touchPoint) && !epImage.isHidden && [epImage isUserInteractionEnabled]) // if user clicks on electrophile
	{
		draggingType = ELECTROKNUCKLES; // set type being dragged as Ep
		[problemView createMovableMarker:touchPoint ofType:1]; // create an Ep movable marker
		epImage.hidden = YES;
		[epImage setUserInteractionEnabled:NO];
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

}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:problemView];
	
	[Animations rotateCannon:cannon towardPoint:touchPoint];
	[Animations rotateGear:gear towardPoint:touchPoint];
	
    [problemView setMovableMarkerPosition:touchPoint];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
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
				[self addScore:50];
				
				[Animations createScoreAnimationInView:self.view withText:@"+50" fromPoint:self.view.center toPoint:scoreLabel.center textColor:[UIColor greenColor]];
				
				[self recordAnswer];
			}
			else
			{
                if (score > 0)
                {
                    [self removeScore:10];
                }
                
				[Animations fireLaser:laser fromCannon:cannon toPoint:touchPoint];
				[Animations createExplosionInView:self.view atPoint:touchPoint withImages:explosionRedFrames];
				AudioServicesPlayAlertSound(explosion);
				
				// If actually put on a element or bond:
				if (!CGPointEqualToPoint([problemView isHitbox:touchPoint], CGPointMake(-1.0f, -1.0f)))
				{
					[Animations shakeView:problemView power:4.0];
				}
				
				[self fadeInDraggableMarker:epImage];
			}
			
			break;
			
		case NUCLEOSONIC: // If the Np was being dragged
			
			hitbox = [problemView isHitbox:touchPoint ofType:ELEMENT_NUCLEOPHILE]; // get the (X,Y) center of the Np element
			
			if (!CGPointEqualToPoint(hitbox, CGPointMake(-1.0f, -1.0f))) // if released on correct answer*
			{
				[problemView showNucleophileMarker:hitbox]; // create a marker at that spot
				[self showNpSuccessImage];
				[self addScore:50];
				[Animations createScoreAnimationInView:self.view withText:@"+50" fromPoint:self.view.center toPoint:scoreLabel.center textColor:[UIColor greenColor]];
				[self recordAnswer];
			}
			else
			{
                if (score > 0)
                {
                    [self removeScore:10];
                }
                
				[Animations fireLaser:laser fromCannon:cannon toPoint:touchPoint];
				[Animations createExplosionInView:self.view atPoint:touchPoint withImages:explosionBlueFrames];
				AudioServicesPlayAlertSound(explosion);
				
				// If actually put on a element or bond:
				if (!CGPointEqualToPoint([problemView isHitbox:touchPoint], CGPointMake(-1.0f, -1.0f)))
				{
					[Animations shakeView:problemView power:4.0];
				}
				
				[self fadeInDraggableMarker:npImage];
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


// A superior fadeInMarkers method, in construction:
-(void) fadeInDraggableMarker:(UIView*)marker
{
	if (!marker.isHidden) {
		return;
	}
	
	int orginialY = marker.center.y; // Save the position the marker will eventually return to.
	marker.center = CGPointMake(marker.center.x, -marker.frame.size.height/2); // move the marker off of the top of the screen
	
	[UIView animateWithDuration:0.4 
						  delay:1.0 
						options:UIViewAnimationOptionCurveEaseIn 
					 animations:^{
						 [marker setHidden:NO];
						 marker.center = CGPointMake(marker.center.x, orginialY);
					 }
					 completion:^(BOOL finished){
						 
						 [UIView animateWithDuration:0.2
											   delay:0
											 options:UIViewAnimationOptionCurveEaseOut 
										  animations:^{ marker.center = CGPointMake(marker.center.x, marker.center.y - 30 * iPadScale); } 
										  completion:^(BOOL finished){
											  
											  [UIView animateWithDuration:0.2
																	delay:0
																  options:UIViewAnimationOptionCurveEaseIn
															   animations:^{ marker.center = CGPointMake(marker.center.x, orginialY); } 
															   completion:^(BOOL finished){
																   
																   [marker setUserInteractionEnabled:YES];
																   
															   }];
											  
										  }];
					 }];
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
	
	[Animations rotateCannon:cannon towardPoint:CGPointMake(self.view.center.x+10, self.view.center.y) duration:0.5];
	[Animations rotateGear:gear towardPoint:CGPointMake(self.view.center.x+10, self.view.center.y)];
	
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
	
	[self goToNextProblem];
}

- (void)viewDidUnload
{
	[self setEpImage:nil];
	[self setNpImage:nil];
	[self setNextButton:nil];
	[self setCannon:nil];
	[self setGear:nil];
	[self setLaser:nil];
	[self setBackground:nil];
	explosionFrames = nil;
	cannon = nil;
	gear = nil;
	npImage = nil;
	epImage = nil;
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

-(void) dealloc 
{
	AudioServicesDisposeSystemSoundID(explosion);
	[epImage release];
	[npImage release];
	[nextButton release];
	[cannon release];
	[gear release];
	[explosionFrames release];
	[laser release];
	[background release];
    [super dealloc];
}


@end