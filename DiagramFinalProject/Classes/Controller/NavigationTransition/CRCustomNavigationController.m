//
//  CRCustomNavigationController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 21/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRCustomNavigationController.h"
#import "CRNodeListViewController.h"

@interface CRCustomNavigationController ()<UINavigationControllerDelegate>

@end

@implementation CRCustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    
 
    return nil;
}


@end
