//
//  CRViewController.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRNodeMap, Node;

@interface CRNodeListViewController : UITableViewController

@property (strong,nonatomic) UIManagedDocument *managedDocument;
@property (strong,nonatomic) CRNodeMap *nodeMap;


@end
