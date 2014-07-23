//
//  CRCustomFigureView.m
//  ConceptualMap
//
//  Created by Carlos Roig Salvador on 04/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRCustomFigureView.h"
#import "Node+Model.h"
#import "CRSquareFigureView.h"
#import "CRRoundColorView.h"

@interface CRCustomFigureView ()

@property (nonatomic, assign) CGPoint currentTouch;
@property (nonatomic, strong) UIView *dragView;
@property (strong,nonatomic) UILabel * titleLabel;
@property (strong,nonatomic) UILabel * textLabel;
@property (strong,nonatomic) UIView * figureView;

@end

@implementation CRCustomFigureView

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupTextLabels];
    }
    return self;
}

- (void)setNode:(Node *)node {
    _node = node;
    [self updateFigure];
    
}

- (void)updateFigure {
    UIColor *figureColor =[UIColor colorFromText:self.node.color];
    self.titleLabel.text = self.node.title;
    self.textLabel.text = self.node.text;
    [self setupFigureViewWithColor:figureColor];
}


#pragma mark - Setup Elements

- (void)setupFigureViewWithColor:(UIColor *)figureColor {
    if (self.figureView) {
        [self.figureView removeFromSuperview];
    }
    switch ([self.node.shapeType intValue]) {
        case CRNodeTypeShapeSquare:
            self.figureView = [[CRSquareFigureView alloc] initWithFrame:self.bounds andColor:figureColor];
            break;
        case CRNodeTypeShapeCircle:
            self.figureView = [[CRRoundColorView alloc] initWithFrame:self.bounds andColor:figureColor];
            break;
        case CRNodeTypeShapeTriangle:
            break;
        case CRNodeTypeShapePolygon:
            break;
    }
    [self addSubview:self.figureView];
}

- (void)setupTextLabels {
    CGRect labelFrame = CGRectMake(5, 15, self.bounds.size.width - 20, 15);
    self.titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font =  [UIFont systemFontOfSize:12];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    labelFrame.origin.y = CGRectGetMaxY(self.titleLabel.frame) + 20;
    
    self.textLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font =  [UIFont systemFontOfSize:14];
    self.textLabel.backgroundColor = [UIColor clearColor];

    self.textLabel.numberOfLines = 0;
    [self addSubview:self.textLabel];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(changeSelectedView:)]) {
        [self.delegate changeSelectedView:self];
    }
}


@end
