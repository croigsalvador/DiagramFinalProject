//
//  CREditNodeViewController.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRBaseViewController.h"

@class Node;
@protocol EditNodeDelegate;

@interface CREditNodeViewController : CRBaseViewController

@property (strong,nonatomic) Node *node;
@property (weak,nonatomic) id<EditNodeDelegate> delegate;

@end

@protocol EditNodeDelegate <NSObject>

- (void) dismissEditNodeViewController:(CREditNodeViewController *)editNodeViewController
                           modifiedData:(BOOL)modifiedData;

@end
