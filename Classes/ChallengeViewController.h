//
//  ChallengeViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeViewController.h"

@interface ChallengeViewController : ModeViewController {
	IBOutlet UIButton *submitButton;
	IBOutlet UIButton *nextButton;
	bool isSecondTry;
}

@property (nonatomic) bool isSecondTry;

-(IBAction)nextProblem:(id)sender;

@end