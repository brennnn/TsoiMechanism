//
//  Bond.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bond : NSObject {
    CGPoint location;
    CGPoint locationA;
    CGPoint locationB;
    int bondOrder;
}

@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGPoint locationA;
@property (nonatomic, assign) CGPoint locationB;
@property (nonatomic, assign) int bondOrder;

@end
