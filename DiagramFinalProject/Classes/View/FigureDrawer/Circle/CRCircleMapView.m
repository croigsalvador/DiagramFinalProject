//
//  CRCircleMapView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRCircleMapView.h"

@implementation CRCircleMapView

@synthesize color = _color;
@synthesize node = _node;

- (id)initWithFrame:(CGRect)frame andNode:(Node *)node
{
    self = [super initWithFrame:frame];
    if (self) {
        // Gets into the setter (self)
        self.node = node;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
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

- (void)drawRect:(CGRect)rect {
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: self.bounds];
    [self.color setFill];
    [ovalPath fill];
}

@end
