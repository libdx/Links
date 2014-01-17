//
//  GRKCollision3.h
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRKShape3.h"

/**
 `GRKCollision3Data` structure represents collision data which can hold 64 collision points
 and 64 additional parameters (in case collision can't be represented by points only).
 Fields of structure are public for optimization reasons (thus can be allocated on function's stack).
 In case size of reserved data is not enough `next` field can be used to point to the another
 `GRKCollision3Data` structure.
 */
typedef struct GRKCollision3Data GRKCollision3Data;
struct GRKCollision3Data {
    CGPoint points[64];
    CGFloat parameters[64];
    GRKCollision3Data *next;
};

/**
 Returns nearest point to the given one from collision data.
 @param collision The collision data.
 @param point A point to which nearest point must be found.
 */
CGPoint GRKCollision3DataNearestPoint(GRKCollision3Data collision, CGPoint point);

/**
 Returns initialized GRKCollision3Data structure.
 */
GRKCollision3Data GRKCollision3DataMake();

/**
 Returns pointer to initialized GRKCollision3Data structure.
 */
GRKCollision3Data *GRKCollision3DataAlloc();

/**
 Destroys all acquired resources for given `collision` struct except `collision` inself.
 */
void GRKCollision3DataCleanup(GRKCollision3Data *collision);

/**
 Destroys all acquired resources for given `collision` struct including `collision` inself.
 */
void GRKCollision3DataFree(GRKCollision3Data *);

@interface GRKCollision3 : NSObject

+ (GRKCollision3Data)collisionOfShapes:(GRKShape3Data [static 2])shapes;
+ (CGPoint)nearestPointToPoint:(CGPoint)point fromCollisionOfShapes:(GRKShape3Data [static 2])shapes;

@end
