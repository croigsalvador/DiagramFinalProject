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
#import "CRCustomButtonFlat.h"

static CGFloat kButtonHeight                = 40.0f;
static CGFloat kButttonWidth                = 100.0f;

static CGFloat kFigureWidth                 = 70.0f;
static CGFloat kFigureHeight                = 70.0f;

static CGFloat kMarginLeftButton            = 10.0f;
//static CGFloat kMarginTopButton           = 20.0f;

static CGFloat kMarginLeftFigure            = 25.0f;
static CGFloat kMarginTopFigure             = 25.0f;

@interface CRFiguresView ()

@end

@implementation CRFiguresView

- (void)awakeFromNib {
    [self setupFigures];
    [self setupButtons];
}


#pragma mark - Setup Elements

- (void)setupButtons {
    
    CGRect buttonFrame = CGRectMake(kMarginLeftButton, 460, kButttonWidth, kButtonHeight);
    
    __weak typeof(self) weakSelf = self;
    CRCustomButtonFlat *deleteButton = [[CRCustomButtonFlat alloc] initWithFrame:buttonFrame color:[UIColor flatAlizarinColor] text:@"Eliminar" andBlock:^() {
        __strong typeof(weakSelf) self = weakSelf;
        [self deleteButtonPressed];
    }];
    [self addSubview:deleteButton];
    
    buttonFrame.origin.y = CGRectGetMaxY(deleteButton.frame) + kMarginLeftButton;
    
    CRCustomButtonFlat *writeButton = [[CRCustomButtonFlat alloc] initWithFrame:buttonFrame color:[UIColor flatSilverColor] text:@"Abc" andBlock:^() {
        __strong typeof(weakSelf) self = weakSelf;
        [self writeButtonPressed];
    }];
    [self addSubview:writeButton];
    
    
}

- (void)setupFigures {
    CGRect figureFrame = CGRectMake(kMarginLeftFigure, kMarginTopFigure, kFigureWidth, kFigureHeight);
    [self setupSquareViewWithFrame:figureFrame shapeType:0];
    figureFrame.origin.y = CGRectGetMaxY(figureFrame) + kMarginTopFigure;
    [self setupSquareViewWithFrame:figureFrame shapeType:1];
    figureFrame.origin.y = CGRectGetMaxY(figureFrame) + kMarginTopFigure;
    [self setupSquareViewWithFrame:figureFrame shapeType:2];
    figureFrame.origin.y = CGRectGetMaxY(figureFrame) + kMarginTopFigure;
    [self setupSquareViewWithFrame:figureFrame shapeType:3];
}


- (void)setupSquareViewWithFrame:(CGRect)figureFrame shapeType:(NSUInteger)shapeType {
    CRFigureDrawerFactory *squareView = [[CRFigureDrawerFactory alloc] initWithFrame:figureFrame andShapeType:shapeType andNode:nil];
    squareView.color = [UIColor lightGrayCustomDDD];
    squareView.tag = shapeType;
    [self addTapGestureToView:squareView];
    [self addSubview:squareView];
}

#pragma mark - Setting Gestures 

- (void)addTapGestureToView:(UIView *)colorView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(figureViewPressed:)];
    [colorView addGestureRecognizer:tapGesture];
}

#pragma mark - Action Methods

- (void)deleteButtonPressed {
    if ([self.delegate respondsToSelector:@selector(deleteButtonPressed:)]) {
        [self.delegate deleteButtonPressed:self];
    }
}
- (void)writeButtonPressed {
    if ([self.delegate respondsToSelector:@selector(writeButtonPressed:)]) {
        [self.delegate writeButtonPressed:self];
    }
}

- (void)figureViewPressed:(UITapGestureRecognizer *)sender {
    CRFigureDrawerFactory *figureView = (CRFigureDrawerFactory *)sender.view;
    if ([self.delegate respondsToSelector:@selector(sendTappedView:withTag:)]) {
        [self.delegate sendTappedView:figureView withTag:figureView.tag];
    }
}

@end
