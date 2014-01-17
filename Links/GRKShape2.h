//
//  GRKShape2.h
//  Links
//
//  Created by Alexander Ignatenko on 1/14/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GRKShape2Type) {
    GRKShape2TypeLine = 1,
    GRKShape2TypeEllipse = 2,
    GRKShape2TypeRect = 3, // as bezier path
    GRKShape2TypeStar = 4, // as bezier path

    GRKShape2TypeReserved
};

@interface GRKShape2 : NSObject <NSCopying, NSMutableCopying>

@property (assign, nonatomic, readonly) CGRect boundingBox;
- (void)getLinePoints:(out CGPoint[static 2])points;
- (void)getEllipseCenter:(out CGPoint *)center radii:(out CGSize *)radii;
@property (assign, nonatomic, readonly) CGPathRef path;

@end

@interface GRKMutableShape2 : GRKShape2

@property (assign, nonatomic) CGRect boundingBox;
- (void)setLinePoints:(CGPoint[static 2])points;
- (void)setEllipseCenter:(CGPoint)center radii:(CGSize)radii;
@property (assign, nonatomic) CGPathRef path;

@end

@protocol GRKShape2Maker <NSObject>

- (GRKShape2 *)makeShapeWithNumber:(NSInteger)shapeNumber
                       boundingBox:(CGRect)boundingBox
                        dataSource:(id)dataSource;

@end
