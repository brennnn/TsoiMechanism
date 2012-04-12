//
//  Animations.h
//  TsoiMechanism
//
//  Created by Derek Cannon on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animations : NSObject
{
	
}

// Cannon related
+(void) rotateCannon:(UIView*)cannon towardPoint:(CGPoint)point duration:(double)duration;
+(void) rotateCannon:(UIView*)cannon towardPoint:(CGPoint)point;

// Gear related
+(void) rotateGear:(UIView*)gear towardPoint:(CGPoint)point duration:(double)duration;
+(void) rotateGear:(UIView*)gear towardPoint:(CGPoint)point;

// Laser related
+(void) fireLaser:(UIView*)laser fromCannon:(UIView*)cannon toPoint:(CGPoint)point;

// Explosion related
+(void) createExplosionInView:(UIView*)view atPoint:(CGPoint)point withImages:(NSArray*)frames;

// Angle calculations
+(double) getAngleOfRotationBetweenPoint:(CGPoint)pointA andPoint:(CGPoint)pointB;


// ??
+(void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration scale:(int)scale toPoint:(CGPoint)point;

+ (void)shakeView:(UIView *)viewToShake power:(CGFloat)t;
+(void) createScoreAnimationInView:(UIView*)view withText:(NSString*)string fromPoint:(CGPoint)begin toPoint:(CGPoint)end textColor:(UIColor*)textColor;

+(double) getAngleOfView:(UIView*)view;
+(int) getiPadScale;


@end