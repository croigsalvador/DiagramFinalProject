//
//  CRSquareFigureView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 17/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRSquareFigureView.h"

@implementation CRSquareFigureView

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat borderWidth = 1.0f;
        self.backgroundColor =  color;
        self.frame = CGRectInset(self.frame, -borderWidth, -borderWidth);
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = borderWidth;
    }
    return self;
}


@end
