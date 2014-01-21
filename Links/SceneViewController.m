//
//  ViewController.m
//  Links
//
//  Created by Alexander Ignatenko on 12/31/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "SceneViewController.h"
#import "GraphKit.h"

@interface SceneViewController () <GRKGraphViewDelegate>

@property (strong, nonatomic) GRKGraphView *graphView;

@end

@implementation SceneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.graphView = [[GRKGraphView alloc] initWithFrame:self.view.bounds];
    self.graphView.delegate = self;
    self.graphView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(didDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.graphView addGestureRecognizer:doubleTap];
    [self.view addSubview:self.graphView];
}

- (void)didDoubleTap:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.graphView];
    id<GRKNode> node = [[GRKBaseNode alloc] initWithCenter:location size:CGSizeMake(84.0, 64.0)];
    [self.graphView addNode:node withParent:self.graphView.allNodes.anyObject];
}

#pragma mark - GRKGraphViewDelegate

- (id<GRKLink>)graphView:(GRKGraphView *)graphView linkForParentNode:(id<GRKNode>)parent childNode:(id<GRKNode>)child
{
    return [[GRKBaseLink alloc] initWithParentNode:parent childNode:child];
}

- (GRKNodeView *)graphView:(GRKGraphView *)graphView viewForNode:(id<GRKNode>)node
{
    return nil;
}

- (void)graphView:(GRKGraphView *)graphView didSelectNode:(id<GRKNode>)node
{

}

- (void)graphView:(GRKGraphView *)graphView didDeselectNode:(id<GRKNode>)node
{
    
}

@end
