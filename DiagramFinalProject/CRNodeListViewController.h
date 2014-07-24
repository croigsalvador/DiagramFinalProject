//
//  CRViewController.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRMapParentViewController.h"

@class CRNodeMap, Node, CRManagedDocument;

@interface CRNodeListViewController : UITableViewController
@property (strong,nonatomic) CRManagedDocument *managedDocument;
@property (strong,nonatomic) CRNodeMap *nodeMap;
- (instancetype)initWithDocument:(UIManagedDocument *)document andNodeMap:(CRNodeMap *)nodeMap;


// Block from ParentViewController
@property (copy,nonatomic)AddNewNodeHandlerBlock  addNewNodeHandlerBLock;
@property (copy,nonatomic)RemoveNodeViewBlock  removeNodeViewBlock;

@end
