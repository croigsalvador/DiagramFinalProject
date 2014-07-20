//
//  CRColoursView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 17/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRColoursView.h"
#import "CRRoundColorView.h"

static CGFloat const kCircleHeight           = 50.0f;
@interface CRColoursView ()

@property (strong,nonatomic) CRRoundColorView *selectedRoundView;

@end

@implementation CRColoursView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [self setupBordersAndShadows];
    [self setupColorPalette];
}

- (void)setupBordersAndShadows {
    self.backgroundColor = [UIColor cr_darkColor];
    self.layer.shadowOffset = CGSizeMake(3 , 3);
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = .8f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.cornerRadius = 5.0f;
}

- (void)setupColorPalette {
    static CGFloat xOffsetFirstRow = 48.5f;
    
    for (int i = 0; i < 11; i++) {
        CGRect colorFrame = CGRectMake(xOffsetFirstRow, 10, kCircleHeight, kCircleHeight);
        CRRoundColorView *roundView = [[CRRoundColorView alloc] initWithFrame:colorFrame andColor:[UIColor blueColor]];
        roundView.alpha = 0.5;
        xOffsetFirstRow = CGRectGetMaxX(roundView.frame) + 15.3f ;
         UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roundViewPressed:)];
        [roundView addGestureRecognizer:tapGesture];
        [self addSubview:roundView];
    }
    static CGFloat xOffsetSecondRow = 15.8f;
    for (int i = 0; i < 12; i++) {
        CGRect colorFrame = CGRectMake(xOffsetSecondRow, 70, kCircleHeight, kCircleHeight);
        CRRoundColorView *roundView = [[CRRoundColorView alloc] initWithFrame:colorFrame andColor:[UIColor blueColor]];
        xOffsetSecondRow = CGRectGetMaxX(roundView.frame) + 15.3f;
        roundView.alpha = 0.5;
         UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roundViewPressed:)];
        [roundView addGestureRecognizer:tapGesture];
        [self addSubview:roundView];
    }
}

- (void)roundViewPressed:(UITapGestureRecognizer *)sender {
    self.selectedRoundView.alpha = 0.5;
    self.selectedRoundView = (CRRoundColorView *)sender.view;
    self.selectedRoundView.alpha = 1.0;
    if ([self.delegate respondsToSelector:@selector(sendInView:selectedColor:)]) {
        [self.delegate sendInView:self selectedColor:@"DARK BLUE"];
    }
}



@end
