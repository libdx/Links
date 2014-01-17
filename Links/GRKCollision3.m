//
//  GRKCollision3.m
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKCollision3.h"
#import "grk_math.h"

static bool isLineWithLineCollision(GRKShape3Data shapes[2])
{
    return GRKShape3DataIsLine(&shapes[0]) && GRKShape3DataIsLine(&shapes[1]);
}

static bool isLineWithEllipseCollision(GRKShape3Data shapes[2])
{
    bool res = ((GRKShape3DataIsLine(&shapes[0])) && GRKShape3DataIsEllipse(&shapes[1])) ||
    ((GRKShape3DataIsEllipse(&shapes[0])) && GRKShape3DataIsLine(&shapes[1]));
    return res;
}

// ...

static GRKShape3Data *getLineShape(GRKShape3Data shapes[2])
{
    GRKShape3Data *res = NULL;
    if (GRKShape3DataIsLine(&shapes[0]))
        res = &shapes[0];
    else if (GRKShape3DataIsLine(&shapes[1]))
        res = &shapes[1];
    return res;
}

static GRKShape3Data *getEllipseShape(GRKShape3Data shapes[2])
{
    GRKShape3Data *res = NULL;
    if (GRKShape3DataIsEllipse(&shapes[0]))
        res = &shapes[0];
    else if (GRKShape3DataIsEllipse(&shapes[1]))
        res = &shapes[1];
    return res;
}

void GRKCollision3DataInit(GRKCollision3Data *collision)
{
    collision->next = NULL;
    for (int idx = 0; idx < 64; ++idx) {
        collision->points[idx] = CGPointMake(NAN, NAN);
        collision->parameters[idx] = NAN;
    }
}

GRKCollision3Data *GRKCollision3DataAlloc()
{
    GRKCollision3Data *collision = malloc(sizeof(GRKCollision3Data));
    GRKCollision3DataInit(collision);
    return collision;
}

GRKCollision3Data GRKCollision3DataMake()
{
    GRKCollision3Data collision;
    GRKCollision3DataInit(&collision);
    return collision;
}


CGPoint GRKCollision3DataNearestPoint(GRKCollision3Data collision, CGPoint point)
{
    return grk_nearest_point(point, collision.points, 64);
}

void GRKCollision3DataCleanup(GRKCollision3Data *collision)
{
    if (collision->next)
        GRKCollision3DataFree(collision->next);
}

void GRKCollision3DataFree(GRKCollision3Data *collision)
{
    if (collision->next)
        GRKCollision3DataFree(collision->next);
    free(collision);
}

@implementation GRKCollision3

+ (GRKCollision3Data)collisionOfShapes:(GRKShape3Data [static 2])shapes
{
    GRKCollision3Data collision = GRKCollision3DataMake();
    if (isLineWithLineCollision(shapes)) {
        grk_collision_line_line(shapes[0].line.points, shapes[1].line.points, collision.points);
    } else if (isLineWithEllipseCollision(shapes)) {
        GRKShape3Data *lineShape = getLineShape(shapes);
        GRKShape3Data *ellipseShape = getEllipseShape(shapes);
        grk_collision_line_ellipse(lineShape->line.points,
                                   ellipseShape->ellipse.center,
                                   ellipseShape->ellipse.radii.width,
                                   ellipseShape->ellipse.radii.height,
                                   collision.points);
    } // else ...
    return collision;
}

+ (CGPoint)nearestPointToPoint:(CGPoint)point fromCollisionOfShapes:(GRKShape3Data [static 2])shapes
{
    GRKCollision3Data collision = [self collisionOfShapes:shapes];
    CGPoint res = GRKCollision3DataNearestPoint(collision, point);
    GRKCollision3DataCleanup(&collision);
    return res;
}

@end
