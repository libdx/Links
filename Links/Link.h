//
//  Link.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Node;

@interface Link : NSObject

@property (strong, nonatomic) id<Node> parentNode;
@property (strong, nonatomic) id<Node> childNode;

- (instancetype)initWithParentNode:(id<Node>)parent childNode:(id<Node>)child;

@end
