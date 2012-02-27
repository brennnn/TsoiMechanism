//
//  Arrow.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Arrow : NSObject {
    CGPoint locationA;
    CGPoint locationB;
    int order;
}

@property (nonatomic, assign) CGPoint locationA;
@property (nonatomic, assign) CGPoint locationB;
@property (nonatomic, assign) int order;

@end
