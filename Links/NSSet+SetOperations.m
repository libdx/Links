//
//  NSSet+SetOperations.m
//  Links
//
//  Created by Alexander Ignatenko on 1/3/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "NSSet+SetOperations.h"

@implementation NSSet (SetOperations)

- (NSSet *)setByRemovingObjectsInSet:(NSSet *)other
{
    NSMutableSet *set = self.mutableCopy;
    [set minusSet:other];
    return set.copy;
}

@end
