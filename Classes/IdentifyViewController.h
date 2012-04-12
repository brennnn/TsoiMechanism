//
//  IdentifyViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeViewController.h"

@interface IdentifyViewController : ModeViewController
{
    IBOutlet UIImageView *epImage;
    IBOutlet UIImageView *npImage;
    IBOutlet UIButton *nextButton;
	IBOutlet UIImageView *cannon;
	IBOutlet UIImageView *gear;
	IBOutlet UIImageView *laser;
	IBOutlet UIImageView *background;
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

@end
