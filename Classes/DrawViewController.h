//
//  DrawViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeViewController.h"

@interface DrawViewController : ModeViewController <UIAlertViewDelegate>
{
	UIButton *hintButton;
}
@property (retain, nonatomic) IBOutlet UIImageView *cannon;
@property (retain, nonatomic) IBOutlet UIImageView *gear;
@property (retain, nonatomic) IBOutlet UIImageView *cannon2;
@property (retain, nonatomic) IBOutlet UIImageView *gear2;

@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (retain, nonatomic) IBOutlet UIImageView *laser;
@property (retain, nonatomic) IBOutlet UIImageView *laser2;

-(IBAction)hintPressed:(id)sender;
-(void) setDrawInstructions;
-(void) hintPopUp;

-(UIImage*) getArrowImageFrom:(CGPoint) pointA and:(CGPoint) pointB;

@end
