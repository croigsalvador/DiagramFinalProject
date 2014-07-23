//
//  CRMapParentViewController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 21/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapParentViewController.h"
#import "CRNodeListViewController.h"
#import "CRMapDrawerViewController.h"

#import "CRNodeMap.h"





static UIEdgeInsets kViewControllerInsets                  = {64.0f, 0.0f, 0.0f , 0.0f};
static NSString * const kMainStoryBoardNameID              = @"Main";
static NSString * const kMapDrawerViewControllerID         = @"MapDrawerViewController";
static NSString * const kNodeListViewControllerID          = @"NodeListViewController";



@interface CRMapParentViewController ()
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (strong,nonatomic) CRNodeListViewController *nodeListViewController;
@property (strong,nonatomic) CRMapDrawerViewController *mapDrawerViewController;

@property (copy,nonatomic) AddNewNodeHandlerBlock addNewNodeHandlerBlock;

@end

@implementation CRMapParentViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentedControl];
    self.navigationController.navigationBarHidden = NO;
    {
        [self displayContentController:self.nodeListViewController];
    }
}

#pragma mark - UIElements Setup Methods

- (void)setupSegmentedControl {
    NSArray *items = @[@"List",@"Map"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [self.segmentedControl addTarget:self action:@selector(changeViewControllerChild:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentedControl;
}

#pragma mark - Custom Getters

- (CRNodeListViewController *)nodeListViewController {
    if (!_nodeListViewController) {
        UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:kMainStoryBoardNameID bundle:[NSBundle mainBundle]];
        _nodeListViewController = (CRNodeListViewController *)[mapStoryboard instantiateViewControllerWithIdentifier:kNodeListViewControllerID];
        _nodeListViewController.nodeMap = self.nodeMap;
        _nodeListViewController.managedDocument = self.managedDocument;
        _nodeListViewController.addNewNodeHandlerBLock = self.addNewNodeHandlerBlock;
    }
    return _nodeListViewController;
}

- (CRMapDrawerViewController *)mapDrawerViewController {
    if (!_mapDrawerViewController) {
        UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:kMainStoryBoardNameID bundle:[NSBundle mainBundle]];
        _mapDrawerViewController = (CRMapDrawerViewController *)[mapStoryboard instantiateViewControllerWithIdentifier:kMapDrawerViewControllerID];
        _mapDrawerViewController.nodeMap = self.nodeMap;
        _mapDrawerViewController.managedDocument = self.managedDocument;
    }
    return _mapDrawerViewController;
}

- (AddNewNodeHandlerBlock)addNewNodeHandlerBlock {
    if (!_addNewNodeHandlerBlock) {
        __weak typeof(self) weakSelf = self;
        _addNewNodeHandlerBlock = ^(Node *node){
            NSLog(@"Añadiendo Nodo");
            [weakSelf.mapDrawerViewController addNewNodeFromList:node];
        };
    }
    return _addNewNodeHandlerBlock;
}

#pragma mark - Action Methods

- (void)changeViewControllerChild:(UISegmentedControl *)segmented {
    if (segmented.selectedSegmentIndex == 0) {
        [self hideContentController:self.mapDrawerViewController];
        [self displayContentController:self.nodeListViewController];
    } else {
        [self hideContentController:self.nodeListViewController];
        [self displayContentController:self.mapDrawerViewController];
    }
}


#pragma mark - Container Controller methods

- (CGRect)frameForContentController {
    return UIEdgeInsetsInsetRect(self.view.bounds, kViewControllerInsets);
}

- (void) displayContentController: (UIViewController*) content; {
    [self addChildViewController:content];
    content.view.frame = [self frameForContentController];
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void) hideContentController: (UIViewController*) content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}



@end
