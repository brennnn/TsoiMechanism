//
//  Problem.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Molecule.h"
#import "Element.h"
#import "Bond.h"

@interface Problem : NSObject {
    NSMutableArray *moleculeArray;
}

@property (nonatomic, retain) NSMutableArray *moleculeArray;

@end
