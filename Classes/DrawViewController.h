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
	int correctValue;
	int incorrectValue;
}

@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, assign) int correctValue;
@property (nonatomic, assign) int incorrectValue;

-(IBAction)hintPressed:(id)sender;
-(void) setDrawInstructions;
-(void) hintPopUp;
-(void) getCorrectScore;
-(void) getinCorrectScore;

@end
