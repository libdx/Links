//
//  GraphView.m
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKGraphView.h"
#import "GRKLinksView.h"
#import "GRKNode.h"
#import "GRKLink.h"
#import "GRKNodeView.h"

@interface GRKGraphView ()

@property (strong, nonatomic) UIView<GRKLinksView> *linksView;

@property (strong, nonatomic) NSMutableOrderedSet *nodes;
@property (strong, nonatomic) NSMutableOrderedSet *links;

@property (strong, nonatomic) NSMutableSet *nodeViews;

@property (strong, nonatomic) NSSet *movedViews;

@end

static NSSet *setByRemovingObjectsInSet(NSSet *set, NSSet *other)
{
    NSMutableSet *new = set.mutableCopy;
    [new minusSet:other];
    return new.copy;
}

static void setCenterX(UIView *view, CGFloat centerX)
{
    view.center = CGPointMake(centerX, view.center.y);
}

static void setCenterY(UIView *view, CGFloat centerY)
{
    view.center = CGPointMake(view.center.x, centerY);
}

@implementation GRKGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _linksView = [[GRKDrawingLinksView alloc] initWithFrame:self.bounds links:_links.set];
        [self addSubview:_linksView];
        _nodes = [[NSMutableOrderedSet alloc] init];
        _links = [[NSMutableOrderedSet alloc] init];
        _nodeViews = [[NSMutableSet alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)didTap:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self];

    UIView *view = [self hitTest:location withEvent:nil];
    if ([view isKindOfClass:[GRKNodeView class]]) {
        GRKNodeView *nodeView = (GRKNodeView *)view;
        id<GRKNode> node = nodeView.node;
        BOOL selected  = !node.isSelected;
        node.selected = selected;
        nodeView.selected = selected;
        if (nodeView.isSelected)
            [self bringSubviewToFront:nodeView];

        if (node.isSelected && [_delegate respondsToSelector:@selector(graphView:didSelectNode:)])
            [_delegate graphView:self didSelectNode:node];
        else if (!node.isSelected && [_delegate respondsToSelector:@selector(graphView:didDeselectNode:)])
            [_delegate graphView:self didDeselectNode:node];
    }
}

- (void)setNeedsUpdateByAddingNode:(id<GRKNode>)node link:(id<GRKLink>)link
{
    NSSet *nodes = [NSSet setWithObjects:node, nil];
    NSSet *links = [NSSet setWithObjects:link, nil];
    [self setNeedsUpdateByAddingNodes:nodes links:links];
}

- (void)setNeedsUpdateByAddingNodes:(NSSet *)nodes links:(NSSet *)links
{
    [_nodes unionSet:nodes];
    [_links unionSet:links];

    [self setNeedsLayout];
    [_linksView setNeedsUpdateByAddingLinks:links];
}

- (void)setNeedsUpdateBySubtractingNodes:(NSSet *)nodes links:(NSSet *)links
{
    [_nodes minusSet:nodes];
    [_links minusSet:links];

    [self setNeedsLayout];
    [_linksView setNeedsUpdateByAddingLinks:links];
}

- (NSSet *)allNodes
{
    return _nodes.set;
}

- (NSSet *)allLinks
{
    return _links.set;
}

- (void)addNode:(id<GRKNode>)node
{
    [self addNodes:[NSSet setWithObjects:node, nil]];
}

- (void)addNodes:(NSSet *)nodes
{
    [self addNodes:nodes withParent:nil];
}

- (void)addNode:(id<GRKNode>)node withParent:(id<GRKNode>)parent
{
    [self addNodes:[NSSet setWithObjects:node, nil] withParent:parent];
}

- (void)addNodes:(NSSet *)nodes withParent:(id<GRKNode>)parent
{
    NSMutableSet *links;
    if (parent) {
        if (![_nodes containsObject:parent]) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Given node as a parent %@ is not part of nodes' graph", parent];
        }
        links = [NSMutableSet set];
        for (id<GRKNode> node in nodes) {
            id<GRKLink> link = [_delegate graphView:self linkForParentNode:parent childNode:node];
            if (nil == link)
                [NSException raise:NSInvalidArgumentException format:@"Link can't be nil, but nil is given"];
            [links addObject:link];
        }
    }

    [self setNeedsUpdateByAddingNodes:nodes links:links];
}

- (void)removeNode:(id<GRKNode>)node
{
    [self removeNodes:[NSSet setWithObject:node]];
}

- (void)removeNodes:(NSSet *)nodes
{
    NSPredicate *parentOrChildNode = [NSPredicate predicateWithFormat:@"parentNode IN %@ OR childNode IN %@",
                                      nodes, nodes];
    NSOrderedSet *links = [_links filteredOrderedSetUsingPredicate:parentOrChildNode];
    [_links minusOrderedSet:links];
    [_nodes minusSet:nodes];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // update links view frame

    _linksView.frame = self.bounds;

    // balancing views with nodes

    NSSet *abandonedViews;
    NSSet *newViews;

    [self abandonedViews:&abandonedViews
                newViews:&newViews
         amongShownNodes:[_nodeViews valueForKeyPath:@"@distinctUnionOfObjects.node"]
             actualNodes:_nodes.set];

    [abandonedViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [newViews enumerateObjectsUsingBlock:^(UIView *view, BOOL *stop) {
        [_nodeViews addObject:view];
        [self addSubview:view];
    }];
}

- (void)abandonedViews:(NSSet **)outAbandonedViews
              newViews:(NSSet **)outNewViews
       amongShownNodes:(NSSet *)shownNodes
           actualNodes:(NSSet *)actualNodes
{
    NSSet *abandonedNodes = setByRemovingObjectsInSet(shownNodes, actualNodes);
    NSSet *newNodes = setByRemovingObjectsInSet(actualNodes, shownNodes);

    NSPredicate *inAbandonedNodes = [NSPredicate predicateWithFormat:@"node in %@", abandonedNodes];
    *outAbandonedViews = [_nodeViews filteredSetUsingPredicate:inAbandonedNodes];

    NSMutableSet *newViews = [NSMutableSet set]; for (id<GRKNode> node in newNodes) {
        CGFloat x = node.center.x - round(node.size.width * 0.5);
        CGFloat y = node.center.y - round(node.size.height * 0.5);
        CGRect frame = CGRectMake(x,
                                  y,
                                  node.size.width,
                                  node.size.height);
        UIView *view;
        if ([_delegate respondsToSelector:@selector(graphView:viewForNode:)]) {
            view = [_delegate graphView:self viewForNode:node];
            view.frame = frame;
        }
        if (nil == view)
            view = [[GRKNodeView alloc] initWithFrame:frame node:node];
        [newViews addObject:view];
    }
    *outNewViews = newViews.copy;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSPredicate *selected = [NSPredicate predicateWithFormat:@"isSelected = TRUE"];
    _movedViews = [_nodeViews filteredSetUsingPredicate:selected];
    UITouch *touch = touches.anyObject;
    if (![touch.view isKindOfClass:[GRKNodeView class]]) {
        [_movedViews enumerateObjectsUsingBlock:^(GRKNodeView *view, BOOL *stop) {
            view.node.selected = NO;
            view.selected = NO;
        }];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    CGPoint delta = CGPointMake(location.x - previousLocation.x, location.y - previousLocation.y);

    // if move is made over not selected view, we'll move only this one
    UIView *view = [self hitTest:location withEvent:event];
    if ([view isKindOfClass:[GRKNodeView class]]) {
        GRKNodeView *nodeView = (GRKNodeView *)view;
        if (NO == nodeView.isSelected) {
            nodeView.selected = YES;
            nodeView.node.selected = YES;
            for (GRKNodeView *view in _movedViews)
                view.selected = NO;
            _movedViews = [NSSet setWithObject:view];
        }
    }

    for (GRKNodeView *view in _movedViews) {
        setCenterX(view, view.center.x + delta.x);
        setCenterY(view, view.center.y + delta.y);
        id<GRKNode> node = view.node;
        node.center = view.center;
    }

//    NSSet *movedNodes = [_movedViews valueForKeyPath:@"@distinctUnionOfObjects.node"];
//    NSPredicate *parentOrChildNode = [NSPredicate predicateWithFormat:@"parentNode IN %@ OR childNode IN %@",
//                                      movedNodes, movedNodes];
//    NSSet *affectedLinks = [_links filteredOrderedSetUsingPredicate:parentOrChildNode].set;
//    [_linksView setNeedsUpdateForLinks:affectedLinks];
    [_linksView setNeedsUpdateForLinks:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_movedViews enumerateObjectsUsingBlock:^(GRKNodeView *view, BOOL *stop) {
        id<GRKNode> node = view.node;
        node.center = view.center;
    }];

    _movedViews = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _movedViews = nil;
}

@end
