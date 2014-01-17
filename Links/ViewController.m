//
//  ViewController.m
//  Links
//
//  Created by Alexander Ignatenko on 12/31/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "ViewController.h"
#import "GraphView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    GraphView *graphView = [[GraphView alloc] initWithFrame:self.view.bounds];
    graphView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:graphView];
}

@end
