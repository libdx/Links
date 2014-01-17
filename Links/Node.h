//
//  Node.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRKShape3.h"

@protocol Node <NSObject>

@property (assign, nonatomic) CGPoint center;
@property (assign, nonatomic) CGSize size;

@property (assign, nonatomic, readonly) CGRect boundingBox;

@property (assign, nonatomic, getter = isSelected) BOOL selected;
@property (assign, nonatomic, getter = isHighlighted) BOOL highlighted;

@property (assign, nonatomic) NSInteger shapeNumber;
- (const GRKShape3Data)shape;

@end

@interface BaseNode : NSObject <Node>

- (instancetype)initWithCenter:(CGPoint)center;
- (instancetype)initWithCenter:(CGPoint)center size:(CGSize)size;

@end
