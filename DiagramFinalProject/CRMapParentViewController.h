//
//  CRMapParentViewController.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 21/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRBaseViewController.h"

@class CRNodeMap;

@interface CRMapParentViewController : CRBaseViewController
@property (strong,nonatomic) CRNodeMap *nodeMap;
@property (strong,nonatomic) UIManagedDocument *managedDocument;
@end
