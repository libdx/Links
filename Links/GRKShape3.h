//
//  GRKShape3.h
//  Links
//
//  Created by Alexander Ignatenko on 1/15/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#ifndef __GRKShape3_H__
#define __GRKShape3_H__

#include <objc/objc.h>
#include <CoreGraphics/CGBase.h>

typedef NS_ENUM(NSInteger, GRKShape3Type) { // TODO: maybe use const char *const ?
    GRKShape3TypeNone = 0,
    GRKShape3TypeLine = 1,
    GRKShape3TypeEllipse = 2,
    GRKShape3TypeRect = 3, // as bezier path
    GRKShape3TypeStar = 4, // as bezier path

    GRKShape3TypeReserved,
};

struct GRKShape3Data {
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
typedef struct GRKShape3Data GRKShape3Data;

/* These 'is' methods are only interested for collision detector */
bool GRKShape3DataIsLine(const GRKShape3Data *);
bool GRKShape3DataIsEllipse(const GRKShape3Data *);
bool GRKShape3DataIsPath(const GRKShape3Data *);

const GRKShape3Data GRKShape3DataMakeLine(CGPoint points[2]);
void GRKShape3DataCleanup(GRKShape3Data *);

const GRKShape3Data GRKShapeMake(NSInteger shapeNumber, CGRect boundingBox, id opts);

// for custom shape make function creations
typedef const GRKShape3Data (*GRKShape3MakeFunc) (NSInteger shapeNumber, CGRect boundingBox, id opts);

#endif // __GRKShape3_H__
