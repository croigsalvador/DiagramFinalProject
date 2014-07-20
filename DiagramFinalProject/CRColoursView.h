//
//  CRColoursView.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 17/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorViewDelegate;

@interface CRColoursView : UIView
@property (weak,nonatomic) id<ColorViewDelegate> delegate;
@end

@protocol ColorViewDelegate <NSObject>

- (void)sendInView:(CRColoursView *)colorView selectedColor:(NSString *)color;

@end
