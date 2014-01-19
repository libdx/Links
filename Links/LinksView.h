//
//  LinksView.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Link;

@protocol GRKLinksView <NSObject>

- (instancetype)initWithFrame:(CGRect)frame links:(NSSet *)links;

- (void)setNeedsUpdateByAddingLinks:(NSSet *)links;
- (void)setNeedsUpdateBySubtractingLinks:(NSSet *)links;
- (void)setNeedsUpdateForLinks:(NSSet *)links;

@end

@interface GRKDrawingLinksView : UIView <GRKLinksView>

@end

@interface GRKViewedLinksView : UIView <GRKLinksView>

@end