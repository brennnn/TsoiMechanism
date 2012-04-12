//
//  Element.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Element.h"

@implementation Element

@synthesize location, label, charge, electrons, type;

-(void) dealloc {
    if (label != nil)
        [label release];
    [super dealloc];
}

@end
