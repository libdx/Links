//
//  Node.m
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKNode.h"

@interface GRKBaseNode ()

@property (assign, nonatomic) GRKShapeData shapeData;
//@property (strong, nonatomic) NSMutableSet *mutableChildren;
//@property (strong, nonatomic) NSMutableSet *mutableParents;

@end

@implementation GRKBaseNode

@synthesize center = _center;
@synthesize highlighted = _highlighted;
@synthesize selected = _selected;
@synthesize shapeNumber = _shapeNumber;
@synthesize size = _size;
//@synthesize parents = _parents;
//@synthesize children = _children;

- (instancetype)initWithCenter:(CGPoint)center
{
    return [self initWithCenter:center size:CGSizeMake(44.0, 44.0)];
}

- (instancetype)initWithCenter:(CGPoint)center size:(CGSize)size
{
    self = [super init];
    if (nil == self)
        return nil;

    _center = center;
    _size = size;
    _shapeNumber = GRKShapeTypeEllipse;

    return self;
}

- (CGRect)boundingBox
{
    CGRect box = CGRectMake(_center.x - round(0.5 * (_size.width)),
                            _center.y - round(0.5 * (_size.height)),
                            _size.width,
                            _size.height);
    return box;
}

- (const GRKShapeData)shape
{
    // TODO: cache shape data
    GRKShapeDataCleanup(&_shapeData);
    _shapeData = GRKShapeMake(self.shapeNumber, [self boundingBox], self);
    return _shapeData;
}

//- (NSMutableSet *)mutableParents
//{
//    if (nil == _mutableParents)
//        _mutableParents = [[NSMutableSet alloc] init];
//    return _mutableParents;
//}
//
//- (NSSet *)parents
//{
//    return _mutableParents.copy;
//}
//
//- (void)addParent:(id<GRKNode>)parent
//{
//    [self.mutableParents addObject:parent];
//}
//
//- (void)removeParent:(id<GRKNode>)parent
//{
//    [_mutableParents removeObject:parent];
//}
//
//- (NSMutableSet *)mutableChildren
//{
//    if (nil == _mutableChildren)
//        _mutableChildren = [[NSMutableSet alloc] init];
//    return _mutableChildren;
//}
//
//- (NSSet *)children
//{
//    return _mutableChildren.copy;
//}
//
//- (void)addChild:(id<GRKNode>)child
//{
//    [self.mutableChildren addObject:child];
//}
//
//- (void)removeChild:(id<GRKNode>)child
//{
//    [_mutableChildren removeObject:child];
//}

@end
