//
//  Element.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ELEMENT_OTHER 0
#define ELEMENT_ELECTROPHILE 1
#define ELEMENT_NUCLEOPHILE 2

#define CHARGE_NONE 0
#define CHARGE_NEGATIVE 1
#define CHARGE_POSITIVE 2

@interface Element : NSObject {
    CGPoint location;
    NSString *label;
    int charge;
    int electrons;
    int type;  
}

@property (nonatomic, assign) CGPoint location;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, assign) int charge;
@property (nonatomic, assign) int electrons;
@property (nonatomic, assign) int type;


@end
