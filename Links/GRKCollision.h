//
//  GRKCollision.h
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRKShape.h"

/**
 `GRKCollisionData` structure represents collision data which can hold 64 collision points
 and 64 additional parameters (in case collision can't be represented by points only).
 Fields of structure are public for optimization reasons (thus can be allocated on function's stack).
 In case size of reserved data is not enough `next` field can be used to point to the another
 `GRKCollisionData` structure.
 */
typedef struct GRKCollisionData GRKCollisionData;
struct GRKCollisionData {
    CGPoint points[64];
    CGFloat parameters[64];
    GRKCollisionData *next;
};

/**
 Returns nearest point to the given one from collision data.
 @param collision The collision data.
 @param point A point to which nearest point must be found.
 */
CGPoint GRKCollisionDataNearestPoint(GRKCollisionData collision, CGPoint point);

/**
 Returns initialized GRKCollisionData structure.
 */
GRKCollisionData GRKCollisionDataMake();

/**
 Returns pointer to initialized GRKCollisionData structure.
 */
GRKCollisionData *GRKCollisionDataAlloc();

/**
 Destroys all acquired resources for given `collision` struct except `collision` inself.
 */
void GRKCollisionDataCleanup(GRKCollisionData *collision);

/**
 Destroys all acquired resources for given `collision` struct including `collision` inself.
 */
void GRKCollisionDataFree(GRKCollisionData *);

@interface GRKCollision : NSObject

+ (GRKCollisionData)collisionOfShapes:(GRKShapeData [static 2])shapes;
+ (CGPoint)nearestPointToPoint:(CGPoint)point fromCollisionOfShapes:(GRKShapeData [static 2])shapes;

@end
