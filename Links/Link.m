//
//  Link.m
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "Link.h"

@implementation Link

- (instancetype)initWithParentNode:(id<Node>)parent childNode:(id<Node>)child;
{
    self = [super init];
    if (nil == self)
        return nil;

    _parentNode = parent;
    _childNode = child;

    return self;
}

@end
