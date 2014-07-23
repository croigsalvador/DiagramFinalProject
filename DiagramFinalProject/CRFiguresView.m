//
//  CRFiguresView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 22/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRFiguresView.h"
#import "CRSquareMapView.h"
#import "CRRoundColorView.h"
#import "CRFigureDrawerFactory.h"

@implementation CRFiguresView

- (void)awakeFromNib {
    [self setupFigures];
}

- (void)setupFigures {
    CGRect figureFrame = CGRectMake(10, 20, 70, 70);
    [self setupSquareViewWithFrame:figureFrame shapeType:0];
    figureFrame.origin.y = CGRectGetMaxY(figureFrame) + 20;
    [self setupSquareViewWithFrame:figureFrame shapeType:1];
    figureFrame.origin.y = CGRectGetMaxY(figureFrame) + 20;
    [self setupSquareViewWithFrame:figureFrame shapeType:2];
    figureFrame.origin.y = CGRectGetMaxY(figureFrame) + 20;
    [self setupSquareViewWithFrame:figureFrame shapeType:3];
}

- (void)setupSquareViewWithFrame:(CGRect)figureFrame shapeType:(NSUInteger)shapeType {
    CRFigureDrawerFactory *squareView = [[CRFigureDrawerFactory alloc] initWithFrame:figureFrame andShapeType:shapeType andNode:nil];
    squareView.color = [UIColor redColor];
    squareView.tag = shapeType;
    [self addTapGestureToView:squareView];
    [self addSubview:squareView];
}

- (void)addTapGestureToView:(UIView *)colorView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(figureViewPressed:)];
    [colorView addGestureRecognizer:tapGesture];
}

- (void)figureViewPressed:(UITapGestureRecognizer *)sender {
    CRFigureDrawerFactory *figureView = (CRFigureDrawerFactory *)sender.view;
    if ([self.delegate respondsToSelector:@selector(sendTappedView:withTag:)]) {
        [self.delegate sendTappedView:figureView withTag:figureView.tag];
    }
}

@end
