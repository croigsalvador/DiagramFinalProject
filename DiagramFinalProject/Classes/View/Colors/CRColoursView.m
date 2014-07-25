//
//  CRColoursView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 17/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRColoursView.h"
#import "CRRoundColorView.h"

static CGFloat const kCircleHeight                = 80.0f;
static CGFloat const kOffsetMargin                = 16.0f;

@interface CRColoursView ()

@property (strong,nonatomic) CRRoundColorView *selectedRoundView;
@property (nonatomic,copy) NSArray *colorsArray;

@end

@implementation CRColoursView

#pragma mark - Initializer
- (void)awakeFromNib {
//    [self setupBordersAndShadows];
    [self setupColorPalette];
}

#pragma mark - Custom Getter

- (NSArray *)colorsArray {
    if (!_colorsArray) {
        _colorsArray = [UIColor flatColorsArray];
    }
    return _colorsArray;
}

#pragma mark - Setup Elements
//- (void)setupBordersAndShadows {
//    self.layer.shadowOffset = CGSizeMake(3 , 3);
//    self.layer.shadowRadius = 3;
//    self.layer.shadowOpacity = .8f;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//}

- (void)setupColorPalette {
    [self setupRowColorWithXPosition:40.0f yPosition:kOffsetMargin+2.5f anIndex:10 colorIndex:9];
}

- (void)setupRowColorWithXPosition:(CGFloat)xPos yPosition:(CGFloat)yPos anIndex:(NSUInteger)index colorIndex:(NSUInteger)colorIndex{
    CGFloat xOffsetFirstRow = xPos;
    NSUInteger colorCount = colorIndex;
    for (int i = 0; i < index; i++) {
        CGRect colorFrame = CGRectMake(xOffsetFirstRow, yPos, kCircleHeight, kCircleHeight);
        [self createViewWithFrame:colorFrame colorIndex:colorCount];
        xOffsetFirstRow = CGRectGetMaxX(colorFrame) + kOffsetMargin;
        colorCount--;
    }
}

- (void)createViewWithFrame:(CGRect)colorFrame colorIndex:(NSUInteger)colorIndex{
    UIColor *currentColor = [UIColor colorFromText:self.colorsArray[colorIndex]];
    CRRoundColorView *roundView = [[CRRoundColorView alloc] initWithFrame:colorFrame andColor:currentColor];
    roundView.alpha = 0.8;
    roundView.tag = colorIndex;
    [self addTapGestureToView:roundView];
    [self addSubview:roundView];
}

- (void)addTapGestureToView:(CRRoundColorView *)colorView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roundViewPressed:)];
    [colorView addGestureRecognizer:tapGesture];
}

#pragma mark - Action Methods
- (void)roundViewPressed:(UITapGestureRecognizer *)sender {
    self.selectedRoundView.alpha = 0.8;
    self.selectedRoundView = (CRRoundColorView *)sender.view;
    NSString *color = self.colorsArray[self.selectedRoundView.tag];
    self.selectedRoundView.alpha = 1.0;
    if ([self.delegate respondsToSelector:@selector(sendInView:selectedColor:)]) {
        [self.delegate sendInView:self selectedColor:color];
    }
}



@end
