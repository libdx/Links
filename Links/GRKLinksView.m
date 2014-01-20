//
//  LinksView.m
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKLinksView.h"
#import "GRKNode.h"
#import "GRKLink.h"
#import "GRKShape.h"
#import "GRKCollision.h"

#import "grk_math.h"

@interface GRKDrawingLinksView ()
{
    NSMutableDictionary *_boundingBoxesOfLinkPaths;
}

@property (strong, nonatomic) NSMutableSet *links;
@property (assign, nonatomic, readonly) CGFloat lineWidth;

@end

@implementation GRKDrawingLinksView

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

- (CGFloat)lineWidth
{
    return 3.0;
}

- (void)setNeedsUpdateByAddingLinks:(NSSet *)links;
{
    [self.links unionSet:links];
    [self setNeedsUpdateForLinks:links];
}

- (void)setNeedsUpdateBySubtractingLinks:(NSSet *)links;
{
    [_links minusSet:links];
    [self setNeedsUpdateForLinks:links];
}

- (void)setNeedsUpdateForLinks:(NSSet *)links
{
    [self setNeedsDisplay];
}

- (CGPathRef)bodyPathForLink:(GRKLink *)link NS_RETURNS_INNER_POINTER
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(link.parentNode.center.x, link.parentNode.center.y)];
    [path addLineToPoint:CGPointMake(link.childNode.center.x, link.childNode.center.y)];
    [path closePath];
    return path.CGPath;
}

- (CGPathRef)arrowheadPathForLink:(GRKLink *)link NS_RETURNS_INNER_POINTER
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
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor brownColor].CGColor);

    for (GRKLink *link in _links.copy) {
        CGContextAddPath(ctx, [self bodyPathForLink:link]);
        CGContextAddPath(ctx, [self arrowheadPathForLink:link]);
    }

    CGContextStrokePath(ctx);
}

@end

@interface GRKLinkView : UIView

@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGPoint ending;
@property (assign, nonatomic) grk_arrowhead_t arrowhead;

@end

@implementation GRKLinkView

- (CGPathRef)bodyPathWithOrigin:(CGPoint)origin ending:(CGPoint)ending NS_RETURNS_INNER_POINTER
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:origin];
    [path addLineToPoint:ending];
    [path closePath];
    return path.CGPath;
}

- (CGPathRef)arrowheadPathWithArrowhead:(grk_arrowhead_t)arrowhead NS_RETURNS_INNER_POINTER
{
    UIBezierPath *path = [[UIBezierPath alloc] init];

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

    CGContextAddPath(ctx, [self bodyPathWithOrigin:self.origin ending:self.ending]);
    CGContextAddPath(ctx, [self arrowheadPathWithArrowhead:self.arrowhead]);

    CGContextStrokePath(ctx);
}

@end

@interface GRKViewedLinksView  ()

@property (strong, nonatomic) NSMutableSet *links;

@end

@implementation GRKViewedLinksView

- (instancetype)initWithFrame:(CGRect)frame links:(NSSet *)links
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

- (void)setNeedsUpdateByAddingLinks:(NSSet *)links
{
    [_links unionSet:links];
}

- (void)setNeedsUpdateBySubtractingLinks:(NSSet *)links
{
    [_links minusSet:links];
}

- (void)setNeedsUpdateForLinks:(NSSet *)links
{
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // TODO: finish implementation
}

- (CGRect)rectForLink:(GRKLink *)link
{
    CGPoint origin;
    origin.x = MIN(link.parentNode.center.x, link.childNode.center.x);
    origin.y = MIN(link.parentNode.center.y, link.childNode.center.y);
    CGPoint ending;
    ending.x = MAX(link.parentNode.center.x, link.childNode.center.x);
    ending.y = MAX(link.parentNode.center.y, link.childNode.center.y);
    CGSize size = CGSizeMake(ending.x - origin.x, ending.y - origin.y);
    return CGRectIntegral(CGRectMake(origin.x, origin.y, size.width, size.height));
}


@end
