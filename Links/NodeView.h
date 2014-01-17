//
//  NodeView.h
//  Links
//
//  Created by Alexander Ignatenko on 1/2/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Node;

@interface NodeView : UIView

@property (weak, nonatomic, readonly) id<Node> node;

- (instancetype)initWithFrame:(CGRect)frame node:(id<Node>)node;
- (instancetype)initWithNode:(id<Node>)node;

@property (assign, nonatomic, getter = isSelected) BOOL selected;
@property (assign, nonatomic, getter = isHighlighted) BOOL highlighted;

@end
