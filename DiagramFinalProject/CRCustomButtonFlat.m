//
//  CRCustomButtonFlat.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRCustomButtonFlat.h"
#import "UIFont+Common.h"

@interface CRCustomButtonFlat ()

@property (nonatomic, strong) UIView *shadow;
@property (nonatomic,copy) PressedButtonBlock pressedBlock;

@end

@implementation CRCustomButtonFlat

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color text:(NSString *)title andBlock:(PressedButtonBlock)pressedBlock {
    
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        _title = title;
        _pressedBlock = pressedBlock;
    }
    [self setup];
    return self;
}

- (void) setup {
    self.backgroundColor = self.color;
    
    UILabel *buttonTitle = [[UILabel alloc]initWithFrame:CGRectInset(self.bounds, 10, 10)];
    buttonTitle.text = self.title;
    buttonTitle.textColor = [UIColor whiteColor];
    buttonTitle.textAlignment = NSTextAlignmentCenter;
    buttonTitle.font = [UIFont montserratRegular];
    [self addSubview:buttonTitle];
    
    CGFloat shadowHeight = 5;
    self.shadow = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                          self.bounds.size.height - shadowHeight,
                                                          self.bounds.size.width,
                                                          shadowHeight)];
    self.shadow.backgroundColor = [UIColor blackColor];
    self.shadow.alpha = 0.2;
    [self addSubview:self.shadow];
}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.shadow.frame = self.bounds;
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat shadowHeight = 5;
    self.shadow.frame = CGRectMake(0,
                                   self.bounds.size.height - shadowHeight,
                                   self.bounds.size.width,
                                   shadowHeight);
    self.pressedBlock(YES);
}


@end
