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
}

@property (retain, nonatomic) IBOutlet UIImageView *epImage;
@property (retain, nonatomic) IBOutlet UIImageView *npImage;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UIImageView *cannon;
@property (retain, nonatomic) IBOutlet UIImageView *gear;
@property (retain, nonatomic) IBOutlet UIImageView *laser;
@property (retain, nonatomic) IBOutlet UIImageView *background;


-(IBAction) tappedNext:(UIButton *)sender;
-(void) moveImage:(UIImageView *)image duration:(NSTimeInterval)duration scale:(int)scale x:(CGFloat)x y:(CGFloat)y;
-(void) recordAnswer;
-(void) newProblem;

@end
