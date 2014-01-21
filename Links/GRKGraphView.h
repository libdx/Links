//
//  GraphView.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRKNodeView;
@protocol GRKGraphViewDelegate, GRKNode, GRKLink;

@interface GRKGraphView : UIView

@property (weak, nonatomic) id<GRKGraphViewDelegate> delegate;

@property (strong, nonatomic, readonly) NSSet *allNodes;
@property (strong, nonatomic, readonly) NSSet *allLinks;

- (void)addNode:(id<GRKNode>)node;
- (void)addNodes:(NSSet *)nodes;
- (void)addNode:(id<GRKNode>)node withParent:(id<GRKNode>)parent;
- (void)addNodes:(NSSet *)nodes withParent:(id<GRKNode>)parent;

- (void)removeNode:(id<GRKNode>)node;
- (void)removeNodes:(NSSet *)nodes;

@end

@protocol GRKGraphViewDelegate <NSObject>

@required

- (id<GRKLink>)graphView:(GRKGraphView *)graphView linkForParentNode:(id<GRKNode>)parent childNode:(id<GRKNode>)child;

@optional

- (GRKNodeView *)graphView:(GRKGraphView *)graphView viewForNode:(id<GRKNode>)node;
- (void)graphView:(GRKGraphView *)graphView didSelectNode:(id<GRKNode>)node;
- (void)graphView:(GRKGraphView *)graphView didDeselectNode:(id<GRKNode>)node;

@end
