//
//  Problems.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Problem.h"

#define MAX_PROBLEMS 10

@interface Problems : NSObject {
    NSMutableArray *problemArray;
    int problemArrayIndex;
}

@property (nonatomic, retain) NSMutableArray *problemArray;

// Loads every .xml file found within bundle and calls -parse:
// with the filename
-(void) load;

// Parses the xml file into it's class model equivilant and
// stores the problem
-(void) parse:(NSString *) filePath;

// Randomizes the order of problems stored
-(void) randomize;

// Returns the current problem
-(Problem*) getCurrent;

// Returns the next problem, incrementing the problem index
-(Problem*) getNext;

// Returns a singleton of Problems (self)
+(id) shared;

@end
