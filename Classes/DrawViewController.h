//
//  DrawViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DrawViewController : ModeViewController <UIAlertViewDelegate>
{
	IBOutlet UIButton *hintButton;
	IBOutlet UIButton *nextButton;
	
	IBOutlet UIImageView *cannon;
	IBOutlet UIImageView *cannon2;
	
	IBOutlet UIImageView *gear;
	IBOutlet UIImageView *gear2;
	
	IBOutlet UIImageView *laser;
	IBOutlet UIImageView *laser2;
	
	SystemSoundID explosion;
	NSArray *myImages;
	CGPoint firstPoint;
	UIImageView *deadArrow;
	
	double iPadScale;
	double currentCannonAngle;
	double currentCannon2Angle;
}
@property (retain, nonatomic) IBOutlet UIImageView *cannon;
@property (retain, nonatomic) IBOutlet UIImageView *gear;
@property (retain, nonatomic) IBOutlet UIImageView *cannon2;
@property (retain, nonatomic) IBOutlet UIImageView *gear2;

@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (retain, nonatomic) IBOutlet UIImageView *laser;
@property (retain, nonatomic) IBOutlet UIImageView *laser2;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;

-(IBAction)tappedNext:(id)sender;
-(IBAction)hintPressed:(id)sender;
-(void) hintPopUp;

-(void) dropArrow;


@end
