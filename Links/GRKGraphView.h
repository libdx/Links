//
//  GraphView.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRKNodeView;
@protocol GRKGraphViewDelegate, GRKNode;

@interface GRKGraphView : UIView

@property (weak, nonatomic) id<GRKGraphViewDelegate> delegate;

- (void)addNode:(id<GRKNode>)node;
- (void)addNodes:(NSSet *)nodes;
- (void)addNode:(id<GRKNode>)node withParent:(id<GRKNode>)parent;
- (void)addNodes:(NSSet *)nodes withParent:(id<GRKNode>)parent;

@end

@protocol GRKGraphViewDelegate <NSObject>

@optional

- (GRKNodeView *)graphView:(GRKGraphView *)graphView viewForNode:(id<GRKNode>)node;
- (void)graphView:(GRKGraphView *)graphView didSelectNode:(id<GRKNode>)node;
- (void)graphView:(GRKGraphView *)graphView didDeselectNode:(id<GRKNode>)node;

@end
