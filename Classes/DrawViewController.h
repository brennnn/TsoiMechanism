//
//  DrawViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeViewController.h"

@interface DrawViewController : ModeViewController
{
	UIButton *instructionButton;
	UIButton *hintButton;
}

@property (nonatomic, retain) IBOutlet UIButton *instructionButton;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;

-(IBAction)instructionPressed:(id)sender;
-(IBAction)hintPressed:(id)sender;

@end
