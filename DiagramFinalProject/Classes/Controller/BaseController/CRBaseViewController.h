//
//  CRBaseViewController.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRBaseViewController : UIViewController
- (void)showAlertErrorWithTitle:(NSString *)title message:(NSString *)message andCancelTitle:(NSString *)cancelTitle;
@end
