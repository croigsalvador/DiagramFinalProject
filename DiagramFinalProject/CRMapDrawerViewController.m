//
//  CRMapDrawerViewController.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapDrawerViewController.h"
#import "CRColoursView.h"

@interface CRMapDrawerViewController ()<ColorViewDelegate>
@property (weak, nonatomic) IBOutlet CRColoursView *colorsView;

@end

@implementation CRMapDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorsView.delegate = self;
}

#pragma mark - ColorView Delegate

- (void)sendInView:(CRColoursView *)colorView selectedColor:(NSString *)color {
    NSLog(@"Color seleccionado: %@", color);
}

@end
