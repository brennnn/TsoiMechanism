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

@property (retain, nonatomic) IBOutlet UIImageView *epImage;
@property (retain, nonatomic) IBOutlet UIImageView *npImage;
@property (retain, nonatomic) IBOutlet UILabel *npLabel;
@property (retain, nonatomic) IBOutlet UILabel *epLabel;
@property (retain, nonatomic) IBOutlet UIImageView *npSuccessImage;
@property (retain, nonatomic) IBOutlet UIImageView *epSuccessImage;
- (IBAction)tappedNext:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;

@end
