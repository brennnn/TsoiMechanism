//
//  ProblemView.h
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Problems.h"
#import "Marker.h"

#define ARROW_NORMAL 0
#define ARROW_CORRECT 1
#define ARROW_INCORRECT 2
 
@interface ProblemView : UIView {
    
    @private
        Problems *problems;
        Marker *electrophileMarker;
        Marker *nucleophileMarker;
        BOOL showProblemMarkers;
        NSMutableArray *problemMarkersArray;
        Marker *movableMarker;
        NSMutableArray *arrowStack;
        BOOL arrowInProgress;
        int arrowOrder;
        int arrowMode;
}

@property (nonatomic, retain) Problems *problems;
@property (nonatomic, retain) Marker *electrophileMarker;
@property (nonatomic, retain) Marker *nucleophileMarker;
@property (nonatomic, retain) NSMutableArray *problemMarkersArray;
@property (nonatomic, retain) Marker *movableMarker;
@property (nonatomic, retain) NSMutableArray *arrowStack;

// Clears the current problem (including Electrophile/Nucleophile Markers and all Arrows) and shows the next Problem.
-(void) showNextProblem;

// Determines if a |point| is within the HITBOX_SIZE of a element or bond and returns a CGPoint
// of that center; overwise returns a CGPoint of -1,-1 to represent no hitbox was found.
-(CGPoint) isHitbox:(CGPoint)point;

// Determines if a |point| of |type| is within the HITBOX_SIZE of a element or bond and returns a
// CGPoint of that center; overwise returns a CGPoint of -1,-1 to represent no hitbox was found.
-(CGPoint) isHitbox:(CGPoint)point ofType:(int) type;

// Dermines if |hitbox| is of |type|, where hitbox is a point returned from a isHitbox: method.
-(BOOL) isType:(int)type ofHitbox:(CGPoint)hitbox;

// Shows a Electrophile Marker at |point|.
-(void) showElectrophileMarker:(CGPoint)point;

// Clears the Electrophile Marker from the screen.
-(void) clearElectrophileMarker;

// Shows a Nucleophile Marker at |point|.
-(void) showNucleophileMarker:(CGPoint)point;

// Clears the Nucleophile Marker from the screen.
-(void) clearNucleophileMarker;

// Shows All Problem Markers
-(void) showProblemMarkers;

// Clears All Problem Markers from screen.
-(void) clearProblemMarkers;

// Creates a Movable Marker at |point|. The |type| is used to determine the color and label of the marker.
-(void) createMovableMarker:(CGPoint)point ofType:(int)type;

// Sets the position of the Movable Marker at |point|.
-(void) setMovableMarkerPosition:(CGPoint)point;

// Returns the type that Movable Marker is set as. Returns -1 Movable Marker is not visible.
-(int) getMovableMarkerType;

// Clears the Movable Marker from the screen
-(void) clearMovableMarker;

// Adds a in progress arrow to the arrow stack, setting it's start position as |point|.
-(void) startArrow:(CGPoint)point;

// Sets the end point of the last in progress arrow added to the arrow stack to |point|. 
// If end point is over a hitbox, the hitbox will be shown until the point is moved out
// of the hitbox or -endArrow: is called.
-(void) setArrowEnd:(CGPoint)point;

// Returns TRUE if a arrow is in progress. A arrow is in progress if -startArrow:
// and/or -setArrowEnd: have been called and -endArrow: has not. Returns FALSE
// if no arrow has been added or -endArrow: has been called.
-(BOOL) isArrowInProgress;

// Finishes a in progress arrow, setting it's final end |point|.
-(void) endArrow:(CGPoint)point;

// Removes the last Arrow added to the arrow stack from the screen.
-(void) removeLastArrow;

// Removes all arrows added to the arrow stack from the screen.
-(void) removeAllArrows;

// Returns the current count of arrows in the arrow stack.
-(int) getArrowStackCount;

// Returns the maximum arrows the current problem has.
-(int) getProblemArrowCount;

// Returns TRUE if the last arrow on the arrow stack has a start type
// equal to the |type| provided.
-(BOOL) isLastArrowStartType:(int) type;

// Returns TRUE if the last arrow on the arrow stack has a end type
// equal to the |type| provided.
-(BOOL) isLastArrowEndType:(int) type;

// Returns TRUE if the last arrow added to the arrow stack matches the 
// same location of the arrow of same order in the problem.
-(BOOL) doesLastArrowMatchProblem;

// Returns TRUE if all arrows in the arrow stack match the arrows in
// the current problem. Also takes into account matching the total
// number of arrows in the arrow stack and current problem.
-(BOOL) doesAllArrowsMatchProblem;

// Sets Arrows that are drawn to a mode: ARROW_NORMAL, ARROW_INCORRECT,
// and ARROW_INCORRECT. This changes the color of the arrows to its mode.
-(void) setArrowMode:(int) mode;

// Returns a UIImage of all Images on the screen.
-(UIImage*) getArrowImage;

// PRIVATE METHODS - FOR INTERNAL CLASS USE ONLY

// Adds all Problem related Markers to problemMarkersArray
-(void) setProblemMarkers;

// Checks if a arrow matches the problems arrow
-(BOOL) doesArrowMatchProblem:(Arrow*)arrow;

// Takes two points that represent a line and shortens them
-(CGPoint) insetPoint:(CGPoint)pointA andPoint:(CGPoint)pointB withLabel:(NSString*)label;


@end
