//
//  grk_math.h
//  Links
//
//  Created by Alexander Ignatenko on 1/6/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#ifndef __grk_math_h__
#define __grk_math_h__

#include <tgmath.h>

#if defined(__APPLE__) || defined(__MACH__)
    #define USE_CORE_GRAPHICS_TYPES 1
#endif

#ifdef USE_CORE_GRAPHICS_TYPES
    #include <CoreGraphics/CGBase.h>
    #include <CoreGraphics/CGGeometry.h>
#endif

#ifdef USE_CORE_GRAPHICS_TYPES
    #define GRK_INLINE CG_INLINE
//    #define GRK_EXTERN CG_EXTERN
#else
    #define GRK_INLINE static inline
//    #define GRK_EXTERN extern
#endif

#define to_degrees(r) (r) * 180 / M_PI
#define to_radians(d) (d) * M_PI / 180

#ifdef USE_CORE_GRAPHICS_TYPES
typedef CGFloat grk_float_t;
#else
typedef double grk_float_t;
#endif

#ifdef USE_CORE_GRAPHICS_TYPES
typedef CGPoint grk_point_t;
#else
struct grk_point_t {
    grk_float_t x;
    grk_float_t y;
};
typedef struct grk_point_t grk_point_t;
#endif

GRK_INLINE int grk_is_point_nan(grk_point_t point) {
    return isnan(point.x) && isnan(point.y);
}

GRK_INLINE grk_point_t grk_line_mean_point(grk_point_t points[2])
{
    grk_point_t p;
    p.x = round(0.5 * (points[0].x + points[1].x));
    p.y = round(0.5 * (points[0].y + points[1].y));
    return p;
}

GRK_INLINE grk_float_t grk_line_angle(grk_float_t dy, grk_float_t dx)
{
    return atan2(dy, dx) + M_PI;
}

struct grk_arrowhead_t {
    grk_float_t angle;
    grk_float_t length;
    // 0 - head point; 1 - first side point; 2 - second side point;
    grk_point_t points[3];
};
typedef struct grk_arrowhead_t grk_arrowhead_t;

// linear equation point-angle form
struct grk_linear_eq_pa_t {
    // any point of the line
    grk_point_t point;
    // angle between line and x axis
    grk_float_t angle;
};
typedef struct grk_linear_eq_pa_t grk_linear_eq_pa_t;

GRK_INLINE grk_arrowhead_t grk_line_arrowhead(grk_linear_eq_pa_t line,
                                                 grk_float_t ar_angle,
                                                 grk_float_t ar_length)
{
    grk_arrowhead_t arrowhead;
    arrowhead.angle = ar_angle;
    arrowhead.length = ar_length;
    arrowhead.points[0] = line.point;

    arrowhead.points[1].x = line.point.x - arrowhead.length * sin(M_PI_2 - line.angle - arrowhead.angle);
    arrowhead.points[1].y = line.point.y - arrowhead.length * cos(M_PI_2 - line.angle - arrowhead.angle);

    arrowhead.points[2].x = line.point.x - arrowhead.length * cos(line.angle - arrowhead.angle);
    arrowhead.points[2].y = line.point.y - arrowhead.length * sin(line.angle - arrowhead.angle);

    return arrowhead;
}

/*
 Returns distance between two given points.
 @param point1 First point.
 @param point2 Second point.
 */
GRK_INLINE grk_float_t grk_distance(grk_point_t point1, grk_point_t point2)
{
    return sqrt( pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2) );
}

/*
 Returns nearest point from given `locus` to given `point`.
 @param point Point against which to do comparison.
 @param locus Is a points' set among which nearest to point to given `point` to be found.
 @param number The number of points in given locus
 */
grk_point_t grk_nearest_point(grk_point_t point, grk_point_t *locus, int number);

/*
 Finds intersections between two lines. The intersections of a line and a line can be empty set, a point, or a line.
 
 @param line1 Line structure that represents first line with two points
 @param line1 Line structure that represents second line with two points
 @param collisions Preallocated array of two grk_point_t's. If intersection is empty set than all two points is a NAN.
 If intersection is a point than first point is this intersection and second is a NAN. If intersection is a line
 two points represent a line.
 */
//void grk_collision_line_line(struct grk_line line1, struct grk_line line2, grk_point_t collisions[2]);
void grk_collision_line_line(grk_point_t l1points[2], grk_point_t l2points[2], grk_point_t collisions[2]);

/*
 Finds intersections between a line and a ellipse. The intersection of a line and a ellipse can be empty set, a point,
 or two points.
 @param line Line structure
 @param ellipse Ellipse structure
 @param collisions Preallocated array of two grk_point_t's. If intersection is empty set that all two points is a NAN.
 If intersection is a point than first point is this intersection and second is a NAN.
 */
//void grk_collision_line_ellipse(struct grk_line line, struct grk_ellipse ellipse, grk_point_t collisions[2]);
void grk_collision_line_ellipse(grk_point_t line_points[2],
                                grk_point_t center,
                                grk_float_t radius_x,
                                grk_float_t radius_y,
                                grk_point_t collisions[2]);

//void grk_collision_line_rect(struct grk_line line, struct grk_rect rect, grk_point_t collisions[2]);

//struct grk_line {
//    grk_point_t points[2];
//};
//
//struct grk_ellipse {
//    grk_point_t center;
//    grk_float_t radius;
//};
//
//struct grk_rect {
//    grk_point_t origin;
//    struct {
//        grk_float_t width;
//        grk_float_t height;
//    } size;
//};
//
//enum grk_bezier_types {
//    grk_bezier_linear = 0,
//    grk_bezier_quadratic,
//    grk_bezier_cubic
//};
//
//struct grk_bezier {
//    enum grk_bezier_types type;
//    grk_point_t points[4];
//};
//
//struct grk_locus_set {
//    grk_point_t *points;
//    int count;
//};


#endif //__grk_math_h__
