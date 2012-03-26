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
@property (retain, nonatomic) IBOutlet UIButton *nextButton;

-(IBAction)tappedNext:(UIButton *)sender;
-(void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration scale:(int)scale x:(CGFloat)x y:(CGFloat)y;
-(void)recordAnswer;
-(void)newProblem;

@end
