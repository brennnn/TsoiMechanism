//
//  Marker.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Marker : NSObject {
    CGPoint point;
    int type;
}

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) int type;

@end
