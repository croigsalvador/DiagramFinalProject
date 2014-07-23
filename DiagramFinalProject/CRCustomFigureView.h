//
//  CRCustomFigureView.h
//  ConceptualMap
//
//  Created by Carlos Roig Salvador on 04/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRCustomViewDelegate;
@class Node;

@interface CRCustomFigureView : UIView

@property (weak,nonatomic) id <CRCustomViewDelegate> delegate;
@property (copy,nonatomic) NSString *titleText;
@property (strong,nonatomic) Node *node;

@end

@protocol CRCustomViewDelegate <NSObject>

- (void)changeSelectedView:(CRCustomFigureView *)view;

@end