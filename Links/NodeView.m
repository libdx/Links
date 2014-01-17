//
//  NodeView.m
//  Links
//
//  Created by Alexander Ignatenko on 1/2/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "NodeView.h"

@interface NodeView ()

@property (assign, nonatomic) CGFloat outlineWidth;

@end

@implementation NodeView

- (instancetype)initWithFrame:(CGRect)frame node:(id<Node>)node;
{
    self = [super initWithFrame:frame];
    if (self) {
        _node = node;
        _outlineWidth = 4.0;
        self.layer.mask = [self newMaskWithRect:CGRectInset(self.bounds, _outlineWidth, _outlineWidth)];
    }
    return self;
}

- (instancetype)initWithNode:(id<Node>)node
{
    return [self initWithFrame:CGRectZero node:node];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsLayout];
}

- (CAShapeLayer *)newMaskWithRect:(CGRect)rect
{
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    shape.fillColor = [UIColor blackColor].CGColor;
    shape.strokeColor = [UIColor clearColor].CGColor;
    shape.lineWidth = 3.0;
    shape.path = path.CGPath;
    return shape;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.backgroundColor = _selected ? [UIColor greenColor] : [UIColor blueColor];
}

@end
