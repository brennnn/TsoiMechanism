//
//  Molecule.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Molecule.h"

@implementation Molecule

@synthesize elements, bonds, arrows;


-(id) init {
    if (self = [super init]) {
        elements = [[NSMutableDictionary alloc] init];
        bonds = [[NSMutableDictionary alloc] init];
        arrows = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(void) dealloc {
    [elements release];
    [bonds release];
    [arrows release];
    [super dealloc];
}

@end
