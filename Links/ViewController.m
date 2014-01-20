//
//  ViewController.m
//  Links
//
//  Created by Alexander Ignatenko on 12/31/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "ViewController.h"
#import "GRKGraphView.h"

@interface ViewController () <GRKGraphViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    GRKGraphView *graphView = [[GRKGraphView alloc] initWithFrame:self.view.bounds];
    graphView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:graphView];
}

#pragma mark - GRKGraphViewDelegate

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
