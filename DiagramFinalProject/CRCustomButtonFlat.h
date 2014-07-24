//
//  CRCustomButtonFlat.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PressedButtonBlock)(BOOL);

@interface CRCustomButtonFlat : UIView
@property (strong,nonatomic) UIColor *color;
@property (nonatomic,copy) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color text:(NSString *)title andBlock:(PressedButtonBlock)pressedBlock;

@end
