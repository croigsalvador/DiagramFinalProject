//
//  CRFiguresView.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 22/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRSquareFigureView;

@protocol FigureViewDelegate;

@interface CRFiguresView : UIView
@property (weak,nonatomic)IBOutlet id<FigureViewDelegate> delegate;

@end

@protocol FigureViewDelegate <NSObject>

- (void)sendTappedView:(CRSquareFigureView *)selectedView;

@end
