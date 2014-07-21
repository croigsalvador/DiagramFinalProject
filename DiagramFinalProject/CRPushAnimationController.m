//
//  KMPSettingsPushAnimationController.m
//  KartMAXPRO
//
//  Created by Rafael Bartolome on 19/12/13.
//  Copyright (c) 2013 Rafael Bartolome. All rights reserved.
//

#import "CRPushAnimationController.h"

@implementation CRPushAnimationController

- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    //Prepare views
    UIView* containerView = [transitionContext containerView];

    UIViewController *tableVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIView *tableViewFake = [tableVC.view snapshotViewAfterScreenUpdates: NO];
    UIView *tableView = tableVC.view;
    tableView.hidden = true;

    UIViewController *settingsVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView *settingsView = [settingsVC.view snapshotViewAfterScreenUpdates: YES];

    //frames
    CGRect initialFrame = [transitionContext initialFrameForViewController:tableVC];
    tableViewFake.frame = initialFrame;
    settingsView.frame = CGRectMake(initialFrame.origin.x-initialFrame.size.width,
                                    initialFrame.origin.y,
                                    initialFrame.size.width,
                                    initialFrame.size.height);
    settingsView.alpha = 1;


    [containerView addSubview: tableViewFake];
    [containerView insertSubview: settingsView aboveSubview: tableViewFake];


    // 2. Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m14 = -0.0005;
    transform.m44 = 1.23;

    tableViewFake.layer.anchorPoint = CGPointMake(1,0.5);


    tableViewFake.frame = CGRectMake(initialFrame.origin.x,
                                    initialFrame.origin.y,
                                    initialFrame.size.width,
                                    initialFrame.size.height);

    // 6. Animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration: duration
                     animations:^{
                         // from

                         tableViewFake.layer.transform = transform;
                         tableViewFake.alpha = 0.5;
                         tableViewFake.center = CGPointMake( containerView.center.x + containerView.frame.size.width /2 - 20, containerView.center.y);

                         // to
                         settingsView.frame = initialFrame;
                         settingsView.alpha = 1;


                     } completion:^(BOOL finished) {
                         // Clean up
                         if (transitionContext.transitionWasCancelled) {
                             //DLog(@"Finish canceled");
                             tableVC.view.hidden = NO;
                             settingsVC.view.hidden = YES;
                         } else {
                             //DLog(@"Finish completed");
                             tableVC.view.hidden = NO;
                             settingsVC.view.hidden = NO;
                         }
                         [tableViewFake removeFromSuperview];
                         [settingsView removeFromSuperview];
                         [containerView addSubview: settingsVC.view];
                         // Declare that we've finished
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }
     ];
    

}

@end
