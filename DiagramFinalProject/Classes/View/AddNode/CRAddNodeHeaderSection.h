//
//  CRAddNodeHeaderSection.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 22/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddNodeHeaderDelegate;

@interface CRAddNodeHeaderSection : UITableViewHeaderFooterView

@property (weak,nonatomic) id<AddNodeHeaderDelegate> delegate;

@end

@protocol AddNodeHeaderDelegate <NSObject>
- (void)addNodeButtonPressed:(CRAddNodeHeaderSection *)headerSection;
@end