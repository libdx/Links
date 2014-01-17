//
//  LinksView.m
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "LinksView.h"
#import "Node.h"
#import "Link.h"
#import "GRKShape.h"
#import "GRKCollision.h"

#import "grk_math.h"

@interface LinksView ()

@property (strong, nonatomic) NSMutableSet *links;

@end

@implementation LinksView

- (instancetype)initWithFrame:(CGRect)frame links:(NSSet *)links;
{
    self = [super initWithFrame:frame];
    if (nil == self)
        return nil;

    _links = links.mutableCopy;
    self.backgroundColor = [UIColor clearColor];

    return self;
}

- (NSMutableSet *)links
{
    if (nil == _links)
        _links = [NSMutableSet set];
    return _links;
}

- (void)setNeedsUpdateByAddingLinks:(NSSet *)links;
{
    [self.links unionSet:links];
    [self setNeedsUpdate];
}

- (void)setNeedsUpdateBySubtractingLinks:(NSSet *)links;
{
    [_links minusSet:links];
    [self setNeedsUpdate];
}

- (void)setNeedsUpdate
{
    [self setNeedsDisplay];
}

- (CGPathRef)bodyPathForLink:(Link *)link NS_RETURNS_INNER_POINTER
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(link.parentNode.center.x, link.parentNode.center.y)];
    [path addLineToPoint:CGPointMake(link.childNode.center.x, link.childNode.center.y)];
    [path closePath];
    return path.CGPath;
}

- (CGPathRef)arrowheadPathForLink:(Link *)link NS_RETURNS_INNER_POINTER
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint delta;
    delta.x = link.parentNode.center.x - link.childNode.center.x;
    delta.y = link.parentNode.center.y - link.childNode.center.y;
    CGFloat angle = grk_line_angle(delta.y, delta.x);

    CGPoint points[2] = {link.parentNode.center, link.childNode.center};
    GRKShapeData lineShape = GRKShapeDataMakeLine(points);
    GRKShapeData shapes[2] = {lineShape, [link.childNode shape]};
    CGPoint collision = [GRKCollision nearestPointToPoint:link.parentNode.center fromCollisionOfShapes:shapes];
    GRKShapeDataCleanup(&lineShape);

    grk_linear_eq_pa_t line = {collision, angle};
    grk_arrowhead_t arrowhead = grk_line_arrowhead(line, to_radians(35), 10.0);

    [path moveToPoint:CGPointMake(arrowhead.points[0].x, arrowhead.points[0].y)];
    [path addLineToPoint:CGPointMake(arrowhead.points[1].x, arrowhead.points[1].y)];
    [path closePath];

    [path moveToPoint:CGPointMake(arrowhead.points[0].x, arrowhead.points[0].y)];
    [path addLineToPoint:CGPointMake(arrowhead.points[2].x, arrowhead.points[2].y)];
    [path closePath];

    return path.CGPath;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(ctx, true);
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetStrokeColorWithColor(ctx, [UIColor brownColor].CGColor);

    for (Link *link in _links.copy) {
        CGContextAddPath(ctx, [self bodyPathForLink:link]);
        CGContextAddPath(ctx, [self arrowheadPathForLink:link]);
    }

    CGContextStrokePath(ctx);
}

@end
