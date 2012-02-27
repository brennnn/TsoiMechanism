//
//  Molecule.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arrow.h"

@interface Molecule : NSObject {
    NSMutableDictionary *elements;
    NSMutableDictionary *bonds;
    NSMutableDictionary *arrows;
}

@property (nonatomic, retain) NSMutableDictionary *elements;
@property (nonatomic, retain) NSMutableDictionary *bonds;
@property (nonatomic, retain) NSMutableDictionary *arrows;

@end
