//
//  GRKShape3.m
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import "GRKShape3.h"

static GRKShape3Data GRKShape3DataMake(NSInteger shapeNumber)
{
    GRKShape3Data shapeData;
    memset(&shapeData, 0, sizeof(shapeData));
    shapeData.id = shapeNumber;
    return shapeData;
}

bool GRKShape3DataIsLine(const GRKShape3Data *collision)
{
    return collision->is.line;
}

bool GRKShape3DataIsEllipse(const GRKShape3Data *collision)
{
    return collision->is.ellipse;
}

bool GRKShape3DataIsPath(const GRKShape3Data *collision)
{
    return collision->is.path;
}

const GRKShape3Data GRKShape3DataMakeLine(CGPoint points[2])
{
    GRKShape3Data shapeData = GRKShape3DataMake(GRKShape3TypeLine);
    shapeData.is.line = 1;
    shapeData.line.points[0] = points[0];
    shapeData.line.points[1] = points[1];
    return shapeData;
}

void GRKShape3DataCleanup(GRKShape3Data *shapeData)
{
    if (NULL != shapeData->path.CGPath)
        CGPathRelease(shapeData->path.CGPath);
}

#pragma mark Shape Make Functions

@interface GRKShape3Loader : NSObject

@end

static const GRKShape3Data ellipseShape3Make(NSInteger shapeNumber, CGRect boundingBox, id opts)
{
    GRKShape3Data shapeData = GRKShape3DataMake(shapeNumber);
    shapeData.boundingBox = boundingBox;
    shapeData.is.ellipse = 1;
    shapeData.ellipse.center = CGPointMake(CGRectGetMidX(boundingBox), CGRectGetMidY(boundingBox));
    shapeData.ellipse.radii = CGSizeMake(round(0.5 * CGRectGetWidth(boundingBox)),
                                            round(0.5 * CGRectGetHeight(boundingBox)));
    return shapeData;
}

static NSMutableDictionary *GRKShapes;

@implementation GRKShape3Loader

+ (void)registerShapeMakeFunc:(GRKShape3MakeFunc)func forNumber:(NSInteger)number
{
    if (nil == GRKShapes)
        GRKShapes = [NSMutableDictionary dictionary];

    NSValue *value = [NSValue valueWithBytes:&func objCType:@encode(intptr_t)];
    [GRKShapes setObject:value forKey:@(number)];
}

+ (void)initialize
{
    if ([self class] == [GRKShape3Loader class]) {
        [self registerShapeMakeFunc:ellipseShape3Make forNumber:GRKShape3TypeEllipse];
    }
}

+ (GRKShape3MakeFunc)funcForNumber:(NSInteger)number
{
    NSValue *value = GRKShapes[@(number)];
    GRKShape3MakeFunc func;
    [value getValue:&func];
    return func;
}

@end

const GRKShape3Data GRKShapeMake(NSInteger shapeNumber, CGRect boundingBox, id opts)
{
    GRKShape3MakeFunc func = [GRKShape3Loader funcForNumber:shapeNumber];
    return func(shapeNumber, boundingBox, opts);
}
