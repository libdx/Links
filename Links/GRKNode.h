//
//  Node.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRKShape.h"

@protocol GRKNode <NSObject>

@property (assign, nonatomic) CGPoint center;
@property (assign, nonatomic) CGSize size;

@property (assign, nonatomic, readonly) CGRect boundingBox;

@property (assign, nonatomic, getter = isSelected) BOOL selected;
@property (assign, nonatomic, getter = isHighlighted) BOOL highlighted;

@property (assign, nonatomic) NSInteger shapeNumber;
@property (assign, nonatomic, readonly) const GRKShapeData shape;

//@property (nonatomic, readonly) NSSet *parents;
//- (void)addParent:(id<GRKNode>)parent;
//- (void)removeParent:(id<GRKNode>)parent;
//
//@property (nonatomic, readonly) NSSet *children;
//- (void)addChild:(id<GRKNode>)child;
//- (void)removeChild:(id<GRKNode>)child;

@end

@interface GRKBaseNode : NSObject <GRKNode>

- (instancetype)initWithCenter:(CGPoint)center;
- (instancetype)initWithCenter:(CGPoint)center size:(CGSize)size;

@end
