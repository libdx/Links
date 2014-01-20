//
//  NodeView.h
//  Links
//
//  Created by Alexander Ignatenko on 1/2/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GRKNode;

@interface GRKNodeView : UIView

@property (weak, nonatomic, readonly) id<GRKNode> node;

- (instancetype)initWithFrame:(CGRect)frame node:(id<GRKNode>)node;
- (instancetype)initWithNode:(id<GRKNode>)node;

@property (assign, nonatomic, getter = isSelected) BOOL selected;
@property (assign, nonatomic, getter = isHighlighted) BOOL highlighted;

@end
