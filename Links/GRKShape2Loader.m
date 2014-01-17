//
//  GRKShape2Loader.m
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKShape2Loader.h"
#import "GRKShape2.h"

@interface GRKEllipseShape2Maker : NSObject <GRKShape2Maker>
@end

static NSMutableDictionary *GRKShapeMakers;

@implementation GRKShape2Loader

+ (void)initialize
{
    if ([self class] == [GRKShape2 class]) {
        [self registerShapeMaker:[[GRKEllipseShape2Maker alloc] init] forNumber:GRKShape2TypeEllipse];
    }
}

+ (GRKShape2 *)shapeWithNumber:(NSInteger)number
                   boundingBox:(CGRect)boundingBox
                    dataSource:(id)dataSource
{
    id<GRKShape2Maker> maker = GRKShapeMakers[@(number)];
    GRKShape2 *shape = [maker makeShapeWithNumber:number boundingBox:boundingBox dataSource:dataSource];
    return shape;
}

+ (void)registerShapeMaker:(id<GRKShape2Maker>)maker forNumber:(NSInteger)number
{

    if (nil == GRKShapeMakers)
        GRKShapeMakers = [[NSMutableDictionary alloc] init];

    GRKShapeMakers[@(number)] = maker;
}

@end

#pragma mark - Shape Makers implementation

@implementation GRKEllipseShape2Maker

- (GRKShape2 *)makeShapeWithNumber:(NSInteger)shapeNumber
                       boundingBox:(CGRect)boundingBox
                        dataSource:(id)dataSource
{
    GRKMutableShape2 *shape = [[GRKMutableShape2 alloc] init];
    [shape setEllipseCenter:CGPointMake(CGRectGetMidX(boundingBox), CGRectGetMidY(boundingBox))
                      radii:CGSizeMake(round( 0.5 * CGRectGetWidth(boundingBox)), round(0.5 * CGRectGetHeight(boundingBox)))];
    return shape.copy;
}

@end
