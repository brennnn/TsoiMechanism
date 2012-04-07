//
//  Animations.m
//  TsoiMechanism
//
//  Created by Derek Cannon on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Animations.h"

@implementation Animations

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

/* Rotates the specified cannon towards a certain point over a certain duration. */
+(void) rotateCannon:(UIView*)cannon towardPoint:(CGPoint)point duration:(double)duration
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:2];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	// Set the cannon's final angle
	cannon.transform = CGAffineTransformMakeRotation([self getAngleOfRotationBetweenPoint:cannon.center andPoint:point]);
	
	// Start the animation
	[UIView commitAnimations];
}

/* Rotates the specified cannon towards a certain point instantly. For use with the touchesMoved: method. */
+(void) rotateCannon:(UIView*)cannon towardPoint:(CGPoint)point
{
	cannon.transform = CGAffineTransformMakeRotation([self getAngleOfRotationBetweenPoint:cannon.center andPoint:point]);
}

+(double) getAngleOfRotationBetweenPoint:(CGPoint)pointA andPoint:(CGPoint)pointB
{
	double dy = pointA.y - pointB.y;
	double dx = pointA.x - pointB.x;
	
	return atan2(dy,dx) - DEGREES_TO_RADIANS(90);
}

/* Returns the angle of rotation of a view in radians */
+(double) getAngleOfView:(UIView*)view
{
	return atan2f(view.transform.b, view.transform.a);
}

+(void) rotateGear:(UIView*)gear towardPoint:(CGPoint)point duration:(double)duration
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:2];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	gear.transform = CGAffineTransformMakeRotation(-[self getAngleOfRotationBetweenPoint:gear.center andPoint:point] - DEGREES_TO_RADIANS(13));
	
	// Commit the changes
	[UIView commitAnimations];
}

+(void) rotateGear:(UIView*)gear towardPoint:(CGPoint)point
{
	gear.transform = CGAffineTransformMakeRotation(-[self getAngleOfRotationBetweenPoint:gear.center andPoint:point]);
}

+(int) getiPadScale
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return 2.5; // The device is an iPad running iPhone 3.2 or later.
	
	return 1.0;
}


+(void) fireLaser:(UIView*)laser fromCannon:(UIView*)cannon toPoint:(CGPoint)point
{	
	[laser setAlpha:1.0];
	
	int iPadScale = [self getiPadScale];
	double distance = sqrt(pow((point.x - laser.center.x), 2.0) + pow(point.y - laser.center.y, 2.0));
	
	laser.bounds = CGRectMake(cannon.center.x, cannon.center.y, 20 * iPadScale, distance);
	laser.center = cannon.center;
	
	laser.transform = CGAffineTransformMakeRotation([self getAngleOfRotationBetweenPoint:cannon.center andPoint:point]);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:10];
	
	[laser setAlpha:0.0];
	
	// Commit the changes
	[UIView commitAnimations];
}

// Taken from http://iphonedevelopertips.com/user-interface/move-an-image-with-animation.html
+(void) moveImage:(UIImageView *)image duration:(NSTimeInterval)duration scale:(int)scale toPoint:(CGPoint)point
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	// The transform matrix
	CGAffineTransform transform = CGAffineTransformMakeTranslation(point.x, point.y);
	image.transform = transform;
	
	CGAffineTransform scaleTo = CGAffineTransformScale(transform, scale, scale);
	image.transform = scaleTo;
	
	// Commit the changes
	[UIView commitAnimations];	
}

+(void) createExplosionInView:(UIView*)view atPoint:(CGPoint)point withImages:(NSArray*)frames
{
	int iPadScale = [self getiPadScale];
	
//	AudioServicesPlaySystemSound(explosion); // Play explosion sound FX
	UIImageView __block *explode = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140.0/2 * iPadScale, 200.0/2 * iPadScale)];
	explode.center = point;

	[UIView animateWithDuration:0.4
					  delay: 1.0
					options: UIViewAnimationOptionCurveLinear
				 animations:^{
					 explode.animationImages = frames;
					 explode.animationDuration = 1.0;
					 explode.animationRepeatCount = 1;
					 
					 [view addSubview:explode];
					 
					 [explode startAnimating];
				 }
				 completion:^(BOOL finished){
					 NSLog(@"Explosion done!");
					 explode = nil;
					 [explode release];
				 }];
	
}


// Might need to stay if BG is animated

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


@end
