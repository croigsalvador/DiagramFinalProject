//
//  CRNodeTableViewCell.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//



#import "CRNodeTableViewCell.h"
#import "Node+Model.h"
#import "CRSquareFigureView.h"

static CGFloat const kTabMarginForCell           = 65.0f;

@interface CRNodeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backCellView;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTabLevelConstraint;
@property (weak, nonatomic) IBOutlet UIView *figureView;
@end

@implementation CRNodeTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}
#pragma mark - Public Methods

- (void)configureCellWithColor:(NSString *)color figure:(NSUInteger)CRNodeType andLevel:(NSInteger)level{
    UIColor *colorFromText=[UIColor colorFromText:color];
    self.colorView.backgroundColor = colorFromText;
    const CGFloat* colors = CGColorGetComponents(colorFromText.CGColor );
    UIColor *backColor = [UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:0.4];
    self.backCellView.backgroundColor = backColor;
    [self paintCellWithLevel:level];
}

#pragma mark - Private Methods

- (void)paintCellWithLevel:(NSInteger)level {
    self.leftTabLevelConstraint.constant = ((level - 1) *  kTabMarginForCell);
    [self layoutIfNeeded];
}


/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
*/
@end
