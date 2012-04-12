//
//  Problem.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Problem.h"

@implementation Problem

@synthesize moleculeArray;

-(id) init {
    if (self = [super init]) {
        moleculeArray = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void) dealloc {
    [moleculeArray release];
    [super dealloc];
}

@end
