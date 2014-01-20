//
//  Link.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GRKNode;

@interface GRKLink : NSObject

@property (strong, nonatomic) id<GRKNode> parentNode;
@property (strong, nonatomic) id<GRKNode> childNode;

- (instancetype)initWithParentNode:(id<GRKNode>)parent childNode:(id<GRKNode>)child;

@end
