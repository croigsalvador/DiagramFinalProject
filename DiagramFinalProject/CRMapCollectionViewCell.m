//
//  CRMapCollectionViewCell.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapCollectionViewCell.h"
#import "UIFont+Common.h"

@interface CRMapCollectionViewCell ()

@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation CRMapCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupNameLabel];
    }
    return self;
}

- (void)setCellText:(NSString *)cellText {
    _cellText = cellText;
    self.nameLabel.text = self.cellText;
}

- (void)setupNameLabel {
    
    CGRect labelFrame = CGRectInset(self.bounds, 10, 20);
    
    self.nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font =  [UIFont montSerratBoldForCollectionCell];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.nameLabel];
}

@end
