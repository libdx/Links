//
//  GRKShape2Loader.h
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GRKShape2;
@protocol GRKShape2Maker;

@interface GRKShape2Loader : NSObject

+ (GRKShape2 *)shapeWithNumber:(NSInteger)number
                   boundingBox:(CGRect)boundingBox
                    dataSource:(id)dataSource;

+ (void)registerShapeMaker:(id<GRKShape2Maker>)maker forNumber:(NSInteger)number;

@end
