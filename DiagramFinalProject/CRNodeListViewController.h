//
//  CRViewController.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRNodeMap, Node, CRManagedDocument;

@interface CRNodeListViewController : UITableViewController
@property (strong,nonatomic) CRManagedDocument *managedDocument;
@property (strong,nonatomic) CRNodeMap *nodeMap;
- (instancetype)initWithDocument:(UIManagedDocument *)document andNodeMap:(CRNodeMap *)nodeMap;

@end
