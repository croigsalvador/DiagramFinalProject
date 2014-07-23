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

static CGFloat const kTabMarginForCell           = 40.0f;

@interface CRNodeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTabLevelConstraint;
@property (weak, nonatomic) IBOutlet UIView *figureView;
@end

@implementation CRNodeTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor clearColor];
}
#pragma mark - Public Methods

- (void)configureCellWithColor:(NSString *)color figure:(NSUInteger)CRNodeType andLevel:(NSInteger)level{
    UIColor *colorFromText=[UIColor colorFromText:color];
    self.colorView.backgroundColor = colorFromText;
    [self paintFigureInCell:CRNodeType withColor:colorFromText] ;
    [self paintCellWithLevel:level];
//    [self setNeedsDisplay];
}

#pragma mark - Private Methods

- (void)paintCellWithLevel:(NSInteger)level {
    self.leftTabLevelConstraint.constant = ((level - 1) *  kTabMarginForCell);
    [self layoutIfNeeded];
}

- (void)paintFigureInCell:(CRNodeTypeShape)crNodeType withColor:(UIColor *)color {
    UIView *figureView;
    switch (crNodeType) {
        case CRNodeTypeShapeSquare:
             figureView = [[CRSquareFigureView alloc] initWithFrame:self.figureView.bounds andColor:color];
            break;
        case CRNodeTypeShapeCircle:
            break;
        case CRNodeTypeShapeTriangle:
            break;
        case CRNodeTypeShapePolygon:
            break;
    }
    [self.figureView addSubview:figureView];
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
*/
@end
