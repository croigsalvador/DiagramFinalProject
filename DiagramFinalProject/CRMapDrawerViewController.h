//
//  CRMapDrawerViewController.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRBaseViewController.h"

@class CRNodeMap;

@interface CRMapDrawerViewController : CRBaseViewController
@property (strong,nonatomic) UIManagedDocument *managedDocument;
@property (strong,nonatomic) CRNodeMap *nodeMap;
//- (instancetype)initWithDocument:(UIManagedDocument *)document andNodeMap:(CRNodeMap *)nodeMap;
@end
