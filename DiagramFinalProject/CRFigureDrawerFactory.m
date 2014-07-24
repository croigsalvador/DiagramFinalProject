//  CRFigureDrawerFactory.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 23/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRFigureDrawerFactory.h"
#import "CRSquareMapView.h"
#import "CRCircleMapView.h"
#import "CRPolygonMapView.h"
#import "CRTriangleMapView.h"
#import "UIFont+Common.h"

// I know that have the model in the View is not the best way,
// but it is the simpliest way that I found to know
// which node has a relation with each UIView
#import "Node+Model.h"

@interface CRFigureDrawerFactory ()
@property (strong,nonatomic) UILabel * titleLabel;
@property (strong,nonatomic) UILabel * textLabel;
@property (strong,nonatomic) UIView * figureView;
@end

@implementation CRFigureDrawerFactory

- (id)initWithFrame:(CGRect)frame andNode:(Node *)node {
    return  [self initWithFrame:frame andShapeType:[node.shapeType intValue] andNode:node];
}

//Designate Initializer
- (id)initWithFrame:(CGRect)frame andShapeType:(CRNodeTypeShape)shapeType andNode:(Node *)node {
    self = [super initWithFrame:frame];
    if (self) {
        switch (shapeType) {
            case CRNodeTypeShapeSquare:
                self = [[CRSquareMapView alloc] initWithFrame:frame andNode:node];
                break;
            case CRNodeTypeShapeCircle:
                self = [[CRCircleMapView alloc] initWithFrame:frame andNode:node];
                break;
            case CRNodeTypeShapeTriangle:
                self = [[CRPolygonMapView alloc] initWithFrame:frame andNode:node];
                break;
            case CRNodeTypeShapePolygon:
                self = [[CRTriangleMapView alloc] initWithFrame:frame andNode:node];
                break;
        }
        if (node) {
            [self setupTextLabels];
        }
    }
    return self;
}

- (void)updateFigure {
    UIColor *figureColor = [UIColor flatEmeraldColor];
    if (self.node.color) {
        figureColor = [UIColor colorFromText:self.node.color];
    }
    self.color = figureColor;
    self.titleLabel.text = self.node.title;
    self.titleLabel.font = [UIFont montserratRegular];
}

- (void)hideTextLabels {
    [self.titleLabel removeFromSuperview];
    
}

- (void)setupTextLabels {
    CGRect labelFrame = CGRectInset(self.bounds, 10, 10);
    self.titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font =  [UIFont montserratRegularBig];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    [self updateFigure];
}


#pragma mark - Setup Elements

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(changeSelectedView:)]) {
        [self.delegate changeSelectedView:self];
    }
}

@end
