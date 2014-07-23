//
//  KMPSettingsPopAnimationController.h
//  KartMAXPRO
//
//  Created by Rafael Bartolome on 19/12/13.
//  Copyright (c) 2013 Rafael Bartolome. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CRPopAnimationController: NSObject <UIViewControllerAnimatedTransitioning> {

}

@property (readonly, nonatomic) id masterVC;

- (id) initWithViewController: (id) masterVC;

@end
