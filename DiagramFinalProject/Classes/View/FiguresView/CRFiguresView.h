//
//  CRFiguresView.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 22/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRFigureDrawerFactory;

@protocol FigureViewDelegate;

@interface CRFiguresView : UIView
@property (weak,nonatomic)IBOutlet id<FigureViewDelegate> delegate;
@end

@protocol FigureViewDelegate <NSObject>

- (void)sendTappedView:(CRFigureDrawerFactory *)selectedView withTag:(NSUInteger)tag;
- (void)deleteButtonPressed:(CRFiguresView *)figureDrawer;
- (void)writeButtonPressed:(CRFiguresView *)figureDrawer;

@end
