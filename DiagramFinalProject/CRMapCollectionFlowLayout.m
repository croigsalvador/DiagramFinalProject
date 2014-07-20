//
//  CRMapCollectionFlowLayout.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapCollectionFlowLayout.h"

static UIEdgeInsets kFlowLayoutInsets              = {30.0, 40.0, 50.0, 40.0};

@implementation CRMapCollectionFlowLayout

- (instancetype)init {
    if (self = [super init]) {
    
        self.itemSize = CGSizeMake(200,200);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 50.0f;
        self.minimumLineSpacing = 50.0f;
        self.sectionInset = kFlowLayoutInsets;
//        self.headerReferenceSize = CGSizeMake(100, 100);
        
        
    }
    return self;
}


@end
