//
//  GRKShape.m
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKShape.h"

static GRKShapeData GRKShapeDataMake(NSInteger shapeNumber)
{
    GRKShapeData shapeData;
    memset(&shapeData, 0, sizeof(shapeData));
    shapeData.id = shapeNumber;
    return shapeData;
}

bool GRKShapeDataIsLine(const GRKShapeData *collision)
{
    return collision->is.line;
}

bool GRKShapeDataIsEllipse(const GRKShapeData *collision)
{
    return collision->is.ellipse;
}

bool GRKShapeDataIsPath(const GRKShapeData *collision)
{
    return collision->is.path;
}

const GRKShapeData GRKShapeDataMakeLine(CGPoint points[2])
{
    GRKShapeData shapeData = GRKShapeDataMake(GRKShapeTypeLine);
    shapeData.is.line = 1;
    shapeData.line.points[0] = points[0];
    shapeData.line.points[1] = points[1];
    return shapeData;
}

void GRKShapeDataCleanup(GRKShapeData *shapeData)
{
    if (NULL != shapeData->path.CGPath)
        CGPathRelease(shapeData->path.CGPath);
}

#pragma mark Shape Make Functions

@interface GRKShapeLoader : NSObject

@end

static const GRKShapeData ellipseShape3Make(NSInteger shapeNumber, CGRect boundingBox, id opts)
{
    GRKShapeData shapeData = GRKShapeDataMake(shapeNumber);
    shapeData.boundingBox = boundingBox;
    shapeData.is.ellipse = 1;
    shapeData.ellipse.center = CGPointMake(CGRectGetMidX(boundingBox), CGRectGetMidY(boundingBox));
    shapeData.ellipse.radii = CGSizeMake(round(0.5 * CGRectGetWidth(boundingBox)),
                                            round(0.5 * CGRectGetHeight(boundingBox)));
    return shapeData;
}

static NSMutableDictionary *GRKShapes;

@implementation GRKShapeLoader

+ (void)registerShapeMakeFunc:(GRKShapeMakeFunc)func forNumber:(NSInteger)number
{
    if (nil == GRKShapes)
        GRKShapes = [NSMutableDictionary dictionary];

    NSValue *value = [NSValue valueWithBytes:&func objCType:@encode(intptr_t)];
    [GRKShapes setObject:value forKey:@(number)];
}

+ (void)initialize
{
    if ([self class] == [GRKShapeLoader class]) {
        [self registerShapeMakeFunc:ellipseShape3Make forNumber:GRKShapeTypeEllipse];
    }
}

+ (GRKShapeMakeFunc)funcForNumber:(NSInteger)number
{
    NSValue *value = GRKShapes[@(number)];
    GRKShapeMakeFunc func;
    [value getValue:&func];
    return func;
}

@end

const GRKShapeData GRKShapeMake(NSInteger shapeNumber, CGRect boundingBox, id opts)
{
    GRKShapeMakeFunc func = [GRKShapeLoader funcForNumber:shapeNumber];
    return func(shapeNumber, boundingBox, opts);
}
