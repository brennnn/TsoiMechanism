//
//  IdentifyViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface IdentifyViewController : ModeViewController
{
    IBOutlet UIImageView *epImage;
    IBOutlet UIImageView *npImage;
    IBOutlet UIButton *nextButton;
	IBOutlet UIImageView *cannon;
	IBOutlet UIImageView *gear;
	IBOutlet UIImageView *laser;
	IBOutlet UIImageView *background;
	
	SystemSoundID explosion;
	NSArray *explosionFrames; // The animation frames (images) of the explosion
	NSArray *explosionBlueFrames;
	NSArray *explosionRedFrames;
	double iPadScale;
	
	
	
	int draggingType; // 0 = user isn't dragging anything
	int answered;
	
}

@property (retain, nonatomic) IBOutlet UIImageView *epImage;
@property (retain, nonatomic) IBOutlet UIImageView *npImage;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UIImageView *cannon;
@property (retain, nonatomic) IBOutlet UIImageView *gear;
@property (retain, nonatomic) IBOutlet UIImageView *laser;
@property (retain, nonatomic) IBOutlet UIImageView *background;


-(IBAction) tappedNext:(UIButton *)sender;
-(void) recordAnswer;
-(void) newProblem;

-(void) showEpImageAndText;
-(void) showNpImageAndText;
-(void) showEpSuccessImage;
-(void) showNpSuccessImage;

-(void) fadeInDraggableMarker:(UIView*)marker;


@end
