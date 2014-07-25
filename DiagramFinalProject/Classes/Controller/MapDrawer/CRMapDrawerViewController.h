//
//  CRMapDrawerViewController.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRBaseViewController.h"

@class CRNodeMap, CRManagedDocument, Node;

@interface CRMapDrawerViewController : CRBaseViewController
@property (strong,nonatomic) CRManagedDocument *managedDocument;
@property (strong,nonatomic) CRNodeMap *nodeMap;
//- (instancetype)initWithDocument:(UIManagedDocument *)document andNodeMap:(CRNodeMap *)nodeMap;

- (void)addNewNodeFromList:(Node *)node;
-  (void)removeFiguresWithOutNode:(NSArray *)deletingNodes;

@end
