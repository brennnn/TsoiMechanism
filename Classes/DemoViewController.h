//
//  DemoViewController.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MODE_IDENTIFY 1
#define MODE_DRAW 2
#define MODE_CHALLENGE 3

@interface DemoViewController : UIViewController
{
    int mode;
}

@property (nonatomic, readwrite) int mode;


-(void) moviePlayBackDidFinish:(NSNotification*)notification;
-(void) pushMode;

@end
