//
//  CRPolygonMapView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRPolygonMapView.h"

@implementation CRPolygonMapView
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
    // Polygon
    UIBezierPath* polygonPath = UIBezierPath.bezierPath;
    CGFloat minX = 0;
    CGFloat minY = 0;
    
    CGFloat midY = CGRectGetHeight(self.bounds)/2.61f;
    CGFloat midX = CGRectGetMidX(self.bounds);
    
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    
    [polygonPath moveToPoint: CGPointMake(midX, minY)];
    [polygonPath addLineToPoint: CGPointMake(maxX,midY)];
    [polygonPath addLineToPoint: CGPointMake(CGRectGetWidth(self.bounds)/1.235f , maxY)];
    [polygonPath addLineToPoint: CGPointMake(CGRectGetWidth(self.bounds)/5.17f, maxY)];
    [polygonPath addLineToPoint: CGPointMake(minX, midY)];
    [polygonPath closePath];
    [self.color setFill];
    [polygonPath fill];
}

@end
