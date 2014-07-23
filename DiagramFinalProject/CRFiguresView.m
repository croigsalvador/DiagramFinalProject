//
//  CRFiguresView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 22/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRFiguresView.h"
#import "CRSquareFigureView.h"
#import "CRRoundColorView.h"

@implementation CRFiguresView

- (void)awakeFromNib {
    [self setupFigures];
}

- (void)setupFigures {
    CGRect figureFrame = CGRectMake(10, 20, 70, 70);
    [self setupSquareViewWithFrame:figureFrame];
    figureFrame.origin.y = CGRectGetMaxY(figureFrame) + 10;
    [self setupCircleViewWithFrame:figureFrame];
}

- (void)setupSquareViewWithFrame:(CGRect)figureFrame {
    CRSquareFigureView *squareView = [[CRSquareFigureView alloc] initWithFrame:figureFrame andColor:[UIColor flatConcreteColor]];
    [self addTapGestureToView:squareView];
    [self addSubview:squareView];
}

- (void)setupCircleViewWithFrame:(CGRect)figureFrame {
    UIColor *currentColor = [UIColor flatConcreteColor];
    CRRoundColorView *roundView = [[CRRoundColorView alloc] initWithFrame:figureFrame andColor:currentColor];
    roundView.alpha = 0.8;
    [self addTapGestureToView:roundView];
    [self addSubview:roundView];
}

- (void)addTapGestureToView:(UIView *)colorView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(figureViewPressed:)];
    [colorView addGestureRecognizer:tapGesture];
}

- (void)figureViewPressed:(UITapGestureRecognizer *)sender {
    CRSquareFigureView *figureView =(CRSquareFigureView *)sender.view;
    if ([self.delegate respondsToSelector:@selector(sendTappedView:)]) {
        [self.delegate sendTappedView:figureView];
    }
}

@end
