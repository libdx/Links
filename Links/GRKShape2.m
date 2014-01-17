//
//  GRKShape2.m
//  Links
//
//  Created by Alexander Ignatenko on 1/14/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKShape2.h"

@interface GRKShape2 ()
{
@protected
    struct {
        CGPoint points[2];
    } _line;
    struct {
        CGPoint center;
        CGSize radii;
    } _ellipse;
    CGPathRef _path;
}

@end

@implementation GRKShape2

@synthesize boundingBox = _boundingBox;
@synthesize path = _path;

- (void)getLinePoints:(out CGPoint[static 2])points
{
    points[0] = _line.points[0];
    points[1] = _line.points[1];
}

- (void)getEllipseCenter:(out CGPoint *)center radii:(out CGSize *)radii
{
    *center = _ellipse.center;
    *radii = _ellipse.radii;
}

- (id)copyWithZone:(NSZone *)zone
{
    GRKShape2 *shape = [[GRKShape2 alloc] init];
    shape->_line = _line;
    shape->_ellipse = _ellipse;
    shape->_path = _path;
    return shape;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    GRKMutableShape2 *shape = [[GRKMutableShape2 alloc] init];
    [shape setLinePoints:_line.points];
    [shape setEllipseCenter:_ellipse.center radii:_ellipse.radii];
    shape.path = _path;
    return shape;
}

@end

@implementation GRKMutableShape2

- (void)setLinePoints:(CGPoint[static 2])points
{
    _line.points[0] = points[0];
    _line.points[1] = points[1];
}

- (void)setEllipseCenter:(CGPoint)center radii:(CGSize)radii
{
    _ellipse.center = center;
    _ellipse.radii = radii;
}

@end