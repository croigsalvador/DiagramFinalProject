//
//  KMPSettingsPopAnimationController.m
//  KartMAXPRO
//
//  Created by Rafael Bartolome on 19/12/13.
//  Copyright (c) 2013 Rafael Bartolome. All rights reserved.
//

#import "CRPopAnimationController.h"

@implementation CRPopAnimationController

- (id) initWithViewController: (id) masterVC {

    if ([self init]) {
        _masterVC = masterVC ;
    }

    return self;
}

- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    //Prepare views
    UIView* containerView = [transitionContext containerView];

    UIViewController *tableVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView *tableView = [tableVC.view snapshotViewAfterScreenUpdates: YES];

    UIViewController *settingsVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIView *settingsViewFake = [settingsVC.view snapshotViewAfterScreenUpdates: NO];
    UIView *settingsView = settingsVC.view;
    settingsView.hidden = TRUE;
    settingsViewFake.alpha = 1.0;

    //frames
    CGRect initialFrame = [transitionContext initialFrameForViewController: settingsVC];
    settingsViewFake.frame = initialFrame;
    tableView.frame = initialFrame;

    CGRect settingsFinalFrame = CGRectMake(initialFrame.origin.x-initialFrame.size.width,
                                    initialFrame.origin.y,
                                    initialFrame.size.width,
                                    initialFrame.size.height);



    [containerView addSubview: tableView];
    [containerView sendSubviewToBack: tableView];
    [containerView insertSubview: settingsViewFake aboveSubview: tableView];

    CATransform3D transform = CATransform3DIdentity;
    transform.m14 = -0.0005;
    transform.m44 = 1.23;

    tableView.layer.anchorPoint = CGPointMake(1,0.5);


    tableView.layer.transform = transform;
    tableView.alpha = 0.5;
    tableView.center = CGPointMake( containerView.center.x + containerView.frame.size.width /2 - 20, containerView.center.y);

    // Animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration: duration
                     animations:^{

                         tableView.center = CGPointMake( containerView.center.x + containerView.frame.size.width /2, containerView.center.y);
                         tableView.layer.transform = CATransform3DIdentity;
                         tableView.alpha = 1;

                         settingsViewFake.frame = settingsFinalFrame;

                     } completion:^(BOOL finished) {
                         // Clean up
                         if (transitionContext.transitionWasCancelled) {
                             // DLog(@"Finish canceled");
                             settingsVC.view.hidden = NO;
                             [containerView addSubview: settingsVC.view];
                         } else {
                             //DLog(@"Finish completed");
                             [containerView addSubview: tableVC.view];
                         }

                         [tableView removeFromSuperview];
                         [settingsViewFake removeFromSuperview];

                         // Declare that we've finished
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }
     ];

}


@end
