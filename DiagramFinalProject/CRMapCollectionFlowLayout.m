//
//  CRMapCollectionFlowLayout.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapCollectionFlowLayout.h"

static UIEdgeInsets kFlowLayoutInsets              = {30.0, 137.0, 70.0, 137.0};

@implementation CRMapCollectionFlowLayout

- (instancetype)init {
    if (self = [super init]) {
    
        self.itemSize = CGSizeMake(250,180);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 10.0f;
        self.minimumLineSpacing = 10.0f;
        self.sectionInset = kFlowLayoutInsets;
    }
    return self;
}


@end
