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
	IBOutlet UIButton *undoButtons;
	int tries;
	
	IBOutlet UIImageView *megalaser;
	IBOutlet UIImageView *charge;
}

@property (retain, nonatomic) IBOutlet UIImageView *megalaser;
@property (retain, nonatomic) IBOutlet UIImageView *charge;
@property (retain, nonatomic) IBOutlet UIButton *undoButtons;
@property (retain, nonatomic) IBOutlet UIView *cannonContainerView;

-(IBAction)nextAct:(id)sender;
-(IBAction)submitAct:(id)sender;
-(IBAction)eraseAct:(id)sender;

@end