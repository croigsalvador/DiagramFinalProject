//
//  CRAddNodeHeaderSection.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 22/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRAddNodeHeaderSection.h"

@interface CRAddNodeHeaderSection ()
@property (strong,nonatomic) UIButton *addNodeButton;
@end

@implementation CRAddNodeHeaderSection

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAddNodeButton];
        self.contentView.backgroundColor = [UIColor flatNephritisColor];
    }
    return self;
}

- (void)setupAddNodeButton{
    self.addNodeButton = [[UIButton alloc] initWithFrame:self.bounds];
    [self.addNodeButton setTitle:@"Añadir nueva figura" forState:UIControlStateNormal];
    [self.addNodeButton addTarget:self action:@selector(addNodeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addNodeButton];
}

- (void)addNodeButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addNodeButtonPressed:)]) {
        [self.delegate addNodeButtonPressed:self];
    }
}

@end
