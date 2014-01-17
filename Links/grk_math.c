//
//  grk_math.c
//  Links
//
//  Created by Alexander Ignatenko on 1/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#include "grk_math.h"

static grk_float_t sqr(grk_float_t a)
{
    return pow(a, 2);
}


grk_point_t grk_nearest_point(grk_point_t point, grk_point_t *locus, int number)
{
    struct {
        CGFloat distance;
        CGPoint point;
    } measurer = {-1, {NAN, NAN}};
    for (int i = 0; i < number; ++i) {
        if (grk_is_point_nan(locus[i]))
            continue;

        CGFloat distance = grk_distance(locus[i], point);
        if (measurer.distance > distance || measurer.distance == -1) {
            measurer.distance = distance;
            measurer.point = locus[i];
        }
    }
    return measurer.point;
}

void grk_collision_line_line(grk_point_t l1points[2], grk_point_t l2points[2], grk_point_t collisions[2])
{

}

void grk_collision_line_ellipse(grk_point_t line_points[2],
                                grk_point_t center,
                                grk_float_t radius_x,
                                grk_float_t radius_y,
                                grk_point_t collisions[2])
{
    // transform points into ellipse's local coordinates
    grk_point_t p[2];
    for (int idx = 0; idx < 2; ++idx) {
        p[idx].x = line_points[idx].x - center.x;
        p[idx].y = line_points[idx].y - center.y;
    }

    grk_point_t delta;
    delta.x = p[1].x - p[0].x;
    delta.y = p[1].y - p[0].y;

    // find ratios of square equation
    grk_float_t a = sqr(radius_y) * sqr(delta.x) + sqr(radius_x) * sqr(delta.y);
    grk_float_t b = 2 * (sqr(radius_y) * delta.x * p[0].x + sqr(radius_x) * delta.y * p[0].y);
    grk_float_t c = sqr(radius_y) * sqr(p[0].x) + sqr(radius_x) * sqr(p[0].y) - sqr(radius_x * radius_y);

    // find discriminant
    grk_float_t d = sqr(b) - 4 * a * c;

    // find intersections in line's local coordinates
    grk_float_t inter[2] = {NAN, NAN};
    if (d < 0) {
        // no intersections
    } else if (d == 0) {
        // one intersection
        inter[0] = -b / (2 * a);
    } else {
        // two intersections
        inter[0] = (-b - sqrt(d)) / (2 * a);
        inter[1] = (-b + sqrt(d)) / (2 * a);
    }

    // find acctual intersections in global coordinates
    for (int idx = 0; idx < 2; ++idx) {
        if (!isnan(inter[idx])) {
            collisions[idx].x = round(line_points[0].x + inter[idx] * delta.x);
            collisions[idx].y = round(line_points[0].y + inter[idx] * delta.y);
        }
    }
}
