//
//  NSSet+SetOperations.h
//  Links
//
//  Created by Alexander Ignatenko on 1/3/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (SetOperations)

- (NSSet *)setByRemovingObjectsInSet:(NSSet *)other;

@end
