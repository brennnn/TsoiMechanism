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
	int tries;
}

-(IBAction)nextAct:(id)sender;
-(IBAction)submitAct:(id)sender;
-(IBAction)eraseAct:(id)sender;

@end