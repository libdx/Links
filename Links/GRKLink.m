//
//  Link.m
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKLink.h"

@implementation GRKLink

- (instancetype)initWithParentNode:(id<GRKNode>)parent childNode:(id<GRKNode>)child;
{
    self = [super init];
    if (nil == self)
        return nil;

    _parentNode = parent;
    _childNode = child;

    return self;
}

@end
