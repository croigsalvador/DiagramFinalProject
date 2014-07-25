//
//  CRSquareMapView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRSquareMapView.h"
#import "Node.h"

@interface CRSquareMapView ()

@end

@implementation CRSquareMapView
@synthesize color = _color;
@synthesize node = _node;

- (id)initWithFrame:(CGRect)frame andNode:(Node *)node
{
    self = [super initWithFrame:frame];
    if (self) {
        // Gets into the setter (self)
        self.node = node;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.backgroundColor =  self.color;
}

- (void)setNode:(Node *)node {
    _node = node;
    [self updateFigure];
}

- (void)updateFigure {
    if (self.node) {
        [super updateFigure];
    }
}


@end
