//
//  CRNodeTableViewCell.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "SWTableViewCell.h"

@interface CRNodeTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nodeTextLabel;

@end
