//
//  CRRoundColorView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRRoundColorView.h"

@interface CRRoundColorView ()
@property (strong,nonatomic) UIColor *color;
@end
@implementation CRRoundColorView

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        _color = color;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: self.bounds];
    [self.color setFill];
    [ovalPath fill];
}


@end
