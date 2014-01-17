//
//  GraphView.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NodeView;
@protocol GraphViewDelegate, Node;

@interface GraphView : UIView

@property (weak, nonatomic) id<GraphViewDelegate> delegate;

- (void)addNode:(id<Node>)node;
- (void)addNodes:(NSSet *)nodes;
- (void)addNode:(id<Node>)node withParent:(id<Node>)parent;
- (void)addNodes:(NSSet *)nodes withParent:(id<Node>)parent;

@end

@protocol GraphViewDelegate <NSObject>

@optional

- (NodeView *)graphView:(GraphView *)graphView viewForNode:(id<Node>)node;
- (void)graphView:(GraphView *)graphView didSelectNode:(id<Node>)node;
- (void)graphView:(GraphView *)graphView didDeselectNode:(id<Node>)node;

@end
