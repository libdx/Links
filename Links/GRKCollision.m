//
//  GRKCollision.m
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKCollision.h"
#import "grk_math.h"

static bool isLineWithLineCollision(GRKShapeData shapes[2])
{
    return GRKShapeDataIsLine(&shapes[0]) && GRKShapeDataIsLine(&shapes[1]);
}

static bool isLineWithEllipseCollision(GRKShapeData shapes[2])
{
    bool res = ((GRKShapeDataIsLine(&shapes[0])) && GRKShapeDataIsEllipse(&shapes[1])) ||
    ((GRKShapeDataIsEllipse(&shapes[0])) && GRKShapeDataIsLine(&shapes[1]));
    return res;
}

// ...

static GRKShapeData *getLineShape(GRKShapeData shapes[2])
{
    GRKShapeData *res = NULL;
    if (GRKShapeDataIsLine(&shapes[0]))
        res = &shapes[0];
    else if (GRKShapeDataIsLine(&shapes[1]))
        res = &shapes[1];
    return res;
}

static GRKShapeData *getEllipseShape(GRKShapeData shapes[2])
{
    GRKShapeData *res = NULL;
    if (GRKShapeDataIsEllipse(&shapes[0]))
        res = &shapes[0];
    else if (GRKShapeDataIsEllipse(&shapes[1]))
        res = &shapes[1];
    return res;
}

void GRKCollisionDataInit(GRKCollisionData *collision)
{
    collision->next = NULL;
    for (int idx = 0; idx < 64; ++idx) {
        collision->points[idx] = CGPointMake(NAN, NAN);
        collision->parameters[idx] = NAN;
    }
}

GRKCollisionData *GRKCollisionDataAlloc()
{
    GRKCollisionData *collision = malloc(sizeof(GRKCollisionData));
    GRKCollisionDataInit(collision);
    return collision;
}

GRKCollisionData GRKCollisionDataMake()
{
    GRKCollisionData collision;
    GRKCollisionDataInit(&collision);
    return collision;
}


CGPoint GRKCollisionDataNearestPoint(GRKCollisionData collision, CGPoint point)
{
    return grk_nearest_point(point, collision.points, 64);
}

void GRKCollisionDataCleanup(GRKCollisionData *collision)
{
    if (collision->next)
        GRKCollisionDataFree(collision->next);
}

void GRKCollisionDataFree(GRKCollisionData *collision)
{
    if (collision->next)
        GRKCollisionDataFree(collision->next);
    free(collision);
}

@implementation GRKCollision

+ (GRKCollisionData)collisionOfShapes:(GRKShapeData [static 2])shapes
{
    GRKCollisionData collision = GRKCollisionDataMake();
    if (isLineWithLineCollision(shapes)) {
        grk_collision_line_line(shapes[0].line.points, shapes[1].line.points, collision.points);
    } else if (isLineWithEllipseCollision(shapes)) {
        GRKShapeData *lineShape = getLineShape(shapes);
        GRKShapeData *ellipseShape = getEllipseShape(shapes);
        grk_collision_line_ellipse(lineShape->line.points,
                                   ellipseShape->ellipse.center,
                                   ellipseShape->ellipse.radii.width,
                                   ellipseShape->ellipse.radii.height,
                                   collision.points);
    } // else ...
    return collision;
}

+ (CGPoint)nearestPointToPoint:(CGPoint)point fromCollisionOfShapes:(GRKShapeData [static 2])shapes
{
    GRKCollisionData collision = [self collisionOfShapes:shapes];
    CGPoint res = GRKCollisionDataNearestPoint(collision, point);
    GRKCollisionDataCleanup(&collision);
    return res;
}

@end
