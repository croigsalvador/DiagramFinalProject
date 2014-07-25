//
//  CRTriangleMapView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRTriangleMapView.h"

@implementation CRTriangleMapView

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
    CGFloat minX = 0;
    CGFloat minY = 0;
    
    CGFloat midX = CGRectGetMidX(self.bounds);
    
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    
    UIBezierPath* trianglePath = UIBezierPath.bezierPath;

    NSLog(@"%f, %f %f",midX, maxX, maxY );
    [trianglePath moveToPoint: CGPointMake(midX, minY)];
    [trianglePath addLineToPoint: CGPointMake(maxX,maxY)];
    [trianglePath addLineToPoint: CGPointMake(minX, maxY)];
    [trianglePath closePath];
    [self.color setFill];
    [trianglePath fill];

}

@end
