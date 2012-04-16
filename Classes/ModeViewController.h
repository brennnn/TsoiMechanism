//
//  ModeViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProblemView.h"

@interface ModeViewController : UIViewController {
    IBOutlet ProblemView *problemView;
    IBOutlet UILabel *problemNumberLabel;
    IBOutlet UILabel *scoreLabel;
	
	@private
	int score;
	int problemNumber;
}

@property (nonatomic, retain) IBOutlet ProblemView *problemView;
@property (nonatomic, retain) IBOutlet UILabel *problemNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;

// Increments and displays problemNumber and calls the next problem to be shown
-(void) goToNextProblem;

// Increments and displays the score
-(void) addScore:(int) amount;

// Decrements and displays the score
-(void) removeScore:(int) amount;

// Pops the current view controller off the stack
-(IBAction) exitView:(id)sender;

@end
