//
//  UIColor+Colors.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Custom)
+ (UIColor *)flatBlue;
+ (UIColor *)darkGrayCustom;
+ (UIColor *)lightGrayCustom;
+ (UIColor *)grayCustomForGradient1;
+ (UIColor *)grayCustomForGradient2;
+ (UIColor *)colorFromText:(NSString *)colorText;
+ (NSArray *)flatColorsArray;
@end
