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
@property (weak, nonatomic) IBOutlet UIView *figureView;
@end

@implementation CRNodeTableViewCell


- (void)awakeFromNib {
}
#pragma mark - Public Methods

- (void)configureCellWithColor:(NSString *)color figure:(NSUInteger)CRNodeType andLevel:(NSInteger)level {
    UIColor *colorFromText =[UIColor performSelector: NSSelectorFromString(color)];
    self.containerMainView.backgroundColor = colorFromText;
    
    [self paintFigureInCell:CRNodeType withColor:colorFromText] ;
    [self paintCellWithLevel:level];
    [self setNeedsDisplay];
}

#pragma mark - Private Methods

- (void)paintCellWithLevel:(NSInteger)level {
    CGRect cellFrame = self.bounds;
    cellFrame.origin.x = cellFrame.origin.x + ((level - 1) *  kTabMarginForCell);
    cellFrame.size.width = cellFrame.size.width - ((level - 1) *  kTabMarginForCell);
    self.containerMainView.frame = cellFrame;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
