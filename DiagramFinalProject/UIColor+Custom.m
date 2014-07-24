//
//  UIColor+Colors.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "UIColor+Custom.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (Custom)

+ (UIColor *)flatBlue {
    return UIColorFromRGB(0x1D5B8C);
}
+ (UIColor *)darkGrayCustom {
    return UIColorFromRGB(0x333333);
}
+ (UIColor *)lightGrayCustom {
    return UIColorFromRGB(0x999999);
}

+ (UIColor *)grayCustomForGradient1 {
    return UIColorFromRGB(0xEEEEEE);
}
+ (UIColor *)grayCustomForGradient2{
    return UIColorFromRGB(0xDDDDDD);
}

+ (UIColor *)colorFromText:(NSString *)colorText {
    UIColor *colorFromText =[UIColor performSelector: NSSelectorFromString(colorText)];
    return colorFromText;
}


+ (NSArray *)flatColorsArray {
    NSArray *colorsArray = @[@"flatTurquoiseColor",@"flatEmeraldColor",@"flatPeterRiverColor",@"flatAmethystColor",@"flatMidnightBlueColor",@"flatSunFlowerColor",@"flatCarrotColor",@"flatAlizarinColor",@"flatSilverColor", @"flatAsbestosColor"];
    return colorsArray;
}

@end
