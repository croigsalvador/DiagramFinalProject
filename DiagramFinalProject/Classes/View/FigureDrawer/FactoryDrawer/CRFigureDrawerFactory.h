//
//  CRFigureDrawerFactory.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 23/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node+Model.h"
@class Node;
@protocol CRFigureDrawerDelegate;

@interface CRFigureDrawerFactory : UIView

@property (strong,nonatomic)  Node *node;
@property (strong,nonatomic) UIColor *color;
@property (weak,nonatomic) id <CRFigureDrawerDelegate> delegate;
@property (assign,nonatomic) CGFloat width;

- (void)updateFigure;

- (id)initWithFrame:(CGRect)frame andNode:(Node *)node;
- (id)initWithFrame:(CGRect)frame andShapeType:(CRNodeTypeShape)shapeType andNode:(Node *)node;
@end
@protocol CRFigureDrawerDelegate <NSObject>

- (void)changeSelectedView:(CRFigureDrawerFactory *)view;

@end
