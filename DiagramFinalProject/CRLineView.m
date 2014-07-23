//
//  CRLineView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 23/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRLineView.h"

@interface CRLineView ()

@property (strong,nonatomic) CAShapeLayer *shapeLine;

@end

@implementation CRLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)initialPoint {
    _initialPoint = initialPoint;
}

- (void)setFinalPoint:(CGPoint)finalPoint {
    _finalPoint = finalPoint;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
