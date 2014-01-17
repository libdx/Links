//
//  GRKShape.h
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#ifndef __GRKShape_H__
#define __GRKShape_H__

#include <objc/objc.h>
#include <CoreGraphics/CGBase.h>

typedef NS_ENUM(NSInteger, GRKShapeType) { // TODO: maybe use const char *const ?
    GRKShapeTypeNone = 0,
    GRKShapeTypeLine = 1,
    GRKShapeTypeEllipse = 2,
    GRKShapeTypeRect = 3, // as bezier path
    GRKShapeTypeStar = 4, // as bezier path

    GRKShapeTypeReserved,
};

struct GRKShapeData {
    NSInteger id;
    CGRect boundingBox;
    struct {
        unsigned line:1;
        unsigned ellipse:1;
        unsigned path:1;
    } is;
    struct {
        CGPoint points[2];
    } line;
    struct {
        CGPoint center;
        CGSize radii;
    } ellipse;
    struct {
        CGPathRef CGPath;
    } path;
};
typedef struct GRKShapeData GRKShapeData;

/* These 'is' methods are only interested for collision detector */
bool GRKShapeDataIsLine(const GRKShapeData *);
bool GRKShapeDataIsEllipse(const GRKShapeData *);
bool GRKShapeDataIsPath(const GRKShapeData *);

const GRKShapeData GRKShapeDataMakeLine(CGPoint points[2]);
void GRKShapeDataCleanup(GRKShapeData *);

const GRKShapeData GRKShapeMake(NSInteger shapeNumber, CGRect boundingBox, id opts);

// for custom shape make function creations
typedef const GRKShapeData (*GRKShapeMakeFunc) (NSInteger shapeNumber, CGRect boundingBox, id opts);

#endif // __GRKShape_H__
