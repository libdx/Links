//
//  Node.m
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "Node.h"

@implementation BaseNode
{
    GRKShape3Data _shapeData;
}

@synthesize center = _center;
@synthesize highlighted = _highlighted;
@synthesize selected = _selected;
@synthesize shapeNumber = _shapeNumber;
@synthesize size = _size;

- (instancetype)initWithCenter:(CGPoint)center
{
    return [self initWithCenter:center size:CGSizeMake(64.0, 44.0)];
}

- (instancetype)initWithCenter:(CGPoint)center size:(CGSize)size
{
    self = [super init];
    if (nil == self)
        return nil;

    _center = center;
    _size = size;
    _shapeNumber = GRKShape3TypeEllipse;

    return self;
}

- (CGRect)boundingBox
{
    // TODO: calculate rect here
    CGRect box = CGRectMake(_center.x - round(0.5 * (_size.width)),
                            _center.y - round(0.5 * (_size.height)),
                            _size.width,
                            _size.height);
    return box;
}

- (const GRKShape3Data)shape
{
    GRKShape3DataCleanup(&_shapeData);
    _shapeData = GRKShapeMake(self.shapeNumber, [self boundingBox], self);
    return _shapeData;
}

@end
