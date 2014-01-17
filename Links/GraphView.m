//
//  GraphView.m
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GraphView.h"
#import "LinksView.h"
#import "Node.h"
#import "Link.h"
#import "NodeView.h"

/* TODO:
 - physicsBody (bodyPath)
 - arrows and intersections
 */

@interface GraphView ()

@property (strong, nonatomic) LinksView *linksView;

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

@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _linksView = [[LinksView alloc] initWithFrame:self.bounds links:_links.set];
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
    if ([view isKindOfClass:[NodeView class]]) {
        NodeView *nodeView = (NodeView *)view;
        id<Node> node = nodeView.node;
        BOOL selected  = !node.isSelected;
        node.selected = selected;
        nodeView.selected = selected;

        if (node.isSelected && [_delegate respondsToSelector:@selector(graphView:didSelectNode:)])
            [_delegate graphView:self didSelectNode:node];
        else if (!node.isSelected && [_delegate respondsToSelector:@selector(graphView:didDeselectNode:)])
            [_delegate graphView:self didDeselectNode:node];
    } else {
        Link *link;
        id<Node> node = [self nodeWithCenter:location parent:_nodes.lastObject link:&link];

        [self setNeedsUpdateByAddingNode:node link:link];
    }
}

- (id<Node>)nodeWithCenter:(CGPoint)center parent:(id<Node>)parent link:(Link **)outLink
{
    id<Node> node = [[BaseNode alloc] initWithCenter:center];
    if (parent)
        *outLink = [[Link alloc] initWithParentNode:parent childNode:node];
    return node;
}

- (void)setNeedsUpdateByAddingNode:(id<Node>)node link:(Link *)link
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

- (void)addNode:(id<Node>)node
{
    [self addNodes:[NSSet setWithObjects:node, nil]];
}

- (void)addNodes:(NSSet *)nodes
{
    [self addNodes:nodes withParent:nil];
}

- (void)addNode:(id<Node>)node withParent:(id<Node>)parent
{
    [self addNodes:[NSSet setWithObjects:node, nil] withParent:parent];
}

- (void)addNodes:(NSSet *)nodes withParent:(id<Node>)parent
{
    NSMutableSet *links;
    if (parent) {
        if (![_nodes containsObject:parent]) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Given node as parent %@ is not part of nodes graph", parent];
        }
        links = [NSMutableSet set];
        [nodes enumerateObjectsUsingBlock:^(id<Node> node, BOOL *stop) {
            [links addObject:[[Link alloc] initWithParentNode:parent childNode:node]];
        }];
    }

    [_nodes unionSet:nodes];
    [_links unionSet:links];

    [self setNeedsUpdateByAddingNodes:nodes links:links];
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

    NSMutableSet *newViews = [NSMutableSet set]; for (id<Node> node in newNodes) {
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
        } else {
            view = [[NodeView alloc] initWithFrame:frame node:node];
        }
        [newViews addObject:view];
    }
    *outNewViews = newViews.copy;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSPredicate *selected = [NSPredicate predicateWithFormat:@"isSelected = TRUE"];
    _movedViews = [_nodeViews filteredSetUsingPredicate:selected];
    UITouch *touch = touches.anyObject;
    if (![touch.view isKindOfClass:[NodeView class]]) {
        [_movedViews enumerateObjectsUsingBlock:^(NodeView *view, BOOL *stop) {
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
    [_movedViews enumerateObjectsUsingBlock:^(NodeView *view, BOOL *stop) {
        setCenterX(view, view.center.x + delta.x);
        setCenterY(view, view.center.y + delta.y);
        id<Node> node = view.node;
        node.center = view.center;
    }];
    [_linksView setNeedsUpdate];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_movedViews enumerateObjectsUsingBlock:^(NodeView *view, BOOL *stop) {
        id<Node> node = view.node;
        node.center = view.center;
    }];

    _movedViews = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _movedViews = nil;
}

@end
