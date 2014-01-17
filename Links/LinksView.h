//
//  LinksView.h
//  Links
//
//  Created by Alexander Ignatenko on 1/1/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Link;

@interface LinksView : UIView

- (instancetype)initWithFrame:(CGRect)frame links:(NSSet *)links;

- (void)setNeedsUpdateByAddingLinks:(NSSet *)links;
- (void)setNeedsUpdateBySubtractingLinks:(NSSet *)links;
- (void)setNeedsUpdate;

@end
