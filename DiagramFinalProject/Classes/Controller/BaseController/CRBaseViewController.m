//
//  CRBaseViewController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRBaseViewController.h"

@interface CRBaseViewController ()

@end

@implementation CRBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showAlertErrorWithTitle:(NSString *)title message:(NSString *)message andCancelTitle:(NSString *)cancelTitle {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alert show];
 
}


@end
